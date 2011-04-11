module OurKudos
  class ResponseCodes
    
    CODES_MAP = {
      :I1 => 'Account created',
      :E1 => 'Cannot create an account'
    }
    
    def self.[](code)
      CODES_MAP[code]
    end
    
  end
end