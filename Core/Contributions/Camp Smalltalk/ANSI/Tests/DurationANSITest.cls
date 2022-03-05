"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #DurationANSITest
	instanceVariableNames: 'off0123 smallInt2 largeNegInt2000000000 largePosInt2000000000 float2 fractionHalf numList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DurationANSITest guid: (GUID fromString: '{b2811169-0d04-48a4-acc8-2985adaf7547}')!
DurationANSITest comment: ''!
!DurationANSITest categoriesForClass!Unclassified! !
!DurationANSITest methodsFor!

canonicalObject
	^Duration seconds: 500000000!

protocol
	^#'Duration'!

setUp
	super setUp.
	off0123 := Duration days: 0 hours: 1 minutes: 2 seconds: 3.
	smallInt2 := 2.
	largeNegInt2000000000 := -2000000000.
	largePosInt2000000000 := 2000000000.
	float2 := 2.0d0.
	fractionHalf := 1/2.
	numList := Array new: 5.
	numList at: 1 put: smallInt2.
	numList at: 2 put: largeNegInt2000000000.
	numList at: 3 put: largePosInt2000000000.
	numList at: 4 put: float2.
	numList at: 5 put: fractionHalf.!

testXabs
	" <Duration>#abs "
	| absDuration rcvr |
	#'Date and Time'.
	absDuration := Duration days: 0 hours: 1 minutes: 2 seconds: 3.

	self value: [off0123 abs] should: [:r | r = absDuration]
		conformTo: #'Duration' selector: #'abs' opRECEIVER: off0123.

	rcvr := Duration days: 0 hours: -1 minutes: -2 seconds: -3.

	self value: [rcvr abs] should: [:r | r = absDuration]
		conformTo: #'Duration' selector: #'abs' opRECEIVER: rcvr.!

testXaddOp
	" <Duration>#+ "
	#'Date and Time'.
	self value: [off0123 + (Duration days: 1 hours: 1 minutes: 1 seconds: 1)]
		should: [:r | r = (Duration days: 1 hours: 2 minutes: 3 seconds: 4)]
		conformTo: #'Duration' selector: #'+'!

testXasSeconds
	" <Duration>#asSeconds "
	#'Date and Time'.
	self value: [off0123 asSeconds] should: [:r | r = 3723]
		conformTo: #'Duration' selector: #'asSeconds'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Date and Time'.!

testXdays
	" <Duration>#days "
	#'Date and Time'.
	self value: [off0123 days] should: [:r | r = 0]
		conformTo: #'Duration' selector: #'days'.
	self value: [(Duration days: 9 hours: 0 minutes: 2 seconds: 0) days]
		should: [:r | r = 9]
		conformTo: #'Duration' selector: #'days'.

	self value: [(Duration days: -9 hours: -1 minutes: -2 seconds: -3) days]
		should: [:r | r = -9]
		conformTo: #'Duration' selector: #'days'.!

testXdivideOp
	" <Duration>#/ "
	| retVals |
	#'Date and Time'.
	retVals := Array new: 5.
	"If operand is a <number> answer a new <Duration>."
	"#( 2 -2000000000 2000000000 2.0 1/2 )"
	retVals at: 1 put: (Duration days: 0 hours: 0 minutes: 31 seconds: 1.5).
	retVals at: 2 put: (Duration days: -0 hours: 0
								minutes: 0 seconds: -3723/2000000000).
	retVals at: 3 put: (Duration days: 0 hours: 0
								minutes: 0 seconds: 3723/2000000000).
	retVals at: 4 put: (Duration days: 0 hours: 0 minutes: 31 seconds: 1.5).
	retVals at: 5 put: (Duration days: 0 hours: 2 minutes: 4 seconds: 6).
	
#'testAnom'. "??? <Object> float = test give false for  -0:00:00:01.8615e-6
	1 to: numList size do: [ :ndx |
		self value: [off0123 / (numList at: ndx)]
			should: [:r | (r isKindOf: Duration)
						and: [r = (retVals at: ndx)] ]
			conformTo: #'Duration' selector: #'/'
	].
