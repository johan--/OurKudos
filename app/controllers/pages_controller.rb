class PagesController < ApplicationController
	layout :choose_layout

  def show
    @page = Page.find_with_locale params[:id], I18n.locale
    render_404 and return if @page.blank?
  end

end
