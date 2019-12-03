defmodule Atree.Data.Guide do

  @moduledoc """
  Action guide.

  This struct contains an optional header and body, and a format field.

  The format field allows the body to use different markups.

  Valid formats include 'markdown' and 'html'.
  """

  alias Atree.Data.Guide

  defstruct [header: nil, body: nil, format: "markdown"]

  @type t :: %Guide{
    header: String.t,
    body: String.t,
    format: String.t
  }
end
