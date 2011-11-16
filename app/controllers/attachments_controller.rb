class AttachmentsController < ApplicationController
layout :choose_layout

  def index
    @width = 0
    @group_name = ""
    if params[:gift_group].to_i == 0 || params[:gift_group].blank?
      @gifts = Gift.where(:active => true)
    else
      group = GiftGroup.find(params[:gift_group])
      @gifts = group.gifts.where(:active => true)
      @group_name = " - #{GiftGroup.find(params[:gift_group].to_i).name}"
    end
    @gift_groups = GiftGroup.find_by_sql("SELECT DISTINCT gg.id, gg.name from gift_groups_gifts g JOIN gift_groups gg on gg.id = g.gift_group_id")
    @featured_gift = Gift.first
    @width = (160 * @gifts.count)
  end

  def show
    @attachment = Attachment.find(params[:id])
    respond_to do |format|
      format.html
      format.js {render 'attachment', :layout => false}
    end
  end

end
