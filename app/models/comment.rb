class Comment < ActiveRecord::Base
  
# mysql -Dwww2_sw -e "describe comments;"
# Field Type  Null  Key Default Extra
# id  int(11) NO  PRI NULL  auto_increment
# title varchar(255)  YES     
# comment text  YES   NULL  
# created_at  datetime  YES   NULL  
# updated_at  datetime  YES   NULL  
# user_id int(11) NO  MUL 0 
# web_site  varchar(255)  YES   NULL  
# email varchar(255)  YES   NULL  
# name  varchar(255)  YES   NULL  
# commentable_id  int(11) YES   NULL  
# commentable_type  varchar(255)  YES   NULL  

# describe comments

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
    aloha!
    href=
    -online
    1freewebspace.com
    4u
    5gighost.com
    accutane
    adipex
    adultsex
    advicer
    alprazolam
    amoxil
    arcadepages
    arimidex
    associations.missouristate.edu
    ativan
    augmentin
    baccarrat
    baclofen
    beaver
    blackjack
    bllogspot
    blogs.blackmarble.co.uk
    blowjob
    booker
    buspar
    byob
    car-rental-e-site
    car-rentals-e-site
    carisoprodol
    casino
    casinos
    chatroom
    cialis
    cipro
    citalopram
    clomid
    clonazepam
    comment1
    comment2
    comment3
    comment4
    comment5
    comment6
    coolcoolhu
    coolhu
    credit-card-debt
    credit-report-4u
    creditonlinepersonalloans
    cwas
    cyclen
    cyclobenzaprine
    dating-e-site
    day-trading
    debt-consolidation
    debt-consolidation-consultant
    diazepam
    diovan
    discreetordering
    dostinex
    duty-free
    dutyfree
    dvxuser.com
    equityloans
    fanreach.com
    fioricet
    flagyl
    flowers-leading-site
    fosamax
    freenet
    freenet-shopping
    gambling-
    hair-loss
    health-insurancedeals-4u
    hi5.com
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
    hyves.mn
    incest
    insurance-quotesdeals-4u
    insurancedeals-4u
    isuzuforums.com
    jestmaster
    jizz
    jrcreations
    kaboodle.com
    kamagra
    klonopin
    lamictal
    lesbian
    levaquin
    levitra
    lezbian
    loans
    lorazepam
    lycos
    macinstruct
    metformin
    metronidazole
    mortgage-4-u
    mortgagequotes
    musicstation
    nojazzfest
    nolvadex
    online-gambling
    onlinegambling-4u
    ottawavalleyag
    ownsthis
    palm-texas-holdem-game
    paxil
    paydal
    penguinforum
    penis
    personalloansbad
    pharmacy
    phenergan
    phentermine
    poker-chip
    porn
    poze
    profiles.friendster.com
    propecia
    proscar
    pussy
    remeron
    rental-car-e-site
    ringtone
    ringtones
    roulette
    shemale
    shoes
    slot-machine
    Staphcillin
    tamiflu
    tegretol
    texas-holdem
    thorcarlson
    top-e-site
    top-site
    toprol
    toradol
    tramadol
    tramodal
    tramodol
    trim-spa
    ultram
    valeofglamorganconservatives
    valium
    viagra
    vibramycin
    vicodin
    vioxx
    voltaren
    vytorin
    xanax
    zantac
    zithromax
    zofran
    zolpidem
    zolus
    )
    badwords.each do |bw|
      if !comment.nil? && comment.downcase.include?(bw) 
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
