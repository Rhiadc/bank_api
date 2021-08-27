defmodule BankApiWeb.TransactionView do
  use BankApiWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, __MODULE__, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    list_transactions =
      Enum.map(transaction.transactions, fn t ->
        %{
          type: t.type,
          account_from: t.account_from,
          account_to: t.account_to,
          date: t.date,
          value: t.value
        }
      end)

    %{transaction_list: list_transactions, total: transaction.total}
  end
end
