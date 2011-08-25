module KudoCategoriesHelper
	def default_category
			KudoCategory.where(:name => "Thank You").first.id if KudoCategory.where(:name => "Thank You").exists?
	end
end