defmodule UberGen.Playbooks.Phx.Dsl do

  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  def run(_) do
    IO.puts "RUNNING #{__MODULE__}"
  end

  call(context, options) do
    context
  end

  test(context, options) do
    true
  end

  guide(context, options) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end
end
