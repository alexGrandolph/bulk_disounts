class Holiday 
  attr_reader :next_holidays

  def initialize(data)
    # @next_holidays = []
    # first_three = data[0..2]
    # first_three.each do |holiday|
    #   next_holidays << holiday[:localName]
      
    # end
    # @next_holidays

    @next_holidays = {}
    first_three = data[0..2]
    first_three.each do |holiday|
      @next_holidays[holiday[:localName]] = holiday[:date]
    end 
    # binding.pry

  end 


end 