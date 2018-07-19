defmodule CA.Util do
  defp expand(n, bits) do
    unpadded = Integer.digits(n, 2)
    to_pad = bits - length(unpadded)
    List.duplicate(0, to_pad) ++ unpadded
  end

  defp make_rule(n, bits) do
    max = :math.pow(2, bits) |> round

    for(
      k <- (max - 1)..0,
      do: expand(k, bits)
    )
    |> Enum.zip(expand(n, max))
  end

  def run(_, _, 0), do: :ok

  def run(state, {rules, gen_fn, render_fn}, iterations) do
    gen_fn.(state, rules)
    |> render_fn.()
    |> run({rules, gen_fn, render_fn}, iterations - 1)
  end

  def init(module \\ CA.Elementary, rule_number, state_size) do
    render_fn = fn state -> module.render(state, &render_cell/1) end

    {module.make_state(state_size),
     {make_rule(rule_number, module.bits()), &module.produce/2, render_fn}}
  end

  defp render_cell(cell) when cell == 0, do: ?\s
  defp render_cell(_), do: ?\█

  def produce(neighborhood, [{neighborhood, p} | _]), do: p

  def produce(neighborhood, [_ | rules]) do
    produce(neighborhood, rules)
  end
end
