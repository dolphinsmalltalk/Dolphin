"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ScaledDecimalANSITest
	instanceVariableNames: 'smallInt2 largeNegInt2000000000 largePosInt2000000000 float2 fractionHalf sclDec2s3 numList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScaledDecimalANSITest guid: (GUID fromString: '{5200c2d1-95c6-4600-9409-435dcb726b43}')!

ScaledDecimalANSITest comment: ''!

!ScaledDecimalANSITest categoriesForClass!Unclassified! !

!ScaledDecimalANSITest methodsFor!

canonicalObject
	^sclDec2s3!

protocol
	^#'scaledDecimal'!

setUp
	super setUp.
	smallInt2 := 2.
	largeNegInt2000000000 := -2000000000.
	largePosInt2000000000 := 2000000000.
	float2 := 2.0d0.
	fractionHalf := 1/2.
	sclDec2s3 := 2.0s3.
	numList := Array new: 6.
	numList at: 1 put: smallInt2.
	numList at: 2 put: largeNegInt2000000000.
	numList at: 3 put: largePosInt2000000000.
	numList at: 4 put: float2.
	numList at: 5 put: fractionHalf.
	numList at: 6 put: sclDec2s3.!

testLiterals
	#'Numeric'.
	self should: [123s = 123s0].
	self should: [123s = 123s0].
	self should: [123s0 = 123s0].

	self should: [123.0s = 123.0s1].
	self should: [123s1 = 123.0s1].
	self should: [123.0s1 = 123.0s1].

	self should: [123.000s = 123.000s3].
	self should: [123s3 = 123.000s3].
	self should: [123.0s3 = 123.000s3].
	self should: [123.00s3 = 123.000s3].
	self should: [123.000s3 = 123.000s3].!

testXabs
	" <number>#abs (Return Values: <RECEIVER>) "
	| rcvr |
	#'Numeric'.
	rcvr := 2.0s3.
	self value: [rcvr abs] should: [:r | r = 2.0s3]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := 2.0s3.
	self value: [rcvr abs] should: [:r | r = 2.0s3]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := 0.0s3.
	self value: [rcvr abs] should: [:r | r = 0s3]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.!

testXasFloat
	" <number>#asFloat "
	#'Numeric'.
	self value: [2.0s3 asFloat] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [-2.0s3 asFloat] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [0.0s3 asFloat] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloat'.!

testXasFloatD
	" <number>#asFloatD "
	#'Numeric'.
	self value: [2.0s3 asFloatD] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [-2.0s3 asFloatD] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [0.0s3 asFloatD] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatD'.!

testXasFloatE
	" <number>#asFloatE "
	#'Numeric'.
	self value: [2.0s3 asFloatE] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [-2.0s3 asFloatE] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [0.0s3 asFloatE] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatE'.!

testXasFloatQ
	" <number>#asFloatQ "
	#'Numeric'.
	self value: [2.0s3 asFloatQ] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [-2.0s3 asFloatQ] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [0.0s3 asFloatQ] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatQ'.!

testXasFraction
	"2000/06/23 Harmon, R. Changed to fix illegal fixed point literals."

	self value: [2.0s3 asFraction] should: [:r | r = 2]
		conformTo: #'number' selector: #'asFraction'.
	self value: [-2.5s3 asFraction] should: [:r | r = (-5/2)]
		conformTo: #'number' selector: #'asFraction'.
	self value: [0.0s3 asFraction] should: [:r | r = 0]
		conformTo: #'number' selector: #'asFraction'.

	"Scale less than required to represent value:"
	self value: [0.25s2 asFraction] should: [:r | r = (1/4)]
		conformTo: #'number' selector: #'asFraction'.!

