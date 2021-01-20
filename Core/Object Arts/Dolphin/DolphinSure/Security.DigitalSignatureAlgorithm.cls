"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DigitalSignatureAlgorithm
	instanceVariableNames: 'randKey randSeed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'SmallPrimes' -> #(3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 379 383 389 397 401 409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503 509 521 523 541 547 557 563 569 571 577 587 593 599 601 607 613 617 619 631 641 643 647 653 659 661 673 677 683 691 701 709 719 727 733 739 743 751 757 761 769 773 787 797 809 811 821 823 827 829 839 853 857 859 863 877 881 883 887 907 911 919 929 937 941 947 953 967 971 977 983 991 997 1009 1013 1019 1021 1031 1033 1039 1049 1051 1061 1063 1069 1087 1091 1093 1097 1103 1109 1117 1123 1129 1151 1153 1163 1171 1181 1187 1193 1201 1213 1217 1223 1229 1231 1237 1249 1259 1277 1279 1283 1289 1291 1297 1301 1303 1307 1319 1321 1327 1361 1367 1373 1381 1399 1409 1423 1427 1429 1433 1439 1447 1451 1453 1459 1471 1481 1483 1487 1489 1493 1499 1511 1523 1531 1543 1549 1553 1559 1567 1571 1579 1583 1597 1601 1607 1609 1613 1619 1621 1627 1637 1657 1663 1667 1669 1693 1697 1699 1709 1721 1723 1733 1741 1747 1753 1759 1777 1783 1787 1789 1801 1811 1823 1831 1847 1861 1867 1871 1873 1877 1879 1889 1901 1907 1913 1931 1933 1949 1951 1973 1979 1987 1993 1997 1999)
	}!
DigitalSignatureAlgorithm guid: (GUID fromString: '{b1b2a1d8-34b1-4c43-90dc-767320f26e47}')!
DigitalSignatureAlgorithm comment: 'This class implements the Digital Signature Algorithm (DSA) of the U.S. government''s "Digital Signature Standard" (DSS). The DSA algorithm was proposed in 1991 and became a standard in May 1994. The official description is available as a Federal Information Processing Standards Publication (FIPS PUB 186, May 19, 1994). A companion standard, the Secure Hash Standard, or SHS (FIPS PUB 180-1, April 17, 1995), describes a 160-bit message digest algorithm known as the Secure Hash Algorithm (SHA). This message digest is used to compute the document signature.

This class was ported from the Squeak original.

Here''s how to use it:

  1. The "signer" creates a pair of keys. One of these must be kept private. The other may be freely distributed. For example, it could be built into the signature checking code of an application.

  2. When the signer wishes to sign a packet of data (a "message") , he uses the secure hash algorithm to create a 160-bit message digest (hash) which is used as the input to DSA. The result of this is a pair of large numbers called a "signature" that is attached to the original message.

  3. When someone receives a signed message purported to have come from the signer, they compute the 160-bit hash of the message and pass that, along with the message signature and the signer''s public key, to the signature verification algorithm. If the signature checks, then it is virtually guaranteed that the message originated from someone who had the signer''s private key. That is, the message is not a forgery and has not been modified since it was signed. For example, if the message contains a program, and the recipient trusts the signer, then the recipient can run the program with the assurance that it won''t do anything harmful. (At least, not intentionally. A digital signature is no guarantee against bugs!! :->)

The signer must keep the private key secure, since anyone who has the private key can forge the signer''s signature on any message they like. As long as the secret key is not stolen, cryptographers believe it to be virtually impossible either to forge a signature, to find a message that matches an existing sigature, or to discover the signer''s private key by analyzing message signatures. Knowing the public key (which, for example, could be recovered from an application that had it built in), does not weaken the security at all.

An excellent reference work on digital signatures and cryptography in general is:

  Schneier, Bruce
  "Applied Cryptography: Protocols, Algorithms, and Source Code in C"
  John Wiley and Sons, 1996.

I (John Maloney) used this book as a guide to implementing many of the numerical algorithms required by DSA.

Patents and Export Restrictions:

