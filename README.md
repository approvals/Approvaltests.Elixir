# Approval Testing Framework for Elixir
[![.github/workflows/test.yml](../../actions/workflows/test.yml/badge.svg)](../../actions/workflows/test.yml)


## Status - Work in Progress  

This is very early days.

Currently the code consists of a couple of helper functions you can use to run an approval test inside a unit test.  It has no line by line comparitor yet.  I am simply using a diff plugin.

A test looks something like the one below.

1. The input builder is a hook function that assembles the parameters to call the SUT (System Under Test) with.
1. The test data is a Keyword that holds the various values that exercise the corner cases.
1. `ExApproval.gen_test_data_set(test_data_set, input_builder)` creates a list of parameter sets that contains all the permutations of the test data. 
1. All the file writing and comparing files is still in the test.

<!-- snippet: guilded_rose_example -->
<a id='snippet-guilded_rose_example'></a>
```exs
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
```
<sup><a href='/test/example_test.exs#L14-L50' title='Snippet source file'>snippet source</a> | <a href='#snippet-guilded_rose_example' title='Start of snippet'>anchor</a></sup>
<!-- endSnippet -->
