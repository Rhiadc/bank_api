defmodule BankApi.Accounts do
  alias BankApi.Repo
  alias BankApi.Accounts.{Account, User}

  def create_user(attrs \\ %{}) do
    case insert_user(attrs) do
      {:ok, user} ->
        {:ok, account} =
          user
          |> Ecto.build_assoc(:accounts)
          |> Account.changeset()
          |> Repo.insert()

        {:ok, account |> Repo.preload(:user)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  # teste-novo
  defp insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user!(id), do: Repo.get(User, id) |> Repo.preload(:accounts)

  def get_account!(id), do: Repo.get(Account, id)

  def get_users(), do: Repo.all(User) |> Repo.preload(:accounts)
end
