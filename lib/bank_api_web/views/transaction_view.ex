defmodule BankApiWeb.TransactionView do
  use BankApiWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, __MODULE__, "transaction.json")}
  end
end
