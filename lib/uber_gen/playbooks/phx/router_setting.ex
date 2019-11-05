defmodule UberGen.Playbooks.Phx.RouterSettings do

  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  def run(_) do
    IO.puts "RUNNING #{__MODULE__}"
  end

  call(ctx, opts) do
    ctx
  end

  guide(ctx, opts) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end

  test(ctx, opts) do
    true
  end
end
