module ApplicationHelper
  def active_coupon?(code)
    return true if Coupon.where(code: code).first.active?
    false
  end

  def coupon_discount_percentage(code)
    coupon = Coupon.where(code: code).first
    return coupon.percentage if coupon
    nil
  end
end
