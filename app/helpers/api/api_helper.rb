module Api::ApiHelper

    def secure_columns_for *fields
      
      column_names.select do |c|
      !c.include?("_id") &&
        !c.include?("_by") &&
          !c.include?("_at") &&
            c != "id" &&
          !fields.include?(c)
     end
  end


end
