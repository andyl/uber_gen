defmodule Atree.NoActionError do
  defexception [:playbook, :message, mix: true]

  @impl true
  def exception(opts) do
    playbook = opts[:playbook]
    %Atree.NoActionError{playbook: playbook, message: msg(playbook)}
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
    Atree.Util.Mix.load_all()

    Atree.Util.Mix.all_modules()
    |> Enum.map(&{&1, Atree.Util.Mix.playbook_name(&1)})
    |> Enum.reduce({nil, nil, 0}, &max_similar(&1, playbook, &2))
  end

  defp max_similar({mod, source}, target, {_, _, current} = best) do
    score = String.jaro_distance(source, target)
    if score < current, do: best, else: {mod, source, score}
  end

  defp expected_mod_name(playbook) do
    "Atree.Actions." <> Atree.Utils.command_to_module_name(playbook)
  end
end

defmodule Atree.InvalidActionError do
  defexception [:playbook, :message, mix: true]

  @impl true
  def exception(opts) do
    playbook = opts[:playbook]
    %Atree.InvalidActionError{playbook: playbook, message: "The playbook #{inspect(playbook)} does not export run/1"}
  end
end

defmodule Atree.ElixirVersionError do
  defexception [:target, :expected, :actual, :message, mix: true]

  @impl true
  def exception(opts) do
    target = opts[:target]
    actual = opts[:actual]
    expected = opts[:expected]

    message =
      "You're trying to run #{inspect(target)} on Elixir v#{actual} but it " <>
        "has declared in its mix.exs file it supports only Elixir #{expected}"

    %Atree.ElixirVersionError{target: target, expected: expected, actual: actual, message: message}
  end
end

defmodule Atree.NoProjectError do
  message =
    "Could not find a Atree.Project, please ensure you are running Atree in a directory with a mix.exs file"

  defexception message: message, mix: true
end

defmodule Atree.Error do
  defexception [:message, mix: true]
end
