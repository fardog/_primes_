###
The MIT License (MIT)
---------------------

Copyright (c) 2013 Nathan Wittstock

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###


# die: Dump a message to the console, and quit with an error
#
# message - The message to output
#
# Returns nothing
die = (message) ->
  console.log "Error: " + message
  process.exit(1)


Fiber = require 'fibers'
Twitter = require 'twitter'
config = require 'nconf'

# Load configuration
config.argv().env().file('./config.json')

# Start up our Twitter reader/writer
twitter = new Twitter data=
  consumer_key: config.get 'consumer_key'
  consumer_secret: config.get 'consumer_secret'
  access_token_key: config.get 'access_token_key'
  access_token_secret: config.get 'access_token_secret'

minutes_between_posts = config.get 'minutes_between_posts'
if typeof minutes_between_posts == 'undefined' or minutes_between_posts < 10
  die "Minutes between posts was not set appropriately."


# addHours: Extend the date object to contain a function to add minutes
#
# m - Number of minutes to be added
#
# Returns the date object with the minutes added
Date.prototype.addMinutes = (m) ->
  @setMinutes (@getMinutes()+m)


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
# n - Number to start generating primes from
#
# Returns the fiber to be used as the generator
Primes = (n) ->
  fiber = Fiber ->
    while true
      if isPrime n
        console.log "Info: Prime generated was " + n
        Fiber.yield n
      n++

  return fiber.run.bind fiber


# Variables we'll use to manage state
startPrime = null  # The prime number we're starting from
seq = null  # The sequence generator function
timeout = 0  # The amount of time we're waiting before posting
last_post = null  # The last time we posted, in milliseconds


# scheduleNext: Uses data from twitter to determine the next posting time, and
# handles any error checking to make sure we don't over-post.
#
# data - JSON data returned from Twitter
#
# Returns nothing
scheduleNext = (data) ->
  # Get the last prime number posted
  if data? and data.text?
    startPrime = parseInt data.text
    console.log "Info: Starting Prime is " + startPrime
    
    # If it's not a prime that was posted last, something is wrong
    if !isPrime(startPrime)
      die "We retrieved a non-prime number from Twitter!"

  else
    die "Could not retrieve starting number from Twitter!"

  # Now we're ready to start calculating and posting.
  seq = Primes(startPrime + 1)
  prime_number = seq()

  # Get the date of the last post from the twitter data
  date = null
  if typeof data.created_at != 'undefined'
    date = new Date data.created_at
    date.addMinutes(minutes_between_posts)
  else
    die "Could not get the last posting date from Twitter."

  # Check if it's been enough time since last post, or calculate when to post
  if !(Date.now() > date)
    timeout = date - Date.now()
    console.log "Info: Will post in " + timeout + " milliseconds."

  # Start the timer before posting
  setTimeout (=>
    # Fail-safe to ensure we haven't posted too often accidentally
    failsafe_duration = 1000*60*minutes_between_posts/2
    if last_post == null or (last_post + failsafe_duration) < Date.now()
      last_post = Date.now()
      twitter.updateStatus prime_number, (data) ->
        console.log "Info: Successfully posted to Twitter."
        scheduleNext data
    else
      die "Tried to post too often."
  ), timeout


# Get our starting number from twitter, so we can see what was last posted
twitter.getUserTimeline null, (data) ->
  scheduleNext data[0]

