# KinoKroki

[![Package Version](https://img.shields.io/hexpm/v/kino_kroki.svg)](https://hex.pm/packages/kino_kroki)

A Livebook smart-cell to render diagrams powered by [Kroki][kroki].

[![Livebook badge](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fhexdocs.pm%2Fkino_kroki%2Fexamples.livemd)

## Installation

Add it as a dependency in your notebook with:

```elixir
Mix.install([:kino_kroki])
```

## Usage

Paste the diagram source in the editor and select the diagram type.

![sample](https://i.imgur.com/p79Ev5E.png)

You may also render from a variable with:

```elixir
graph = """
digraph G { bgcolor="purple:pink" label="agraph" fontcolor="white"
fontname="Helvetica,Arial,sans-serif"
node [fontname="Helvetica,Arial,sans-serif"]
edge [fontname="Helvetica,Arial,sans-serif"]
  subgraph cluster1 {fillcolor="blue:cyan" label="acluster" fontcolor="white" style="filled" gradientangle="270"
        node [shape=box fillcolor="red:yellow" style="filled" gradientangle=90]
        anode;
    }

}

Kino.Kroki.new(graph, :graphviz)
```

## License

Copyright (c) 2022 Dimitris Zorbas, MIT License.
See [LICENSE.txt](https://github.com/zorbash/kino_kroki/blob/master/LICENSE.txt) for further details.

[kroki]: https://kroki.io
