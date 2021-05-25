defmodule MateWeb.PageLive do
  @moduledoc false
  use MateWeb, :live_view
  alias Mate.Conty

  @impl true
  def mount(_params, _session, socket) do

    {:ok, entry_items} = Conty.entry_items_by_account_type(:assets, %{end_date: Date.utc_today()})

    {:ok, assign(socket, entry_items: entry_items)}
  end
end
