class Event < ApplicationRecord
  require 'icalendar/tzinfo'
  require 'classes/jinshuju'

  belongs_to :week_table,optional: true
  has_many :shifts,dependent: :destroy
  has_many :slacks, through: :shifts

  scope :booked_with, ->(name) { Slack.find_by("name = ?", name).events }
  scope :last_week, -> { where(start_time: Date.current..(Date.current + 7.days)) }

  def to_ics

    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new self.start_time, tzid: "Asia/Shanghai"
    event.dtend = Icalendar::Values::DateTime.new self.end_time, tzid: "Asia/Shanghai"
    event.summary = self.summary
    event.description = self.calendar_description
    event.created = self.created_at
    event.last_modified = self.updated_at

    #event.url = "#{PUBLIC_URL}events/#{self.id}"
    event
  end

  def all_slacks=(names)
    self.slacks = names.split(",").map do |name|
      Slack.where(name: name.strip).first_or_create!
    end
  end

  def calendar_description
    self.slacks.map{|slack| slack.name.downcase.prepend("@")}.join(", ")
  end

  def all_slacks
    slacks.select("name").map(&:name).join(", ")
  end

  def self.import_shifts(data)
    data.shifts.each do |shift|
      result = Event.find_by(start_time: Time.zone.parse(shift[:start_time]), end_time: Time.zone.parse(shift[:end_time]), summary: shift[:summary])

      if result.blank?
        Event.create(
          start_time: shift[:start_time], end_time: shift[:end_time], summary: shift[:summary], all_slacks: data.slack_id
          )
      else
        result.all_slacks += ", #{data.slack_id}" unless result.all_slacks.split(",").include?(data.slack_id)
      end
    end
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|

      row = Hash[[header, spreadsheet.row(i)].transpose]
      slack_id = row['slack ID']
      schedules = row['请选择班次'].split("，")

      data = Jinshuju.new(slack_id, schedules)

      import_shifts(data)
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, options={})
    when ".xls" then Roo::Excel.new(file.path, options={})
    when ".xlsx" then Roo::Excelx.new(file.path, options={})
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
