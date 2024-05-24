defmodule Namer do
  @moduledoc """
    Creates names for output files.

    General format

    ```file_name.test_name.(approved|received).extension```

    e.g. ```project.subsystem.approved.txt```
  """

  def received_name(config), do: name(config, "received")

  def approved_name(config), do: name(config, "approved")

  defp name(
         %Approvals{
           test_name: test_name,
           file_extension: extension,
           file_path: path
         },
         type
       ) do
    file_name = [test_name, type, extension] |> Enum.join(".")
    path <> "/" <> file_name
  end

  defmacro get_namer_parts() do
    __CALLER__.file
    |> String.replace_prefix(File.cwd!(), "")
    |> String.split(~r"(/|\.)")
    |> fileparts()
    |> Macro.escape()
  end

  defp fileparts([_ | bits]) do
    Enum.zip([:directory, :source_file_name, :source_file_extension], bits) |> Enum.into(%{})
  end
end
