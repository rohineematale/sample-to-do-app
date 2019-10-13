class Task < ApplicationRecord

  ##### validations #####
  validates_presence_of :title
  validate :valid_state
  validate :valid_date, on: :create

  ##### callbacks #####
  before_create :set_sequence
 
  ##### public methods #####
  def valid_state
    errors.add(:status, "invalid state") unless ['pending', 'completed'].include?(self.status)
  end

  def valid_date
    errors.add(:due_date, "invalid date") if (self.due_date.present? && (self.due_date < Date.today))
  end

  def set_sequence #adds default sequence to task
    last_sequence = Task.where(user_id: self.user_id).pluck(:sequence).max
    self.sequence = last_sequence ? (last_sequence + 1) : 1
  end

  def formatted_date
    self.due_date ? self.due_date.strftime("%d/%m/%Y") : "--/--/--"
  end

  def update_seq_status(params)
    validate_sequence(params["prev_sequence"], params["next_sequence"])
    return if self.errors.present?
    update_sequence(params["prev_sequence"], params["next_sequence"])
    update_status(params["status"])
    self.save
  end

  # logic - when task dreg and drop down between task, 
  # following method calculates mean of prev & next task and use it as sequence.
  # becuase of this, only one (drag & dropping) tasks needs to update instead of multiple tasks
  def update_sequence(prev_sequence, next_sequence)
    if (prev_sequence && next_sequence)
      self.sequence = ((prev_sequence.to_f + next_sequence.to_f) / 2)
    elsif (prev_sequence && !next_sequence)
      self.sequence = prev_sequence.to_f + 1
    elsif (!prev_sequence && next_sequence)
      self.sequence = next_sequence.to_f - 1
    end
  end

  # only due and pending task are drag & dropped to completed task to mark them as complete.
  def update_status(status)
    self.status = status if status.present?
  end

  # to avoid calculation with non-numeric sequence.
  def validate_sequence(prev_sequence, next_sequence)
    errors.add(:sequence, "invalid sequence") if prev_sequence && !is_valid_number(prev_sequence)
    errors.add(:sequence, "invalid sequence") if next_sequence && !is_valid_number(next_sequence)
  end

  def is_valid_number(num)
    true if Float(num) rescue false
  end
end
