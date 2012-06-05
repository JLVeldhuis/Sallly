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
  has_many :leads
  has_many :events
  has_many :authentications
  
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
                    'className'  => User.get_event_class_name(event.eventtype)
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
  
  def self.get_event_class_name(clnm)
    if clnm == 1
      return "Cold Calls"
    elsif clnm == 2
      return "Visits"
    elsif clnm == 3
      return "Quotes"
    else
      return "Others"
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
      
      if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
        user.email = data['email']
      end
    end
  end
  
  def self.find_for_service_oauth_with_email(email, access_token, signed_in_resource=nil)
    data = access_token[:extra][:raw_info]
    if user = self.find_by_email(email)
      account = user.authentications.find_by_provider_and_uid(access_token[:provider], access_token[:uid])
      account ||= user.authentications.create(:provider => access_token[:provider], :uid => access_token[:uid])
      user
    else # Create a user with a stub password.
      username = data[:name] || data[:username] || email
      user = User.new(:email => email, :password => Devise.friendly_token[0,20], :name => username) 
      user.authentications.build(:provider => access_token[:provider], :uid => access_token[:uid])
      user.save
      user
    end
  end
  
  def self.find_for_service_oauth(access_token, signed_in_resource=nil)
    if access_token.provider == "facebook"
      data = access_token.extra.raw_info
    else
      data = access_token['info']
    end
    if user = self.find_by_email(data.email)
      account = user.authentications.find_by_provider_and_uid(access_token.provider, access_token.uid)
      account ||= user.authentications.create(:provider => access_token.provider, :uid => access_token.uid)
      user
    else # Create a user with a stub password.
      username = data.name || data.username || data.email 
      user = User.new(:email => data.email, :password => Devise.friendly_token[0,20], :name => username) 
      user.authentications.build(:provider => access_token.provider, :uid => access_token.uid)
      user.save ? user : nil
    end
  end
  
  def refresh_leads
    leads_via_highrise = Highrise::Person.find(:all)
    leads_via_highrise.each do |l|
      self.leads.create({
                          :name => "#{l.first_name} #{l.last_name}"
                       })
    end
  end
end