Many digital signature technologies are patented. DSA is also patented, but the patent is owned by the U.S. government which has made DSA available royalty-free. There is a claim that the government patent infringes on an earlier patent by Schnorr, but the government is requiring the use of DSA, so they apparently believe this claim is not strong enough to be a serious threat to their own patent.

Most cryptography technology, including digital signature technology, requires an export license for it to be distributed outside the U.S. Recent legislation may have relaxed the export license requirements, but it would be prudent to check the current regulations before exporting this code.'!
!DigitalSignatureAlgorithm categoriesForClass!Cryptography-Support! !
!DigitalSignatureAlgorithm methodsFor!

computeSignatureForMessageHash: hash privateKey: privateKey 
	"Answer the digital signature of the given message hash using the given private key. A signature is a pair of large integers. The private key is an array of four large integers: (p, q, g, x)."

	| p q g x rs r s |
	p := privateKey first.
	q := privateKey second.
	g := privateKey third.
	x := privateKey fourth.
	r := s := 0.
	[r = 0 or: [s = 0]] whileTrue: 
			[| k |
			k := self remainder: self nextRandom160 mod: q.
			rs := self 
						dsaSign: p
						q: q
						g: g
						k: k
						x: x
						h: hash.
			r := rs at: 1.
			s := rs at: 2].
	^rs!

dsaSign: p q: q g: g k: k x: x h: h
	"Private - Answer the digital signature of the given message hash using the given private key parameters"

	| r s tmp |
	r := s := 0.
	r := self remainder: (self
						raise: g
						to: k
						mod: p)
				mod: q.
	tmp := self remainder: h + (x * r) mod: q.
	s := self remainder: (self inverseOf: k mod: q) * tmp mod: q.
	^{r. s}!

elgamalDecrypt: m privateKey: privateKey
	"Answer the Elgamal decryption of the given message using the given private key. "

	| a b p q x g rs e |
	p := privateKey first.
	q := privateKey second.
	g := privateKey third.
	x := privateKey fourth.

	a := m at: 1.
	b := m at: 2.

	rs := self dsaSign: p q: p g: a k: x x: 0 h: 0.
	e := rs at: 1.
	rs := self dsaSign: p q: p g: 1 k: e x: b h: 0.
	^rs at: 2
	
	

	
	
!

elgamalEncrypt: m publicKey: publicKey
	"Answer the Elgamal encryption of the given message using the given private key. 
	The private key is an array of four large integers: (p, q, g, x)."

	| p q y g k rs a b u |
	p := publicKey first.
	q := publicKey second.
	g := publicKey third.
	y := publicKey fourth.
	k := self remainder: self nextRandom160 mod: q.
	rs := self
				dsaSign: p
				q: p
				g: g
				k: k
				x: 0
				h: 0.
	a := rs at: 1.
	rs := self
				dsaSign: p
				q: p
				g: y
				k: k
				x: 0
				h: 0.
	u := rs at: 1.
	rs := self
				dsaSign: p
				q: p
				g: m
				k: 1
				x: u
				h: 0.
	b := rs at: 2.
	^{a. b}!

generateFullKeySet
	"Generate and answer a key set for DSA. The result is a pair (<private key><public key>). 
	Each key is an array of four large integers. The private key is (p, q, g, x); the public one 
	is (p, q, g, y). The signer must be sure to record (p, q, g, x), and must keep x secret to 
	prevent someone from forging their signature.
	
	Note: Key generation can take some time. "

	| group ks p q g x y |
	group := self generateKeyGroup.
	p := group first.
	q := group second.
	g := group third.
	ks := self generateKeySetForGroup: group.
	x := ks first.
	y := ks second.
	^{{p. q. g. x}. {p. q. g. y}}!

generateKeyGroup
	"Generate and answer a partial key set for DSA. The result is an array of three large integers
	[p, c, g] and can be used for creating key sets that are shared between a group of users.
	
	Note: Key generation can take some time. "

	| qAndPandS q p exp g h |
	qAndPandS := self generateQandP.
	q := qAndPandS first.
	p := qAndPandS at: 2.
	exp := (p - 1) / q.
	h := 2.
	
	[g := self
				raise: h
				to: exp
				mod: p.
	g = 1] whileTrue: [h := h + 1].
	^{p. q. g}!

