defmodule UberGen.Playbooks.ConfigSetting do

  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  call(context, _options) do
    context
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
