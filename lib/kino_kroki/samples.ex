defmodule Kino.Kroki.Samples do
  @samples_file :code.priv_dir(:kino_kroki)
                |> Path.join("samples.txt")

  @external_resource @samples_file
  @samples_separator ~r/<--- sample:(?<type>.+) --->\n/m
  @samples @samples_file
           |> File.read!()
           |> String.split(@samples_separator,
             include_captures: true,
             trim: true
           )
           |> Enum.chunk_every(2)
           |> Enum.map(fn
             [separator, diagram] ->
               {String.to_atom(Regex.named_captures(@samples_separator, separator)["type"]),
                String.trim(diagram)}
           end)
           |> Map.new()

  @type type :: unquote(Enum.reduce(Map.keys(@samples), &{:|, [], [&1, &2]}))

  @moduledoc """
  Parses and makes samples easy to access.

  Samples for the following diagram types are available:

  #{for {type, _} <- @samples, into: "", do: "* `#{type}` \n"}
  """

  @doc "Return all the samples"
  @spec all :: map()
  def all, do: @samples

  @doc "Fetch a sample by diagram type"
  @spec get(type :: String.t() | type) :: String.t() | nil
  def get(type) when is_atom(type), do: @samples[type]
  def get(type) when is_bitstring(type), do: get(String.to_existing_atom(type))
end
