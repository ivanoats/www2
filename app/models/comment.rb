class Comment < ActiveRecord::Base
  
  # +------------------+--------------+------+-----+---------+----------------+
  # | Field            | Type         | Null | Key | Default | Extra          |
  # +------------------+--------------+------+-----+---------+----------------+
  # | id               | int(11)      | NO   | PRI | NULL    | auto_increment |
  # | title            | varchar(255) | YES  |     |         |                |
  # | comment          | text         | YES  |     | NULL    |                |
  # | created_at       | datetime     | YES  |     | NULL    |                |
  # | updated_at       | datetime     | YES  |     | NULL    |                |
  # | user_id          | int(11)      | NO   | MUL | 0       |                |
  # | web_site         | varchar(255) | YES  |     | NULL    |                |
  # | email            | varchar(255) | YES  |     | NULL    |                |
  # | name             | varchar(255) | YES  |     | NULL    |                |
  # | commentable_id   | int(11)      | YES  |     | NULL    |                |
  # | commentable_type | varchar(255) | YES  |     | NULL    |                |
  # +------------------+--------------+------+-----+---------+----------------+
  
  attr_accessor :key

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates_presence_of :email, :on => :create, :message => "can't be blank"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "email is invalid"
  validates_presence_of :comment, :on => :create, :message => "can't be blank"
  validates_presence_of :commentable_id, :on => :create, :message => "you have to comment on something!"
  validate :does_not_include_badwords

  # Helper method to check comments against a badword list
  def does_not_include_badwords

    badwords = %w(
    -online
    4u
    5gighost.com
    adipex
    advicer
    ativan
    baccarrat
    blowjob
    blackjack
    bllogspot
    booker
    byob
    car-rental-e-site
    car-rentals-e-site
    carisoprodol
    casino
    casinos
    chatroom
    cialis
    citalopram
    clonazepam
    coolcoolhu
    coolhu
    credit-card-debt
    credit-report-4u
    cwas
    cyclen
    cyclobenzaprine
    dating-e-site
    day-trading
    debt-consolidation
    debt-consolidation-consultant
    diazepam
    discreetordering
    duty-free
    dutyfree
    equityloans
    fioricet
    flowers-leading-site
    freenet
    freenet-shopping
    gambling-
    hair-loss
    health-insurancedeals-4u
    holdem
    holdempoker
    holdemsoftware
    holdemtexasturbowilson
    homeequityloans
    homefinance
    hotel-dealse-site
    hotele-site
    hotelse-site
    hydrocodone
    incest
    insurance-quotesdeals-4u
    insurancedeals-4u
    isuzuforums.com
    jrcreations
    kamagra
    kaboodle.com
    klonopin
    levitra
    lycos
    lesbian
    lezbian
    loans
    lorazepam
    macinstruct
    metformin
    metronidazole
    mortgage-4-u
    mortgagequotes
    musicstation
    online-gambling
    onlinegambling-4u
    ottawavalleyag
    ownsthis
    palm-texas-holdem-game
    paydal
    paxil
    penguinforum
    penis
    pharmacy
    phentermine
    poker-chip
    poze
    porn
    propecia
    profiles.friendster.com
    pussy
    rental-car-e-site
    ringtone
    ringtones
    roulette
    shemale
    shoes
    slot-machine
    tamiflu
    texas-holdem
    thorcarlson
    top-e-site
    top-site
    tramadol
    trim-spa
    ultram
    valeofglamorganconservatives
    valium
    viagra
    vibramycin
    vicodin
    vioxx
    xanax
    zolpidem
    zolus
    blogs.blackmarble.co.uk
    personalloansbad
    1freewebspace.com
    associations.missouristate.edu
    arcadepages
    jestmaster
    Staphcillin
    amoxil
    baclofen
    lamictal
    levaquin
    toprol
    diovan
    arimidex
    augmentin
    voltaren
    remeron
    zantac
    zofran
    phenergan
    dostinex
    proscar
    tegretol
    creditonlinepersonalloans
    cipro
    vytorin
    accutane
    flagyl
    dvxuser.com
    buspar
    fosamax
    toradol
    adultsex
    jizz
    nojazzfest
    comment1
    comment2
    comment3
    comment4
    comment5
    comment6
    )
    badwords.each do |bw|
      if comment.downcase.include?(bw) 
        errors.add_to_base("Comment Rejected") 
        break
      end
    end
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  def self.find_comments_by_user(userid)
    find(:all,
      :conditions => ["user_id = ?", userid],
      :order => "created_at DESC"
    )
  end
  
  # Helper class method to look up all comments for 
  # commentable class name and commentable id. 
  # commented out because I couldn't imagine what I could use it for
  #
  # def self.find_comments_for_commentable(commentable_str, commentable_id)
  #     find(:all,
  #       :conditions => ["commentable_type = ? and commentable_id = ?", commentable_str, commentable_id],
  #       :order => "created_at DESC"
  #     )
  #   end

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  # commented out because I couldn't imagine what I could use it for
  #
  # def self.find_commentable(commentable_str, commentable_id)
  #   commentable_str.constantize.find(commentable_id)
  # end
end