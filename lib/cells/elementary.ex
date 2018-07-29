defmodule CA.Elementary do
  @moduledoc """
  Elementary (1-dimensional) cellular automata.
  """

  @type t :: CA.word(CA.bit())

  @spec bits(any) :: integer
  def bits(_), do: 3

  defp produce(state, _, out, n) when n == length(state), do: Enum.reverse(out)

  defp produce(state, rules, out, n) do
    neighborhood = for k <- -1..1, i = rem(k + n, length(state)), do: Enum.fetch!(state, i)
    production = CA.Util.produce(neighborhood, rules)
    produce(state, rules, [production | out], n + 1)
  end

  @doc """
  Produce one new generation from `state`, given `rules`.
  """
  @spec produce(t, [CA.rule(CA.bit())]) :: t
  def produce(state, rules), do: produce(state, rules, [], 0)

  @doc """
  Generate a random binary word of size `n`.
  """
  @spec make_state(integer, any) :: t
  def make_state(n, _) when n >= 1 do
    for _ <- 1..n, do: :rand.uniform(2) - 1
  end

  @spec render(t) :: t
  def render(s) do
    :ok = IO.puts(for d <- s, do: CA.Util.render_cell(d))
    s
  end
end
