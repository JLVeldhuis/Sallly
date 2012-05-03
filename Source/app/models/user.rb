class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,     :presence     => true,
                       :length       => { :maximum => 50 }
  validates :email,    :presence     => true,
                       :format       => { :with => email_regex },
                       :uniqueness   => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
    
  has_one :setting
  has_many :events
  
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
end
