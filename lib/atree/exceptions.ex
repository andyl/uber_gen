defmodule Atree.NoActionError do
  defexception [:action, :message, mix: true]

  @impl true
  def exception(opts) do
    action = opts[:action]
    %Atree.NoActionError{action: action, message: msg(action)}
  end

  defp msg(action) do
    msg = "The action #{inspect(action)} could not be found"

    case did_you_mean(action) do
      {mod, ^action, _score} ->
        msg <>
          " because the module is named #{inspect(mod)} instead of " <>
          "#{expected_mod_name(action)} as expected. " <> "Please rename it and try again"

      {_mod, similar, score} when score > 0.8 ->
        msg <> ". Did you mean #{inspect(similar)}?"

      _otherwise ->
        msg
    end
  end

  defp did_you_mean(action) do
    # Ensure all actions are loaded
    Atree.Util.Beam.load_all()

    Atree.Util.Beam.all_modules()
    |> Enum.map(&{&1, Atree.Util.Beam.action_name(&1)})
    |> Enum.reduce({nil, nil, 0}, &max_similar(&1, action, &2))
  end

  defp max_similar({mod, source}, target, {_, _, current} = best) do
    score = String.jaro_distance(source, target)
    if score < current, do: best, else: {mod, source, score}
  end

  defp expected_mod_name(action) do
    "Atree.Actions." <> Atree.Utils.command_to_module_name(action)
  end
end

defmodule Atree.InvalidActionError do
  defexception [:action, :message, mix: true]

  @impl true
  def exception(opts) do
    action = opts[:action]
    %Atree.InvalidActionError{action: action, message: "The action #{inspect(action)} does not export run/1"}
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
