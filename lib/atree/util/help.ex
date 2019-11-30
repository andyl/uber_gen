defmodule Atree.Util.Help do
  def output(%{action: nil}) do
    IO.puts """
    Usage: atree [method] [action] [<options>]

    methods: 
      export <playbook|action>   # export a guide
      tailor <playbook|action>   # tailor a guide to your codebase
      run    <playbook|action>   # execute action commands
      serve  <playbook|action>   # run the atree server
      list [playbooks | actions] # list playbooks and/or actions
      help [<method>|<playbook>|<action>] 

    options:
      -p --param KEY=VAL     # define key/val params for an action
      -w --write FORMAT=FILE # write formatted text to files
      -o --output FORMAT     # write formatted text to STDOUT
      -c --context FILE      # read context from file

    FORMATS:
      action_tree      # nested actions  
      ctx_inspect      # context using Elixir#inspect
      ctx_json         # context in JSON [DEFAULT]
      guide_html       # guide as HTML
      guide_markdown   # guide as Markdown
      log_inspect      # context log using Elixir#inspect
      log_json         # context log in JSON

    NOTES:
      - read ctx_json from STDIN using '-' or '-c -' or '-c stdin'
          `$ mix atree export | mix atree -`
      - use `$ help <method>` to view usage examples
    """
  end

  def output(%{action: "list"}) do
    IO.puts """
    HELP LIST
    """
  end

  def output(%{action: "export"}) do
    IO.puts """
    HELP EXPORT
    """
  end

  def output(%{action: "tailor"}) do
    IO.puts """
    HELP TAILOR
    """
  end

  def output(%{action: "run"}) do
    IO.puts """
    HELP RUN
    """
  end

  def output(%{action: "serve"}) do
    IO.puts """
    HELP SERVE
    """
  end

  def output(%{action: type}) do
    cond do
      Regex.match?(~r/(\.json)$|(\.yaml)$/, type) ->
        output_playbook(type)
      true ->
        output_action(type)
    end
  end

  def output_playbook(playbook) do
    pbook = Atree.Util.Registry.Playbooks.find(playbook)

    case pbook do
      nil -> 
        IO.puts("Playbook not found (#{playbook})")
      path -> 
        IO.puts """
        Playbook: #{playbook}
        Full path: #{path}
        """
    end
  end

  def output_action(action) do
    act = Atree.Util.Registry.Actions.find(action)

    case act do
      nil -> 
        IO.puts("Action not found (#{action})")
      {module, _name} -> 
        IO.puts """
        Action: #{action}
        Module: #{module}

        Summary: 
        #{Mix.Task.shortdoc(module)}
        
        Documentation:
        #{Mix.Task.moduledoc(module)}
        Propspecs:
        #{inspect(module.propspecs(), pretty: true, width: 40)}
        """
    end
  end
end
