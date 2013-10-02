Fiber = require 'fibers'
Twitter = require 'twitter'
config = require 'nconf'

# Load configuration
config.argv().env().file('./config.json')

# Start up our Twitter reader
twitter = new Twitter data=
  consumer_key: config.get 'consumer_key'
  consumer_secret: config.get 'consumer_secret'
  access_token_key: config.get 'access_token_key'
  access_token_secret: config.get 'access_token_secret'


Date.prototype.addHours = (h) ->
    @setHours (@getHours()+h)


# isPrime: A function for determining if a number is prime
#
# n - Number to be tested
#
# Returns true if the number is prime, false otherwise
isPrime = (n) ->
  max = Math.sqrt n

  for i in [2..max]
    if n % i == 0
      return false

  return true

# Primes: Generator function that yelds one prime per iteration
#
# Returns the fiber to be used as the generator
Primes = (n) ->
  fiber = Fiber ->
    while true
      if isPrime n
        Fiber.yield n
      n++

  return fiber.run.bind fiber



# Number of Primes we want to get
nPrimes = 3

# Number that we're starting from
startPrime = null
seq = null
timeout = 0


scheduleNext = (data) ->
  date = new Date(data.created_at)

  if Date.now() > date
    console.log "would post already"
  else
    timeout = date - Date.now()
    console.log "would post later " + timeout

  if data? and data.text?
    startPrime = parseInt data.text
    console.log "startPrime is " + startPrime
    
    if !isPrime(startPrime)
      console.log "Error: We retrieved a non-prime number from twitter!"
      process.exit(1)

  else
    console.log "Error: Could not retrieve starting number from Twitter!"
    process.exit(1)

  # Now we're ready to start calculating and posting.
  seq = Primes(startPrime + 1)

  setTimeout (=>
    prime_number = seq()
    twitter.updateStatus prime_number, (data) ->
      scheduleNext(data)
  ), timeout

# Get our starting number from twitter, so we can see what was last posted
twitter.getUserTimeline null, (data) ->
  scheduleNext(data[0])
