defmodule BankApi.Accounts.Auth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, opts) do
    body = Poison.encode!(%{error: to_string(type)})

    IO.inspect reason
    IO.inspect opts
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
