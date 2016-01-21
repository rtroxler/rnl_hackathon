ExUnit.start

Mix.Task.run "ecto.create", ~w(-r RnlHackathon.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r RnlHackathon.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(RnlHackathon.Repo)

