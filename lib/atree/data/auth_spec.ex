defmodule Atree.Data.AuthSpec do
  @moduledoc """
  Atree Auth.
  """

  alias Atree.Data.{AuthSpec}

  @derive Jason.Encoder

  defstruct when: nil, unless: nil

  @type t :: %AuthSpec{
          when: any(),
          unless: any()
        }
end