generateKeySetForGroup: aGroupArray
	"Generate and answer a key set for DSA. The result is an array (<private key><public key>). "

	| q p g x y |
	p := aGroupArray first.
	q := aGroupArray second.
	g := aGroupArray third.
	x := self nextRandom160.
	y := self
				raise: g
				to: x
				mod: p.
	^{x. y}!

generateQandP
	"Private - Generate the two industrial-grade primes, q (160-bits) and p (>512-bit) needed 
	to build a key set. Answer the array (q, p, s), where s is the seed that from which q 
	and p were created. This seed is normally discarded, but can be used to verify the 
	key generation process if desired."

	| pBits halfTwoToTheP chunkCount |
	pBits := self keyStrength.	"desired size of p in bits"
	halfTwoToTheP := 2 raisedTo: pBits - 1.
	chunkCount := pBits // 160.
	[true] whileTrue: 
			[| sAndq q twoQ n c s |
			sAndq := self generateSandQ.
			s := sAndq first.
			q := sAndq last.
			twoQ := q bitShift: 1.
			n := 2.
			c := 0.
			[c < 4096] whileTrue: 
					[| w x p |
					w := self
								generateRandomLength: pBits
								s: s
								n: n.
					x := w + halfTwoToTheP.
					p := x - (self remainder: x mod: twoQ) + 1.
					p highBit = pBits ifTrue: [(self isProbablyPrime: p) ifTrue: [^{q. p. s}]].
					n := n + chunkCount + 1.
					c := c + 1]]!

generateRandomLength: bitLength s: s n: n 
	"Private - Answer a random number of bitLength bits generated using the secure hash algorithm."

	| sha out count extraBits |
	sha := SecureHashAlgorithm new.
	out := 0.
	count := bitLength // 160.
	extraBits := bitLength - (count * 160).
	0 to: count
		do: 
			[:k | 
			| v |
			v := sha hashInteger: s + n + k.
			k = count ifTrue: [v := v - (v >> extraBits << extraBits)].
			out := out bitOr: (v bitShift: 160 * k)].
	^out!

generateSandQ
	"Private - Generate a 160-bit random seed s and an industrial grade prime q."

	| hasher |
	hasher := SecureHashAlgorithm new.
	[true] whileTrue: 
			[| s sPlusOne u q |
			s := self nextRandom160.
			sPlusOne := s + 1.
			sPlusOne highBit > 160 ifTrue: [self remainder: sPlusOne mod: (2 raisedTo: 160)].
			u := (hasher hashInteger: s) bitXor: (hasher hashInteger: sPlusOne).
			q := u bitOr: ((1 bitShift: 159) bitOr: 1).
			(self isProbablyPrime: q) ifTrue: [^{s. q}]]!

initRandom: randomInteger
	"Private - Initialize the the secure random number generator with the given value. 
	The argument should be a positive integer of up to 512 bits chosen randomly to avoid someone
	being able to predict the sequence of random values generated.

	Note: The random generator must be initialized before generating a key set or signature. 
	Signature verification does not require initialization of the random generator."

	randSeed := 16rEFCDAB8998BADCFE10325476C3D2E1F067452301.  "initial seed"
	randKey := randomInteger.
!

initRandomFromUser
	"Private - Ask the user to type a long random string and use the result to seed the secure random number generator."

	| s k srcIndex |

	s :=  (Delay microsecondClockValue bitOr: 1) displayString.
	k := LargeInteger new: (s size min: 64)//4.
	srcIndex := 0.
	k byteSize to: 1 by: -1 do: [:i |
		k basicAt: i put: (s at: (srcIndex := srcIndex + 1)) codePoint].
	k := k + (Random new next; seed) truncated.  "a few additional bits randomness"
	k highBit > 512 ifTrue: [k := k bitShift: k highBit - 512].
	self initRandom: k.
