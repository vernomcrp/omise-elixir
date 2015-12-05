defmodule Omise.Transaction do
  @moduledoc """
  Transaction struct.

  ## Reference:
  https://www.omise.co/transactions-api
  """
  defstruct [:id, :type, :amount, :currency, :created]
  @type t :: %__MODULE__{}
end