class User < ActiveRecord::Base
  
  # setup devise
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  # validations
  validates :name,     :presence     => true,
                       :length       => { :maximum => 50 }
  
  # associations
  has_one :setting
  has_many :events
  
  # callbacks
  before_create :add_setting_for_user
  
  def add_setting_for_user
    self.setting = Setting.new
  end
  
  # returns the user's events as json optimized for full calendar
  def calendar_events_json
    event_feed = []
    self.events.each do |event|
      thisEvent = {
                    'event_id'   => event.id,
                    'title'      => event.title,
                    'allDay'     => false,
                    'className'  => Event::EventType.invert[event.eventtype]
                  }
      unless event.date_to.blank?
        thisEvent['allDay'] = false
        thisEvent['end']    = event.date_to.iso8601 
      end
      thisEvent['start']    = event.date_from.iso8601 unless event.date_from.blank?
      event_feed << thisEvent
    end
    event_feed
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = self.find_by_email(data.email)
      user
    else # Create a user with a stub password. 
      self.create!(:email => data.email, :password => Devise.friendly_token[0,20]) 
    end
  end
end
