namespace :comments do

  desc 'cleans spam from comments'
  task(:clean => :environment) do
    puts "Starting Comment cleaner at #{Time.now}"
    #loop through comments
    #check for badwords
    badwords = %w(
 viagra
 cialis
 isuzuforums.com
 phentermine
 ativan
 xanax
 ringtones
 levitra
 propecia
 valium
 tamiflu
 tramadol
 diazepam
 lorazepam
 zolpidem
 klonopin
 vibramycin
 metronidazole
 kamagra
 penguinforum
 clonazepam
 metformin
 citalopram
 clonazepam
-online
4u
adipex
advicer
baccarrat
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
discreetordering
duty-free
dutyfree
equityloans
fioricet
flowers-leading-site
freenet-shopping
freenet
gambling-
hair-loss
health-insurancedeals-4u
homeequityloans
homefinance
holdem
holdempoker
holdemsoftware
holdemtexasturbowilson
hotel-dealse-site
hotele-site
hotelse-site
incest
insurance-quotesdeals-4u
insurancedeals-4u
jrcreations
levitra
macinstruct
mortgage-4-u
mortgagequotes
online-gambling
onlinegambling-4u
ottawavalleyag
ownsthis
palm-texas-holdem-game
paxil
penis
pharmacy
phentermine
poker-chip
poze
pussy
rental-car-e-site
ringtones
roulette
shemale
shoes
slot-machine
texas-holdem
thorcarlson
top-site
top-e-site
tramadol
trim-spa
ultram
valeofglamorganconservatives
viagra
vioxx
xanax
zolus
)
    #delete if they have badwords
    comments = Comment.find(:all)
    comments.each do |c|
      badwords.each do |bw|    
        c.destroy() if c.comment.downcase.include?(bw)
      end
    end
    puts "Completed Comment cleaner at #{Time.now}"
  end
end