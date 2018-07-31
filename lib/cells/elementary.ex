defmodule CA.Elementary do
  @moduledoc """
  Elementary (1-dimensional) cellular automata.
  """

  @type t :: CA.word(CA.bit())

  @spec bits(any) :: integer
  def bits(_), do: 3

  defp produce(_, _, acc, n, n), do: Enum.reverse(acc)

  defp produce(state, rules, acc, n, m) do
    production =
      Stream.cycle(state)
      # Create a cycle starting with the last element of the state.
      |> Stream.drop(length(state) - 1)
      # A 3-slice starting at `n` will now start one back, modulo the
      # length of the state.
      |> Enum.slice(n, 3)
      |> CA.produce(rules)

    produce(state, rules, [production | acc], n + 1, m)
  end

  @doc """
  Produce one new generation from `state`, given `rules`.
  """
  @spec produce(t, [CA.rule(CA.bit())]) :: t
  def produce(state, rules), do: produce(state, rules, [], 0, length(state))

  @doc """
  Generate a random binary word of size `n`.
  """
  @spec make_state(integer, any) :: t
  def make_state(n, _) when n >= 1 do
    for _ <- 1..n, do: :rand.uniform(2) - 1
  end

  @spec render(t) :: t
  def render(s) do
    :ok = IO.puts(Enum.map(s, &CA.render_cell/1))
    s
  end
end
