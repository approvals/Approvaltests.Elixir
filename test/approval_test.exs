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
    __ENV__.file
    parts = Namer.get_parts(__ENV__.file)
    IO.inspect(parts, label: "PARTS TEST")
    assert parts.test_name == "approval_test"
  end

  test "simple test" do
    "Hello World" |> Approvals.verify()
  end
end
