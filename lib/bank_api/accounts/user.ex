defmodule BankApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  @fields_for_validate [
    :email,
    :first_name,
    :last_name,
    :password,
    :password_confirmation,
    :role

  ]

  @fields_that_can_be_changed [
    :email,
    :first_name,
    :last_name,
    :password,
    :password_confirmation,
    :role

  ]

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "user"
    has_one :accounts, BankApi.Accounts.Account
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields_that_can_be_changed)
    |> validate_required(@fields_for_validate)
    |> validate_format(:email, ~r/@/, messsage: "email em formato invalido")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password, min: 6, max: 100, message: "password must be between 6 and 100 characteres")
    |> validate_confirmation(:password, message: "Passowords does not match")
    |> unique_constraint(:email, message: "Email already in use")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
