defmodule BankApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  @values_to_validate [
    :email,
    :first_name,
    :last_name,
    :password,
    :password_confirmation,
    :role
  ]

  @values_that_can_be_changed [
    :email,
    :first_name,
    :last_name,
    :password,
    :password_confirmation,
    :role
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :email,                 :string
    field :first_name,            :string
    field :last_name,             :string
    field :password,              :string, virtual: true
    field :password_confirmation,  :string, virtual: true
    field :password_hash,         :string
    field :role,                  :string, default: "user"

    has_one :accounts, BankApi.Accounts.Account
    timestamps()
  end
  def changeset(user, attrs) do
    user
    |> cast(attrs, @values_that_can_be_changed)
    |> validate_required(@values_to_validate)
    |> validate_format(:email, ~r/@/, message: "bad email format")
    |> update_change(:email, &(String.downcase(&1)))
    |> validate_length(:password, min: 6, max: 100, message: "password length must be between 6 and 100 characters")
    |> validate_confirmation(:password, message: "Passwords does not match")
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
