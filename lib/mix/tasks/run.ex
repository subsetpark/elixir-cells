defmodule Mix.Tasks.Ca do
  use Mix.Task

  def args(type, rule_number) do
    {module, neighborhood_type} =
      case type do
        "elementary" -> {CA.Elementary, :ok}
        "vn" -> {CA.VonNeumann, :von_neumann}
        "moore" -> {CA.VonNeumann, :moore}
      end

    rule =
      case rule_number do
        "random" -> rule_number
        n -> String.to_integer(n)
      end

    {module, neighborhood_type, rule}
  end

  def run([type, rule_number, size, iters]) do
    {module, neighborhood_type, rule} = args(type, rule_number)
    {state, init} = CA.init(module, neighborhood_type, rule, String.to_integer(size))
    CA.run(state, init, String.to_integer(iters))
  end

  def run([rule_number, size, iters]) do
    run(["elementary", rule_number, size, iters])
  end
end

defmodule Mix.Tasks.Svg do
  use Mix.Task
  alias Ca.Svg

  def render_state(state, filename) do
    rendered = Svg.render(state)

    File.write(filename, rendered)
    |> IO.inspect()
  end

  @col_num 2
  @row_num 3

  def run([type, rule_number, size, step, begin_at]) do
    {module, neighborhood_type, rule} = Mix.Tasks.Ca.args(type, rule_number)
    {state, {rules, module}} = CA.init(module, neighborhood_type, rule, String.to_integer(size))

    run_for = fn state, n ->
      1..String.to_integer(n)
      |> Enum.reduce(state, fn _, state -> module.produce(state, rules) end)
    end

    rendered =
      state
      |> Svg.generate(@col_num, @row_num, begin_at, step, run_for)
      |> Svg.render()

    File.write("#{type}-#{rule_number}-#{size}-#{step}-#{begin_at}.svg", rendered)
  end
end
