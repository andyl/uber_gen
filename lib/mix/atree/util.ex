# defmodule Mix.Atree.Util do
#
#   @moduledoc false
#
#   alias Atree.Presentor
#
#   def parse(argv) do
#     switches = [
#       format: :string,
#       help: :boolean
#     ]
#
#     aliases = [
#       h: :help,
#       f: :format
#     ]
#
#     OptionParser.parse(argv, switches: switches, aliases: aliases)
#   end
#
#   def presentor(format) do
#     case format do 
#       "action_tree"    -> Presentor.ActionTree
#       "ctx_inspect"    -> Presentor.CtxInspect
#       "ctx_json"       -> Presentor.CtxJson
#       "guide_html"     -> Presentor.GuideHtml
#       "guide_markdown" -> Presentor.GuideMarkdown
#       "log_inspect"    -> Presentor.LogInspect
#       "log_json"       -> Presentor.LogJson
#       _ -> Presentor.CtxInspect
#     end
#   end
# end
