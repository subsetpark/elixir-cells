defmodule CA do
  def apply_rules(neighborhood, [{neighborhood, r} | _]), do: r

  def apply_rules(neighborhood, [_ | rules]) do
    apply_rules(neighborhood, rules)
  end

  def process_state(state, rules), do: process_state(state, rules, [], 0)

  defp process_state(state, _, out, n) when n == length(state), do: Enum.reverse(out)
  defp process_state(state, rules, out, n) do
    neighborhood = for k <- -1..1, i <- rem((k + n), length(state)), do: Enum.fetch!(state, i)
    r = apply_rules(neighborhood, rules)
    process_state(state, rules, [r|out], n+1)
  end

  def make_state(n) do
    for _ <- 1..n, do: :rand.uniform(2) - 1
  end

  def render(s) do
    IO.puts for d <- s, do: render_cell(d)
  end

  defp render_cell(cell) when cell == 0, do: ?\s
  defp render_cell(_), do: ?\#
end
