defmodule CA.Elementary do
  def bits, do: 3

  def produce(state, rules), do: produce(state, rules, [], 0)

  defp produce(state, _, out, n) when n == length(state), do: Enum.reverse(out)

  defp produce(state, rules, out, n) do
    neighborhood = for k <- -1..1, i = rem(k + n, length(state)), do: Enum.fetch!(state, i)
    production = CA.Util.produce(neighborhood, rules)
    produce(state, rules, [production | out], n + 1)
  end

  def make_state(n) do
    for _ <- 1..n, do: :rand.uniform(2) - 1
  end

  def render(s, render_fn) do
    :ok = IO.puts(for d <- s, do: render_fn.(d))
    s
  end
end
