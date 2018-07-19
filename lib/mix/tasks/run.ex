defmodule Mix.Tasks.Ca do
  use Mix.Task

  def run([type, rule_number, size, iters]) do
    module =
      case type do
        "elementary" -> CA.Elementary
        "vn" -> CA.VonNeumann
      end

    {state, init} = CA.Util.init(module, String.to_integer(rule_number), String.to_integer(size))
    CA.Util.run(state, init, String.to_integer(iters))
  end

  def run([rule_number, size, iters]) do
    run(["elementary", rule_number, size, iters])
  end
end
