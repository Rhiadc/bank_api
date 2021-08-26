defmodule BankApi.Operations do
  alias BankApi.{Accounts, Accounts.Account}
  alias BankApi.Transactions.Transaction
  alias BankApi.Repo

  def transfer(from, t_id, value) do
    value = Decimal.new(value)

    case !is_negative?(from.balance, value) && !verify_id?(from.id, t_id) && !negative_value?(value) do
      false -> {:error, "Invalid operation"}
      true -> perform_update(from, t_id, value)
    end
  end

  def withdraw(user_account, value) do
    value = Decimal.new(value)

    case !is_negative?(user_account.balance, value) && !negative_value?(value) do
      false ->
        {:error, "Invalid operation"}

      true ->
        withdraw_operation(user_account, value)
    end
  end

  defp verify_id?(f_id, t_id), do: f_id == t_id

  defp negative_value?(value), do: Decimal.negative?(value)

  defp is_negative?(from_balance, value) do
    Decimal.sub(from_balance, value)
    |> Decimal.negative?()
  end

  defp withdraw_operation(from, value) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
    |> Ecto.Multi.insert(:transaction, gen_transaction(value, from.id, nil, "withdraw"))
    |> Repo.transaction()
    |> transaction_case("Withdraw success, value: #{value}")
  end

  defp perform_update(from, t_id, value) do
    to = Accounts.get_account!(t_id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
    |> Ecto.Multi.update(:account_to, perform_operation(to, value, :sum))
    |> Ecto.Multi.insert(:transaction, gen_transaction(value, from.id, to.id, "transfer"))
    |> Repo.transaction()
    |> transaction_case("Transfer success, from: #{from.id} to: #{to.id}, value: #{value}")
  end

  defp transaction_case(operations, msg) do
    case operations do
      {:ok, _} ->
        {:ok, msg}

      {:error, :account_from, changeset, _} ->
        {:error, changeset}

      {:error, :account_to, changeset, _} ->
        {:error, changeset}

      {:error, :transaction, changeset, _} ->
        {:error, changeset}
    end
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
  end

  def gen_transaction(value, from_id, to_id, type) do
    %Transaction{
      account_from: from_id,
      account_to: to_id,
      date: Date.utc_today(),
      type: type,
      value: value
    }
  end
end
