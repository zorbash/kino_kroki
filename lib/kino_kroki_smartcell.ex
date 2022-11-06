defmodule Kino.KrokiSmartcell do
  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "Diagram"

  @default_type "graphviz"

  @impl true
  def init(_attrs, ctx) do
    ctx =
      ctx
      |> assign(type: @default_type)
      |> assign(diagram: Kino.Kroki.Samples.get(@default_type))

    {:ok, ctx}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{type: ctx.assigns.type, diagram: ctx.assigns.diagram}, ctx}
  end

  @impl true
  def handle_event("update_type", type, ctx) do
    ctx = assign(ctx, type: type)

    diagram = Kino.Kroki.Samples.get(type)

    ctx = update(ctx, :diagram, fn _ -> diagram end)
    broadcast_event(ctx, "update_type", %{type: ctx.assigns.type, diagram: diagram})

    {:noreply, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    %{"type" => ctx.assigns.type, "diagram" => ctx.assigns.diagram}
  end

  @impl true
  def to_source(attrs) do
    quote do
      Kino.Kroki.new(unquote(attrs["diagram"]), unquote(attrs["type"]))
    end
    |> Kino.SmartCell.quoted_to_string()
  end

  asset "main.js" do
    """
    export function init(ctx, payload) {
      ctx.importCSS("main.css");
      ctx.importCSS("https://fonts.googleapis.com/css2?family=Inter:wght@400;500&display=swap");

      root.innerHTML = `
        <div class="app">
          <form>
            <div class="container">
              <div class="row header">
                <div class="inline-field">
                  <label class="inline-input-label label">Diagram type</label>
                  <select class="input" name="type"/>
                    <option value="blockdiag">BlockDiag</option>
                    <option value="bpmn">BPMN</option>
                    <option value="bytefield">Bytefield</option>
                    <option value="seqdiag">SeqDiag</option>
                    <option value="actdiag">ActDiag</option>
                    <option value="nwdiag">NwDiag</option>
                    <option value="packetdiag">PacketDiag</option>
                    <option value="rackdiag">RackDiag</option>
                    <option value="c4plantuml">C4 with PlantUML</option>
                    <option value="ditaa">Ditaa</option>
                    <option value="erd">Erd</option>
                    <option value="excalidraw">Excalidraw</option>
                    <option selected value="graphviz">GraphViz</option>
                    <option value="mermaid">Mermaid</option>
                    <option value="nomnoml">Nomnoml</option>
                    <option value="pikchr">Pikchr</option>
                    <option value="plantuml">PlantUML</option>
                    <option value="structurizr">Structurizr</option>
                    <option value="svgbob">Svgbob</option>
                    <option value="vega">Vega</option>
                    <option value="vegalite">Vega-Lite</option>
                    <option value="wavedrom">WaveDrom</option>
                  </select>
                </div>

                <div class="logo">
                  <span>Powered by: </span>
                  <a href="https://kroki.io">
                    <img alt="kroki" src="https://kroki.io/assets/logo.svg"/>
                  </a>
                </div>
              </div>

              <div class="row">
                <div class="field grow">
                  <label class="input-label">Diagram Source</label>
                  <textarea
                    id="diagram-source"
                    name="diagram"
                    class="input textarea code"
                    placeholder=""
                    rows="25">#{Kino.Kroki.Samples.get(@default_type)}</textarea>
                </div>
              </div>
            </container>
          </form>
        </div>
      `;

      const typeEl = ctx.root.querySelector(`[name="type"]`);
      const diagramEl = ctx.root.querySelector(`#diagram-source`);

      typeEl.addEventListener("change", (event) => {
        ctx.pushEvent("update_type", event.target.value);
      });

      ctx.handleEvent("update_type", (event) => {
        typeEl.value = event.type;
        diagramEl.value = event.diagram;
      });

      ctx.handleSync(() => {
        // Synchronously invokes change listeners
        document.activeElement &&
          document.activeElement.dispatchEvent(new Event("change"));
      });
    }
    """
  end

  asset "main.css" do
    """
    .app {
      font-family: "Inter";
      box-sizing: border-box;

      --gray-50: #f8fafc;
      --gray-100: #f0f5f9;
      --gray-200: #e1e8f0;
      --gray-300: #cad5e0;
      --gray-400: #91a4b7;
      --gray-500: #61758a;
      --gray-600: #445668;
      --gray-800: #1c2a3a;

      --blue-100: #ecf0ff;
    }

    input,
    select,
    textarea,
    button {
      font-family: inherit;
    }

    .container {
      border: solid 1px var(--gray-300);
      border-radius: 0.5rem;
      background-color: rgba(248, 250, 252, 0.3);
      padding-bottom: 8px;
    }


    .row {
      display: flex;
      align-items: center;
      padding: 8px 16px;
      gap: 8px;
    }

    .header {
      display: flex;
      justify-content: space-between;
      background-color: var(--blue-100);
      padding: 8px 16px;
      margin-bottom: 12px;
      border-radius: 0.5rem 0.5rem 0 0;
      border-bottom: solid 1px var(--gray-200);
      gap: 16px;
    }

    .input--text {
      max-width: 50%;
    }

    .label {
      font-size: 0.875rem;
      font-weight: 500;
      color: #445668;
      text-transform: uppercase;
    }

    .input-label {
      display: block;
      margin-bottom: 2px;
      font-size: 0.875rem;
      color: var(--gray-800);
      font-weight: 500;
    }

    .inline-input-label {
      display: block;
      margin-bottom: 2px;
      color: var(--gray-600);
      font-weight: 500;
      padding-right: 6px;
      font-size: 0.875rem;
    }

    .field {
      display: flex;
      flex-direction: column;
    }

    .inline-field {
      display: flex;
      flex-direction: row;
      align-items: baseline;
    }

    .grow {
      flex-grow: 1;
    }

    .input {
      padding: 8px 12px;
      background-color: var(--gray-50);
      font-size: 0.875rem;
      border: 1px solid var(--gray-200);
      border-radius: 0.5rem;
      color: #445668;
      color: var(--gray-600);
    }

    .input:focus {
      outline: none;
      border: 1px solid var(--gray-300);
    }

    .input::placeholder {
      color: var(--gray-400);
    }

    .logo {
      color: var(--gray-800);
    }

    .logo img {
      height: 1rem;
    }
    """
  end
end
