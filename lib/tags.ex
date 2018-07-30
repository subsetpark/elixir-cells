defmodule Tags do
  require Logger

  @moduledoc """
  Models a tag system, consisting of three elements: a drop_number,
  alphabet, and ruleset.
  """

  @typedoc """
  A list of possible elements in a word.
  """
  @type alphabet :: charlist

  @typedoc """
  A tuple containing a set of drop and production rules for a tag system.
  """
  @type tag_system :: {drop_number, alphabet, CA.rules(char)}

  @typedoc """
  A number indicating how many elements to drop from the beginning of
  a word at each production.
  """
  @type drop_number :: non_neg_integer

  @halting_char ?H

  @doc """
  Given a word and tag system, process the word according to the system
  rules and return the halting word.
  """
  @spec produce(CA.word(char), tag_system) :: CA.word(char)
  def produce(word, {drop, _, _}) when length(word) < drop, do: word
  def produce([@halting_char | _] = word, _), do: word

  def produce([h | _] = word, {drop, _, rules} = system) do
    production = CA.produce(h, rules)

    word
    |> Enum.drop(drop)
    |> Kernel.++(production)
    |> produce(system)
  end

  defp atom_to_symbol(atom) do
    charlist = Atom.to_charlist(atom)

    case length(charlist) do
      1 -> hd(charlist)
      _ -> raise "Ruleset keys must be one character long"
    end
  end

  @doc """
  Given a drop number and a set of rules, create a tag system.

  > system = Tags.make_system(2, a: 'aaa', b: 'ab')
  {2, 'Hab', [{97, 'aaa'}, {98, 'ab'}]}
  """
  @spec make_system(drop_number, [{atom, charlist}]) :: tag_system
  def make_system(drop, rules) do
    to_chars =
      for {atom, production} <- rules do
        {atom_to_symbol(atom), production}
      end

    unless Enum.any?(rules, fn {_, p} -> Enum.member?(p, @halting_char) end) do
      Logger.warn("No rules will terminate. This may result in an infinite loop.")
    end

    {drop, get_alphabet(to_chars), Enum.into(to_chars, %{})}
  end

  defp get_alphabet(rules) do
    [@halting_char | for({symbol, _} <- rules, do: symbol)]
  end

  @doc """
  Generate a random word from a system's alphabet.
  """
  @spec make_state(tag_system, drop_number) :: CA.word(char)
  def make_state({_, alphabet, _}, size) do
    for _ <- 1..size, do: Enum.random(alphabet)
  end
end
