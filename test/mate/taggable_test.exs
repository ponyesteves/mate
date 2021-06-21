defmodule Mate.TaggableTest do
  use Mate.DataCase

  alias Mate.Taggable

  describe "tags" do
    alias Mate.Taggable.Tag

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}
  end
end
