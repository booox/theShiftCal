class Jinshuju
  require 'chronic'

  attr_accessor :slack_id
  attr_reader :shifts

  def initialize(slack, schedules)
    @slack_id = slack
    @schedules = schedules
    @shifts = init_shifts
  end

  def init_shifts
    result = []
    @schedules.each do |schedule|
      result << {:start_time => t_start_time(schedule), :end_time => t_end_time(schedule), :summary => t_summary(schedule)}
    end
    result
  end

  def t_start_time(schedule)
    Chronic.parse(change_chinese_day(schedule[0,2]) + " #{schedule[-11,2]}").strftime('%Y-%m-%d %H:%M:%S')
  end

  def t_end_time(schedule)
    Chronic.parse(change_chinese_day(schedule[0,2]) + " #{schedule[-5,2]}").strftime('%Y-%m-%d %H:%M:%S')
  end

  def t_summary(schedule)
    Chronic.parse(change_chinese_day(schedule[0,2]) + " #{schedule[-11,2]}").strftime('%H%p').downcase + "-" + Chronic.parse(change_chinese_day(schedule[0,2]) + " #{schedule[-5,2]}").strftime('%H%p').downcase + " 值班助教"
  end

  def change_chinese_day(text)
    case text
    when "周六"
      'This week Saturday'
    when "周日"
      'This week Sunday'
    when "周一"
      'Next week Monday'
    when "周二"
      'Next week Tuesday'
    when "周三"
      'Next week Wednesday'
    when "周四"
      'Next week Thursday'
    when "周五"
      'Next week Friday'
    end
  end
end