testXasInteger
	" <number>#asInteger "
	#'Numeric'.
	self value: [2.0s3 asInteger] should: [:r | r = 2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [2.1s3 asInteger] should: [:r | r = 2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [2.5s3 asInteger] should: [:r | r = 3]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2.0s3 asInteger] should: [:r | r = -2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2.1s3 asInteger] should: [:r | r = -2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2.5s3 asInteger] should: [:r | r = -3]
		conformTo: #'number' selector: #'asInteger'.
	self value: [0.0s3 asInteger] should: [:r | r = 0]
		conformTo: #'number' selector: #'asInteger'.!

testXasScaledDecimalX
	"2000/06/23 Harmon, R. Changed to fix illegal fixed point literals."

	self value: [2.0s3 asScaledDecimal: 3]
		should: [:r | r = 2.0s3 & (r scale = 3)]
		conformTo: #'number' selector: #'asScaledDecimal:'.
	self value: [-2.0s3 asScaledDecimal: 2]
		should: [:r | r = -2.0s2 & (r scale = 2)]
		conformTo: #'number' selector: #'asScaledDecimal:'.
	self value: [0.0s3 asScaledDecimal: 0]
		should: [:r | r = 0.0s1 & (r scale = 0)]
		conformTo: #'number' selector: #'asScaledDecimal:'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver  and min or max are not comparable"

	self value: [2.0s3 between: 1 and: 3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [-2000000002.0s3 between: -2000000003 and: -2000000001]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2000000002.0s3 between: 2000000001 and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0s3 between: 1.0 and: 3.0]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0s3 between: (3/2) and: (5/2)]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0s3 between: 1.0s3 and: 3.0s3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	self value: [2.0s3 between: (3/2) and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0s3 between: -2000000001 and: 3.0]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"Num between: Num and: Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx)
					between: (numList at: ndx)
					and: (numList at: ndx)]
			should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'
	].

	self value: [2.0s3 between: 3 and: 4]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [-2000000000.0s3 between: -2000000003 and: -2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2000000000.0s3 between: 2000000003 and: 2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0s3 between: 3.0 and: 5.0]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0s3 between: (5/2) and: (7/2)]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0s3 between: 3.0s3 and: 5.0s3]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"??? min not min but max and vice versa -> false ???"
	self value: [2.0s3 between: 3 and: 1]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.!

