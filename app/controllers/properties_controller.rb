class PropertiesController < ApplicationController
  before_action :authenticate!

  def index
    properties = current_user.properties
    response_information = []

    if (properties.length != 0)
      properties.each do |property|
        response_information.push(calculate(property))
      end

      render json: response_information
    else
      render json: ['You currently have no quotes saved in the database']
    end
  end

  def show
    property = Property.find_by(id: params[:id])
    render json: ['Quote id not found'] if !property

    if (property.user_id === current_user.id)
      render json: calculate(property)
    else
      render json: ['You must be signed into the appropriate account to view this quote']
    end
  end

  def create
    begin
      property = create_property(params)
      property.save!
      create_units(params[:rent_roll], property.id)
      create_expenses(params[:expenses], property.id) if params[:expenses]

      render json: calculate(property)
    rescue
      render json: ['Please review the JSON object structure in your request']
    end
  end

  def bulk_create
    begin
      response_information = []

      params[:package].each do |property|
        newProperty = create_property(property)
        newProperty.save!
        create_units(property[:rent_roll], newProperty.id)
        create_expenses(property[:expenses], newProperty.id) if property[:expenses]

        response_information.push(calculate(newProperty))
      end

      render json: response_information
    rescue
      render json: ['Please review the JSON object structure in your request']
    end
  end

  def update
    property = Property.find_by(id: params[:id])
    render json: ['Quote id not found'] if !property

    if (property.user_id === current_user.id)
      property.update_attributes(
        address: params[:address] ? params[:address] : property.address,
        cap_rate: params[:cap_rate] ? params[:cap_rate] : property.cap_rate
      )

      if (params[:rent_roll])
        property.units.destroy_all
        create_units(params[:rent_roll], property.id)
      end

      if (params[:expenses])
        property.expenses.destroy_all
        create_expenses(params[:expenses], property.id)
      end
    else
      render json: ['You must be signed into the appropriate account to update this quote']
    end

    render json: calculate(property)
  end

  def destroy
    property = Property.find_by(id: params[:id])
    render json: ['Quote id not found'] if !property

    if (property.user_id === current_user.id)
      property.destroy
    else
      render json: ['You must be signed into the appropriate account to delete this quote']
    end

    render json: ['This quote has been deleted from the database']
  end

  private
  def calculate(property)
    # I'm calculating this here rather than saving it in the DB because
    # the debt_rate depends on the 10 year Treasury note yield curve --
    # I'd imagine one would want to set up an API call in this method to
    # a service that tracks the yield curve, which would update the
    # debt_rate calculation

    total_annual_rent_collected = 0
    property.units.each do |unit|
      total_annual_rent_collected += unit.annual_rent
    end

    total_expenses = 0
    property.expenses.each do |expense|
      total_expenses += expense.amount
    end

    # The first part of the debt_rate equation is the 10 year Treasury
    # note yield curve as of August 14th, 2018
    debt_rate = 0.0289 + 0.02
    noi = total_annual_rent_collected - total_expenses
    minimum_debt_service = noi * 1.25
    property_value = noi / property.cap_rate

    # I'm pretty confused about how these formulas work,
    # because it looks like LTV will always be much higher
    dscr = (noi / minimum_debt_service) / debt_rate
    ltv = property_value * 0.8

    dscr < ltv ? loan_amount = dscr : loan_amount = ltv

    return {
      "Address": property.address,
      "Loan Amount": loan_amount.to_i,
      "Debt Rate": debt_rate,
      "id": property.id,
    }
  end

  def create_property(property)
    newProperty = Property.new(
      address: property[:address],
      cap_rate: property[:cap_rate],
      user_id: current_user.id
    )
    newProperty.save!
    return newProperty
  end

  def create_units(units, property_id)
    units.each do |unit|
      Unit.new(
        monthly_rent: unit[:monthly_rent],
        vacancy: !!unit[:vacancy],
        annual_rent:  !unit[:vacancy] ? (unit[:monthly_rent] * 12) : 0,
        unit_number: unit[:unit_number],
        bedrooms: unit[:bedrooms],
        bathrooms: unit[:bathrooms],
        property_id: property_id
      ).save!
    end
  end

  def create_expenses(expenses, property_id)
    expenses.each do |expense|
      Expense.new(
        amount: expense[:amount],
        expense_type: expense[:expense_type],
        property_id: property_id
      ).save!
    end
  end
end
