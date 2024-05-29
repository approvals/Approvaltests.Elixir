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
    Path.join([path, file_name])
  end

  def get_parts(caller_file) do
    caller_file
    |> Path.relative_to(File.cwd!())
    |> Path.rootname()
    |> Path.split()
    |> make_default_config()
  end

  defp make_default_config([path, test_name]) do
    project_name = Mix.Project.config()[:app] |> Atom.to_string()

    %Approvals{
      project_name: project_name,
      file_path: path,
      test_name: test_name,
      file_extension: "txt"
    }
  end
end
