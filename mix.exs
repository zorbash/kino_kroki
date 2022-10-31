defmodule Kino.Kroki.MixProject do
  use Mix.Project

  @source_url "https://github.com/zorbash/kino_kroki"

  def project do
    [
      app: :kino_kroki,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "A Livebook smart-cell to render diagrams powered by kroki.io",
      docs: [
        main: "readme",
        extras: ["README.md", "priv/examples.livemd"],
        homepage_url: @source_url,
        source_url: @source_url,
        before_closing_body_tag: &before_closing_body_tag/1
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Kino.Kroki.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.7"},
      {:ex_doc, "~> 0.28", only: :dev}
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "priv/samples.txt",
        "priv/examples.livemd",
        "README.md",
        "LICENSE.txt"
      ],
      maintainers: ["Dimitris Zorbas"],
      licenses: ["MIT"],
      links: %{github: @source_url}
    ]
  end

  defp before_closing_body_tag(:html) do
    """
    <script>
    if (document.queryselector('#full-width')) {
      let content = document.queryselector('#content');

      content.style.margin = '0';
      content.style.padding = '0';
      content.style.maxwidth = '100%';

      for (const heading of content.queryselectorall("h1, h2, h3")) {
        heading.style.paddingleft = '40px';
      }
    }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/vanilla-js-wheel-zoom@6.17.2/dist/wheel-zoom.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/mermaid@9.1.6/dist/mermaid.min.js"></script>
    <script>
      document.addeventlistener("domcontentloaded", function () {
        mermaid.initialize({ startonload: false });
        let id = 0;
        for (const codeel of document.queryselectorall("pre code.mermaid")) {
          const preel = codeel.parentelement;
          const graphdefinition = codeel.textcontent;
          const graphel = document.createelement("div");
          const graphid = "mermaid-graph-" + id++;
          mermaid.render(graphid, graphdefinition, function (svgsource, bindlisteners) {
            graphel.innerhtml = svgsource;
            bindlisteners && bindlisteners(graphel);
            preel.insertadjacentelement("afterend", graphel);
            preel.remove();

            // Make mermaid diagrams zoomable
            graphel.style.cursor = 'grab';
            wzoom.create(graphel, {
              type: 'html',
              maxscale: 10,
              speed: 100
            });
          });
        }
      });
    </script>
    """
  end

  defp before_closing_body_tag(_), do: ""
end
