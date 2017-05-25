class AdminController < ApplicationController
  before_action :authorize

  def index
    @total_oders = Order.count
  end

  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end
end
