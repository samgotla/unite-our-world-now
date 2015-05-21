module TagHelper
  def active_nav_item(title, path)

    # TODO: currently uses entire request.fullpath, but make this better later
    active_class = (request.fullpath == path) ? 'active': ''

    return content_tag(:li, class: active_class) do
      link_to(title, path)
    end
  end
end
