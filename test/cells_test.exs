defmodule CellsTest do
  use ExUnit.Case
  use ExUnitProperties

  property "rules produce matching production" do
    check all word <- term(),
              production <- term(),
              other_rule <- {term(), term()} do
      word_rule = {word, production}

      assert CA.Util.produce(word, [word_rule, other_rule]) == production
    end
  end
end

defmodule ElementaryTest do
  use ExUnit.Case
  use ExUnitProperties

  property "make state produces binary word of desired length" do
    check all length <- integer() |> filter(&(&1 > 0)) do
      state = CA.Elementary.make_state(length)
      assert length(state) == length
      assert Enum.all?(state, &(&1 == 0 or &1 == 1))
    end
  end
end

defmodule GridsTest do
  use ExUnit.Case
  use ExUnitProperties

  property "new grid produces grid of correct size and values" do
    check all length <- integer() |> filter(&(&1 > 0)) do
      grid = Grid.new_grid(length)
      values = Map.values(grid.map)

      assert length(values) == length * length
      assert Enum.all?(values, &(&1 == 0))
    end
  end

  property "neighborhood size is always 9" do
    check all length <- integer() |> filter(&(&1 > 0)),
              x <- integer() |> filter(&(&1 < length)),
              y <- integer() |> filter(&(&1 < length)) do
      assert length
             |> Grid.new_grid()
             |> Grid.get_moore_neighborhood({x, y})
             |> length() == 9
    end
  end
end

defmodule VonNeumannTest do
  use ExUnit.Case
  use ExUnitProperties

  property "make state produces a random grid" do
    check all length <- integer() |> filter(&(&1 > 0)) do
      state = CA.VonNeumann.make_state(length)

      assert state.size == length

      values = Map.values(state.map)

      assert length(values) == length * length
      assert Enum.all?(values, &(&1 == 0 or &1 == 1))
    end
  end
end
