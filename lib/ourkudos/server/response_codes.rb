module OurKudos
  class ResponseCodes
    
    CODES_MAP = {
      :I1 => 'Resource created',
      :I2 => 'Resource updated',
      :E1 => 'No such api key',
      :E2 => "Api key expired",
      :E3 => 'This app / site is blocked',
      :E4 => "Cannot save this resource",
      :E5 => 'Server error',
      :E6 => 'Unable to update resource',
      :E7 => "Unable to process request, server responded with error",
      :E8 => "No such record",
      :E9 => "No such action / resource",
      :I3 => "Resource removed",
     :E10 => "Unable to remove resource"
    }
    
    def self.[](code)
      CODES_MAP[code]
    end
    
  end
end