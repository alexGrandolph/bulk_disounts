class SwaggerService

  def get_holiday
    response = HTTParty.get("https://date.nager.at/api/v3/PublicHolidays/2022/US")
    JSON.parse(response.body, symbolize_names: true)
  end
  

end