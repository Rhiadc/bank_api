# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankApi.Repo.insert!(%BankApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
value = %BankApi.Accounts.User{email: "rhia@teste.com", first_name: "Felipe", last_name: "Esparza", password: "teste123", password_confirmation: "teste123"}
a = %{email: "rhia@teste.com", first_name: "Felipe", last_name: "Esparza", password: "teste123", password_confirmation: "teste123"}
