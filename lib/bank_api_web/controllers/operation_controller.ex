defmodule BankApiWeb.OperationController do
  use BankApiWeb, :controller
  alias BankApi.Operations

  action_fallback BankApiWeb.FallbackController

  def transfer(conn, %{"to_account_id" => t_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, message} <- Operations.transfer(user.accounts, t_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def withdraw(conn, %{"value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, message} <- Operations.withdraw(user.accounts, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