???"
	"If operand is a <Duration> answer a <number>."
	"#( 2 -2000000000 2000000000 2.0 1/2 )"
	retVals at: 1 put: (3723/2).
	retVals at: 2 put: (-3723/2000000000).
	retVals at: 3 put: (3723/2000000000).
	retVals at: 4 put: 1861.5.
	retVals at: 5 put: 7446.0.
	1 to: numList size do: [ :ndx |
		self value: [off0123 / (Duration seconds: (numList at: ndx))]
			should: [:r | (r isKindOf: Number)
						and: [r = (retVals at: ndx)] ]
			conformTo: #'Duration' selector: #'/'
	].
	self value: [off0123 / 0] shouldRaise: ZeroDivide.
	self value: [off0123 / (Duration zero)] shouldRaise: ZeroDivide.!

testXequalityOp
	" <Duration>#= "
	| tmpDuration |
	#'Date and Time'.
	tmpDuration := (Duration days: 0 hours: 1 minutes: 2 seconds: 3).
	self value: [off0123 = tmpDuration] should: [:r | r]
		conformTo: #'Duration' selector: #'='.
	self should: [off0123 hash = tmpDuration hash].
	tmpDuration := (Duration days: 1 hours: 1 minutes: 1 seconds: 1).
	self value: [off0123 = tmpDuration] shouldnt: [:r | r]
		conformTo: #'Duration' selector: #'='.
	self shouldnt: [off0123 hash = tmpDuration hash].!

testXgreaterThanOp
	" <Duration>#> "
	#'Date and Time'.
	self value: [(Duration days: 1 hours: 1 minutes: 1 seconds: 1)
				> off0123]
		should: [:r | r]
		conformTo: #'Duration' selector: #'>'.
	self value: [(Duration days: 0 hours: 1 minutes: 2 seconds: 3)
				> off0123]
		shouldnt: [:r | r]
		conformTo: #'Duration' selector: #'>'.
	self value: [off0123 > 0] shouldRaise: Error.!

testXgreaterThanOrEqualToOp
	" <magnitude>#>= "
	#'Date and Time'.!

testXhours
	" <Duration>#hours "
	#'Date and Time'.
	self value: [off0123 hours] should: [:r | r = 1]
		conformTo: #'Duration' selector: #'hours'.
	self value: [(Duration days: 9 hours: 0 minutes: 2 seconds: 0) hours]
		should: [:r | r = 0]
		conformTo: #'Duration' selector: #'hours'.
	self value: [(Duration days: -9 hours: -1 minutes: -2 seconds: -3) hours]
		should: [:r | r = -1]
		conformTo: #'Duration' selector: #'hours'.!

testXlessThanOp
	" <Duration>#< "
	#'Date and Time'.
	self value: [off0123
				< (Duration days: 1 hours: 1 minutes: 1 seconds: 1)]
		should: [:r | r]
		conformTo: #'Duration' selector: #'<'.

	self value: [off0123
				< (Duration days: 0 hours: 1 minutes: 2 seconds: 3)]
		shouldnt: [:r | r]
		conformTo: #'Duration' selector: #'<'.
	self value: [off0123 < 0] shouldRaise: Error.!

testXlessThanOrEqualToOp
	" <magnitude>#<= "
	#'Date and Time'.!

testXmaxX
	" <magnitude>#max: "
	#'Date and Time'.!

testXminutes
	" <Duration>#minutes "
	#'Date and Time'.
	self value: [off0123 minutes] should: [:r | r = 2]
		conformTo: #'Duration' selector: #'minutes'.
	self value: [(Duration days: 9 hours: 0 minutes: 0 seconds: 0) minutes]
		should: [:r | r = 0]
		conformTo: #'Duration' selector: #'minutes'.
	self value: [(Duration days: -9 hours: -1 minutes: -2 seconds: -3) minutes]
		should: [:r | r = -2]
		conformTo: #'Duration' selector: #'minutes'.!

testXminX
	" <magnitude>#min: "
	#'Date and Time'.!

