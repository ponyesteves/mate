defmodule MateWeb.ViewHelpers do
  @moduledoc false
  import Phoenix.HTML.Form, only: [label: 4]
  import Phoenix.HTML, only: [sigil_E: 2]

  def to_select(enum) do
    Enum.map(enum, &{&1.name, &1.id})
  end

  def t(msg) do
    Gettext.gettext(MateWeb.Gettext, msg)
  end

  def tlabel(form, attr_key, opts \\ []) do
    label(
      form,
      attr_key,
      Gettext.dgettext(MateWeb.Gettext, "labels", Atom.to_string(attr_key)),
      opts
    )
  end

  @format_options [precision: 0, delimiter: ".", separator: ",", format: "%n"]

  def format_number(number, opts \\ @format_options)

  def format_number(numbers, [{:sup, sup} | opts]) do
    ~E"""
      <%= format_number(numbers, opts) %><sup class="ml-1"><%= find_sup_string(sup) %></sup>
    """
  end

  def format_number(number, opts) do
    Number.Delimit.number_to_delimited(number, Keyword.merge(@format_options, opts))
  end

  defp find_sup_string(sup) do
    [ars: "Ars", cab: "Cab", percent: "%", kg: "Kg", kg_cab: "Kg/Cab", ars_kg: "Ars/Kg"]
    |> Keyword.fetch!(sup)
  end

  def format_currency(number) do
    Number.Currency.number_to_currency(number, @format_options)
  end

  def format_time(time) do
    Timex.format!(time, "%d-%m", :strftime)
  end
end

