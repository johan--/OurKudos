class GiftsController < ApplicationController
layout :choose_layout

  def index
    @width = 0
    @group_name = ""
    if params[:gift_group].to_i == 0 || params[:gift_group].blank?
      @gifts = Gift.where(:active => true)
    else
      group = GiftGroup.find(params[:gift_group])
      @gifts - group.gifts.where(:active => true)
      @group_name = " - #{GiftGroup.find(params[:gift_group].to_i).name}"
    end
    @gift_groups = GiftGroup.find_by_sql("SELECT DISTINCT gg.id, gg.name from gift_groups_gifts g JOIN gift_groups gg on gg.id = g.gift_group_id")
    @featured_gift = Gift.first
    @width = (160 * @gifts.count)
  end

  def show
    @gift = Gift.find(params[:id])
    respond_to do |format|
      format.html
      format.js {render 'gift', :layout => false}
    end
  end

  def list_gifts_in_group_slider
    if params[:id].to_s == '0'
      @gifts = Gift.where(:active => true)
    else
      group = GiftGroup.find(params[:id])
      @gifts = group.gifts.where(:active => true)
    end
    respond_to do |format|
      format.html
      format.js {render 'gift_select_slider'}
    end
  end

#  def get_gift
#    @gift = Gift.find params[:id]
#    respond_to do |format|
#      format.html
#      format.js {render 'gift'}
#    end
#  end
  
  
end
