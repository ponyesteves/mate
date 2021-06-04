defmodule MateWeb.Dropdown do
  @moduledoc false
  use MateWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="dropdown">
      <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="<%= @id %>" data-bs-toggle="dropdown" aria-expanded="false">
        <i class="fa fa-gear"></i>
      </button>
      <ul class="dropdown-menu" aria-labelledby="<%= @id %>">
        <%= render_block @inner_block %>
      </ul>
    </div>
    """
  end
end
