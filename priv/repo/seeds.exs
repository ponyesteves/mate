# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mate.Repo.insert!(%Mate.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Mate.Conty.create_account(%{name: "Bank", type: "assets"})
Mate.Conty.create_account(%{name: "Income", type: "income"})
Mate.Conty.create_account(%{name: "Receivable", type: "assets"})
Mate.Conty.create_account(%{name: "Payable", type: "liabilities"})
