module ApplicationHelper
  FLASH_TYPE = { alert: "danger", notice: "success"}

  def sort_link(columns, title = nil)
    title ||= columns.titleize
    direction = columns == sort_column && sort_direction == "asc" ? "desc" : "asc"
    icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = columns == sort_column ? icon : ""
    link_to "#{title} <span class='#{icon}'></span>".html_safe, {column: columns, direction: direction}
  end

  def flash_message
    flash.map do |key, msg|
      content_tag :div, :class => "alert alert-#{FLASH_TYPE[key.to_sym] || key } alert-dismissible", :role => "alert" do
        concat (content_tag :button, :type => "button", :class => "close", data:{:dismiss => "alert"}, aria:{:label => "Close"} do
          content_tag :span, "&times;".html_safe, aria:{:hidden => "true"}
        end)
        concat msg
      end
    end.join.html_safe
  end
end
