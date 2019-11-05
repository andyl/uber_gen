defmodule UberGen.Playbooks.Mix.SetDeps do

  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  def run(_) do
    IO.puts "RUNNING #{__MODULE__}"
  end

  call(context, _options) do
    context
  end

  steps(_ctx, _opts) do
    []
  end

  test(_context, _options) do
    true
  end

  guide(_context, _options) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end
end
