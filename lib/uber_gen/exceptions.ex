defmodule UberGen.NoPlaybookError do
  defexception [:playbook, :message, mix: true]

  @impl true
  def exception(opts) do
    playbook = opts[:playbook]
    %UberGen.NoPlaybookError{playbook: playbook, message: msg(playbook)}
  end

  defp msg(playbook) do
    msg = "The playbook #{inspect(playbook)} could not be found"

    case did_you_mean(playbook) do
      {mod, ^playbook, _score} ->
        msg <>
          " because the module is named #{inspect(mod)} instead of " <>
          "#{expected_mod_name(playbook)} as expected. " <> "Please rename it and try again"

      {_mod, similar, score} when score > 0.8 ->
        msg <> ". Did you mean #{inspect(similar)}?"

      _otherwise ->
        msg
    end
  end

  defp did_you_mean(playbook) do
    # Ensure all playbooks are loaded
    UberGen.PlaybookMix.load_all()

    UberGen.PlaybookMix.all_modules()
    |> Enum.map(&{&1, UberGen.PlaybookMix.playbook_name(&1)})
    |> Enum.reduce({nil, nil, 0}, &max_similar(&1, playbook, &2))
  end

  defp max_similar({mod, source}, target, {_, _, current} = best) do
    score = String.jaro_distance(source, target)
    if score < current, do: best, else: {mod, source, score}
  end

  defp expected_mod_name(playbook) do
    "UberGen.Playbooks." <> UberGen.Utils.command_to_module_name(playbook)
  end
end

defmodule UberGen.InvalidPlaybookError do
  defexception [:playbook, :message, mix: true]

  @impl true
  def exception(opts) do
    playbook = opts[:playbook]
    %UberGen.InvalidPlaybookError{playbook: playbook, message: "The playbook #{inspect(playbook)} does not export run/1"}
  end
end

defmodule UberGen.ElixirVersionError do
  defexception [:target, :expected, :actual, :message, mix: true]

  @impl true
  def exception(opts) do
    target = opts[:target]
    actual = opts[:actual]
    expected = opts[:expected]

    message =
      "You're trying to run #{inspect(target)} on Elixir v#{actual} but it " <>
        "has declared in its mix.exs file it supports only Elixir #{expected}"

    %UberGen.ElixirVersionError{target: target, expected: expected, actual: actual, message: message}
  end
end

defmodule UberGen.NoProjectError do
  message =
    "Could not find a UberGen.Project, please ensure you are running UberGen in a directory with a mix.exs file"

  defexception message: message, mix: true
end

defmodule UberGen.Error do
  defexception [:message, mix: true]
end
