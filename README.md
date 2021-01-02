# ACCOUNT MANAGER
Simple bank account manager API.

## Setup
- Clone the project: `git clone https://github.com/thomasalmeida/account_manager.git`
- Install gems: `bundle install`
- Add database configurations (database name, database username and database password) in credentials: `EDITOR="nano" rails credentials:edit`
- Create database:  `rails db:create && rails db:migrate`
- Run the server: `rails s`

## Routes
### User
Add a new User
-  **Endpoint:**  `http://localhost:3000/user`
-  **HTTP:** POST
-  **Body:**  `{ username": "username", "password": "password" }`

Login
-  **Endpoint:**  `http://localhost:3000/login`
-  **HTTP:** POST
-  **Body:**  `{ "username": "username", "password": "password" }`

### Account
Add a new Account
-  **Endpoint:**  `http://localhost:3000/accounts`
-  **HTTP:** POST
-  **Body:**  `{ cpf: "12345678910", name: "john doe", email: "john@mail.com", birth_date: "2000-01-01", gender: "undefined", city: "Sao Paulo", state: "SP", country: "Brazil" }`
(CPF is a required field.)
-  **Header**  `Authorization: Bearer $$JWT$$`

Update an Account
-  **Endpoint:**  `http://localhost:3000/accounts/:id`
-  **HTTP:** PATCH
-  **Body:**  `{ name: "john doe", email: "john@mail.com", birth_date: "2000-01-01", gender: "undefined", city: "Sao Paulo", state: "SP", country: "Brazil" }` }`
-  **Header**  `Authorization: Bearer $$JWT$$`
  
### Referral
List referrals by referral code
-  **Endpoint:**  `http://localhost:3000/referrals/:code`
-  **HTTP:** GET
-  **Header**  `Authorization: Bearer $$JWT$$`

## Usage
Running tests:
`bundle exec rspec`

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
This project is released under the [MIT License](https://opensource.org/licenses/MIT).