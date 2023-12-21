module ApplicationHelper

  def genModalId(action_name)
    action_name.strip.downcase.gsub(" ","-")
  end
end
