defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("account.json", %{account: account}) do
    %{
      balance: account.balance,
      account_id: account.id,
      user: %{
        email: account.user.email,
        first_name: account.user.first_name,
        last_name: account.user.last_name,
        role: account.user.role,
        id: account.user.id
      }
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      balance: user.accounts.balance,
      account_id: user.accounts.id,
      user: %{
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        role: user.role,
        id: user.id
      }
    }
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end
end
