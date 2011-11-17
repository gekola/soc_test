module ApplicationHelper

  def title
    base_title = t ".title"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
      image_tag("logo.png", :alt => (t "layouts.application.title"), :class => "round")
  end
end
