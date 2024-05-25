defmodule ExampleTest do
  use ExUnit.Case

  require Approvals

  defmodule Item do
    defstruct name: nil, sell_in: nil, quality: nil
  end

  defmodule GuildedRose do
    def update_quality(data), do: data
  end

  # begin-snippet: guilded_rose_example

  # If you want to set up special output file names you can define the parts here
  # otherwise they default to the test file name.
  
  # def config do
  #   %Approvals{
  #     project_name: "approval_tests",
  #     test_name: "example_test",
  #     file_extension: "txt",
  #     file_path: "test"
  #   }
  # end

  test "Approvals test" do
    input_builder = fn %{name: name, sell_in: sell_in, quality: quality} ->
      %Item{name: name, sell_in: sell_in, quality: quality}
    end

    test_data =
      [
        name: [
          "Others",
          "Aged Brie",
          "Backstage passes to a TAFKAL80ETC concert",
          "Sulfuras, Hand of Ragnaros"
        ],
        sell_in: [-1, 0, 1, 10, 50],
        quality: [0, 1, 49, 50]
      ]
      |> Approvals.gen_test_data_set(input_builder)

    GuildedRose.update_quality(test_data)
    |> Approvals.verify()
  end

  # end-snippet
end
