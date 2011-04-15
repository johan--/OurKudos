module OurKudos
  class ResponseCodes
    
    CODES_MAP = {
      :I1 => 'Account created',
      :E1 => 'No such api key',
      :E2 => "Api key expired",
      :E3 => 'This app / site is blocked',
      :E4 => "Cannot save this user",
      :E5 => 'Server error'
    }
    
    def self.[](code)
      CODES_MAP[code]
    end
    
  end
end