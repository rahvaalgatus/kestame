def link_to_unless_current(path)
  #path = path.path if path.respond_to? :path

  attrs = {}
  attrs[:href] = path if @item_rep.path != path
  attrs[:class] = "selected" if @item_rep.path == path
  attrs
end
