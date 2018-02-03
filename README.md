_primes_
========

**Note:** This code is deprecated; it's been replaced by [primebot][] which is
more maintainable, and works on multiple social networks.

_primes_ is a prime number calculator that uses twitter as its storage backend;
you can follow [@\_primes\_](https://twitter.com/_primes_) to see the magic. It 
works as follows:

1. Start up
2. Fetch the most recently calculated prime from the Twitter feed.
3. Calculate the next prime.
4. Post if an hour has passed since the last posting. Wait if not.
5. Steps 2–4 forever.

With the speed that the average machine can calculate prime numbers, it should 
be several decades before processor time becomes an issue.


The MIT License (MIT)
---------------------

Copyright (c) 2014 Nathan Wittstock

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

[primebot]: https://github.com/fardog/primebot
