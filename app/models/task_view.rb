class TaskView < Tag
  default_scope :order => "LOWER(name) ASC"

  def self.find_by_param(id)
    self.find_by_name!(id)
  end
end
