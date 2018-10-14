defmodule CA do
  @moduledoc """
  Entry module for initializing and running cellular automata.
  """
  @type t :: any()

  @typedoc """
  A pairing of an elment and the sequence of elements it should produce.
  """
  @type rules(t) :: %{required(t) => word(t)}

  @typedoc """
  A sequence of elements.
  """
  @type word(t) :: [t]

  @type bit :: 0 | 1

  @spec expand(integer, integer) :: [bit]
  defp expand(n, bits) do
    unpadded = Integer.digits(n, 2)
    to_pad = bits - length(unpadded)
    List.duplicate(0, to_pad) ++ unpadded
  end

  defp max(bits), do: :math.pow(2, bits) |> round

  defp make_rules("random", bits) do
    max = max(bits)
    make_rules(:rand.uniform(max), bits)
  end

  @spec make_rules(integer, integer) :: rules(bit)
  defp make_rules(n, bits) do
    max = max(bits)

    for(
      k <- (max - 1)..0,
      do: expand(k, bits)
    )
    |> Enum.zip(expand(n, max))
    |> Enum.into(%{})
  end

  @type system(t) :: {rules(t), atom}

  @spec init(atom, atom, integer, integer) :: {word(bit), system(bit)}
  def init(module, neighborhood_type, rule_number, state_size) do
    {module.make_state(state_size, neighborhood_type),
     {make_rules(rule_number, module.bits(neighborhood_type)), module}}
  end

  @spec run(word(any), system(any), integer) :: :ok
  def run(_, _, 0), do: :ok

  def run(state, {rules, module}, iterations) do
    module.produce(state, rules)
    |> module.render()
    |> run({rules, module}, iterations - 1)
  end

  @spec produce(t, rules(t)) :: t
  def produce(neighborhood, rules) do
    %{^neighborhood => production} = rules
    production
  end

  def render_cell(0), do: ?\s
  def render_cell(_), do: ?\█
end
