module TasksHelper

  def formatted_date(date)
    date ? date.strftime("%Y/%m/%d") : "--/--/--"
  end
end
