defmodule MateWeb.EntryGroupLive.Show do
  use MateWeb, :live_view

  alias Mate.Transactions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:entry_group, Transactions.get_entry_group!(id))}
  end

  defp page_title(:show), do: "Show Entry group"
  defp page_title(:edit), do: "Edit Entry group"
end
