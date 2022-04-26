require 'httparty'

class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @facade = HolidayFacade.new 
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    if params[:percentage].to_i >= 100
      flash[:notice] = "It is company policy for discounts to be less than or eqaul to 100%"
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/new"
    else 
      discount = merchant.bulk_discounts.create!(
        name: params[:name],
        percentage: params[:percentage],
        threshold: params[:threshold,]
      )
      discount.save
      redirect_to "/merchants/#{merchant.id}/bulk_discounts"
    end 
  end
  
  def destroy
    merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end
  
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    
    if params[:percentage].to_i >= 100
      flash[:notice] = "It is company policy for discounts to be less than or eqaul to 100%"
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit", method: :patch
    else 
      @discount.update(name: params[:name], percentage: params[:percentage], threshold: params[:threshold])
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}"
    end 
  end
  
  
  

end 