!

inverseOf: x mod: n 
	"Private - Answer the inverse of x modulus n. That is, the integer y such that (x * y) \\ n is 1. 
	Both x and n must be positive, and it is assumed that x < n and that x and n are integers."

	"Details: Use the extended Euclidean algorithm, Schneier, p. 247."

	| v u k u1 u2 u3 t1 t2 t3 |
	(x <= 0 or: [n <= 0]) ifTrue: [self error: 'x and n must be greater than zero'].
	x >= n ifTrue: [self error: 'x must be < n'].
	v := x.
	u := n.
	k := 0.
	[x even and: [n even and: [u > 0]]] whileTrue: 
			["eliminate common factors of two"

			k := k + 1.
			u := u bitShift: -1.
			v := v bitShift: -1].
	u1 := 1.
	u2 := 0.
	u3 := u.
	t1 := v.
	t2 := u - 1.
	t3 := v.
	
	[
	[u3 even 
		ifTrue: 
			[(u1 odd or: [u2 odd]) 
				ifTrue: 
					[u1 := u1 + v.
					u2 := u2 + u].
			u1 := u1 bitShift: -1.
			u2 := u2 bitShift: -1.
			u3 := u3 bitShift: -1].
	(t3 even or: [u3 < t3]) 
		ifTrue: 
			[| tmp |
			tmp := u1.
			u1 := t1.
			t1 := tmp.
			tmp := u2.
			u2 := t2.
			t2 := tmp.
			tmp := u3.
			u3 := t3.
			t3 := tmp].
	u3 even and: [u3 > 0]] 
			whileTrue: 
				["loop while u3 is even"

				].
	[(u1 < t1 or: [u2 < t2]) and: [u1 > 0]] whileTrue: 
			[u1 := u1 + v.
			u2 := u2 + u].
	u1 := u1 - t1.
	u2 := u2 - t2.
	u3 := u3 - t3.
	t3 > 0] 
			whileTrue: 
				["loop while t3 > 0"

				].
	[u1 >= v and: [u2 >= u]] whileTrue: 
			[u1 := u1 - v.
			u2 := u2 - u].
	u1 := u1 bitShift: k.
	u2 := u2 bitShift: k.
	u3 := u3 bitShift: k.
	u3 = 1 ifFalse: [self error: 'no inverse'].
	^u - u2!

isProbablyPrime: p 
	"Private - Answer true if p is prime with very high probability. Such a number is sometimes called an 
	'industrial grade prime'--a large number that is so extremely likely to be prime that it can
	assumed that it actually is prime for all practical purposes. 
	This implementation uses the Rabin-Miller algorithm (Schneier, p. 159)."

	| iterations factor pMinusOne b m r |
	iterations := 50.	"Note: The DSA spec requires >50 iterations; Schneier says 5 are enough (p. 260)"

	"quick elimination: check for p divisible by a small prime"
	factor := SmallPrimes detect: [:f | p \\ f = 0] ifNone: [nil].
	factor isNil ifFalse: [^false].
	pMinusOne := p - 1.
	b := self logOfLargestPowerOfTwoDividing: pMinusOne.
	m := pMinusOne // (2 raisedTo: b).
	"Assert: pMinusOne = m * (2 raisedTo: b) and m is odd"
	r := Random new.
	iterations timesRepeat: 
			[| a j z couldBePrime |
			a := (r next * 16rFFFFFF) truncated.
			j := 0.
			z := self 
						raise: a
						to: m
						mod: p.
			couldBePrime := z = 1.
			[couldBePrime] whileFalse: 
					[z = 1 ifTrue: [^false].	"not prime"
					z = pMinusOne 
						ifTrue: [couldBePrime := true]
						ifFalse: [(j := j + 1) < b ifTrue: [z := self remainder: z * z mod: p] ifFalse: [^false]]]].	"not prime"
	^true	"passed all tests; probably prime"!

keyStrength
	"Answer the default key strength in bits"

	^768!

