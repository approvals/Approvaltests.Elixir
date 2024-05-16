defmodule ApprovalsTest do
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
      project_name: "project",
      test_name: "test",
      file_extension: "txt",
      file_path: "test"
    }
  end

  test "received name" do
    assert Namer.received_name(config()) ==
             "test/project.test.received.txt"
  end

  test "approved name" do
    assert Namer.approved_name(config()) ==
             "test/project.test.approved.txt"
  end
end
