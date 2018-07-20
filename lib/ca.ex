defmodule CA do
  @doc """
  Entry module for initializing and running cellular automata.
  """

  @typedoc """
  A pairing of an elment and the sequence of elements it should produce.
  """
  @type rule(t) :: {t, word(t)}

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

  @spec make_rules(integer, integer) :: [rule(bit)]
  defp make_rules(n, bits) do
    max = :math.pow(2, bits) |> round

    for(
      k <- (max - 1)..0,
      do: expand(k, bits)
    )
    |> Enum.zip(expand(n, max))
  end

  @type system(t) :: {[rule(t)], fun, fun}

  @spec init(atom, integer, integer) :: {word(bit), system(bit)}
  def init(module, rule_number, state_size) do
    {module.make_state(state_size),
     {make_rules(rule_number, module.bits()), &module.produce/2, &module.render/1}}
  end

  @spec run(word(any), system(any), integer) :: :ok
  def run(_, _, 0), do: :ok

  def run(state, {rules, gen_fn, render_fn}, iterations) do
    gen_fn.(state, rules)
    |> render_fn.()
    |> run({rules, gen_fn, render_fn}, iterations - 1)
  end
end
