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

    def shared_sql user
      "(\"kudos\".\"share_scope\" = \'friends\' AND \"kudo_copies\".\"recipient_id\" IN (#{user.friends_ids_list}) \
      OR  (\"kudos\".\"share_scope\" IS NULL))"
    end

    def nearby_kudos_sql user
     "(kudo_copies.recipient_id IN (#{local_authors(user)}) AND kudo_copies.share_scope IS NULL) "
    end

    def sort_by_field field
      if Kudo.allowed_sorting.include?(field)
      case field
        when 'date_asc'      ; "kudos.id ASC"
        when 'comments_asc'  ; "kudos.comments_count ASC"
        when 'date_desc'     ; "kudos.id DESC"
        when 'comments_desc' ; "kudos.comments_count DESC"
      end
      else
        "kudos.id DESC"
      end
    end


    end

end