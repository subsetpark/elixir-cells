defmodule CA.Elementary do
  @moduledoc """
  Elementary (1-dimensional) cellular automata.
  """

  @type t :: CA.word(CA.bit())

  @spec bits(any) :: integer
  def bits(_), do: 3

  defp produce([x, y, z | cycle], rules, acc) do
    production = CA.produce([x, y, z], rules)
    produce([y, z | cycle], rules, [production | acc])
  end

  defp produce(_, _, acc), do: Enum.reverse(acc)

  @doc """
  Produce one new generation from `state`, given `rules`.
  """
  @spec produce(t, [CA.rule(CA.bit())]) :: t
  def produce(state, rules) do
    length = length(state)

    Stream.cycle(state)
    # Create a cycle starting with the last element of the state.
    |> Stream.drop(length - 1)
    # Take enough for the whole state with the modular neighborhood
    # on either end.
    |> Enum.take(length + 2)
    |> produce(rules, [])
  end

  @doc """
  Generate a random binary word of size `n`.
  """
  @spec make_state(integer, any) :: t
  def make_state(n, _) when n >= 1 do
    for _ <- 1..n, do: :rand.uniform(2) - 1
  end

  @spec render(t) :: t
  def render(s) do
    :ok = Enum.map(s, &CA.render_cell/1) |> IO.puts()
    s
  end
end
