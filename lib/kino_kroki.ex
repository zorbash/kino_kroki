defmodule Kino.Kroki do
  @moduledoc """
  A simple encoder for the online diagram renderer https://kroki.io/
  """

  @doc """
  Returns a `Kino.Markdown` image to render the diagram.

  ### Examples

      iex> Kino.Kroki.new(Kino.Kroki.Sample.get(:graphviz), :graphviz)
      %Kino.Markdown{
        content: "![svg](https://kroki.io/graphviz/svg/eJx9kM"
      }
  """
  @spec new(graph :: String.t(), type :: Kino.Kroki.Samples.type()) :: Kino.Markdown.t()
  def new(graph, type) do
    graph
    |> :zlib.compress()
    |> Base.url_encode64()
    |> then(&"https://kroki.io/#{type}/svg/#{&1}")
    |> then(&"![svg](#{&1})")
    |> Kino.Markdown.new()
  end
end
