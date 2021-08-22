defmodule BankApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID

  schema "accounts" do
    field :balance, :decimal, precision: 10, scale: 2, default: 1000
    belongs_to :user, BankApi.Accounts.User
    timestamps()
  end

  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end


"""
[user] = BankApi.Repo.all(User)
account = Ecto.build_assoc(user :accounts)
account = account |> Account.changeset()
BankApi.Repo.insert account

BankApi.Repo.all(User)
|> Ecto.build_assoc(:accounts)
|> Account.changeset()
|> BankApi.Repo.Insert()
"""
