<?php

namespace Commerce\Adjusters;

use Commerce\Helpers\CommerceCurrencyHelper;
use Craft\Commerce_DiscountModel;
use Craft\Commerce_LineItemModel;
use Craft\Commerce_OrderAdjustmentModel;
use Craft\Commerce_OrderModel;
use Craft\StringHelper;

/**
 * Discount Adjustments
 *
 * Class Commerce_DiscountAdjuster
 *
 * @package Commerce\Adjusters
 */
class Commerce_DiscountAdjuster implements Commerce_AdjusterInterface
{
	const ADJUSTMENT_TYPE = 'Discount';

	/**
	 * @param Commerce_OrderModel      $order
	 * @param Commerce_LineItemModel[] $lineItems
	 *
	 * @return \Craft\Commerce_OrderAdjustmentModel[]
	 */
	public function adjust(Commerce_OrderModel &$order, array $lineItems = [])
	{
		if (empty($lineItems))
		{
			return [];
		}

		$discounts = \Craft\craft()->commerce_discounts->getAllDiscounts(['condition' => '(code = :code OR code IS NULL) and enabled = :enabled', 'params' => ['code' => $order->couponCode, 'enabled' => true],'order'=>'sortOrder']);
		$adjustments = [];
		foreach ($discounts as $discount)
		{
			if ($adjustment = $this->getAdjustment($order, $lineItems, $discount))
			{
				$adjustments[] = $adjustment;

				if($discount->stopProcessing)
				{
					break;
				}
			}
		}

		return $adjustments;
	}

	/**
	 * @param Commerce_OrderModel      $order
	 * @param Commerce_LineItemModel[] $lineItems
	 * @param Commerce_DiscountModel   $discount
	 *
	 * @return Commerce_OrderAdjustmentModel|false
	 */
	private function getAdjustment(Commerce_OrderModel $order, array $lineItems, Commerce_DiscountModel $discount)
	{
		//preparing model
		$adjustment = new Commerce_OrderAdjustmentModel;
		$adjustment->type = self::ADJUSTMENT_TYPE;
		$adjustment->name = $discount->name;
		$adjustment->orderId = $order->id;
		$adjustment->description = $discount->description ?: $this->getDescription($discount);
		$adjustment->optionsJson = $discount->attributes;
		$affectedLineIds = [];


		// Handle special coupon rules
		if ($order->couponCode == $discount->code)
		{
			// Since we will allow the coupon to be added to an anonymous cart with no email, we need to remove it
			// if a limit has been set.
			if ($order->email && $discount->perEmailLimit)
			{
				$previousOrders = \Craft\craft()->commerce_orders->getOrdersByEmail($order->email);

				$usedCount = 0;
				foreach ($previousOrders as $previousOrder)
				{
					if ($previousOrder->couponCode == $discount->code)
					{
						$usedCount = $usedCount + 1;
					}
				}

				if ($usedCount >= $discount->perEmailLimit)
				{
					$order->couponCode = "";

					return false;
				}
			}
		}


		//checking items
		$matchingQty = 0;
		$matchingTotal = 0;
		$matchingLineIds = [];
		foreach ($lineItems as $item)
		{
			if (\Craft\craft()->commerce_discounts->matchLineItem($item, $discount))
			{
				$matchingLineIds[] = $item->id;
				$matchingQty += $item->qty;
				$matchingTotal += $item->getSubtotal();
			}
		}

		if (!$matchingQty)
		{
			return false;
		}

		// Have they entered a max qty?
		if ($discount->maxPurchaseQty > 0)
		{
			if ($matchingQty > $discount->maxPurchaseQty)
			{
				return false;
			}
		}

		// Reject if they have not added enough matching items
		if ($matchingQty < $discount->purchaseQty)
		{
			return false;
		}

		// Reject if the matching items values is not enough
		if ($matchingTotal < $discount->purchaseTotal)
		{
			return false;
		}

		// calculate discount (adjustment amount should be negative)
		$amount = $discount->baseDiscount;
		$amount += CommerceCurrencyHelper::round($discount->perItemDiscount * $matchingQty);
		$amount += CommerceCurrencyHelper::round($discount->percentDiscount * $matchingTotal);

		$shippingRemoved = 0;

		foreach ($lineItems as $item)
		{
			if (in_array($item->id, $matchingLineIds))
			{
				$amountPerItem = CommerceCurrencyHelper::round($discount->perItemDiscount * $item->qty);
				$amountPercentage = CommerceCurrencyHelper::round($discount->percentDiscount * $item->getSubtotal());
				$item->discount += $amountPerItem + $amountPercentage;
				// If the discount is larger than the subtotal
				// make the discount equal to the item, thus making the item free.
				if (($item->discount * -1) > $item->getSubtotal())
				{
					$item->discount = -$item->getSubtotal();
				}

				if (!$item->purchasable->getIsPromotable())
				{
					$item->discount = 0;
				}

				$affectedLineIds[] = $item->id;

				if ($discount->freeShipping)
				{
					$shippingRemoved = $shippingRemoved + $item->shippingCost;
					$item->shippingCost = 0;
				}
			}
		}

		if ($discount->freeShipping)
		{
			$shippingRemoved = $shippingRemoved + $order->baseShippingCost;
			$order->baseShippingCost = 0;
		}

		$order->baseDiscount += $discount->baseDiscount;

		// only display adjustment if an amount was calculated
		if ($amount || $shippingRemoved)
		{
			// Record which line items this discount affected.
			$adjustment->optionsJson = array_merge(['lineItemsAffected' => $affectedLineIds], $adjustment->optionsJson);
			$adjustment->amount = $amount + ($shippingRemoved * -1);

			return $adjustment;
		}
		else
		{
			return false;
		}
	}

	/**
	 * @param Commerce_DiscountModel $discount
	 *
	 * @return string "1$ and 5% per item and 10$ base rate"
	 */
	private function getDescription(Commerce_DiscountModel $discount)
	{
		$description = '';
		$currency = \Craft\craft()->commerce_paymentCurrencies->getPrimaryPaymentCurrencyIso();

		if ($discount->perItemDiscount || $discount->percentDiscount)
		{
			if ($discount->perItemDiscount)
			{
				$description .= \Craft\craft()->numberFormatter->formatCurrency($discount->perItemDiscount * -1, $currency);
			}

			if ($discount->percentDiscount)
			{
				if ($discount->perItemDiscount)
				{
					$description .= ' and ';
				}

				$description .= \Craft\craft()->numberFormatter->formatPercentage($discount->percentDiscount * -1 .'%');
			}

			$description .= ' per item ';
		}

		if ($discount->baseDiscount)
		{
			if ($description)
			{
				$description .= 'and ';
			}
			$description .= \Craft\craft()->numberFormatter->formatCurrency($discount->baseDiscount * -1, $currency).' base rate ';
		}

		if ($discount->freeShipping)
		{
			if ($description)
			{
				$description .= 'and ';
			}

			$description .= 'free shipping ';
		}

		if ($discount->code)
		{
			if ($description)
			{
				$description .= 'and ';
			}

			$description .= 'using code '.StringHelper::toUpperCase($discount->code);
		}

		return $description;
	}
}
