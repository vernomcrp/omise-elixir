defmodule Omise.ChargeTest do
  use ExUnit.Case
  import TestHelper

  setup_all do
    charge_id = "chrg_test_4yq7duw15p9hdrjp8oq"

    {:ok, charge_id: charge_id}
  end

  test "list all charges" do
    with_mock_request "charges-get", fn ->
      {:ok, list} =  Omise.Charge.list

      assert %Omise.List{data: charges} = list
      assert list.object == "list"
      assert list.from
      assert list.to
      assert list.offset
      assert list.limit
      assert list.total
      assert is_list(list.data)

      Enum.each charges, fn(charge) ->
        assert %Omise.Charge{} = charge
        assert charge.object == "charge"
      end
    end
  end

  test "retrieve a charge", %{charge_id: charge_id} do
    with_mock_request "charges/#{charge_id}-get", fn ->
      {:ok, charge} = Omise.Charge.retrieve(charge_id)

      assert %Omise.Charge{} = charge
      assert charge.object == "charge"
      assert charge.id
      assert is_boolean(charge.livemode)
      assert charge.location
      assert charge.status
      assert charge.amount
      assert charge.currency
      assert charge.description
      assert is_boolean(charge.capture)
      assert is_boolean(charge.authorized)
      assert is_boolean(charge.reversed)
      assert is_boolean(charge.paid)
      assert charge.transaction
      assert charge.card
      assert charge.refunded
      assert charge.refunds
      refute charge.failure_code
      refute charge.failure_message
      assert charge.customer
      refute charge.ip
      assert charge.dispute
      assert charge.created
      refute charge.return_uri
      refute charge.authorize_uri
      refute charge.reference

      assert %Omise.Card{} = charge.card
      assert %Omise.List{} = charge.refunds
      assert %Omise.Dispute{} = charge.dispute
    end
  end

  test "create a charge" do
    with_mock_request "charges-post", fn ->
      {:ok, charge} = Omise.Charge.create(
        amount: 1000_00,
        currency: "thb",
        card: "tokn_test_12p4j8aeb6x1v7mk63x"
      )

      assert %Omise.Charge{} = charge
      assert charge.object == "charge"
      assert charge.location
      assert charge.authorized
      assert charge.capture
      assert charge.paid
      assert charge.amount == 1000_00
      assert charge.status == "successful"
    end
  end

  test "update a charge", %{charge_id: charge_id} do
    with_mock_request "charges/#{charge_id}-patch", fn ->
      description = "Elixir is awesome"
      {:ok, charge} = Omise.Charge.update(charge_id, description: description)

      assert %Omise.Charge{} = charge
      assert charge.object == "charge"
      assert charge.description == description
    end
  end

  test "capure a charge", %{charge_id: charge_id} do
    with_mock_request "charges/#{charge_id}/capture-post", fn ->
      {:ok, charge} = Omise.Charge.capture(charge_id)

      assert %Omise.Charge{} = charge
      assert charge.object == "charge"
      assert charge.paid
    end
  end

  test "reverse a charge", %{charge_id: charge_id} do
    with_mock_request "charges/#{charge_id}/reverse-post", fn ->
      {:ok, charge} = Omise.Charge.reverse(charge_id)

      assert %Omise.Charge{} = charge
      assert charge.object == "charge"
      assert charge.reversed
    end
  end
end
