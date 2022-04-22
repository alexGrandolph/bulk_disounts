class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
   
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.bulk_discounts.create!(
      name: params[:name],
      percentage: params[:percentage],
      threshold: params[:threshold,]
    )
    if discount.save
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
    # else 
    #   flash[:notice] = "Invalid! Try Again!"
    #   redirect_to "/merchants/#{@merchant.id}/new"

    end 
  end
  
  
  
  

end 