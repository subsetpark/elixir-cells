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

  def run_for(state, _, _, 0), do: state

  def run_for(state, module, rules, n) do
    module.produce(state, rules)
    |> run_for(module, rules, n - 1)
  end

  def render_state(state) do
    state
    |> Svg.render()
    |> IO.puts()

    state
  end

  def run([type, rule_number, size]) do
    {module, neighborhood_type, rule} = Mix.Tasks.Ca.args(type, rule_number)
    {state, {rules, module}} = CA.init(module, neighborhood_type, rule, String.to_integer(size))

    offsets = [
      {10, 10},
      {60, 10},
      {10, 60},
      {60, 60},
      {10, 110},
      {60, 110}
    ]

    svg = %Svg{width: 110, height: 170}

    {_, svg} =
      offsets
      |> Enum.reduce({state, svg}, fn offset, {state, svg} ->
        state = run_for(state, module, rules, 20)
        svg = Ca.Svg.add_cells(svg, state, offset)

        {state, svg}
      end)

    render_state(svg)
  end
end
