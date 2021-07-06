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

Mate.Conty.create_account(%{name: "Banco", type: "assets"})
Mate.Conty.create_account(%{name: "Freelance", type: "income"})
Mate.Conty.create_account(%{name: "Sueldo", type: "income"})
Mate.Conty.create_account(%{name: "Colegio", type: "outcome"})
Mate.Conty.create_account(%{name: "Energía", type: "outcome"})
Mate.Conty.create_account(%{name: "Gas", type: "outcome"})
Mate.Conty.create_account(%{name: "Cobros pendientes", type: "assets"})
Mate.Conty.create_account(%{name: "Pagos pendientes", type: "liabilities"})
