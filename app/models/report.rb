class Report

    attr_accessor :id, :name

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

  class << self

  def all
      [
          Report.new(:id => 1, :name => "People signed up",
                              :headers => [:email ])
      ]
  end



  end


end