logOfLargestPowerOfTwoDividing: aPositiveInteger 
	"Private - Answer the base-2 log of the largest power of two that divides the given integer. 
	For example, the largest power of two that divides 24 is 8, whose log base-2 is 3. 
	Do this efficiently even when the given number is a large integer. Assume that the given integer is > 0."

	"DigitalSignatureAlgorithm new largestPowerOfTwoDividing: (32 * 3)"

	| digitIndex power d |
	digitIndex := (1 to: aPositiveInteger digitLength) 
				detect: [:i | (aPositiveInteger digitAt: i) ~= 0].
	power := (digitIndex - 1) * 8.
	d := aPositiveInteger digitAt: digitIndex.
	[d odd] whileFalse: 
			[power := power + 1.
			d := d bitShift: -1].
	^power!

nextRandom160
	"Private - Answer a newly generated 160-bit random number in the range [1..(2^160 - 1)].
	Try again in the extremely unlikely chance that zero is encountered."

	| result |
	result := 0.
	[result = 0] whileTrue: [
		result := SecureHashAlgorithm new hashInteger: randKey.
		randKey := randKey + result + 1].
	^ result
!

raise: x to: y mod: n
	"Private - Answer ((x raisedTo: y) \\ n) for integers x, y and n, but computed efficiently when x, y, and n are very 
	large positive integers. From Schneier, p. 244."

	| s t u |
	s := 1.
	t := x.
	u := y.
	[u = 0] whileFalse: [
		u even ifFalse: [
			s := s * t.
			s >= n ifTrue: [s := self remainder: s mod: n]].
		t := t * t.
		t >= n ifTrue: [t := self remainder: t mod: n].
		u := u bitShift: -1].
	^ s
!

remainder: x mod: y
	"Private - Answer the remainder of dividing x by y, where x and y are both 
	arge positive integers of at least two digits.

	This was originally coded  in Squeak to speed up the basic LargeInteger divide
	in Squeak. Dolphin's LargeInteger support is fast enough so we just use this."

	^x rem: y
!

signatureToString: aSignature
	"Private - Answer a string representation of the given signature. 
	This string can be parsed using the stringToSignature: method."

	| s hex |
	s := WriteStream on: (String new: 2000).
	s nextPutAll: '[DSA digital signature '.
	hex := aSignature first hex.
	s nextPutAll: (hex copyFrom: 4 to: hex size).
	s space.
	hex := aSignature second hex.
	s nextPutAll: (hex copyFrom: 4 to: hex size).
	s nextPutAll: ']'.
	^ s contents
!

stringToSignature: aString
	"Private - Answer the signature stored in the given string. A signature string has the format:
		 '[DSA digital signature <r> <s>]'
	where <r> and <s> are large positive integers represented by strings of hexidecimal digits."

	| prefix stream r s |
	prefix := '[DSA digital signature '.
	(aString beginsWith: prefix) ifFalse: [self error: 'bad signature prefix'].
	stream := ReadStream on: aString.
	stream position: prefix size.
	r := Integer readFrom: stream radix: 16.
	stream next.
	s := Integer readFrom: stream radix: 16.
	^{r. s}!

verifySignature: aSignature ofMessageHash: hash publicKey: publicKey
	"Answer true if the given signature is the authentic signature of the given message hash. 
	That is, if the signature must have been computed using the private key set corresponding to 
	he given public key. The public key is an array of four large integers: (p, q, g, y)."

	| p q g y r s w u1 u2 v0 v |
	p := publicKey first.
	q := publicKey second.
	g := publicKey third.
	y := publicKey fourth.
	r := aSignature first.
	s := aSignature last.
	((r > 0) and: [r < q]) ifFalse: [^ false].  "reject"
	((s > 0) and: [s < q]) ifFalse: [^ false].  "reject"

	w := self inverseOf: s mod: q.
	u1 := self remainder: (hash * w) mod: q.
	u2 := self remainder: (r * w) mod: q.
	v0 := (self raise: g to: u1 mod: p) * (self raise: y to: u2 mod: p).
	v := self remainder: (self remainder: v0 mod: p) mod: q.
	^ v = r
