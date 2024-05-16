defmodule Writer do
  @moduledoc """
    Writes output files.
  """

  def write(config, content) do
    File.write!(Namer.received_name(config), String.replace(content, "\r\n", "\n"))
  end
end
