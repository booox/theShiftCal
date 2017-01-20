class ApiV1::EventsController < ApiController
  def create
    if request.post?
      slack_id = request['entry']['field_25']
      schedule_ary = request['entry']['field_18']

      schedule_ary.each do |s|
        start_time = Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-11,2]}").strftime('%Y-%m-%d %H:%M:%S')
        end_time = Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-5,2]}").strftime('%Y-%m-%d %H:%M:%S')
        summary = Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-11,2]}").strftime('%H%p').downcase + "-" + Chronic.parse(change_chinese_day(s[0,2]) + " #{s[-5,2]}").strftime('%H%p').downcase + " 值班助教"

        result = Event.joins(:week_table).where(start_time: Time.zone.parse(start_time), end_time: Time.zone.parse(end_time), summary: summary)

        if result.empty?
          WeekTable.create(
            events_attributes: [
              { start_time: start_time, end_time: end_time, summary: summary, all_slacks: slack_id },
            ]
          )
        else
          unless result.first.all_slacks.include?(slack_id)
            result.first.all_slacks += ", #{slack_id}"
          end
        end
      end
      render :json => { :message => "We got form data" }, :status => 200
    end
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

=begin
curl -X POST http://localhost:3000/api/v1/events -H "Content-Type:application/json" --data '{
  "form": "0IISoJ",
  "form_name": "全栈营线上助教排班系统",
  "entry": {
    "serial_number": 123,
    "field_9": "尼克",
    "field_25": "bboyceo_is_nic",
    "field_18": [
      "周四 18:00-20:00",
      "周五（除夕） 22:00-24:00",
      "周一 22:00-24:00",
      "周六 20:00-22:00",
      "周六 16:00-18:00",
      "周一 20:00-22:00",
      "周三 14:00-16:00"
    ],
    "creator_name": "小王",
    "created_at": "2017-01-19 14:05:09 UTC",
    "updated_at": "2017-01-19 14:05:09 UTC",
    "info_remote_ip": "127.0.0.1"
  }
}'
=end
