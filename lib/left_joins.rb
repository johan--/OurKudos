class ActiveRecord::Base

  #extension to query dashboard

  class << self

    def group_by_order
      column_names.map {|column| "#{table_name}.#{column}"}.join(", ")
    end


    def left_joins_categories
      %q{LEFT JOIN "kudo_categories" ON "kudo_categories"."id" = "kudos"."kudo_category_id"}
    end

    def left_joins_comments
      %q{LEFT JOIN "comments" ON "comments"."commentable_id" = "kudos"."id" AND "comments"."commentable_type" = 'Kudo'}
    end

    def grouping_order
      KudoCopy.group_by_order + ", " + Kudo.group_by_order + ", " + Comment.group_by_order
    end


  end

end