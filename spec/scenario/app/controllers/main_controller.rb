class MainController < ApplicationController
  def index
    puts "CURRENT USER #{current_user.inspect}"
  end

  def another_cool_page
  end
end
