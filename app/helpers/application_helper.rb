module ApplicationHelper
  
  def logo
    image_tag("logo.png", :alt => "FlickrJuice!", :class=> "round")
  end
end
