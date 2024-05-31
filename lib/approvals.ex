defmodule Approvals do
  require ExUnit.Assertions

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

  @doc """
  Generates a default options %Approval{} struct based on the calling test to pass to
  the verify function.
  """
  defmacro verify(data) do
    quote do
      options = __ENV__.file |> Namer.get_parts()
      Approvals.verify(unquote(data), options)
    end
  end

  @doc """
  Takes the generated output and the options %Approval{} struct to write the
  data to a "received" file and compares it to the existing "approved" file.
  """
  def verify(data, options) do
    received_file_name = Namer.received_name(options)
    Writer.write(data, received_file_name)

    approved_file_name = Namer.approved_name(options)

    received_data = File.read!(received_file_name)
    approved_data = File.read!(approved_file_name)

    cond do
      approved_data == received_data ->
        true

      true ->
        System.cmd("code", ["-d", received_file_name, approved_file_name])
        ExUnit.Assertions.assert(approved_data == received_data)
    end
  end
end
