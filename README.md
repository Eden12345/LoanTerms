# Instructions For My Loan Terms API Challenge Submission

## API URL
https://afternoon-forest-31057.herokuapp.com/  
Deployed on Heroku with a PostgreSQL database

## Routes
```
POST /users (create a user)
POST /session (sign in)
DELETE /session (sign out)
GET /quotes (view all of the quotes you have created under your user profile)
POST /quotes (create a quote)
POST /quotes/bulk (create a batch of quotes)
GET /quotes/:id (view a specific quote, if you created it)
PATCH /quotes/:id (update a specific quote, if you created it)
DELETE /quotes/:id (delete a specific quote, if you created it)
```

## Notes
* You must be signed into an account in order to create quotes (the project will save your session to your cookies)
* You also must be signed into the appropriate account to view, update, or delete your properties
* address and cap_rate are required attributes for Properties (i.e. quotes)
* monthly_rent is the only required attribute for Units
* amount is the only required attribute for Expenses
* Expenses and Units must come in arrays
* You must list at least one unit in your rent_roll when creating a new quote
* Unit annual rent only counted if vacancy is false, which is the default
* If you pass a rent_roll or expenses array in your JSON to PATCH, it will replace all of them
* You need a “package” key for bulk requests
* When returning quotes, I also included their addresses and IDs for testing purposes

## Input Examples

### User object structure
```
{
	"username": "ethan",
	"password": "pass"
}
```

### Quote object structure
```
{
	"address": "555 Tulip Lane",
	"cap_rate": 0.13,
	"rent_roll": [
		{
			"monthly_rent": 2300,
			"vacancy": "true",
			"unit_number": 101,
			"bedrooms": 2,
			"bathrooms": 1
		},
		{
			"monthly_rent": 4000
		},
		{
			"monthly_rent": 1500
		}
	],
	"expenses": [
		{
			"amount": 20000,
			"expense_type": "Marketing"
		},
		{
			"amount": 10000
		},
		{
			"amount": 8000
		}
	]
}
```

### Bulk quote object structure
```
{
	"package": [
		{
			"address": "555 Garden Road",
			"cap_rate": 0.15,
			"rent_roll": [
				{
					"monthly_rent": 5000
				},
				{
					"monthly_rent": 1200
				},
				{
					"monthly_rent": 3000
				}
			],
			"expenses": [
				{
					"amount": 5000,
					"expense_type": "Taxes"
				},
				{
					"amount": 10000
				},
				{
					"amount": 2000
				}
			]
		},
		{
			"address": "555 Riggley Square",
			"cap_rate": 0.12,
			"rent_roll": [
				{
					"monthly_rent": 2000,
					"vacancy": "true"
				},
				{
					"monthly_rent": 3500
				},
				{
					"monthly_rent": 2000
				}
			],
			"expenses": [
				{
					"amount": 20000,
					"expense_type": "Payroll"
				},
				{
					"amount": 500
				}
			]
		}
	]
}
```
