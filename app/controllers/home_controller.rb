class HomeController < ApplicationController
  def index
    @num = "ああああああああああ"
    render html: nil, layout: 'application'
  end
end
