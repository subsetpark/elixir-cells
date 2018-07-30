defmodule CellsTest do
  use ExUnit.Case
  use ExUnitProperties

  property "rules produce matching production" do
    check all word <- term(),
              production <- term(),
              other_word <- term() |> filter(&(&1 !== word)),
              other_production <- term() do
      assert CA.produce(word, %{word => production, other_word => other_production}) == production
    end
  end
end

defmodule ElementaryTest do
  use ExUnit.Case
  use ExUnitProperties

  property "make state produces binary word of desired length" do
    check all length <- integer() |> filter(&(&1 > 0)) do
      state = CA.Elementary.make_state(length, :ok)
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
      grid = Grid.new_grid(length, :von_neumann)
      values = Map.values(grid.map)

      assert length(values) == length * length
      assert Enum.all?(values, &(&1 == 0))
    end
  end

  test "von neumann neighborhood ordering" do
    vn_grid = %Grid{
      map: %{
        {0, 0} => 1,
        {1, 0} => 2,
        {2, 0} => 3,
        {0, 1} => 4,
        {1, 1} => 5,
        {2, 1} => 6,
        {0, 2} => 7,
        {1, 2} => 8,
        {2, 2} => 9
      },
      size: 3,
      type: :von_neumann
    }

    assert Grid.get_neighborhood(vn_grid, {1, 1}) == [2, 4, 5, 6, 8]
    assert Grid.get_neighborhood(vn_grid, {1, 0}) == [8, 1, 2, 3, 5]

    moore_grid = %Grid{vn_grid | type: :moore}

    assert Grid.get_neighborhood(moore_grid, {1, 1}) == [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  property "neighborhood size is always 9" do
    check all length <- integer() |> filter(&(&1 > 0)),
              x <- integer() |> filter(&(&1 < length)),
              y <- integer() |> filter(&(&1 < length)) do
      assert length
             |> Grid.new_grid(:moore)
             |> Grid.get_neighborhood({x, y})
             |> length() == 9
    end
  end
end

defmodule VonNeumannTest do
  use ExUnit.Case
  use ExUnitProperties

  property "make state produces a random grid" do
    check all length <- integer() |> filter(&(&1 > 0)) do
      state = CA.VonNeumann.make_state(length, :moore)

      assert state.size == length

      values = Map.values(state.map)

      assert length(values) == length * length
      assert Enum.all?(values, &(&1 == 0 or &1 == 1))
    end
  end
end