! !
!DigitalSignatureAlgorithm categoriesFor: #computeSignatureForMessageHash:privateKey:!operations!public!signing! !
!DigitalSignatureAlgorithm categoriesFor: #dsaSign:q:g:k:x:h:!operations!private! !
!DigitalSignatureAlgorithm categoriesFor: #elgamalDecrypt:privateKey:!operations!public! !
!DigitalSignatureAlgorithm categoriesFor: #elgamalEncrypt:publicKey:!operations!public! !
!DigitalSignatureAlgorithm categoriesFor: #generateFullKeySet!key generation!operations!public! !
!DigitalSignatureAlgorithm categoriesFor: #generateKeyGroup!key generation!operations!public! !
!DigitalSignatureAlgorithm categoriesFor: #generateKeySetForGroup:!key generation!operations!public! !
!DigitalSignatureAlgorithm categoriesFor: #generateQandP!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #generateRandomLength:s:n:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #generateSandQ!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #initRandom:!initializing!private! !
!DigitalSignatureAlgorithm categoriesFor: #initRandomFromUser!initializing!private! !
!DigitalSignatureAlgorithm categoriesFor: #inverseOf:mod:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #isProbablyPrime:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #keyStrength!accessing!public! !
!DigitalSignatureAlgorithm categoriesFor: #logOfLargestPowerOfTwoDividing:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #nextRandom160!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #raise:to:mod:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #remainder:mod:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #signatureToString:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #stringToSignature:!helpers!private! !
!DigitalSignatureAlgorithm categoriesFor: #verifySignature:ofMessageHash:publicKey:!operations!public!signing! !

!DigitalSignatureAlgorithm class methodsFor!

example
	"Private - Example of signing a message and verifying its signature.
		self example
	"

	| msg keys sig |
	msg := 'This is a test...'.
	keys := self testKeySet512.
	sig := self sign: msg privateKey: keys first.
	^[(self verify: sig isSignatureOf: msg publicKey: keys last)	ifFalse: [
		self error: 'ERROR!! Signature verification failed' ]] timeToRun.
!

generateFullKeySet
	"Generate and answer a key set for code signing. The result is a pair (<private key><public key>). 
	Each key is an array of four large integers. The signer must be sure to record this keys set and must
	keep the private key secret to prevent someone from forging their signature.

	Note: Key generation can take some time. 

	self generateFullKeySet
	"

	^self new initRandomFromUser generateFullKeySet
!

generateKeyGroup
	"Generate and answer a partial key set for DSA. The result is an array of three large integers
	[p, c, g] and can be used for creating key sets that are shared between a group of users.
	
	Note: Key generation can take some time. 

	self generateKeyGroup
"

	^self new initRandomFromUser generateKeyGroup
!

generateKeySetForGroup: aGroupArray
	"Generate and answer a key set for DSA. The result is an array (<private key><public key>). 
	
	Note: Key generation can take some time. 

	self  generateKeySetForGroup: aGroupArray
"

	^self new initRandomFromUser generateKeySetForGroup: aGroupArray
!

initialize
	"Private - Initialize the receiver.

	DigitalSignatureAlgorithm initialize
	"

	| smallPrimes |
	"SmallPrimes is a list of small primes greater than two."
	smallPrimes := Integer primesUpTo: 2000.
	self addClassConstant: 'SmallPrimes' value: (smallPrimes copyFrom: 2 to: smallPrimes size)!

sign: aStringOrStream privateKey: privateKey
	"Sign the given message (a stream or string) and answer a signature string."

	| dsa hasher h sig |
	dsa := self new.
	dsa initRandomFromUser.
	hasher := SecureHashAlgorithm new.
	(aStringOrStream class isBytes)
		ifTrue: [h := hasher hashMessage: aStringOrStream]
		ifFalse: [h := hasher hashStream: aStringOrStream].
	sig := dsa computeSignatureForMessageHash: h privateKey: privateKey.
	^ dsa signatureToString: sig
!

