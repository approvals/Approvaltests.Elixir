defmodule ExampleTest do
  use ExUnit.Case

  defmodule Item do
    defstruct name: nil, sell_in: nil, quality: nil
  end

  defmodule GuildedRose do
    def update_quality(data), do: data
  end

  # begin-snippet: guilded_rose_example

  def config do
    %Approvals{
      project_name: "ex_approval",
      test_name: "example",
      file_extension: "txt",
      file_path: "test"
    }
  end

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

    received_output =
      GuildedRose.update_quality(test_data)
      |> inspect(pretty: true, infinity: true)

    Writer.write(config(), received_output)

    approved_output = File.read!(Namer.approved_name(config()))

    assert(approved_output == received_output)
  end

  # end-snippet

  test "simple test" do
    "Hello World" |> Approvals.verify()
  end
end
