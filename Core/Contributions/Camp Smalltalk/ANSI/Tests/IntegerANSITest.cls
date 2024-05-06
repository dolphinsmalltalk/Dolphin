"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #IntegerANSITest
	instanceVariableNames: 'smallInt2 largeNegInt2000000000 largePosInt2000000000 float2 fractionHalf sclDec2s3 numList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IntegerANSITest guid: (GUID fromString: '{306c76ad-1873-4623-81fb-f94d3d80f1bd}')!

IntegerANSITest comment: ''!

!IntegerANSITest categoriesForClass!Unclassified! !

!IntegerANSITest methodsFor!

canonicalObject
	^47!

protocol
	^#'integer'!

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

testXabs
	" <number>#abs (Return Values: <RECEIVER>) "
	| rcvr |
	#'Numeric'.
	rcvr := 2.
	self value: [rcvr abs] should: [:r | r = 2]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := -2.
	self value: [rcvr abs] should: [:r | r = 2]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := -2000000000.
	self value: [rcvr abs] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := 2000000000.
	self value: [rcvr abs] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := 0.
	self value: [rcvr abs] should: [:r | r = 0]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.!

testXaddOp
	" <number>#+ (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

	retVals := #(4 -1999999998 2000000002 4.0s3 0 4.0) copy.
	retVals at: 5 put: (5/2).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 + (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'+'
			ruleReceiver: smallInt2 operand: (numList at: ndx)
	].

	retVals := #(-1999999998 -4000000000 0 -1999999998.0s3 0 -1999999998.0) copy.
	retVals at: 5 put: (-3999999999/2).
	1 to: numList size do: [ :ndx |
		self value: [largeNegInt2000000000 + (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'+'
			ruleReceiver: largeNegInt2000000000
			operand: (numList at: ndx)
	].

	retVals := #(2000000002 0 4000000000 2000000002.0s3 0 2000000002.0) copy.
	retVals at: 5 put: (4000000001/2).
	1 to: numList size do: [ :ndx |
		self value: [largePosInt2000000000 + (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'+'
			ruleReceiver: largePosInt2000000000
			operand: (numList at: ndx)
	].!

testXallMaskX
	" <integer>#allMask: "
	#'Numeric'.!

testXanyMaskX
	" <integer>#anyMask: "
	#'Numeric'.!

testXasFloat
	" <number>#asFloat "
	#'Numeric'.
	self value: [2 asFloat] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [-2 asFloat] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [-2000000000 asFloat] should: [:r | r = -2000000000.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [2000000000 asFloat] should: [:r | r = 2000000000.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [0 asFloat] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloat'.!

testXasFloatD
	" <number>#asFloatD "
	#'Numeric'.
	self value: [2 asFloatD] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [-2 asFloatD] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [-2000000000 asFloatD] should: [:r | r = -2000000000.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [2000000000 asFloatD] should: [:r | r = 2000000000.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [0 asFloatD] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatD'.!

testXasFloatE
	" <number>#asFloatE "
	#'Numeric'.
	self value: [2 asFloatE] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [-2 asFloatE] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [-2000000000 asFloatE] should: [:r | r = -2000000000.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [2000000000 asFloatE] should: [:r | r = 2000000000.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [0 asFloatE] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatE'.!

testXasFloatQ
	" <number>#asFloatQ "
	#'Numeric'.
	self value: [2 asFloatQ] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [-2 asFloatQ] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [-2000000000 asFloatQ] should: [:r | r = -2000000000.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [2000000000 asFloatQ] should: [:r | r = 2000000000.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [0 asFloatQ] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatQ'.!

testXasFraction
	" <number>#asFraction "
	#'Numeric'.
	self value: [2 asFraction] should: [:r | r = 2]
		conformTo: #'number' selector: #'asFraction'.
	self value: [-2 asFraction] should: [:r | r = -2]
		conformTo: #'number' selector: #'asFraction'.
	self value: [-2000000000 asFraction] should: [:r | r = -2000000000]
		conformTo: #'number' selector: #'asFraction'.
	self value: [2000000000 asFraction] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'asFraction'.
	self value: [0 asFraction] should: [:r | r = 0]
		conformTo: #'number' selector: #'asFraction'.!

testXasInteger
	" <number>#asInteger "
	#'Numeric'.
	self value: [2 asInteger] should: [:r | r = 2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2 asInteger] should: [:r | r = -2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2000000000 asInteger] should: [:r | r = -2000000000]
		conformTo: #'number' selector: #'asInteger'.
	self value: [2000000000 asInteger] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'asInteger'.
	self value: [0 asInteger] should: [:r | r = 0]
		conformTo: #'number' selector: #'asInteger'.!

testXasScaledDecimalX
	"2000/06/23 Harmon, R. Changed to fix illegal fixed point literals."
	"The number of significant digits of the answer is the same as the number of decimal digits in the receiver. The scale of the answer is 0."
	self value: [2 asScaledDecimal: 2]
		should: [:r | r = 2s & (r scale = 0)]
		conformTo: #'integer' selector: #'asScaledDecimal:'.
	self value: [-2 asScaledDecimal: 2]
		should: [:r | r = -2s & (r scale = 0)]
		conformTo: #'integer' selector: #'asScaledDecimal:'.
	self value: [-2000000000 asScaledDecimal: 2]
		should: [:r | r = -2000000000s & (r scale = 0)]
		conformTo: #'integer' selector: #'asScaledDecimal:'.
	self value: [2000000000 asScaledDecimal: 2]
		should: [:r | r = 2000000000s & (r scale = 0)]
		conformTo: #'integer' selector: #'asScaledDecimal:'.
	self value: [0 asScaledDecimal: 2] should: [:r | r = 0s & (r scale = 0)]
		conformTo: #'integer' selector: #'asScaledDecimal:'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver  and min or max are not comparable"

	self value: [2 between: 1 and: 3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [-2000000002 between: -2000000003 and: -2000000001]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2000000002 between: 2000000001 and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2 between: 1.0 and: 3.0]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2 between: (3/2) and: (5/2)]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2 between: 1.0s3 and: 3.0s3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	self value: [2 between: (3/2) and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2 between: -2000000001.0 and: 3.0s3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"Num between: Num and: Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx)
					between: (numList at: ndx)
					and: (numList at: ndx)]
			should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'
	].

	self value: [2 between: 3 and: 4]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [-2000000000 between: -2000000003 and: -2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2000000000 between: 2000000003 and: 2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2 between: 3.0 and: 5.0]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2 between: (5/2) and: (7/2)]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2 between: 3.0s3 and: 5.0s3]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"??? min not min but max and vice versa -> false ???"
	self value: [2 between: 3 and: 1]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.!

testXbitAndX
	" <integer>#bitAnd: "
	#'Numeric'.!

testXbitAtX
	" <integer>#bitAt: "
	#'Numeric'.!

testXbitAtXputX
	" <integer>#bitAt:put: "
	#'Numeric'.!

testXbitOrX
	" <integer>#bitOr: "
	#'Numeric'.!

testXbitShiftX
	" <integer>#bitShift: "
	#'Numeric'.!

testXbitXorX
	" <integer>#bitXor: "
	#'Numeric'.!

testXceiling
	" <number>#ceiling "
	#'Numeric'.
	self value: [2 ceiling] should: [:r | r = 2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2 ceiling] should: [:r | r = -2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2000000000 ceiling] should: [:r | r = -2000000000]
		conformTo: #'number' selector: #'ceiling'.
	self value: [2000000000 ceiling] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'ceiling'.
	self value: [0 ceiling] should: [:r | r = 0]
		conformTo: #'number' selector: #'ceiling'.!

testXcopy
	" <Object>#copy (Return Values: <RECEIVER>) "
	#'Numeric'.
#todo. "??? add change-side-effect test ???"
	
"
If the receiver is an identity object, return the receiver.
"
	self value: [smallInt2 copy]
		should: [:r | (r = smallInt2) & (r == smallInt2)]
		conformTo: #'Object' selector: #'copy' opRECEIVER: smallInt2.
	self value: [largeNegInt2000000000 copy]
		should: [:r | (r = largeNegInt2000000000) ]
		conformTo: #'Object' selector: #'copy'
		opRECEIVER: largeNegInt2000000000.
	self value: [largePosInt2000000000 copy]
		should: [:r | (r = largePosInt2000000000) ]
		conformTo: #'Object' selector: #'copy'
		opRECEIVER: largePosInt2000000000.!

testXdenominator
	" <rational>#denominator "
	#'Numeric'.!

testXdivideOp
	" <number>#/ (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(1 0 0 1.0 4 1.000s3) copy.
	retVals at: 2 put: (-1/1000000000).
	retVals at: 3 put: (1/1000000000).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 / (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'/'
			ruleReceiver: smallInt2 operand: (numList at: ndx)
	].

	retVals := #(-1000000000 1 -1 -1000000000.0 -4000000000 -1000000000.000s3).
	1 to: numList size do: [ :ndx |
		self value: [largeNegInt2000000000 / (numList at: ndx)]
			should: [:r | r = (retVals at: ndx) ]
			conformTo: #'number' selector: #'/'
			ruleReceiver: largeNegInt2000000000
			operand: (numList at: ndx)
	].

	retVals := #(1000000000 -1 1 1000000000.0 4000000000 1000000000.000s3).
	1 to: numList size do: [ :ndx |
		self value: [largePosInt2000000000 / (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'/'
			ruleReceiver: largePosInt2000000000
			operand: (numList at: ndx)
	].


	self value: [0 / smallInt2] should: [:r | r = 0]
		conformTo: #'number' selector: #'/'
		ruleReceiver: smallInt2 operand: 0.
	self value: [0 / largeNegInt2000000000] should: [:r | r = 0]
		conformTo: #'number' selector: #'/'
		ruleReceiver: fractionHalf operand: 0.
	self value: [0 / largePosInt2000000000] should: [:r | r = 0]
		conformTo: #'number' selector: #'/'
		ruleReceiver: fractionHalf operand: 0.

	"The implementation must signal the ZeroDivide exception."
	self value: [smallInt2 / 0] shouldRaise: ZeroDivide.
	self value: [largeNegInt2000000000 / 0] shouldRaise: ZeroDivide.
	self value: [largePosInt2000000000 / 0] shouldRaise: ZeroDivide.!

testXequalityOp
	" <number>#= "
	#'Numeric'.
"
	receiver = comparand	=>
	receiver hash = comparand hash
"
	self value: [smallInt2 = smallInt2]
		should: [:r | r & (smallInt2 hash = smallInt2 hash) ]
		conformTo: #'number' selector: #'='.
	self value: [ smallInt2 = 3 ]
		shouldnt: [ :r | r | (smallInt2 hash = 3 hash) ]
		conformTo: #'number' selector: #'='.
	self value: [largeNegInt2000000000 = largeNegInt2000000000]
		should: [:r | r & (largeNegInt2000000000 hash
						= largeNegInt2000000000 hash) ]
		conformTo: #'number' selector: #'='.
	self value: [largePosInt2000000000 = largePosInt2000000000]
		should: [:r | r & (largePosInt2000000000 hash
						= largePosInt2000000000 hash) ]
		conformTo: #'number' selector: #'='.

"	#( 2 2.0 2.0s3 )."
	self value: [ smallInt2 = 2 ]
		should: [ :r | r  ifTrue: [ smallInt2 hash = 2 hash ]
							ifFalse: [ smallInt2 hash ~= 2 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ smallInt2 = 2.0 ]
		should: [ :r | r ifTrue: [ smallInt2 hash = 2.0 hash ]
						ifFalse: [ smallInt2 hash ~= 2.0 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ 2.5s3 = (5/2) ]
		should: [ :r | r ifTrue: [ 2.5s3 hash = (5/2) hash ]
						ifFalse: [ 2.5s3 hash ~= (5/2) hash ]  ]
		conformTo: #'number' selector: #'='.!

testXeven
	" <integer>#even "
	#'Numeric'.!

testXfactorial
	" <integer>#factorial "
	#'Numeric'.!

testXfloor
	" <number>#floor "
	#'Numeric'.
	self value: [2 floor] should: [:r | r = 2]
		conformTo: #'number' selector: #'floor'.
	self value: [-2 floor] should: [:r | r = -2]
		conformTo: #'number' selector: #'floor'.
	self value: [-2000000000 floor] should: [:r | r = -2000000000]
		conformTo: #'number' selector: #'floor'.
	self value: [2000000000 floor] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'floor'.
	self value: [0 floor] should: [:r | r = 0]
		conformTo: #'number' selector: #'floor'.!

testXfractionPart
	" <number>#fractionPart (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	"Within the limits of representation, the following invariants should hold:

		receiver integerPart + receiver fractionPart = receiver
		receiver \\1 = receiver fractionPart	(RAH - erroneous, add #'abs')
"
	rcvr := 2.
	self value: [rcvr fractionPart]
		should: [:r | r = 0 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := -2.
	self value: [rcvr fractionPart]
		should: [:r | r = 0 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := -2000000000.
	self value: [rcvr fractionPart]
		should: [:r | r = 0 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := 2000000000.
	self value: [rcvr fractionPart]
		should: [:r | r = 0 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := 0.
	self value: [rcvr fractionPart]
		should: [:r | r = 0 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.!

testXgcdX
	" <integer>#gcd: "
	#'Numeric'.!

testXgreaterThanOp
	" <number>#> "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small > Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [1 > tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [-2000000005 > -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [0 > (1/2)] shouldnt: [:r | r] conformTo: #'number' selector: #'>'.

	"Num > Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) > (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'>'
	].

	"Big > Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5 > tstNum] should: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [9000000000 > 2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [-1000000005 > -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [9 > (1/2)] should: [:r | r] conformTo: #'number' selector: #'>'.!

testXgreaterThanOrEqualToOp
	" <magnitude>#>= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small >= Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [1 >= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [-2000000005 >= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [0 >= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.

	"Num >= Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) >= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'>='
	].

	"Big >= Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5 >= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [9000000000 >= 2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [-1000000005 >= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [9 >= (1/2)] should: [:r | r] conformTo: #'magnitude' selector: #'>'.!

testXhash
	" <Object>#hash "
	#'Numeric'.
"	Any two objects that are considered equivalent using the #= message must have the same hash value.  More formally:

	receiver = comparand	=>
	receiver hash = comparand hash
"
#'testAnom'. "??? <Object> test of equivalence seems to confilict
				with <Number> convert then test. ???
	self shouldnt: [smallInt2 = float2].
	self shouldnt: [smallInt2 hash = float2 hash].
"
	self value: [smallInt2 hash]
		should: [:r | r = smallInt2 hash]
		conformTo: #'Object' selector: #'hash'.
	self value: [largeNegInt2000000000 hash]
		should: [:r | r = largeNegInt2000000000 hash]
		conformTo: #'Object' selector: #'hash'.
	self value: [largePosInt2000000000 hash]
		should: [:r | r = largePosInt2000000000 hash]
		conformTo: #'Object' selector: #'hash'.

	self value: [smallInt2 hash]
		should: [:r | r = (4/2) hash] conformTo: #'Object' selector: #'hash'.
	self value: [smallInt2 hash]
		should: [:r | r = (3 - 1) hash] conformTo: #'Object' selector: #'hash'.

	self value: [smallInt2 hash]
		shouldnt: [:r | r = 3 hash] conformTo: #'Object' selector: #'hash'.
	self value: [largeNegInt2000000000 hash]
		shouldnt: [:r | r = 2000000001 hash]
		conformTo: #'Object' selector: #'hash'.
	self value: [largePosInt2000000000 hash]
		shouldnt: [:r | r = 2000000001 hash]
		conformTo: #'Object' selector: #'hash'.

	self value: [smallInt2 hash]
		shouldnt: [:r | r = (6/2) hash] conformTo: #'Object' selector: #'hash'.
	self value: [smallInt2 hash]
		shouldnt: [:r | r = (2 + 1) hash] conformTo: #'Object' selector: #'hash'.!

testXhighBit
	" <integer>#highBit "
	#'Numeric'.!

testXidentityHash
	" <Object>#identityHash "
	#'Numeric'.
	self value: [smallInt2 identityHash]
		should: [:r | r = smallInt2 identityHash]
		conformTo: #'Object' selector: #'identityHash'.
	self value: [largeNegInt2000000000 identityHash]
		should: [:r | r = largeNegInt2000000000 identityHash]
		conformTo: #'Object' selector: #'identityHash'.
	self value: [largePosInt2000000000 identityHash]
		should: [:r | r = largePosInt2000000000 identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [smallInt2 identityHash]
		should: [:r | r = (4/2) identityHash]
		conformTo: #'Object' selector: #'identityHash'.
	self value: [smallInt2 identityHash]
		should: [:r | r = (3 - 1) identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [smallInt2 identityHash]
		shouldnt: [:r | r = 3 identityHash]
		conformTo: #'Object' selector: #'identityHash'.
	self value: [largeNegInt2000000000 identityHash]
		shouldnt: [:r | r = 2000000001 identityHash]
		conformTo: #'Object' selector: #'identityHash'.
	self value: [largePosInt2000000000 identityHash]
		shouldnt: [:r | r = 2000000001 identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [smallInt2 identityHash]
		shouldnt: [:r | r = (6/2) identityHash]
		conformTo: #'Object' selector: #'identityHash'.
	self value: [smallInt2 identityHash]
		shouldnt: [:r | r = (2 + 1) identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self shouldnt: [smallInt2 identityHash = float2 identityHash].!

testXidentityOp
	" <Object>#== "
	#'Numeric'.
"	The value of receiver == comparand is true if and only if the value of comparand == receiver would also be true. If the value of receiver == comparand is true then the receiver and comparand must have equivalent identity hash values.  Or more formally:

	receiver == comparand =>
	receiver identityHash = comparand identityHash
"
	self shouldnt: [smallInt2 == float2].
	self shouldnt: [smallInt2 identityHash == float2 identityHash].

	self value: [smallInt2 == smallInt2]
		should: [:r | r] conformTo: #'Object' selector: #'=='.
	self value: [largeNegInt2000000000 == largeNegInt2000000000]
		should: [:r | r] conformTo: #'Object' selector: #'=='.
	self value: [largePosInt2000000000 == largePosInt2000000000]
		should: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [smallInt2 == (4/2)]
		should: [:r | r] conformTo: #'Object' selector: #'=='.
	self value: [smallInt2 == (3 - 1)]
		should: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [smallInt2 == 3]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.
	self value: [largeNegInt2000000000 == 2000000001]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.
	self value: [largePosInt2000000000 == 2000000001]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [smallInt2 == (6/2)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.
	self value: [smallInt2 == (2 + 1)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.!

testXintegerDivideOp
	" <number>#// "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	"The sign of the result is positive if the receiver and operand
		have the same sign, and negative if the signs are different."
	retVals := #(1 -1 0 1 4 1) copy.
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 // (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'.
	].

	retVals := #(-1 0 -1 -1 -4 -1) copy.
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 // ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'
	].

	self should: [26 // 5.1 = 5].
	self should: [26 // 5 = 5].
	self should: [25500000000 // 5000000000 = 5].
	self should: [-25500000000 // -5000000000 = 5].
	self should: [26 // (51/10) = 5].
	self should: [26 // 5.1s1 = 5].

	self value: [0 // smallInt2] should: [:r | r = 0]
		conformTo: #'number' selector: #'//'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [smallInt2 // 0] shouldRaise: ZeroDivide.!

testXintegerPart
	" <number>#integerPart (returnRule - :receiver) "
	| rcvr |
	#'Numeric'.
	rcvr := 2.
	self value: [rcvr integerPart] should: [:result | result = 2]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := -2.
	self value: [rcvr integerPart] should: [:result | result = -2]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := -2000000000.
	self value: [rcvr integerPart] should: [:result | result = -2000000000]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := 2000000000.
	self value: [rcvr integerPart] should: [:result | result = 2000000000]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := 0.
	self value: [rcvr integerPart] should: [:result | result = 0]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.!

testXisKindOfX
	" <Object>#isKindOf: "
	#'Numeric'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
		#'Fundamental'.
#todo. "Fix find a test for unspecified rule above ???"
	self value: [smallInt2 isKindOf: Integer]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.
	self value: [largeNegInt2000000000 isKindOf: Integer]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.
	self value: [largePosInt2000000000 isKindOf: Integer]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Metaclass tests:"
	self value: [smallInt2 class isKindOf: (Integer class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.
	self value: [largeNegInt2000000000 class isKindOf: (Integer class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.
	self value: [largePosInt2000000000 class isKindOf: (Integer class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Inherit tests:"
	self value: [smallInt2 class isKindOf: (Integer class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.
	self value: [smallInt2 class isKindOf: (Number class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	self value: [smallInt2 isKindOf: Float]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.!

testXlcmX
	" <integer>#lcm: "
	#'Numeric'.!

testXlessThanOp
	" <number>#< "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small < Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [1 < tstNum] should: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [-2000000005 < -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [0 < (1/2)] should: [:r | r] conformTo: #'number' selector: #'<'.

	"Num < Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) < (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'<'
	].

	"Big < Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5 < tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [9000000000 < 2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [-1000000005 < -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [9 < (1/2)] shouldnt: [:r | r] conformTo: #'number' selector: #'<'.!

testXlessThanOrEqualToOp
	" <magnitude>#<= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small <= Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [1 <= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [-2000000005 <= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [0 <= (1/2)] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.

	"Num <= Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) <= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'<='
	].

	"Big <= Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5 <= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [9000000000 <= 2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [-1000000005 <= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [9 <= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.!

testXmaxX
	" <magnitude>#max: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver and operand are not comparable."

	self value: [2 max: 3] should: [:r | r = 3]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [-3000000000 max: -2000000000] should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2000000000 max: 2000000003] should: [:r | r = 2000000003]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2 max: 3.0] should: [:r | r = 3.0]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2 max: (5/2)] should: [:r | r = (5/2)]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2 max: 3.0s3] should: [:r | r = 3.0s3]
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

	self value: [2 min: 1] should: [:r | r = 1]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [-1000000000 min: -2000000000] should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2000000003 min: 2000000001] should: [:r | r = 2000000001]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2 min: 1.0] should: [:r | r = 1.0]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2 min: (3/2)] should: [:r | r = (3/2)]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2 min: 1.0s5] should: [:r | r = 1.0s5]
		conformTo: #'magnitude' selector: #'min:'.

	"Num min: Num -> Num"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) min: (numList at: ndx)]
			should: [:r | r = (numList at: ndx)]
			conformTo: #'magnitude' selector: #'min:'
	].!

testXmultiplyOp
	" <number>#* (returnRule - :receiver :operand) "
	| retVals negInt2 posInt2 |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(4 -4000000000 4000000000 4.0 1 4.000s3).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 * (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'*'
			ruleReceiver: smallInt2 operand: (numList at: ndx)
	].

	retVals := #(-4000000000 4000000000000000000 -4000000000000000000 -4000000000.0 -1000000000 -4000000000.000s3).
	1 to: numList size do: [ :ndx |
		self value: [largeNegInt2000000000 * (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'*'
			ruleReceiver: largeNegInt2000000000
			operand: (numList at: ndx)
	].

	retVals := #(4000000000 -4000000000000000000 4000000000000000000 4000000000.0 1000000000 4000000000.000s3).
	1 to: numList size do: [ :ndx |
		self value: [largePosInt2000000000 * (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'*'
			ruleReceiver: largePosInt2000000000
			operand: (numList at: ndx)
	].

	negInt2 := -2.
	posInt2 := 2.
	self value: [negInt2 * posInt2] should: [:result | result = -4]
		conformTo: #'number' selector: #'*'
		ruleReceiver: negInt2 operand: posInt2.!

testXnegated
	" <number>#negated (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 2.
	self value: [rcvr negated] should: [:r | r = -2]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.

	rcvr := -2.
	self value: [rcvr negated] should: [:r | r = 2]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.

	rcvr := -2000000000.
	self value: [rcvr negated] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.

	rcvr := 2000000000.
	self value: [rcvr negated] should: [:r | r = -2000000000]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.

	rcvr := 0.
	self value: [rcvr negated] should: [:r | r = 0]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.!

testXnegative
	" <number>#negative "
	#'Numeric'.
	self value: [-2 negative] should: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [-2000000000 negative] should: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [2 negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [2000000000 negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [0 negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.!

testXnoMaskX
	" <integer>#noMask: "
	#'Numeric'.!

testXnotEqualityOp
	" <Object>#~= "
	#'Numeric'.
"	The value of receiver ~= comparand is true if and only if the value of
comparand ~= receiver would also be true.
"
#'testAnom'. "??? <Object> test of equivalence seems to confilict
				with <Number> convert then test. ???
	self should: [(smallInt2 ~= float2) & (float2 ~= smallInt2)].
"

	self value: [smallInt2 ~= 3]
		should: [:r | r] conformTo: #'Object' selector: #'~='.
	self value: [largeNegInt2000000000 ~= 2000000001]
		should: [:r | r] conformTo: #'Object' selector: #'~='.
	self value: [largePosInt2000000000 ~= 2000000001]
		should: [:r | r] conformTo: #'Object' selector: #'~='.

	self value: [smallInt2 ~= (6/2)]
		should: [:r | r] conformTo: #'Object' selector: #'~='.
	self value: [smallInt2 ~= (2 + 1)]
		should: [:r | r] conformTo: #'Object' selector: #'~='.

	self value: [smallInt2 ~= smallInt2]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.
	self value: [largeNegInt2000000000 ~= largeNegInt2000000000]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.
	self value: [largePosInt2000000000 ~= largePosInt2000000000]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.

	self value: [smallInt2 ~= (4/2)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.
	self value: [smallInt2 ~= (3 - 1)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.!

testXnotIdentityOp
	" <Object>#~~ "
	#'Numeric'.
"	The value of receiver ~~ comparand is true if and only if the value of comparand ~~ receiver would also be true.
"
	self should: [smallInt2 ~~ float2 and: [float2 ~~ smallInt2]].

	self value: [smallInt2 ~~ 3]
		should: [:r | r] conformTo: #'Object' selector: #'~~'.
	self value: [largeNegInt2000000000 ~~ 2000000001]
		should: [:r | r] conformTo: #'Object' selector: #'~~'.
	self value: [largePosInt2000000000 ~~ 2000000001]
		should: [:r | r] conformTo: #'Object' selector: #'~~'.

	self value: [smallInt2 ~~ (6/2)]
		should: [:r | r] conformTo: #'Object' selector: #'~~'.
	self value: [smallInt2 ~~ (2 + 1)]
		should: [:r | r] conformTo: #'Object' selector: #'~~'.

	self value: [smallInt2 ~~ smallInt2]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~~'.
	self value: [largeNegInt2000000000 ~~ largeNegInt2000000000]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~~'.
	self value: [largePosInt2000000000 ~~ largePosInt2000000000]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~~'.

	self value: [smallInt2 ~~ (4/2)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~~'.
	self value: [smallInt2 ~~ (3 - 1)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~~'.!

testXnumerator
	" <rational>#numerator "
	#'Numeric'.!

testXodd
	" <integer>#odd "
	#'Numeric'.!

testXpositive
	" <number>#positive "
	#'Numeric'.
	self value: [2 positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [2000000000 positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [0 positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [-2 positive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [-2000000000 positive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'positive'.!

testXprintOnXbaseXshowRadixX
	" <integer>#printOn:base:showRadix: "
	#'Numeric'.!

testXprintString
	" <number>#printString "
	#'Numeric'.
	self value: [2 printString] should: [:r | r = '2']
		conformTo: #'number' selector: #'printString'.
	self value: [-2 printString] should: [:r | r = '-2']
		conformTo: #'number' selector: #'printString'.
	self value: [2000000000 printString] should: [:r | r = '2000000000']
		conformTo: #'number' selector: #'printString'.
	self value: [-2000000000 printString] should: [:r | r = '-2000000000']
		conformTo: #'number' selector: #'printString'.
	self value: [0 printString] should: [:r | r = '0']
		conformTo: #'number' selector: #'printString'.!

testXprintStringRadixX
	" <integer>#printStringRadix: "
	#'Numeric'.!

testXquoX
	" <number>#quo: "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(1 0 0 1 4 1 ).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 quo: (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'.
	].

	retVals := #(-1 0 0 -1 -4 -1 ).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 quo: ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'
	].

	self should: [(26 quo: 5.1) = 5].
	self should: [(26 quo: 5) = 5].
	self should: [(25500000000 quo: 5000000000) = 5].
	self should: [(-25500000000 quo: -5000000000) = 5].
	self should: [(26 quo: (51/10)) = 5].
	self should: [(26 quo: 5.1s1) = 5].

	self value: [0 quo: smallInt2] should: [:r | r = 0]
		conformTo: #'number' selector: #'quo:'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [smallInt2 quo: 0] shouldRaise: ZeroDivide.!

testXraisedToIntegerX
	" <number>#raisedToInteger: (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 2.
	self value: [rcvr raisedToInteger: 0] should: [:r | r = 1]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: 1] should: [:r | r = rcvr]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: 2] should: [:r | r = 4]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	self value: [rcvr negated raisedToInteger: 2] should: [:r | r = 4]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: -2] should: [:r | r = (1/4)]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

#'todo'."??? these take 5-10 min.
	self value: [rcvr raisedToInteger: 2000000000]
		should: [:r | r =  ???]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.
	self value: [rcvr raisedToInteger: -2000000000]
		should: [:r | r =  ???]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.
"
	rcvr := 2000000000.
	self value: [rcvr raisedToInteger: 2]
		should: [:r | r = 4000000000000000000]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	rcvr := -2000000000.
	self value: [rcvr raisedToInteger: 2]
		should: [:r | r = 4000000000000000000]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	"It is erroneous if the operand does not conform to the protocol <integer>."
	self value: [2 raisedToInteger: 2.0] shouldRaise: Error.
	self value: [0 raisedToInteger: -2] shouldRaise: ZeroDivide.!

testXraisedToX
	" <number>#raisedTo: "
	| numVals retVals |
	#'Numeric'.
	numVals := #(2 2.0 0 2.0s3 ) copy.
	numVals at: 3 put: (1/2).
	retVals := #(4 4.0 1.414213562373095 4.0 ) copy.
	1 to: numVals size do: [ :ndx |
		self value: [smallInt2 raisedTo: (numVals at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'raisedTo:'.
	].

	retVals := #(0 0.25 0.7071067811865475 0.25 ) copy.
	retVals at: 1 put: (1/4).
	1 to: numVals size do: [ :ndx |
		self value: [smallInt2 raisedTo: ((numVals at: ndx) negated)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'raisedTo:'
	].

	self value: [smallInt2 raisedTo: 0] should: [:r | r = 1]
		conformTo: #'number' selector: #'raisedTo:'.

	self value: [0 raisedTo: smallInt2] should: [:r | r = 0]
		conformTo: #'number' selector: #'raisedTo:'.

	self value: [smallInt2 raisedTo: 1] should: [:r | r = smallInt2]
		conformTo: #'number' selector: #'raisedTo:'.

	"It is erroneous if the receiver equals zero
		and the operand is less than or equal to zero,"
	self value: [0 raisedTo: -2] shouldRaise: Error.

	"	or if the receiver is less than zero."
	self value: [smallInt2 negated raisedTo: 1.1] shouldRaise: Error.!

testXreciprocal
	" <number>#reciprocal (returnRule - :receiver) "
	#'Numeric'.

	self value: [smallInt2 reciprocal] should: [:r | r = (1.0/smallInt2)]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: smallInt2.

	self value: [smallInt2 negated reciprocal]
		should: [:r | r = (1/(smallInt2 negated))]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: (smallInt2 negated).

	self value: [largePosInt2000000000 reciprocal]
		should: [:r | r = (1/largePosInt2000000000)]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: largePosInt2000000000.

	self value: [largeNegInt2000000000 reciprocal]
		should: [:r | r = (1/largeNegInt2000000000)]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: largeNegInt2000000000.

	"Signal a ZeroDivide exception if the receiver is equal to zero."
	self value: [0 reciprocal] shouldRaise: ZeroDivide.!

testXremainderIntegerDivideOp
	" <number>#\\ (returnRule - :receiver :operand) "
	"The remainder has the same sign as operand.
	Within the limits of representation, the following invariant should hold:

		(receiver // operand) * operand + (receiver \\ operand) = receiver
 "
	| retVals recList ndx |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	recList := #( 26 -26000000001 26000000001 26.0 0 26.0s3 ) copy.
	recList at: 5 put: (53/2).
	retVals := #(1 4 1 1.0 0 1.000s3 ) copy.
	retVals at: 5 put: (3/2).
	ndx := 0.
	recList do: [ :rec |
		ndx := ndx + 1.
		self value: [rec \\ 5]
			should: [:r | r = (retVals at: ndx)
					& ((rec // 5) * 5 + (rec \\ 5) = rec)]
			conformTo: #'number' selector: #'\\'
			ruleReceiver: rec operand:  5.
	].

	"The remainder has the same sign as operand."
	retVals := #(-4 -1 -4 -4.0 0 -4.000s3 ) copy.
	retVals at: 5 put: (-7/2).
	ndx := 0.
	recList do: [ :rec |
		ndx := ndx + 1.
		self value: [rec \\ -5]
			should: [:r | r = (retVals at: ndx)
					& ((rec // -5) * -5 + (rec \\ -5) = rec)]
			conformTo: #'number' selector: #'\\'
			ruleReceiver: rec operand:  -5.
	].

	self should: [26 \\ 5 = 1 & ((26 // 5) * 5 + (26 \\ 5) = 26)].
	self should: [26 \\ -5 = -4 & ((26 // -5) * -5 + (26 \\ -5) = 26)].

	self should: [0 \\ smallInt2 = 0].
	self should: [0 \\ largeNegInt2000000000 = 0].
	self should: [0 \\ largePosInt2000000000 = 0].

	"If the operand is zero, the implementation may signal
		the ZeroDivide exception or provide a continuation value."
	self value: [smallInt2 \\ 0] shouldRaise: ZeroDivide.
	self value: [largeNegInt2000000000 \\ 0] shouldRaise: ZeroDivide.
	self value: [largePosInt2000000000 \\ 0] shouldRaise: ZeroDivide.!

testXremX
	" <number>#rem: "
	| retVals ndx num2 int |
	#'Numeric'.
	"Within the limits of representation, the following invariant should hold:
		(receiver quo: operand)*operand + (receiver rem: operand) = receiver"
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	numList := #( 5 5.0 5.0s3 ).
	int := 26.
	retVals := #(1 1.0 1.000s3 ).
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self value: [int rem: num]
			should: [:r | r = (retVals at: ndx)
					& ((int quo: num) * num + (int rem: num) = int)]
			conformTo: #'number' selector: #'rem:'
	].

	numList := numList collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self value: [int rem: num]
			should: [:r | r = (retVals at: ndx)
					& ((int quo: num) * num + (int rem: num) = int)]
			conformTo: #'number' selector: #'rem:'
	].

	int := -26.
	numList := #( 5 5.0 5.0s3 ).
	retVals := retVals collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self should: [(int rem: num) = (retVals at: ndx)
					& ((int quo: num) * num + (int rem: num) = int)]
	].

	numList := numList collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self should: [(int rem: num) = (retVals at: ndx)
					& ((int quo: num) * num + (int rem: num) = int)]
	].

	int := 26.
	num2 := (5/2).
	self value: [int rem: num2]
		should: [:r | r = 1
				& ((int quo: num2) * num2 + (int rem: num2) = int)]
		conformTo: #'number' selector: #'rem:'.

	int :=  10000000001.
	numList := #(-2000000000 2000000000).
	retVals := #(1 1.0 1.000s3 ).
	ndx := 0.
	numList do: [ :num |
		self value: [int rem: num]
			should: [:r | r = (retVals at: 1)
					& ((int quo: num) * num + (int rem: num) = int)]
			conformTo: #'number' selector: #'rem:'
	].

	"If either the receiver or operand are of type <Float> and the operand has a value of zero, the result is implementation defined.  The implementation may signal the ZeroDivide exception or provide a continuation value "
	self value: [smallInt2 rem: 0.0] shouldRaise: ZeroDivide.
	self value: [smallInt2 rem: 0] shouldRaise: ZeroDivide.
	self value: [smallInt2 rem: 0s0] shouldRaise: ZeroDivide.!

testXrounded
	" <number>#rounded "
	#'Numeric'.
	self value: [2 rounded] should: [:r | r = 2]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2 rounded] should: [:r | r = -2]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2000000000 rounded] should: [:r | r = -2000000000]
		conformTo: #'number' selector: #'rounded'.
	self value: [2000000000 rounded] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'rounded'.
	self value: [0 rounded] should: [:r | r = 0]
		conformTo: #'number' selector: #'rounded'.!

testXroundToX
	" <number>#roundTo: (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(2 0 0 2.0 2 2.000s3).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 roundTo: (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'roundTo:'
			ruleReceiver: smallInt2 operand: (numList at: ndx)
	].

	self should: [(0 roundTo: smallInt2) = 0]!

testXsign
	" <number>#sign "
	#'Numeric'.
	self value: [2 sign] should: [:r | r = 1]
		conformTo: #'number' selector: #'sign'.
	self value: [2000000000 sign] should: [:r | r = 1]
		conformTo: #'number' selector: #'sign'.
	self value: [0 sign] should: [:r | r = 0]
		conformTo: #'number' selector: #'sign'.
	self value: [-2 sign] should: [:r | r = -1]
		conformTo: #'number' selector: #'sign'.
	self value: [-2000000000 sign] should: [:r | r = -1]
		conformTo: #'number' selector: #'sign'.!

testXsqrt
	" <number>#sqrt "
	#'Numeric'.
	self value: [4 sqrt] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'sqrt'.
	self value: [2000000000 sqrt] should: [:r | r closeTo: 44721.3595499958]
		conformTo: #'number' selector: #'sqrt'.
	self value: [0 sqrt] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'sqrt'!

testXsquared
	" <number>#squared (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	self value: [smallInt2 squared] should: [:r | r = 4]
		conformTo: #'number' selector: #'squared' opRECEIVER: smallInt2.

	rcvr := -2.
	self value: [rcvr squared] should: [:r | r = 4]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

	self value: [largeNegInt2000000000 squared]
		should: [:r | r = 4000000000000000000]
		conformTo: #'number' selector: #'squared'
		opRECEIVER: largeNegInt2000000000.

	self value: [largePosInt2000000000 squared]
		should: [:r | r = 4000000000000000000]
		conformTo: #'number' selector: #'squared'
		opRECEIVER: largePosInt2000000000.

	rcvr := 0.
	self value: [rcvr squared] should: [:r | r = 0]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.!

testXstrictlyPositive
	" <number>#strictlyPositive "
	#'Numeric'.
	self value: [2 strictlyPositive] should: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.
	self value: [2000000000 strictlyPositive] should: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.

	self value: [0 strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.
	self value: [-2 strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.
	self value: [-2000000000 strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.!

testXsubtractOp
	" <number>#- (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

	retVals := #(0 2000000002 -1999999998 0.0s3 0 0.0) copy.
	retVals at: 5 put: (3/2).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 - (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'-'
			ruleReceiver: smallInt2 operand: (numList at: ndx)
	].

	retVals := #(-2000000002 0 -4000000000 -2000000002.0s3 0 -2000000002.0) copy.
	retVals at: 5 put: (-4000000001/2).
	1 to: numList size do: [ :ndx |
		self value: [largeNegInt2000000000 - (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'-'
			ruleReceiver: largeNegInt2000000000
			operand: (numList at: ndx)
	].

	retVals := #(1999999998 4000000000 0  1999999998.0s3 0  1999999998.0) copy.
	retVals at: 5 put: (3999999999/2).
	1 to: numList size do: [ :ndx |
		self value: [largePosInt2000000000 - (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'-'
			ruleReceiver: largePosInt2000000000
			operand: (numList at: ndx)
	].!

testXtoX
	" <number>#to: "

	| start middleNdx stop2 |
	#Numeric.
	start := 1.
	numList := #(2 2.0 0 2.0s3) copy.
	numList at: 3 put: 5 / 2.
	numList do: 
			[:stop | 
			self 
				value: [start to: stop]
				should: 
					[:r | 
					r size = 2 & (r last = (start + ((stop - start) // 1))) 
						& (r allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #integer])
					". . . the last element in the sequence . . . is . . .[:]
						receiver + ((stop - receiver) // 1)"
					"The elements conform to the receiver's protocol."]
				conformTo: #number
				selector: #to:].
	stop2 := 2000000000.
	middleNdx := 1000000000.	"Check conformance of first, middle and last."
	self 
		value: [start to: stop2]
		should: 
			[:r | 
			r size = 2000000000 & (r last = (start + ((stop2 - start) // 1))) 
				& ((Array 
						with: (r at: 1)
						with: (r at: middleNdx)
						with: (r at: 3)) allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #integer])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.
	start := -2000000000.
	stop2 := -1.
	middleNdx := 1000000000.	"Check conformance of first, middle and last."
	self 
		value: [start to: stop2]
		should: 
			[:r | 
			r size = 2000000000 & (r last = (start + ((stop2 - start) // 1))) 
				& ((Array 
						with: (r at: 1)
						with: (r at: middleNdx)
						with: (r at: 3)) allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #integer])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.

	"The interval answered will be empty if the receiver is greater than stop."
	self 
		value: [1 to: -1]
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
	self value: [2 truncated] should: [:r | r = 2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2 truncated] should: [:r | r = -2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2000000000 truncated] should: [:r | r = -2000000000]
		conformTo: #'number' selector: #'truncated'.
	self value: [2000000000 truncated] should: [:r | r = 2000000000]
		conformTo: #'number' selector: #'truncated'.
	self value: [0 truncated] should: [:r | r = 0]
		conformTo: #'number' selector: #'truncated'.!

testXtruncateToX
	" <number>#truncateTo: (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(2 0 0 2.0 2 2.000s3).
	1 to: numList size do: [ :ndx |
		self value: [smallInt2 truncateTo: (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'truncateTo:'
			ruleReceiver: smallInt2 operand: (numList at: ndx)
	].

	self should: [(0 truncateTo: smallInt2) = 0].! !

!IntegerANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
testXabs!public! !
testXaddOp!public! !
testXallMaskX!public! !
testXanyMaskX!public! !
testXasFloat!public! !
testXasFloatD!public! !
testXasFloatE!public! !
testXasFloatQ!public! !
testXasFraction!public! !
testXasInteger!public! !
testXasScaledDecimalX!public! !
testXbetweenXandX!public! !
testXbitAndX!public! !
testXbitAtX!public! !
testXbitAtXputX!public! !
testXbitOrX!public! !
testXbitShiftX!public! !
testXbitXorX!public! !
testXceiling!public! !
testXcopy!public! !
testXdenominator!public! !
testXdivideOp!public! !
testXequalityOp!public! !
testXeven!public! !
testXfactorial!public! !
testXfloor!public! !
testXfractionPart!public! !
testXgcdX!public! !
testXgreaterThanOp!public! !
testXgreaterThanOrEqualToOp!public! !
testXhash!public! !
testXhighBit!public! !
testXidentityHash!public! !
testXidentityOp!public! !
testXintegerDivideOp!public! !
testXintegerPart!public! !
testXisKindOfX!public! !
testXlcmX!public! !
testXlessThanOp!public! !
testXlessThanOrEqualToOp!public! !
testXmaxX!public! !
testXminX!public! !
testXmultiplyOp!public! !
testXnegated!public! !
testXnegative!public! !
testXnoMaskX!public! !
testXnotEqualityOp!public! !
testXnotIdentityOp!public! !
testXnumerator!public! !
testXodd!public! !
testXpositive!public! !
testXprintOnXbaseXshowRadixX!public! !
testXprintString!public! !
testXprintStringRadixX!public! !
testXquoX!public! !
testXraisedToIntegerX!public! !
testXraisedToX!public! !
testXreciprocal!public! !
testXremainderIntegerDivideOp!public! !
testXremX!public! !
testXrounded!public! !
testXroundToX!public! !
testXsign!public! !
testXsqrt!public! !
testXsquared!public! !
testXstrictlyPositive!public! !
testXsubtractOp!public! !
testXtoX!public! !
testXtoXbyX!public! !
testXtoXbyXdoX!public! !
testXtoXdoX!public! !
testXtruncated!public! !
testXtruncateToX!public! !
!

