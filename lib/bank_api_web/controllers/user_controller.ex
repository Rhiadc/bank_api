defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller
  alias BankApi.Accounts
  action_fallback BankApiWeb.FallbackController

  def signup(conn, %{"user" => user}) do
    with {:ok, account} <-  Accounts.create_user(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, id: account.user.id))
      |> render("account.json", %{account: account})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn
    |> render("show.json", user: user)
  end

  def index(conn, _) do
    conn
    |> render("index.json", users: Accounts.get_users())
  end
end
