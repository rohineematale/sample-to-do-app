module TasksHelper

  def due_tasks(tasks)
    tasks.select{|task| (task.status == 'pending') && (task.due_date == Date.today)}
  end

  def pending_tasks(tasks)
    tasks.select{|task| (task.status == 'pending') && (task.due_date != Date.today)}
  end

  def completed_tasks(tasks)
    tasks.select{|task| task.status == 'completed'}
  end
end
