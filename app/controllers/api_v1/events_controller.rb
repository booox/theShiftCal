class ApiV1::EventsController < ApiController
  require 'classes/jinshuju'

  def create
    if request.post?
      data = Jinshuju.new(params)

      data.shifts.each do |shift|
        result = Event.find_by(start_time: Time.zone.parse(shift[:start_time]), end_time: Time.zone.parse(shift[:end_time]), summary: shift[:summary])

        if result.blank?
          WeekTable.create(
            events_attributes: [
              { start_time: shift[:start_time], end_time: shift[:end_time], summary: shift[:summary], all_slacks: data.slack_id },
            ]
          )
        else
          result.all_slacks += ", #{data.slack_id}" unless result.all_slacks.split(",").include?(data.slack_id)
        end
      end
      render :json => { :message => "We got form data" }, :status => 200
    end
  end
end
