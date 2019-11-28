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

  def output(%{action: type}) do
    IO.puts("Help for type #{type}")
  end
end
