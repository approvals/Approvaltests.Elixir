defmodule ApprovalsTest do
  require Namer
  use ExUnit.Case

  doctest Approvals

  test "diffs in one line" do
    diffs =
      Dmp.Diff.main(
        "The quick brown fox jumps over the lazy dog.",
        "The quick brown fox jumps over the lazy dog."
      )

    assert assert Approvals.same?(diffs)
  end

  test "diffs empty -> written strings" do
    diffs =
      Dmp.Diff.main(
        "",
        "test"
      )

    assert assert not Approvals.same?(diffs)
  end

  test "diffs empty strings" do
    diffs =
      Dmp.Diff.main(
        "",
        ""
      )

    assert assert Approvals.same?(diffs)
  end

  test "diffs in one multiline" do
    diffs =
      Dmp.Diff.main(
        """
        The quick brown fox jumps over the lazy dog.
        """,
        """
        The quick brown fox jumps over the lazy dog.
        """
      )

    assert Approvals.same?(diffs)
  end

  test "diffs in multiline" do
    diffs =
      Dmp.Diff.main(
        """
        the quick brown fox
        jumps over the lazy dog.
        """,
        """
        The quick brown fox
        Jumps over the lazy dog.
        """
      )

    assert not Approvals.same?(diffs)
  end

  defp config do
    %Approvals{
      test_name: "test",
      file_extension: "txt",
      file_path: "test"
    }
  end

  test "received name" do
    assert Namer.received_name(config()) ==
             "test/test.received.txt"
  end

  test "approved name" do
    assert Namer.approved_name(config()) ==
             "test/test.approved.txt"
  end

  test "get revieved name" do
    parts = Namer.get_parts(__ENV__.file)
    assert parts.test_name == "approval_test"
  end

  test "simple test" do
    "Hello World" |> Approvals.verify()
  end

  test "empty test data" do
    assert(Approvals.gen_test_data_set([], fn x -> x end) == [])
  end

  test "single category empty test data set" do
    assert(Approvals.gen_test_data_set([x: []], fn x -> x end) == [])
  end

  test "two category empty test data set" do
    assert(Approvals.gen_test_data_set([x: [], y: []], fn x -> x end) == [])
  end

  test "single category single item test data set" do
    assert(Approvals.gen_test_data_set([x: [1]], fn %{x: x} -> {x} end) == [{1}])
  end

  test "two category single item test data set" do
    actual = Approvals.gen_test_data_set([x: [1], y: [2]], fn %{x: x, y: y} -> {x, y} end)
    expected = [{1, 2}]
    assert actual == expected
  end

  test "two category 2:1 item count test data set" do
    actual = Approvals.gen_test_data_set([x: [1, 2], y: [3]], fn %{x: x, y: y} -> {x, y} end)
    expected = [{1, 3}, {2, 3}]
    assert actual == expected
  end

  test "two category 1:2 item count test data set" do
    actual = Approvals.gen_test_data_set([x: [1], y: [2, 3]], fn %{x: x, y: y} -> {x, y} end)
    expected = [{1, 2}, {1, 3}]
    assert actual == expected
  end

  test "two category two item test data set" do
    actual = Approvals.gen_test_data_set([x: [1, 2], y: [3, 4]], fn %{x: x, y: y} -> {x, y} end)
    expected = [{1, 3}, {1, 4}, {2, 3}, {2, 4}]
    assert actual == expected
  end
end
