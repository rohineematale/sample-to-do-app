class Task < ApplicationRecord

  validates_presence_of :title
  before_create :set_sequence

  def set_sequence
    last_sequence = Task.where(user_id: self.user_id).pluck(:sequence).max
    self.sequence = last_sequence ? last_sequence+1 : 1
  end

  def formatted_date
    self.due_date ? self.due_date.strftime("%Y/%m/%d") : "--/--/--"
  end

  def update_seq_status(params)
    if (params["prev_sequence"] && params["next_sequence"])
      self.sequence = ((params["prev_sequence"].to_f + params["next_sequence"].to_f) / 2)
    elsif (params["prev_sequence"] && !params["next_sequence"])
      self.sequence = params["prev_sequence"].to_f + 1
    elsif (!params["prev_sequence"] && params["next_sequence"])
      self.sequence = params["next_sequence"].to_f - 1
    end
    if params["status"] && params["status"] == "due"
      self.status = "pending" if self.status != "pending"
      self.due_date = Date.today
    elsif params["status"]
      self.status = params["status"]
    end
    self.save
  end
end
