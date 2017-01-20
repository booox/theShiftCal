class Jinshuju
  require 'chronic'

  attr_accessor :slack_id
  attr_reader :shifts

  def initialize hash
    @slack_id = hash['entry']['field_25']
    @schedule_ary = hash['entry']['field_18']
    @shifts = init_shifts
  end

  def init_shifts
    result = []
    @schedule_ary.each do |s|
      start_time = Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-11,2]}").strftime('%Y-%m-%d %H:%M:%S')
      end_time = Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-5,2]}").strftime('%Y-%m-%d %H:%M:%S')
      summary = Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-11,2]}").strftime('%H%p').downcase + "-" + Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-5,2]}").strftime('%H%p').downcase + " 值班助教"
      result << {:start_time => start_time, :end_time => end_time, :summary => summary}
    end
    result
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
