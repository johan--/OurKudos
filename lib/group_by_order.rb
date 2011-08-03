class ActiveRecord::Base

  class << self

    def group_by_order
      column_names.map {|column| "#{table_name}.#{column}"}.join(", ")
    end

  end

end