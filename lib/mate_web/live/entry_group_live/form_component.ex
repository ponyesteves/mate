defmodule MateWeb.EntryGroupLive.FormComponent do
  @moduledoc false
  use MateWeb, :live_component

  alias Mate.Transactions
  alias Transactions.EntryGroup

  @impl true
  def update(%{entry_group: entry_group} = assigns, socket) do
    changeset = Transactions.change_entry_group(entry_group)

    periodicity_types =
      build_periodicity_types_select_options(Ecto.Changeset.get_field(changeset, :periodicity))

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:periodicity_types, periodicity_types)
     |> assign(:changeset, changeset)}
  end

  defp account_debit_id(socket, account_name) when account_name in [nil, ""], do: nil
  defp account_debit_id(socket, account_name) do
    debit_accounts = socket.assigns.debit_accounts

    with {_, id} <- Enum.find(debit_accounts, fn {name, _} -> name == account_name end) do
      "#{id}"
    else
      _ ->
        type = socket.assigns.card == :expenses && :outcome || :assets
        {:ok, account} = Mate.Conty.create_account(%{name: account_name, type: type})

        "#{account.id}"
    end
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
       periodicity_types:
         build_periodicity_types_select_options(entry_group_params["periodicity"])
     )}
  end

  def handle_event(
        "save",
        %{"entry_group" => entry_group_params, "select_handler" => select_handler},
        socket
      ) do
    account_debit_name = select_handler["account_debit_name"]

    account_debit_id = account_debit_id(socket, account_debit_name)

    save_entry_group(
      socket,
      socket.assigns.action,
      Map.put(entry_group_params, "account_debit_id", account_debit_id)
    )
  end

  defp build_periodicity_types_select_options(periodicity) do
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

  defp save_entry_group(socket, action, entry_group_params) when action in ~w(new new_outcome)a do
    case Transactions.create_entry_group(entry_group_params) do
      {:ok, _entry_group} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
