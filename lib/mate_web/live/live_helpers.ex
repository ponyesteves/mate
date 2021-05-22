defmodule MateWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `MateWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, MateWeb.EntryGroupLive.FormComponent,
        id: @entry_group.id || :new,
        action: @live_action,
        entry_group: @entry_group,
        return_to: Routes.entry_group_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, MateWeb.ModalComponent, modal_opts)
  end
end
