defmodule UberGen.Presentor.GuideHtml do
  @moduledoc """
  Converts the context to an inspectable string.
  """

  alias UberGen.Data.Ctx

  @doc """
  Generate Guide HTML output.
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    markdown = UberGen.Presentor.GuideMarkdown.generate(ctx)
    {:ok, html, _} = Earmark.as_html(markdown)
    html
  end
end
