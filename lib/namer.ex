defmodule Namer do
  @moduledoc """
    Creates names for output files.

    General format

    ```file_name.test_name.(approved|received).extension```

    e.g. ```project.subsystem.approved.txt```
  """

  def received_name(project_name, test_name, extension, path) do
    file_name = [project_name, test_name, "received", extension] |> Enum.join(".")
    path <> "/" <> file_name
  end

  def approved_name(project_name, test_name, extension, path) do
    file_name = [project_name, test_name, "approved", extension] |> Enum.join(".")
    path <> "/" <> file_name
  end
end
