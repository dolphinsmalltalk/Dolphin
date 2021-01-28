"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Security.DigitalSignatureAlgorithm'
	instanceVariableNames: 'randKey randSeed'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'SmallPrimes' -> #(16r3 16r5 16r7 16rB 16rD 16r11 16r13 16r17 16r1D 16r1F 16r25 16r29 16r2B 16r2F 16r35 16r3B 16r3D 16r43 16r47 16r49 16r4F 16r53 16r59 16r61 16r65 16r67 16r6B 16r6D 16r71 16r7F 16r83 16r89 16r8B 16r95 16r97 16r9D 16rA3 16rA7 16rAD 16rB3 16rB5 16rBF 16rC1 16rC5 16rC7 16rD3 16rDF 16rE3 16rE5 16rE9 16rEF 16rF1 16rFB 16r101 16r107 16r10D 16r10F 16r115 16r119 16r11B 16r125 16r133 16r137 16r139 16r13D 16r14B 16r151 16r15B 16r15D 16r161 16r167 16r16F 16r175 16r17B 16r17F 16r185 16r18D 16r191 16r199 16r1A3 16r1A5 16r1AF 16r1B1 16r1B7 16r1BB 16r1C1 16r1C9 16r1CD 16r1CF 16r1D3 16r1DF 16r1E7 16r1EB 16r1F3 16r1F7 16r1FD 16r209 16r20B 16r21D 16r223 16r22D 16r233 16r239 16r23B 16r241 16r24B 16r251 16r257 16r259 16r25F 16r265 16r269 16r26B 16r277 16r281 16r283 16r287 16r28D 16r293 16r295 16r2A1 16r2A5 16r2AB 16r2B3 16r2BD 16r2C5 16r2CF 16r2D7 16r2DD 16r2E3 16r2E7 16r2EF 16r2F5 16r2F9 16r301 16r305 16r313 16r31D 16r329 16r32B 16r335 16r337 16r33B 16r33D 16r347 16r355 16r359 16r35B 16r35F 16r36D 16r371 16r373 16r377 16r38B 16r38F 16r397 16r3A1 16r3A9 16r3AD 16r3B3 16r3B9 16r3C7 16r3CB 16r3D1 16r3D7 16r3DF 16r3E5 16r3F1 16r3F5 16r3FB 16r3FD 16r407 16r409 16r40F 16r419 16r41B 16r425 16r427 16r42D 16r43F 16r443 16r445 16r449 16r44F 16r455 16r45D 16r463 16r469 16r47F 16r481 16r48B 16r493 16r49D 16r4A3 16r4A9 16r4B1 16r4BD 16r4C1 16r4C7 16r4CD 16r4CF 16r4D5 16r4E1 16r4EB 16r4FD 16r4FF 16r503 16r509 16r50B 16r511 16r515 16r517 16r51B 16r527 16r529 16r52F 16r551 16r557 16r55D 16r565 16r577 16r581 16r58F 16r593 16r595 16r599 16r59F 16r5A7 16r5AB 16r5AD 16r5B3 16r5BF 16r5C9 16r5CB 16r5CF 16r5D1 16r5D5 16r5DB 16r5E7 16r5F3 16r5FB 16r607 16r60D 16r611 16r617 16r61F 16r623 16r62B 16r62F 16r63D 16r641 16r647 16r649 16r64D 16r653 16r655 16r65B 16r665 16r679 16r67F 16r683 16r685 16r69D 16r6A1 16r6A3 16r6AD 16r6B9 16r6BB 16r6C5 16r6CD 16r6D3 16r6D9 16r6DF 16r6F1 16r6F7 16r6FB 16r6FD 16r709 16r713 16r71F 16r727 16r737 16r745 16r74B 16r74F 16r751 16r755 16r757 16r761 16r76D 16r773 16r779 16r78B 16r78D 16r79D 16r79F 16r7B5 16r7BB 16r7C3 16r7C9 16r7CD 16r7CF)
	}!