testXceiling
	" <number>#ceiling "
	#'Numeric'.
	self value: [2.0s3 ceiling] should: [:r | r = 2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [2.1s3 ceiling] should: [:r | r = 3]
		conformTo: #'number' selector: #'ceiling'.
	self value: [2.5s3 ceiling] should: [:r | r = 3]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2.0s3 ceiling] should: [:r | r = -2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2.1s3 ceiling] should: [:r | r = -2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2.5s3 ceiling] should: [:r | r = -2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [0.0s3 ceiling] should: [:r | r = 0]
		conformTo: #'number' selector: #'ceiling'.!

testXcopy
	" <Object>#copy (Return Values: <RECEIVER>) "
	#'Numeric'.
"	Return a new object that must be as similar as possible to the receiver in its initial state and behavior.  Any operation that changes the state of the new object should not as a side-effect change the state or behavior of the receiver.  Similarly, any change to the receiver should not as a side-effect change the new object.
	If the receiver is an identity object, return the receiver.
"
#todo. "??? add change-side-effect test ???"
	self value: [sclDec2s3 copy] should: [:r | (r = sclDec2s3) ]
		conformTo: #'Object' selector: #'copy' opRECEIVER: sclDec2s3.!

testXequalityOp
	" <number>#= "
	#'Numeric'.
"
	receiver = comparand	=>
	receiver hash = comparand hash
"
	self value: [sclDec2s3 = sclDec2s3]
		should: [:r | r & (sclDec2s3 hash = sclDec2s3 hash) ]
		conformTo: #'number' selector: #'='.
	self should: [5.1s2 = 5.1s1 & (5.1s2 hash = 5.1s1 hash)].
	self value: [ sclDec2s3 = 2.1s3 ]
		shouldnt: [ :r | r | (sclDec2s3 hash = 2.1s3 hash) ]
		conformTo: #'number' selector: #'='.

"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	self value: [ sclDec2s3 = 2 ]
		should: [ :r | r  ifTrue: [ sclDec2s3 hash = 2 hash ]
							ifFalse: [ sclDec2s3 hash ~= 2 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ -2000000000.0s3 = -2000000000 ]
		should: [ :r | r ifTrue: [ -2000000000.0s3 hash = -2000000000 hash ]
						ifFalse: [ -2000000000.0s3 hash ~= -2000000000 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ 2000000000.0s3 = 2000000000 ]
		should: [ :r | r ifTrue: [ 2000000000.0s3 hash = 2000000000 hash ]
						ifFalse: [ 2000000000.0s3 hash ~= 2000000000 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ sclDec2s3 = 2.0 ]
		should: [ :r | r ifTrue: [ sclDec2s3 hash = 2.0 hash ]
						ifFalse: [ sclDec2s3 hash ~= 2.0 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ 2.5s3 = (5/2) ]
		should: [ :r | r ifTrue: [ 2.5s3 hash = (5/2) hash ]
						ifFalse: [ 2.5s3 hash ~= (5/2) hash ]  ]
		conformTo: #'number' selector: #'='.!

testXfloor
	" <number>#floor "
	#'Numeric'.
	self value: [2.0s3 floor] should: [:r | r = 2]
		conformTo: #'number' selector: #'floor'.
	self value: [2.1s3 floor] should: [:r | r = 2]
		conformTo: #'number' selector: #'floor'.
	self value: [2.5s3 floor] should: [:r | r = 2]
		conformTo: #'number' selector: #'floor'.
	self value: [-2.0s3 floor] should: [:r | r = -2]
		conformTo: #'number' selector: #'floor'.
	self value: [-2.1s3 floor] should: [:r | r = -3]
		conformTo: #'number' selector: #'floor'.
	self value: [-2.5s3 floor] should: [:r | r = -3]
		conformTo: #'number' selector: #'floor'.
	self value: [0.0s3 floor] should: [:r | r = 0]
		conformTo: #'number' selector: #'floor'.!

testXfractionPart
	" <number>#fractionPart (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	"Within the limits of representation, the following invariants should hold:

		receiver integerPart + receiver fractionPart = receiver
		receiver \\1 = receiver fractionPart	(RAH - erroneous, add #'abs')
"
	rcvr := 26.5s3.
	self value: [rcvr fractionPart]
		should: [:r | r = 0.5s3 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := -26.5s3.
	self value: [rcvr fractionPart]
		should: [:r | r = -0.5s3 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := 0.0s3.
	self value: [rcvr fractionPart]
		should: [:r | r = 0s3 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := 0.0s3.
	self value: [rcvr fractionPart]
		should: [:r | r = 0s3 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.!

testXgreaterThanOp
	" <number>#> "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	self value: [5.1s1 > 5.1s2] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [-5.1s1 > -5.2s2] should: [:r | r]
		conformTo: #'number' selector: #'>'.

	"Small > Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3s3 > tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [-2000000005.0s3 > -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [0.25s3 > (1/2)] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.

	"Num > Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) > (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'>'
	].

	"Big > Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0s3 > tstNum] should: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [9000000000s3 > 2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [-1000000005.0s3 > -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [9.0s3 > (1/2)] should: [:r | r] conformTo: #'number' selector: #'>'.!

testXgreaterThanOrEqualToOp
	" <magnitude>#>= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	self value: [5.1s1 >= 5.1s2] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [-5.1s1 >= -5.9s2] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.

	"Small >= Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3s3 >= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [-2000000005.0s3 >= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [0.25s3 >= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.

	"Num >= Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) >= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'>='
	].

	"Big >= Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0s3 >= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [9000000000s3 >= 2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [-1000000005.0s3 >= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [9.0s3 >= (1/2)] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.!

testXintegerDivideOp
	" <number>#// "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	"The sign of the result is positive if the receiver and operand
		have the same sign, and negative if the signs are different."
	retVals := #(1 -1 0 1 4 1).
	1 to: numList size do: [ :ndx |
		self value: [sclDec2s3 // (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'.
	].

	retVals := #(-1 0 -1 -1 -4 -1).
	1 to: numList size do: [ :ndx |
		self value: [sclDec2s3 // ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'
	].

	self should: [25.5s3 // 5.1s3 = 5].
	self should: [25.5s3 // 5 = 5].
	self should: [25500000000.5s3 // 5000000000 = 5].
	self should: [-25500000000.5s3 // -5000000000 = 5].
	self should: [25.5s3 // (51/10) = 5].
	self should: [25.5s3 // 5.1 = 5].

	self value: [0s // sclDec2s3] should: [:r | r = 0s]
		conformTo: #'number' selector: #'//'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [sclDec2s3 // 0s] shouldRaise: ZeroDivide.!

testXintegerPart
	" <number>#integerPart (returnRule - :receiver) "
	| rcvr |
	#'Numeric'.
	rcvr := 2.5s3.
	self value: [rcvr integerPart] should: [:result | result = 2.0s3]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := 2.0s3.
	self value: [rcvr integerPart] should: [:r | r = 2.0s3]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := -2.0s3.
	self value: [rcvr integerPart] should: [:result | result = -2.0s3]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := 0.0s3.
	self value: [rcvr integerPart] should: [:result | result = 0s3]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.!

testXlessThanOp
	" <number>#< "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver and operand are not comparable."
	self value: [5.1s1 < 5.1s2] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.

	"Small < Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3s3 < tstNum] should: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [-2000000005.0s3 < -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [0.25s3 < (1/2)] should: [:r | r]
		conformTo: #'number' selector: #'<'.

	"Num < Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) < (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'<'
	].

	"Big < Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0s3 < tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [9000000000s3 < 2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [-1000000005.0s3 < -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [9.0s3 < (1/2)] shouldnt: [:r | r] conformTo: #'number' selector: #'<'.!

testXlessThanOrEqualToOp
	" <magnitude>#<= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	self value: [5.1s1 <= 5.1s2] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.

	"Small <= Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3s3 <= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [-2000000005.0s3 <= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [0.25s3 <= (1/2)] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.

	"Num <= Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) <= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'<='
	].

	"Big <= Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0s3 <= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [9000000000s3 <= 2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [-1000000005.0s3 <= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [9.0s3 <= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.!

testXmaxX
	" <magnitude>#max: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver and operand are not comparable."

	self value: [2.0s3 max: 3] should: [:r | r = 3]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [-3000000000.0s3 max: -2000000000]
		should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2000000000.0s3 max: 2000000003]
		should: [:r | r = 2000000003]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2.0s3 max: 3.0] should: [:r | r = 3.0]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2.0s3 max: (5/2)] should: [:r | r = (5/2)]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2.0s3 max: 3.0s3] should: [:r | r = 3.0s3]
		conformTo: #'magnitude' selector: #'max:'.

	"Num max: Num -> Num"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) max: (numList at: ndx)]
			should: [:r | r = (numList at: ndx)]
			conformTo: #'magnitude' selector: #'max:'
	].!

testXminX
	" <magnitude>#min: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver and operand are not comparable."

	self value: [2.0s3 min: 1] should: [:r | r = 1]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [-1000000000.0s3 min: -2000000000]
		should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2000000003.0s3 min: 2000000001]
		should: [:r | r = 2000000001]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2.0s3 min: 1.0] should: [:r | r = 1.0]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2.0s3 min: (3/2)] should: [:r | r = (3/2)]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2.0s3 min: 1.0s5] should: [:r | r = 1.0s5]
		conformTo: #'magnitude' selector: #'min:'.

	"Num min: Num -> Num"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) min: (numList at: ndx)]
			should: [:r | r = (numList at: ndx)]
			conformTo: #'magnitude' selector: #'min:'
	].!

testXnegated
	" <number>#negated (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 2.0s3.
	self value: [rcvr negated] should: [:r | r = -2.0s3]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.

	rcvr := -2.0s3.
	self value: [rcvr negated] should: [:r | r = 2.0s3]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.

	rcvr := 0.0s3.
	self value: [rcvr negated] should: [:r | r = 0s3]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.!

testXnegative
	" <number>#negative "
	#'Numeric'.
	self value: [-2.0s3 negative] should: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [2.0s3 negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [0.0s3 negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.!

testXpositive
	" <number>#positive "
	#'Numeric'.
	self value: [2.0s3 positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [0.0s3 positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [-2.0s3 positive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'positive'.!

testXquoX
	" <number>#quo: "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #( 1 0 0 1 4 1 ).
	1 to: numList size do: [ :ndx |
		self value: [sclDec2s3 quo: (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'.
	].

	retVals := #( -1 0 0 -1 -4 -1 ).
	1 to: numList size do: [ :ndx |
		self value: [sclDec2s3 quo: ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'
	].

	self should: [(25.5s3 quo: 5.1s3) = 5].
	self should: [(25.5s3 quo: 5) = 5].
	self should: [(25500000000.5s3 quo: 5000000000) = 5].
	self should: [(-25500000000.5s3 quo: -5000000000) = 5].
	self should: [(25.5s3 quo: (51/10)) = 5].
	self should: [(25.5s3 quo: 5.1) = 5].

	self value: [0s quo: sclDec2s3] should: [:r | r = 0s]
		conformTo: #'number' selector: #'quo:'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [sclDec2s3 quo: 0s] shouldRaise: ZeroDivide.!

testXraisedToX
	" <number>#raisedTo: "
	| numVals retVals |
	#'Numeric'.
	numVals := #(2 2.0 0 2.0s3 ) copy.
	numVals at: 3 put: (1/2).
	retVals := #(4.000s3 4.0 1.414213562373095 4.0 ) copy.
	1 to: numVals size do: [ :ndx |
		self value: [sclDec2s3 raisedTo: (numVals at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'raisedTo:'.
	].

	retVals := #(0.250s3 0.25 0.7071067811865475 0.25 ) copy.
	1 to: numVals size do: [ :ndx |
		self value: [sclDec2s3 raisedTo: ((numVals at: ndx) negated)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'raisedTo:'
	].

	self value: [sclDec2s3 raisedTo: 0.0s2] should: [:r | r = 1.0s2]
		conformTo: #'number' selector: #'raisedTo:'.

	self value: [0.0s2 raisedTo: sclDec2s3] should: [:r | r = 0.0s2]
		conformTo: #'number' selector: #'raisedTo:'.

	self value: [sclDec2s3 raisedTo: 1.0s2] should: [:r | r = sclDec2s3]
		conformTo: #'number' selector: #'raisedTo:'.

	"It is erroneous if the receiver equals zero
		and the operand is less than or equal to zero,"
	self value: [0.0s2 raisedTo: -2.0s2] shouldRaise: Error.

	"	or if the receiver is less than zero."
	self value: [sclDec2s3 negated raisedTo: 2.0s2]
		shouldRaise: Error.!

testXreciprocal
	" <number>#reciprocal (returnRule - :receiver) "
	#'Numeric'.
	self value: [sclDec2s3 reciprocal] should: [:r | r = (1.0s2/sclDec2s3)]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: sclDec2s3.

	self value: [sclDec2s3 negated reciprocal]
		should: [:r | r = (1.0s2/(sclDec2s3 negated))]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: (sclDec2s3 negated).

	"Signal a ZeroDivide exception if the receiver is equal to zero."
	self value: [0.0s2 reciprocal] shouldRaise: ZeroDivide.!

testXremX
	" <number>#rem: "
	| num2 sd retVals ndx |
	#'Numeric'.
	"Within the limits of representation, the following invariant should hold:
		(receiver quo: operand)*operand + (receiver rem: operand) = receiver"
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	sd := 26.5s03.
	numList := #( 5 5.0 5.0s3 ).
	retVals := #( 1.500s3 1.5 1.500s3 ).
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self value: [sd rem: num]
			should: [ :r | r = (retVals at: ndx)
					& ((sd quo: num) * num + (sd rem: num) = sd)]
			conformTo: #'number' selector: #'rem:'
	].

	numList := numList collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self value: [sd rem: num]
			should: [ :r | r = (retVals at: ndx)
					& ((sd quo: num) * num + (sd rem: num) = sd)]
			conformTo: #'number' selector: #'rem:'
	].

	sd := -26.5s3.
	numList := #( 5 5.0 5.0s3 ).
	retVals := retVals collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self should: [(sd rem: num) = (retVals at: ndx)
				& ((sd quo: num) * num + (sd rem: num) = sd)]
	].

	numList := numList collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self should: [(sd rem: num) = (retVals at: ndx)
					& ((sd quo: num) * num + (sd rem: num) = sd)]
	].

	sd := 26.5s3.
	num2 := (5/2).
	self value: [sd rem: num2]
		should: [:r | r = 1.5s3
				& ((sd quo: num2) * num2 + (sd rem: num2) = sd)]
		conformTo: #'number' selector: #'rem:'.

	numList := #( -2000000000 2000000000 ).
	sd :=  10000000001.5s3.
	numList do: [ :num |
		self value: [sd rem: num]
			should: [:r | r = 1.5s3
					& ((sd quo: num) * num + (sd rem: num) = sd)]
			conformTo: #'number' selector: #'rem:'
	].

	"If either the receiver or operand are of type <Float> and the operand has a value of zero, the result is implementation defined.  The implementation may signal the ZeroDivide exception or provide a continuation value "
	self value: [sclDec2s3 rem: 0.0] shouldRaise: ZeroDivide.
	self value: [sclDec2s3 rem: 0] shouldRaise: ZeroDivide.
	self value: [sclDec2s3 rem: 0.0s3] shouldRaise: ZeroDivide.!

testXrounded
	" <number>#rounded "
	#'Numeric'.
	self value: [2.0s3 rounded] should: [:r | r = 2]
		conformTo: #'number' selector: #'rounded'.
	self value: [2.1s3 rounded] should: [:r | r = 2]
		conformTo: #'number' selector: #'rounded'.
	self value: [2.5s3 rounded] should: [:r | r = 3]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2.0s3 rounded] should: [:r | r = -2]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2.1s3 rounded] should: [:r | r = -2]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2.5s3 rounded] should: [:r | r = -3]
		conformTo: #'number' selector: #'rounded'.
	self value: [0.0s3 rounded] should: [:r | r = 0]
		conformTo: #'number' selector: #'rounded'.!

testXscale
	" <scaledDecimal>#scale "
	#'Numeric'.!

testXsign
	" <number>#sign "
	#'Numeric'.
	self value: [2.0s3 sign] should: [:r | r = 1]
		conformTo: #'number' selector: #'sign'.
	self value: [0.0s3 sign] should: [:r | r = 0]
		conformTo: #'number' selector: #'sign'.
	self value: [-2.0s3 sign] should: [:r | r = -1]
		conformTo: #'number' selector: #'sign'.!

testXsqrt
	"2000/06/23 Harmon, R. Changed to fix illegal fixed point literals."

	self value: [26s0 sqrt] should: [:r | r closeTo: 5.099019513592784]
		conformTo: #'number' selector: #'sqrt'.
	self value: [26.0s1 sqrt] should: [:r | r closeTo:  5.099019513592784]
		conformTo: #'number' selector: #'sqrt'.
	self value: [26.01s2 sqrt] should: [:r | r closeTo: 5.1]
		conformTo: #'number' selector: #'sqrt'.
	self value: [26.01s3 sqrt] should: [:r | r closeTo: 5.1]
		conformTo: #'number' selector: #'sqrt'.
	self value: [0.0s3 sqrt] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'sqrt'!

testXsquared
	" <number>#squared (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 5.1s3.
	self value: [rcvr squared] should: [:r | (r = 26.010s3) & (r scale = 3)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

#'todo'."??? Uncommented fails--compiler error?.
	rcvr := -5.1s3.
	self value: [rcvr squared] should: [:r | (r = 26.010s3) & (r scale = 3)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

	rcvr := 5.1s2.
	self value: [rcvr squared] should: [:r | (r = 26.01s2) & (r scale = 2)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

	rcvr := 5.1s1.
	self value: [rcvr squared] should: [:r | (r = 26.0s1) & (r scale = 1)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

	self halt.
	rcvr := 5.1s0.
	self value: [rcvr squared] should: [:r | (r = 26.010s3) & (r scale = 0)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

	rcvr := 0.0s3.
	self value: [rcvr squared] should: [:r | (r = 0.000s3) & (r scale = 3)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.
"!

testXstrictlyPositive
	" <number>#strictlyPositive "
	#'Numeric'.
	self value: [2.0s3 strictlyPositive] should: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.

	self value: [0.0s3 strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.
	self value: [-2.0s3 strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.!

testXtoX
	" <number>#to: "

	| start middleNdx stop2 |
	#Numeric.
	start := 1.0s3.
	numList := #(2 2.0 0 2.0s3) copy.
	numList at: 3 put: 5 / 2.
	numList do: 
			[:stop | 
			self 
				value: [start to: stop]
				should: 
					[:r | 
					r size = 2 & (r last = (start + ((stop - start) // 1))) 
						& (r allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #scaledDecimal])
					". . . the last element in the sequence . . . is . . .[:]
						receiver + ((stop - receiver) // 1)"
					"The elements conform to the receiver's protocol."]
				conformTo: #number
				selector: #to:].
	stop2 := 2000000000s3.
	middleNdx := 1000000000.	"Check conformance of first, middle and last."
	self 
		value: [start to: stop2]
		should: 
			[:r | 
			r size = 2000000000 & (r last = (start + ((stop2 - start) // 1))) 
				& ((Array 
						with: (r at: 1)
						with: (r at: middleNdx)
						with: (r at: 3)) 
							allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #scaledDecimal])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.
	start := -2000000000.0s3.
	stop2 := -1s3.
	middleNdx := 1000000000.	"Check conformance of first, middle and last."
	self 
		value: [start to: stop2]
		should: 
			[:r | 
			r size = 2000000000 & (r last = (start + ((stop2 - start) // 1))) 
				& ((Array 
						with: (r at: 1)
						with: (r at: middleNdx)
						with: (r at: 3)) 
							allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #scaledDecimal])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.

	"The interval answered will be empty if the receiver is greater than stop."
	self 
		value: [1.0s3 to: -1.0s3]
		should: [:r | r isEmpty]
		conformTo: #number
		selector: #to:!

testXtoXbyX
	" <number>#to:by: "
	#'Numeric'.!

testXtoXbyXdoX
	" <number>#to:by:do: "
	#'Numeric'.!

testXtoXdoX
	" <number>#to:do: "
	#'Numeric'.!

testXtruncated
	" <number>#truncated "
	#'Numeric'.
	self value: [2.0s3 truncated] should: [:r | r = 2]
		conformTo: #'number' selector: #'truncated'.
	self value: [2.1s3 truncated] should: [:r | r = 2]
		conformTo: #'number' selector: #'truncated'.
	self value: [2.5s3 truncated] should: [:r | r = 2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2.0s3 truncated] should: [:r | r = -2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2.1s3 truncated] should: [:r | r = -2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2.5s3 truncated] should: [:r | r = -2]
		conformTo: #'number' selector: #'truncated'.
	self value: [0.0s3 truncated] should: [:r | r = 0]
		conformTo: #'number' selector: #'truncated'.! !

!ScaledDecimalANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
testLiterals!public! !
testXabs!public! !
testXasFloat!public! !
testXasFloatD!public! !
testXasFloatE!public! !
testXasFloatQ!public! !
testXasFraction!public! !
testXasInteger!public! !
testXasScaledDecimalX!public! !
testXbetweenXandX!public! !
testXceiling!public! !
testXcopy!public! !
testXequalityOp!public! !
testXfloor!public! !
testXfractionPart!public! !
testXgreaterThanOp!public! !
testXgreaterThanOrEqualToOp!public! !
testXintegerDivideOp!public! !
testXintegerPart!public! !
testXlessThanOp!public! !
testXlessThanOrEqualToOp!public! !
testXmaxX!public! !
testXminX!public! !
testXnegated!public! !
testXnegative!public! !
testXpositive!public! !
testXquoX!public! !
testXraisedToX!public! !
testXreciprocal!public! !
testXremX!public! !
testXrounded!public! !
testXscale!public! !
testXsign!public! !
testXsqrt!public! !
testXsquared!public! !
testXstrictlyPositive!public! !
testXtoX!public! !
testXtoXbyX!public! !
testXtoXbyXdoX!public! !
testXtoXdoX!public! !
testXtruncated!public! !
!

