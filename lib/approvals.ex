defmodule Approvals do
  @moduledoc """
  Helper functions to implement approval testing
  """

  @doc "Parameters for the current approval test"
  defstruct [:project_name, :test_name, :file_extension, :file_path]

  @spec gen_test_data_set(keyword(), fun()) :: list()
  @doc """
  creates a list of parameter sets that contains all the permutations of the
  test data.
  """
  def gen_test_data_set(parameters, input_constructor) do
    parameters
    |> Enum.map(fn {id, lst} -> Enum.map(lst, fn el -> {id, el} end) end)
    |> permutations()
    |> Enum.map(&input_constructor.(&1))
  end

  @spec permutations(list(list())) :: map()
  defp permutations([]), do: %{}
  defp permutations([hd]), do: Enum.map(hd, &Enum.into([&1], %{}))

  defp permutations([hd | tail]) do
    for {k, v} <- hd,
        submap <-
          Enum.map(
            permutations(tail),
            fn submap -> Map.put(submap, k, v) end
          ) do
      submap
    end
  end

  def verify(data) do
    verify(data, %Approvals{})
  end

  def verify(_data, _options) do
    nil
  end

  @spec same?(keyword()) :: boolean()
  @doc """
  Takes a diffset and returns true if there are no changes.
  """
  def same?([]), do: true

  def same?(diffs) do
    keys = Keyword.keys(diffs)

    length(keys) == 1 && List.first(keys) == :equal
  end
end
