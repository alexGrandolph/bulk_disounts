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

    if invalid_percentage == true || invalid_threshold == true 
      flash[:notice] = "BAD! Discount Percentage Must Be Greater Than 0 AND Less Than 100"
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
   
    if invalid_percentage == true || invalid_threshold == true 
      flash[:notice] = "BAD! Threshold and Percentage MUST be an Integer Between 0 and 100"
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"
    else 
      @discount.update(name: params[:name], percentage: params[:percentage], threshold: params[:threshold])
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}"
    end 
  end

  private
      def invalid_percentage
        params[:percentage].to_i >= 101 || params[:percentage].to_i < 0 || params[:percentage].count("a-zA-Z") > 0
      end 

      def invalid_threshold
        # binding.pry
        params[:threshold].count("a-zA-Z") > 0 || params[:threshold].to_i < 0
      end

      # def error_message
      #   flash[:notice] = "BAD! Discount Percentage Must Be Greater Than 0 AND Less Than 100"
      # end
      
      
  
  
  

end 
    # if params[:percentage].to_i >= 100 || params[:percentage].to_i < 0
    #   flash[:notice] = "BAD! Discount Percentage Must Be Greater Than 0 AND Less Than 100"
