defmodule Tags do
  @moduledoc """
  Models a tag system, consisting of three elements: a drop_number,
  alphabet, and ruleset.
  """

  @typedoc """
  A tuple containing a set of drop and production rules for a tag system.
  """
  @type tag_system :: {drop_number, alphabet, [rule]}

  @typedoc """
  A number indicating how many elements to drop from the beginning of
  a word at each production.
  """
  @type drop_number :: non_neg_integer

  @typedoc """
  A list of possible elements in a word.
  """
  @type alphabet :: symbol

  @typedoc """
  A pairing of an elment and the sequence of elements it should produce.
  """
  @type rule :: {symbol, word}

  @type symbol :: term

  @typedoc """
  A sequence of elements, possibly including a termination character.
  """
  @type word :: [symbol]

  @halting_char ?H

  @doc """
  Given a word and tag system, process the word according to the system
  rules and return the halting word.
  """
  @spec process_state(word, tag_system) :: word
  def process_state(word, {drop, _, _}) when length(word) < drop, do: word
  def process_state([@halting_char | _] = word, _), do: word

  def process_state([h | _] = word, {drop, _, rules} = system) do
    production = CA.apply_rules(h, rules)
    process_state(Enum.drop(word, drop) ++ production, system)
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
        {atom |> to_charlist() |> hd(), production}
      end

    alphabet = get_alphabet(to_chars)
    {drop, alphabet, to_chars}
  end

  defp get_alphabet(rules) do
    [@halting_char | for({symbol, _} <- rules, do: symbol)]
  end

  @doc """
  Generate a random word from a system's alphabet.
  """
  @spec make_state(drop_number, tag_system) :: word
  def make_state(size, {_, alphabet, _}) do
    for _ <- 1..size, do: Enum.random(alphabet)
  end
end
