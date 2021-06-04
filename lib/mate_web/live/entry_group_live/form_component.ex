defmodule MateWeb.EntryGroupLive.FormComponent do
  @moduledoc false
  use MateWeb, :live_component

  alias Mate.{Conty, Transactions}
  alias Transactions.EntryGroup

  @impl true
  def update(%{entry_group: entry_group} = assigns, socket) do
    changeset = Transactions.change_entry_group(entry_group)
    accounts = Conty.list_accounts() |> Enum.map(&{&1.name, &1.id})
    periodicity_types = build_periodicity_types(Ecto.Changeset.get_field(changeset, :periodicity))

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:periodicity_types, periodicity_types)
     |> assign(:changeset, changeset)
     |> assign(:accounts, accounts)}
  end

  @impl true
  def handle_event("validate", %{"entry_group" => entry_group_params}, socket) do
    changeset =
      socket.assigns.entry_group
      |> Transactions.change_entry_group(entry_group_params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       changeset: changeset,
       periodicity_types: build_periodicity_types(entry_group_params["periodicity"])
     )}
  end

  def handle_event("save", %{"entry_group" => entry_group_params}, socket) do
    save_entry_group(socket, socket.assigns.action, entry_group_params)
  end

  def build_periodicity_types(periodicity) do
    periodicity =
      case periodicity do
        x when x in ["", nil] -> 0
        str when is_bitstring(str) -> String.to_integer(str)
        integer when is_integer(integer) -> integer
        _ -> raise "Periodicity should be a number"
      end
    values = Ecto.Enum.values(EntryGroup, :periodicity_type)

    for value <- values do
      key = Atom.to_string(value)
      {Gettext.dngettext(MateWeb.Gettext, "labels", key, "#{key}_p", periodicity, %{}), value}
    end
  end

  defp save_entry_group(socket, :edit, entry_group_params) do
    case Transactions.update_entry_group(socket.assigns.entry_group, entry_group_params) do
      {:ok, _entry_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry group updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_entry_group(socket, :new, entry_group_params) do
    case Transactions.create_entry_group(entry_group_params) do
      {:ok, _entry_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry group created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