testKeySet512
	"Answer a pair of keys for testing. The first key is the private key, the second one is the public key."
	"WARNING: This test key set is public should be used only for testing!! In a real application, 
	the user would create a set of keys using generateKeySet and would keep the private key secret."

	^ #(
		(8343811888543852523216773185009428259187948644369498021763210776677854991854533186365944349987509452133156416880596803846631577352387751880552969116768071 1197175832754339660404549606408619548226315875117 1433467472198821951822151391684734233265646022897503720591270330985699984763922266163182803556189497900262038518780931942996381297743579119123094520048965 957348690772296812)
		(8343811888543852523216773185009428259187948644369498021763210776677854991854533186365944349987509452133156416880596803846631577352387751880552969116768071 1197175832754339660404549606408619548226315875117 1433467472198821951822151391684734233265646022897503720591270330985699984763922266163182803556189497900262038518780931942996381297743579119123094520048965 4645213122572190617807944614677917601101008235397095646475699959851618402406173485853587185431290863173614335452934961425661774118334228449202337038283799))
!

testKeySet768
	"Answer a pair of keys for testing. The first key is the private key, the second one is the public key."
	"WARNING: This test key set is public should be used only for testing!! In a real application, 
	the user would create a set of keys using generateKeySet and would keep the private key secret."

	^ #(#(1082138836425255953211995230324521348389130355452262780466266522058989688414890641671224471666756742728738102128639306928997540876269576810456413268321578326117274408283556924423723530115207151293199899103401190855163217664179499529 1182435541330805048477792778798697086534217783301 1020195516071593088210469195023335054920770421248508529231657236455003943954059636619803570908494960338021372974483001717345624780347253724201018342081753239637372345085102145578266171850102257452076391274921044148038150005362326055 1346011898932192008877394314479800394935831791792) #(1082138836425255953211995230324521348389130355452262780466266522058989688414890641671224471666756742728738102128639306928997540876269576810456413268321578326117274408283556924423723530115207151293199899103401190855163217664179499529 1182435541330805048477792778798697086534217783301 1020195516071593088210469195023335054920770421248508529231657236455003943954059636619803570908494960338021372974483001717345624780347253724201018342081753239637372345085102145578266171850102257452076391274921044148038150005362326055 490414973875541729824497223270631982125597880443260523281675239538997047116392418745266198434772423144512675115525520759466894832285952738656595303978028204230335735619216959227192779262383858277312305393568408859560424180365453578))
!

verify: signatureString isSignatureOf: aStringOrStream publicKey: publicKey
	"Answer true if the given signature string signs the given message (a stream or string).

	Note: Random numbers are not needed for signature verification; thus, there is no need
	call initRandomFromUser before verifying a signature."

	| dsa hasher h sig |
	dsa := self new.
	hasher := SecureHashAlgorithm new.

	(aStringOrStream class isBytes)
		ifTrue: [h := hasher hashMessage: aStringOrStream]
		ifFalse: [h := hasher hashStream: aStringOrStream].
	sig := dsa stringToSignature: signatureString.

	^ dsa verifySignature: sig ofMessageHash: h publicKey: publicKey
! !
!DigitalSignatureAlgorithm class categoriesFor: #example!examples!private! !
!DigitalSignatureAlgorithm class categoriesFor: #generateFullKeySet!key generation!operations!public! !
!DigitalSignatureAlgorithm class categoriesFor: #generateKeyGroup!key generation!operations!public! !
!DigitalSignatureAlgorithm class categoriesFor: #generateKeySetForGroup:!key generation!operations!public! !
!DigitalSignatureAlgorithm class categoriesFor: #initialize!initializing!private! !
!DigitalSignatureAlgorithm class categoriesFor: #sign:privateKey:!operations!public!signing! !
!DigitalSignatureAlgorithm class categoriesFor: #testKeySet512!accessing!examples!public! !
!DigitalSignatureAlgorithm class categoriesFor: #testKeySet768!accessing!examples!public! !
!DigitalSignatureAlgorithm class categoriesFor: #verify:isSignatureOf:publicKey:!operations!public!signing! !

