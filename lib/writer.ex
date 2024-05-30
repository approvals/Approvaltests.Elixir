defmodule Writer do
  @moduledoc """
    Writes output files.
  """

  def write(content, file_name) when is_binary(content) do
    content
    |> String.replace("\r\n", "\n")
    |> then(&File.write!(file_name, &1))
  end

  def write(content, file_name) do
    content
    |> inspect(pretty: true, limit: :infinity)
    |> String.replace("\r\n", "\n")
    |> then(&File.write!(file_name, &1))
  end
end
