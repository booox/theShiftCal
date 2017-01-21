class ApiV1::EventsController < ApiController
  require 'classes/jinshuju'

  def create
    if request.post?
      slack = params['entry']['field_25']
      schedules = params['entry']['field_18']

      data = Jinshuju.new(slack, schedules)

      Event.import_shifts(data)

      render :json => { :message => "We got form data" }, :status => 200
    end
  end
end