testXmultiplyOp
	" <Duration>#* "
	| retVals |
	#'Date and Time'.
	retVals := Array new: 5.		"#( 2 -2000000000 2000000000 2.0 1/2 )"
	retVals at: 1 put: (Duration days: 0 hours: 2 minutes: 4 seconds: 6).
	retVals at: 2 put: (Duration days: -86180555 hours: -13
								minutes: -20 seconds: 0).
	retVals at: 3 put: (Duration days: 86180555 hours: 13
								minutes:  20 seconds: 0).
	retVals at: 4 put: (Duration days: 0 hours: 2 minutes: 4 seconds: 6).
	retVals at: 5 put: (Duration days: 0 hours: 0 minutes: 31 seconds: 1.5).
	
	1 to: numList size do: [ :ndx |
		self value: [off0123 * (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'Duration' selector: #'*'
	].!

testXnegated
	" <Duration>#negated "
	| negatedDuration rcvr |
	#'Date and Time'.
	negatedDuration := Duration days: 0 hours: -1 minutes: -2 seconds: -3.

	self value: [off0123 negated] should: [:r | r = negatedDuration]
		conformTo: #'Duration' selector: #'negated' opRECEIVER: off0123.

	self value: [negatedDuration negated] should: [:r | r = off0123]
		conformTo: #'Duration' selector: #'negated'
		opRECEIVER: negatedDuration.

	rcvr := Duration zero.

	self value: [rcvr negated] should: [:r | r = (Duration zero)]
		conformTo: #'Duration' selector: #'negated' opRECEIVER: rcvr.!

testXnegative
	" <Duration>#negative "
	#'Date and Time'.
	self value: [off0123 negative] shouldnt: [:r | r]
		conformTo: #'Duration' selector: #'negative'.
	self value: [(Duration days: 0 hours: -1 minutes: -2 seconds: -3) negative]
		should: [:r | r]
		conformTo: #'Duration' selector: #'negative'.
	self value: [(Duration zero) negative] shouldnt: [:r | r]
		conformTo: #'Duration' selector: #'negative'.!

testXpositive
	" <Duration>#positive "
	#'Date and Time'.
	self value: [off0123 positive] should: [:r | r]
		conformTo: #'Duration' selector: #'positive'.
	self value: [(Duration days: 0 hours: -1 minutes: -2 seconds: -3) positive]
		shouldnt: [:r | r]
		conformTo: #'Duration' selector: #'positive'.
	self value: [(Duration zero) positive] should: [:r | r]
		conformTo: #'Duration' selector: #'positive'.!

testXprintString
	" <Duration>#printString "
	#'Date and Time'.
	self value: [off0123 printString] should: [:r | r = '0:01:02:03']
		conformTo: #'Duration' selector: #'printString'.
	self value: [(Duration days: 0 hours: -1 minutes: -2 seconds: -3.5) printString]
		should: [:r | r = '-0:01:02:03.5']
		conformTo: #'Duration' selector: #'printString'.
	self value: [(Duration zero) printString] should: [:r | r = '0:00:00:00']
		conformTo: #'Duration' selector: #'printString'.!

testXseconds
	" <Duration>#seconds "
	#'Date and Time'.
	self value: [off0123 seconds] should: [:r | r = 3]
		conformTo: #'Duration' selector: #'seconds'.
	self value: [(Duration days: 9 hours: 0 minutes: 0 seconds: 0) seconds]
		should: [:r | r = 0]
		conformTo: #'Duration' selector: #'seconds'.
	self value: [(Duration days: -9 hours: -1 minutes: -2 seconds: -3.5) seconds]
		should: [:r | r = -3.5]
		conformTo: #'Duration' selector: #'seconds'.!

testXsubtractOp
	" <Duration>#- "
	#'Date and Time'.
	self value: [off0123 - (Duration days: 1 hours: 1 minutes: 1 seconds: 1)]
		should: [:r | r = (Duration days:-0 hours:-23 minutes:-58 seconds:-58)]
		conformTo: #'Duration' selector: #'-'! !
!DurationANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
testXabs!public! !
testXaddOp!public! !
testXasSeconds!public! !
testXbetweenXandX!public! !
testXdays!public! !
testXdivideOp!public! !
testXequalityOp!public! !
testXgreaterThanOp!public! !
testXgreaterThanOrEqualToOp!public! !
testXhours!public! !
testXlessThanOp!public! !
testXlessThanOrEqualToOp!public! !
testXmaxX!public! !
testXminutes!public! !
testXminX!public! !
testXmultiplyOp!public! !
testXnegated!public! !
testXnegative!public! !
testXpositive!public! !
testXprintString!public! !
testXseconds!public! !
testXsubtractOp!public! !
!

