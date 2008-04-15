class RemindblastController < ApplicationController
  before_filter :init_session, :only=>"save"
  USER_NAME = ENV['USER_NAME']
  PASSWORD = ENV['PASSWORD']
  CALENDAR_ID = ENV['CALENDAR_ID']
  
  TIME_ZONES = [
    'Yankee Time Zone',
    'Samoa',
    'Caracas',
    'Newfoundland',
    'Buenos Aires',
    'Mid-Atlantic',
    'Cape Verde Is.',
    'Greenwich Mean Time',
    'Pretoria',
    'Nairobi',
    'Abu Dhabi',
    'Islamabad',
    'Dhaka',
    'Bangkok',
    'Singapore',
    'Tokyo',
    'Adelaide',
    'Guam',
    'Lord Howe',
    'New Caledonia',
    'Norfolk',
    'Fiji',
    'Honolulu',
    'Anchorage',
    'Los Angeles',
    'Denver',
    'Chicago',
    'New York',
    'Auckland',
    'Sydney',
    'London',
    'Rome'
  ]
  
  def index
    
  end
  
  def save
    
    description = title = params[:remind][:description]
    description = "Hey #{params[:remind][:name]}, #{title}" if !params[:remind][:name].empty?
    
    puts title
    puts description
    
    @event = Sponger::Event.new
    @event.title = title
    @event.description = description
    @event.start_time = parse_time(params[:remind],:start_time)
    @event.end_time = @event.start_time + 1.minutes
    @event.tzid = Sponger::TimeZone.tzid_from_human(params[:remind][:time_zone])
    @event.all_day = false
    @event.calendar_id = CALENDAR_ID
    @event.save
    
    @reminder = Sponger::Reminder.create(:event_id=>@event.id,:minutes_before=>0,:email=>params[:remind][:email],:mobile_number=>params[:remind][:mobile_number])
    flash.now[:note] = "Reminder saved."
    render :action=>"list"
  end

  def init_session
    #Sponger::Resource.clear_private_data
    #@signed_in = !!session[:spongewolf_token]
    token = Sponger::AuthorizationToken.create(:user_name=>USER_NAME,:password=>PASSWORD)
    Sponger::Resource.token = token
  end
  
end
