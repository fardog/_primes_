/*
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
*/

'use strict';

function isPrime(n) {
	var max = Math.sqrt(n);

	for (var i = 2; i < max; i++) {
		if (n % i === 0) return false
	}

	return true;
}

$(document).ready(function() {

	var viewModel = function() {
		var self = this;

		self.primesPerPage = 100;
		
		self.primeNumbers = ko.observableArray();
		self.lastPrime = ko.observable();

		self.populatePrimes = function(start, next) {
			// blank the existing array of primes
			self.primeNumbers([]);

			var n = start; // number to be checked for prime
			var i = 1; // number of primes we've generated

			// generate primes
			while (i < self.primesPerPage) {
				if (isPrime(n)) {
					self.primeNumbers.push({
						val: n
					});

					i++;  // if we found a prime, increment the counter
					
					// save the last prime we've found
					if (i >= self.primesPerPage) {
						self.lastPrime(n);
					}
				}

				// increment the number we're checking
				n++;
			}

			// run our callback if we have one
			if (typeof next !== 'undefined' && next) next();
		};

		self.doGenerateNextPrimes = function(next) {
			var hash = location.hash;
			hash = hash.replace(/^#!\/start\//, '') || 2;
			if (isNaN(hash + 1)) hash = 2;
			self.populatePrimes(hash, next);
		};
	};

	var view = new viewModel();

	ko.applyBindings(view);

	$(window).hashchange(function() {
		view.doGenerateNextPrimes();
	});

	$(window).hashchange();
});
