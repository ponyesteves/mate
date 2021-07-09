defmodule Mate.Conty.Balance do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Conty.Account
  alias Mate.Taggable.Tagging

  embedded_schema do
    field :amount, :decimal
    field :prev_amount, :decimal, default: 0

    belongs_to :account, Account
    belongs_to :source, Account

    has_many :taggings, Tagging,
      where: [taggable_type: "#{Account}"],
      foreign_key: :taggable_id

    has_many :tags, through: [:taggings, :tag]
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :account_id, :source_id])
    |> validate_required([:amount, :account_id])
  end
end
