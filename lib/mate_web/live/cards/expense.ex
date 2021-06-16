defmodule MateWeb.ExpenseCard do
  @moduledoc false
  use MateWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card__header--danger">
        <div class="card__header-title">Gastos</div>
        <%= live_patch to: Routes.page_path(@socket, :new), class: "btn btn-danger border-white" do %>
          <i class="fa fa-plus"></i>
        <% end %>
      </div>
      <div class="card-body">
        <ul class="list-group">
          <%= for balance <- @balances do %>
            <li class="list-group__item text-secondary">
            <div class="row">
              <div class="col-4">
                <%= balance.account.name %>
              </div>
              <div class="col-4 d-flex justify-content-end align-items-center">
                <%= format_number(balance.amount, sup: :ars) %>
              </div>
              <div class="col-4 d-flex justify-content-end align-items-center">
                <%= live_component @socket, MateWeb.DropdownComponent, %{id: "expense_#{balance.account.id}"} do %>
                  <li>
                    <%= live_patch "Corregir", to: Routes.page_path(@socket, :adjust_balance, balance.account), class: "dropdown-item" %>
                  </li>
                  <li>
                    <%= live_patch "Mover", to: Routes.page_path(@socket, :move_balance, balance.account), class: "dropdown-item" %>
                  </li>
                <% end %>
              </div>
            </div>
            </li>
          <% end %>
          <li class="list-group__item bg-secondary text-white">
            <div class="row">
              <div class="col-4">
                Total
              </div>
              <div class="col-4 d-flex justify-content-end align-items-center">
                <%= Mate.EnumHelpers.totalize(@balances, :amount) |> format_number(sup: :ars) %>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>

    """
  end
end
