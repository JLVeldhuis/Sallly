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
      return "Cold Call"
    elsif clnm == 2
      return "Visit"
    elsif clnm == 3
      return "Quote"
    else
      return "Other"
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
    data = access_token.provider == "facebook" ? access_token.extra.raw_info : access_token['info']
    user = signed_in_resource ? signed_in_resource : self.find_by_email(data.email)
    if user
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
    if setting.crm_option == "salesforce"
      refresh_leads_via_salesforce
    else
      refresh_leads_via_highrise
    end
  end
  
  def refresh_leads_via_highrise
    leads_via_highrise = Highrise::Person.find(:all)
    leads_via_highrise.each do |l|
      lead    = self.leads.find_by_crm_id(l.id)
      lead  ||= self.leads.build({:crm_id => l.id})
      
      lead.name  = "#{l.first_name} #{l.last_name}"
      lead.phone = l.contact_data.phone_numbers[0].number if l.contact_data.phone_numbers.count > 0
      lead.email = l.contact_data.email_addresses[0].address if l.contact_data.email_addresses.count > 0
      if l.contact_data.addresses.count > 0
        lead.city = l.contact_data.addresses[0].city
        lead.address = "#{l.contact_data.addresses[0].street} #{l.contact_data.addresses[0].city} #{l.contact_data.addresses[0].country} #{l.contact_data.addresses[0].zip}"
      end
      
      if l.notes.count > 0
        crm_data = []
        l.notes.each do |note|
          crm_data << note.body
        end
        lead.crm_notes = crm_data.join(' ')
      end
      lead.save
    end
  end
  
  def refresh_leads_via_salesforce
    
  end
end
