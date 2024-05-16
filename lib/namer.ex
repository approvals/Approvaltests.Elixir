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
           project_name: project_name,
           test_name: test_name,
           file_extension: extension,
           file_path: path
         },
         type
       ) do
    file_name = [project_name, test_name, type, extension] |> Enum.join(".")
    path <> "/" <> file_name
  end
end
