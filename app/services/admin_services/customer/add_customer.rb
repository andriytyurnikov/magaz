class AdminServices::Customer::AddCustomer

  attr_reader :success, :customer, :errors
  alias_method :success?, :success

  def initialize  shop_id: nil, 
                  params: {}
    @shop_id = shop_id
    @customer = Shop.find(shop_id).customers.new
    @params = params
  end

  def run
    @customer.assign_attributes(@params)
    if @customer.valid?
      @customer.save
      @success = true
    else
      @errors = @customer.errors
      @success = false
    end
    self
  end
end
