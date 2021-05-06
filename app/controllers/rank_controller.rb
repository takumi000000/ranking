class RankController < ApplicationController
  def index
    time = Time.now
    @day ="#{time.month}月#{time.day}日#{time.hour}時#{time.min}分 現在の"
  end

  def show
  end
end
