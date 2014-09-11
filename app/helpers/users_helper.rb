module UsersHelper
  def highlight_hidden(user)
    user.active ? {} : {class: 'hidden_user'}
  end

  def hide_unhide(user)
    if user.active
      link_to 'Hide user', hide_user_path(user)
    else
      link_to 'Unhide user', unhide_user_path(user)
    end
  end
end
