defmodule Atree.Data.Guide do

  @moduledoc """
  Action guide.
  """

  alias Atree.Data.Guide

  defstruct [header: nil, body: nil]

  @type t :: %Guide{
    header: String.t,
    body: String.t
  }
end
