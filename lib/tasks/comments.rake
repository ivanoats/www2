namespace :comments do

  desc 'cleans spam from comments'
  task(:clean => :environment) do
    puts "Starting Comment cleaner at #{Time.now}"
    #loop through comments
    #check for badwords
    badwords = %w(
-online
4u
5gighost.com
adipex
advicer
ativan
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
incest
insurance-quotesdeals-4u
insurancedeals-4u
isuzuforums.com
jrcreations
kamagra
klonopin
levitra
lycos
lorazepam
macinstruct
metformin
metronidazole
mortgage-4-u
mortgagequotes
online-gambling
onlinegambling-4u
ottawavalleyag
ownsthis
palm-texas-holdem-game
paxil
penguinforum
penis
pharmacy
phentermine
poker-chip
poze
propecia
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
vioxx
xanax
zolpidem
zolus
blogs.blackmarble.co.uk
personalloansbad
1freewebspace.com
associations.missouristate.edu
)
    #delete if they have badwords
    comments = Comment.find(:all)
    comments.each do |c|
      badwords.each do |bw|
        if c.comment.downcase.include?(bw) 
          c.destroy() 
          break
        end
      end
    end
    puts "Completed Comment cleaner at #{Time.now}"
  end
end