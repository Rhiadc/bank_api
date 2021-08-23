defmodule BankApi.Operations do
  alias BankApi.{Accounts, Accounts.Account}
  alias BankApi.Repo

  def transfer(f_id, t_id, value) do
    from = Accounts.get_account!(f_id)
    value = Decimal.new(value)

    case (!is_negative?(from.balance, value) && !verify_id?(f_id, t_id) && !negative_value?(value))  do
      false -> {:error, "Invalid operation"}
      true -> perform_update(from, t_id, value)
    end
  end

  defp verify_id?(f_id, t_id), do: f_id == t_id #false

  defp negative_value?(value), do: Decimal.negative?(value) #true

  defp is_negative?(from_balance, value) do #false
    Decimal.sub(from_balance, value)
    |> Decimal.negative?()
  end

  defp perform_update(from, t_id, value) do
    {:ok, from} = from
    |>  perform_operation(value, :sub)

    {:ok, to} = Accounts.get_account!(t_id)
    |> perform_operation(value, :sum)

    {:ok, "Transfer success, from: #{from.id} to: #{to.id}, value: #{value}"}
  end

  def perform_operation(account, value, :sub) do
    account
    |> update_account(%{balance: Decimal.sub(account.balance, value)})
  end

  def perform_operation(account, value, :sum) do
    account
    |> update_account(%{balance: Decimal.add(account.balance, value)})
  end

  def update_account(%Account{} = account, attrs) do
    Account.changeset(account, attrs)
    |> Repo.update()
  end
end
