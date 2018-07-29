defmodule Mix.Tasks.Ca do
  use Mix.Task

  def run([type, rule_number, size, iters]) do
    {module, neighborhood_type} =
      case type do
        "elementary" -> {CA.Elementary, :ok}
        "vn" -> {CA.VonNeumann, :von_neumann}
        "moore" -> {CA.VonNeumann, :moore}
      end

    {state, init} = CA.init(module, neighborhood_type, String.to_integer(rule_number), String.to_integer(size))
    CA.run(state, init, String.to_integer(iters))
  end

  def run([rule_number, size, iters]) do
    run(["elementary", rule_number, size, iters])
  end
end