Security.DigitalSignatureAlgorithm guid: (Core.GUID fromString: '{b1b2a1d8-34b1-4c43-90dc-767320f26e47}')!
Security.DigitalSignatureAlgorithm comment: 'This class implements the Digital Signature Algorithm (DSA) of the U.S. government''s "Digital Signature Standard" (DSS). The DSA algorithm was proposed in 1991 and became a standard in May 1994. The official description is available as a Federal Information Processing Standards Publication (FIPS PUB 186, May 19, 1994). A companion standard, the Secure Hash Standard, or SHS (FIPS PUB 180-1, April 17, 1995), describes a 160-bit message digest algorithm known as the Secure Hash Algorithm (SHA). This message digest is used to compute the document signature.

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
!Security.DigitalSignatureAlgorithm categoriesForClass!Cryptography-Support! !
!Security.DigitalSignatureAlgorithm methodsFor!

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

	| a b p x rs e |
	p := privateKey first.
	x := privateKey fourth.
	a := m at: 1.
	b := m at: 2.
	rs := self
				dsaSign: p
				q: p
				g: a
				k: x
				x: 0
				h: 0.
	e := rs at: 1.
	rs := self
				dsaSign: p
				q: p
				g: 1
				k: e
				x: b
				h: 0.
	^rs at: 2!

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

	| p g x y |
	p := aGroupArray first.
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
	[result = 0] whileTrue: 
			[result := SecureHashAlgorithm new hashInteger: randKey.
			randKey := randKey + result + 1].
	^result!

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
!Security.DigitalSignatureAlgorithm categoriesFor: #computeSignatureForMessageHash:privateKey:!operations!public!signing! !
!Security.DigitalSignatureAlgorithm categoriesFor: #dsaSign:q:g:k:x:h:!operations!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #elgamalDecrypt:privateKey:!operations!public! !
!Security.DigitalSignatureAlgorithm categoriesFor: #elgamalEncrypt:publicKey:!operations!public! !
!Security.DigitalSignatureAlgorithm categoriesFor: #generateFullKeySet!key generation!operations!public! !
!Security.DigitalSignatureAlgorithm categoriesFor: #generateKeyGroup!key generation!operations!public! !
!Security.DigitalSignatureAlgorithm categoriesFor: #generateKeySetForGroup:!key generation!operations!public! !
!Security.DigitalSignatureAlgorithm categoriesFor: #generateQandP!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #generateRandomLength:s:n:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #generateSandQ!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #initRandom:!initializing!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #initRandomFromUser!initializing!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #inverseOf:mod:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #isProbablyPrime:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #keyStrength!accessing!public! !
!Security.DigitalSignatureAlgorithm categoriesFor: #logOfLargestPowerOfTwoDividing:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #nextRandom160!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #raise:to:mod:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #remainder:mod:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #signatureToString:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #stringToSignature:!helpers!private! !
!Security.DigitalSignatureAlgorithm categoriesFor: #verifySignature:ofMessageHash:publicKey:!operations!public!signing! !

!Security.DigitalSignatureAlgorithm class methodsFor!

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
	aStringOrStream class isBytes
		ifTrue: [h := hasher hashMessage: aStringOrStream]
		ifFalse: [h := hasher hashStream: aStringOrStream].
	sig := dsa computeSignatureForMessageHash: h privateKey: privateKey.
	^dsa signatureToString: sig!

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
	aStringOrStream class isBytes
		ifTrue: [h := hasher hashMessage: aStringOrStream]
		ifFalse: [h := hasher hashStream: aStringOrStream].
	sig := dsa stringToSignature: signatureString.
	^dsa
		verifySignature: sig
		ofMessageHash: h
		publicKey: publicKey! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #example!examples!private! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #generateFullKeySet!key generation!operations!public! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #generateKeyGroup!key generation!operations!public! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #generateKeySetForGroup:!key generation!operations!public! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #initialize!initializing!private! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #sign:privateKey:!operations!public!signing! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #testKeySet512!accessing!examples!public! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #testKeySet768!accessing!examples!public! !
!Security.DigitalSignatureAlgorithm class categoriesFor: #verify:isSignatureOf:publicKey:!operations!public!signing! !

