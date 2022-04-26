class HolidayFacade 

  def holiday
    Holiday.new(holiday_data)
  end
  

  def holiday_data
    @_holiday_data = service.get_holiday
  end

  def service
    @_service ||= SwaggerService.new
  end
  
  

end 