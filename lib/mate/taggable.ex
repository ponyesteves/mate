defmodule Mate.Taggable do
  @moduledoc """
  The Taggable context.
  """

  import Ecto.Query, warn: false

  alias Mate.Repo
  alias Mate.Taggable.{Tag, Tagging}

  def tag(%{__struct__: module, id: taggable_id}, tag_name) do
    {:ok, tag} = find_or_create_tag(%{name: tag_name, taggable_type: "#{module}"})

    create_tagging(%{tag_id: tag.id, taggable_id: taggable_id, taggable_type: "#{module}"})
  end

  def list_tags(module) do
    from(t in Tag,
      where: t.taggable_type == ^"#{module}")
    |> Repo.all
  end

  def find_or_create_tag(%{name: name, taggable_type: taggable_type} = attrs) do
    with {:ok, tag} <- Repo.get_by(Tag, name: name, taggable_type: taggable_type) do
      {:ok, tag}
    else
      _ ->
        create_tag(attrs)
    end
  end

  defp create_tag(attrs) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  defp create_tagging(attrs) do
    %Tagging{}
    |> Tagging.changeset(attrs)
    |> Repo.insert()
  end

  alias Mate.Taggable.Tagging

  @doc """
  Include this macro to a schema to make it taggable
  """
  defmacro taggable do
    quote do
      has_many :taggings, Tagging,
        where: [taggable_type: "#{__MODULE__}"],
        foreign_key: :taggable_id

      has_many :tags, through: [:taggings, :tag]
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Mate.Taggable, only: [taggable: 0]
    end
  end
end
