defmodule CA.Util do
  @moduledoc """
  Generic functions for managing CAs.
  """
  @spec produce(CA.t(), [CA.rule(CA.t())]) :: CA.t()
  def produce(neighborhood, [{neighborhood, p} | _]), do: p

  def produce(neighborhood, [_ | rules]) do
    produce(neighborhood, rules)
  end

  def render_cell(0), do: ?\s
  def render_cell(_), do: ?\█
end
