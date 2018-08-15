class PropertiesController < ApplicationController
  before_action :require_signed_in!

  def index
    properties = current_user.properties
    response_information = []

    properties.each do |property|
      response_information.push(calculate(property))
    end

    render json: response_information
  end

  def show
  end

  def create
    property = Property.new(
      address: params[:address],
      cap_rate: params[:cap_rate],
      user_id: current_user.id
    )

    property.save!

    params['rent_roll'].each do |unit|
      Unit.new(
        monthly_rent: unit['monthly_rent'],
        vacancy: !!unit['vacancy'],
        annual_rent:  !unit['vacancy'] ? (unit['monthly_rent'] * 12) : 0,
        unit_number: unit['unit_number'],
        bedrooms: unit['bedrooms'],
        bathrooms: unit['bathrooms'],
        property_id: property.id
      ).save!
    end

    if params['expenses'] then
      params['expenses'].each do |expense|
        Expense.new(
          amount: expense['amount'],
          expense_type: expense['expense_type'],
          property_id: property.id
        ).save!
      end
    end

    render json: [calculate(property)]
  end

  def update
  end

  def destroy
  end

  private
  def calculate(property)
    # I'm calculating this here rather than saving it in the DB because
    # the debt_rate depends on a 10 year Treasury note yield curve,
    # which of course regularly changes -- I'd imagine we would want
    # to set up an API call in this method to a service that tracks
    # the yield curve

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

    dscr = (noi / minimum_debt_service) / debt_rate
    ltv = property_value * 0.8

    dscr < ltv ? loan_amount = dscr : loan_amount = ltv

    return { "Loan Amount": loan_amount, "Debt Rate": debt_rate }
  end
end
