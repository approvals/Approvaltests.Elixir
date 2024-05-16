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

  def get_namer_parts() do
    Process.info(self(), :current_stacktrace)
    |> elem(1)
    |> Enum.at(2)
    |> elem(3)
    |> Enum.at(0)
    |> elem(1)
    |> to_string()
    |> String.split(~r"(/|\.)")
    |> then(fn bits ->
      Enum.zip([:directory, :source_file_name, :source_file_extension], bits) |> Enum.into(%{})
    end)
  end
end
