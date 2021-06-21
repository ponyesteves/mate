defmodule Mate.Taggable do
  @moduledoc """
  The Taggable context.
  """

  import Ecto.Query, warn: false

  alias Mate.Repo
  alias Mate.Taggable.{Tag, Tagging}

  def tag(%{__struct__: taggable_type, id: taggable_id}, tag_name) do
    {:ok, tag} = find_or_create_tag(%{name: tag_name, taggable_type: taggable_type})

    create_tagging(%{tag_id: tag.id, taggable_id: taggable_id, taggable_type: taggable_type})
  end

  def untag(%{__struct__: taggable_type, id: taggable_id}, tag_name) do
    with tag when not is_nil(tag) <- find_tag(tag_name, taggable_type),
         tagging when not is_nil(tagging) <- find_tagging(tag.id, taggable_id, taggable_type) do
      delete_tagging(tagging)
    else
      _ -> {:error, :tagging_or_tag_missing}
    end
  end

  def delete_tagging(%Tagging{} = tagging) do
    Repo.delete(tagging)
  end

  def filter(taggable, tag_name) do
    Repo.preload(taggable, :tags)
    |> Enum.filter(fn taggable -> Enum.any?(taggable.tags, & &1.name == tag_name) end)
  end

  def list_tags(module) do
    from(t in Tag,
      where: t.taggable_type == ^"#{module}"
    )
    |> Repo.all()
  end

  defp find_or_create_tag(%{name: name, taggable_type: taggable_type} = attrs) do
    if(tag = find_tag(name, taggable_type)) do
      {:ok, tag}
    else
      create_tag(attrs)
    end
  end

  defp find_tag(name, taggable_type),
    do: Repo.get_by(Tag, name: name, taggable_type: taggable_type)

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

  defp find_tagging(tag_id, taggagle_id, taggable_type) do
    Repo.get_by(Tagging, tag_id: tag_id, taggable_id: taggagle_id, taggable_type: taggable_type)
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
