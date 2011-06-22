class Report

    attr_accessor :id, :name, :data

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def run! since, to
      self.data.call since, to
    end

  class << self

      def all
        [
          Report.new(:id => 1, :name => "People signed up",      :data => ->(from, to){ User.send :date_range ,from, to }),
          Report.new(:id => 2, :name => "Invitations send out",  :data => ->(from, to){ EmailKudo.send :date_range ,from, to }),
          Report.new(:id => 3, :name => "Kudos send",            :data => ->(from, to){ Kudo.send :date_range ,from, to }),
          Report.new(:id => 4, :name => "Facebook shares",       :data => ->(from, to){ FacebookKudo.send :date_range ,from, to }),
          Report.new(:id => 5, :name => "Twitter shares",        :data => ->(from, to){ TwitterKudo.send :date_range ,from, to })
        ]
      end

        def find id
          Report.all.select {|report| report.id == id.to_i }.first
        end

        def types_for_select
        [
          ['Users',
                        [['People signed up','1'],
                         ["Invitations send out",'2']
                         ]
          ],
          ['Messages',  [['Kudos sent','3'],
                          ['Facebook shares', '4'],
                          ['Twitter shares', '5']
                          ]
          ]
         ]
      end


  end


end
