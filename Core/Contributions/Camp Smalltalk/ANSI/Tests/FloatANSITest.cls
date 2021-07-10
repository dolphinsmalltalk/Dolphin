"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #FloatANSITest
	instanceVariableNames: 'smallInt2 largeNegInt2000000000 largePosInt2000000000 float2 fractionHalf sclDec2s3 numList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FloatANSITest guid: (GUID fromString: '{4d838c1d-796f-4138-9bb2-0776679222ae}')!
FloatANSITest comment: ''!
!FloatANSITest categoriesForClass!Unclassified! !
!FloatANSITest methodsFor!

canonicalObject
	^Float pi   "3.141592653589793"!

protocol
	^#'Float'!

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
	self should: [1.1e1 = 11.0].
	self should: [1.1d1 = 11.0].
	self should: [1.1q1 = 11.0].
	"Not ANSI conforming:"
#todo. "??? fix ???"
"	self shouldnt: [1.0q = 1.0].
	self shouldnt: [10e10 = 1.0].
"!

testXabs
	" <number>#abs (Return Values: <RECEIVER>) "
	| rcvr |
	#'Numeric'.
	rcvr := 2.0.
	self value: [rcvr abs] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := -2.0.
	self value: [rcvr abs] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := 0.0.
	self value: [rcvr abs] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.!

testXaddOp
	" <number>#+ (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(4.0 -1999999998.0 2000000002.0 4.0 2.5 4.0).
	1 to: numList size do: [ :ndx |
		self value: [float2 + (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'+'
			ruleReceiver: float2 operand: (numList at: ndx)
	].!

testXarcCos
	" <Float>#arcCos "
	#'Numeric'.!

testXarcSin
	" <Float>#arcSin "
	#'Numeric'.!

testXarcTan
	" <Float>#arcTan "
	#'Numeric'.!

testXasFloat
	" <number>#asFloat "
	#'Numeric'.
	self value: [2.0 asFloat] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [-2.0 asFloat] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloat'.
	self value: [0.0 asFloat] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloat'.!

testXasFloatD
	" <number>#asFloatD "
	#'Numeric'.
	self value: [2.0 asFloatD] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [-2.0 asFloatD] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [0.0 asFloatD] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatD'.!

testXasFloatE
	" <number>#asFloatE "
	#'Numeric'.
	self value: [2.0 asFloatE] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [-2.0 asFloatE] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [0.0 asFloatE] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatE'.!

testXasFloatQ
	" <number>#asFloatQ "
	#'Numeric'.
	self value: [2.0 asFloatQ] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [-2.0 asFloatQ] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [0.0 asFloatQ] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'asFloatQ'.!

testXasFraction
	" <number>#asFraction "
	#'Numeric'.
	self value: [2.0 asFraction] should: [:r | r = 2]
		conformTo: #'number' selector: #'asFraction'.
	self value: [-2.5 asFraction] should: [:r | r = (-5/2)]
		conformTo: #'number' selector: #'asFraction'.
	self value: [0.0 asFraction] should: [:r | r = 0]
		conformTo: #'number' selector: #'asFraction'.!

testXasInteger
	" <number>#asInteger "
	#'Numeric'.
	self value: [2.0 asInteger] should: [:r | r = 2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [2.1 asInteger] should: [:r | r = 2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [2.5 asInteger] should: [:r | r = 3]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2.0 asInteger] should: [:r | r = -2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2.1 asInteger] should: [:r | r = -2]
		conformTo: #'number' selector: #'asInteger'.
	self value: [-2.5 asInteger] should: [:r | r = -3]
		conformTo: #'number' selector: #'asInteger'.
	self value: [0.0 asInteger] should: [:r | r = 0]
		conformTo: #'number' selector: #'asInteger'.!

testXasScaledDecimalX
	" <number>#asScaledDecimal: "
	#'Numeric'.
	self value: [2.0 asScaledDecimal: 2]
		should: [:r | r = 2.0s2 & (r scale = 2)]
		conformTo: #'number' selector: #'asScaledDecimal:'.
	self value: [-2.0 asScaledDecimal: 2]
		should: [:r | r = -2.0s2 & (r scale = 2)]
		conformTo: #'number' selector: #'asScaledDecimal:'.
	self value: [0.0 asScaledDecimal: 2]
		should: [:r | r = 0.0s2 & (r scale = 2)]
		conformTo: #'number' selector: #'asScaledDecimal:'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver  and min or max are not comparable"

	self value: [2.0 between: 1 and: 3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [-2000000002.0 between: -2000000003 and: -2000000001]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2000000002.0 between: 2000000001 and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0 between: 1.0 and: 3.0]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0 between: (3/2) and: (5/2)]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0 between: 1.0s3 and: 3.0s3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	self value: [2.0 between: (3/2) and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0 between: -2000000001 and: 3.0s3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"Num between: Num and: Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx)
					between: (numList at: ndx)
					and: (numList at: ndx)]
			should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'
	].

	self value: [2.0 between: 3 and: 4]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [-2000000000.0 between: -2000000003 and: -2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2000000000.0 between: 2000000003 and: 2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0 between: 3.0 and: 5.0]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0 between: (5/2) and: (7/2)]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [2.0 between: 3.0s3 and: 5.0s3]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"??? min not min but max and vice versa -> false ???"
	self value: [2.0 between: 3 and: 1]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.!

testXceiling
	" <number>#ceiling "
	#'Numeric'.
	self value: [2.0 ceiling] should: [:r | r = 2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [2.1 ceiling] should: [:r | r = 3]
		conformTo: #'number' selector: #'ceiling'.
	self value: [2.5 ceiling] should: [:r | r = 3]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2.0 ceiling] should: [:r | r = -2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2.1 ceiling] should: [:r | r = -2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [-2.5 ceiling] should: [:r | r = -2]
		conformTo: #'number' selector: #'ceiling'.
	self value: [0.0 ceiling] should: [:r | r = 0]
		conformTo: #'number' selector: #'ceiling'.!

testXcopy
	" <Object>#copy (Return Values: <RECEIVER>) "
	#'Numeric'.
"	Return a new object that must be as similar as possible to the receiver in its initial state and behavior.  Any operation that changes the state of the new object should not as a side-effect change the state or behavior of the receiver.  Similarly, any change to the receiver should not as a side-effect change the new object.
	If the receiver is an identity object, return the receiver.
"
#todo. "??? add change-side-effect test ???"
	self value: [float2 copy] should: [:r | (r = float2) ]
		conformTo: #'Object' selector: #'copy' opRECEIVER: float2.!

testXcos
	" <Float>#cos "
	#'Numeric'.!

testXdegreesToRadians
	" <Float>#degreesToRadians "
	#'Numeric'.!

testXdivideOp
	" <number>#/ (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(1.0 -1.0e-9 1.0e-9 1.0 4.0  1.0).
	1 to: numList size do: [ :ndx |
		self value: [float2 / (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'/'
			ruleReceiver: float2 operand: (numList at: ndx)
	].

	self value: [0.0 / float2] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'/'
		ruleReceiver: float2 operand: 0.0!

testXequalityOp
	" <Float>#= "
	#'Numeric'.
"
	receiver = comparand	=>
	receiver hash = comparand hash
"
	self value: [float2 = float2]
		should: [:r | r & (float2 hash = float2 hash) ]
		conformTo: #'Float' selector: #'='.
	self value: [ float2 = 2.1 ]
		shouldnt: [ :r | r | (float2 hash = 2.1 hash) ]
		conformTo: #'Float' selector: #'='.

"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	self value: [ float2 = 2 ]
		should: [ :r | r  ifTrue: [ float2 hash = 2 hash ]
							ifFalse: [ float2 hash ~= 2 hash ]  ]
		conformTo: #'Float' selector: #'='.
	self value: [ -2000000000.0 = -2000000000 ]
		should: [ :r | r ifTrue: [ -2000000000.0 hash = -2000000000 hash ]
						ifFalse: [ -2000000000.0 hash ~= -2000000000 hash ]  ]
		conformTo: #'Float' selector: #'='.

	self value: [ 2000000000.0 = 2000000000 ]
		should: [ :r | r ifTrue: [ 2000000000.0 hash = 2000000000 hash ]
						ifFalse: [ 2000000000.0 hash ~= 2000000000 hash ]  ]
		conformTo: #'Float' selector: #'='.
	self value: [ 2.5 = (5/2) ]
		should: [ :r | r ifTrue: [ 2.5 hash = (5/2) hash ]
						ifFalse: [ 2.5 hash ~= (5/2) hash ]  ]
		conformTo: #'Float' selector: #'='.
	self value: [ float2 = 2.0s3 ]
		should: [ :r | r ifTrue: [ float2 hash = 2.0s3 hash ]
						ifFalse: [ float2 hash ~= 2.0s3 hash ]  ]
		conformTo: #'Float' selector: #'='.!

testXexp
	" <Float>#exp "
	#'Numeric'.!

testXfloor
	" <number>#floor "
	#'Numeric'.
	self value: [2.0 floor] should: [:r | r = 2]
		conformTo: #'number' selector: #'floor'.
	self value: [2.1 floor] should: [:r | r = 2]
		conformTo: #'number' selector: #'floor'.
	self value: [2.5 floor] should: [:r | r = 2]
		conformTo: #'number' selector: #'floor'.
	self value: [-2.0 floor] should: [:r | r = -2]
		conformTo: #'number' selector: #'floor'.
	self value: [-2.1 floor] should: [:r | r = -3]
		conformTo: #'number' selector: #'floor'.
	self value: [-2.5 floor] should: [:r | r = -3]
		conformTo: #'number' selector: #'floor'.
	self value: [0.0 floor] should: [:r | r = 0]
		conformTo: #'number' selector: #'floor'.!

testXfloorLogX
	" <Float>#floorLog: "
	#'Numeric'.!

testXfractionPart
	" <number>#fractionPart (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	"Within the limits of representation, the following invariants should hold:

		receiver integerPart + receiver fractionPart = receiver
		receiver \\1 = receiver fractionPart	(RAH - erroneous, add #'abs')
"
	rcvr := 26.5.
	self value: [rcvr fractionPart]
		should: [:r | r = 0.5 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := -26.5.
	self value: [rcvr fractionPart]
		should: [:r | r = -0.5 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := 26.0.
	self value: [rcvr fractionPart]
		should: [:r | r = 0.0 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := 0.0.
	self value: [rcvr fractionPart]
		should: [:r | r = 0.0 & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.!

testXgreaterThanOp
	" <number>#> "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small > Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3 > tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [-2000000005.0 > -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [0.25 > (1/2)] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.

	"Num > Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) > (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'>'
	].

	"Big > Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0 > tstNum] should: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [9000000000.0 > 2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [-1000000005.0 > -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [9.0 > (1/2)] should: [:r | r] conformTo: #'number' selector: #'>'.!

testXgreaterThanOrEqualToOp
	" <magnitude>#>= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver and operand are not comparable."

	"Small >= Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3 >= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [-2000000005.0 >= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [0.25 >= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.

	"Num >= Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) >= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'>='
	].

	"Big >= Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0 >= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [9000000000.0 >= 2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [-1000000005.0 >= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [9.0 >= (1/2)] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.!

testXhash
	" <Object>#hash "
	#'Numeric'.
"	Any two objects that are considered equivalent using the #= message must have the same hash value.  More formally:

	receiver = comparand	=>
	receiver hash = comparand hash
"
	self value: [float2 hash]
		should: [:r | r = float2 hash] conformTo: #'Object' selector: #'hash'.
	self value: [float2 hash]
		shouldnt: [:r | r = 2.1 hash] conformTo: #'Object' selector: #'hash'.!

testXidentityHash
	" <Object>#identityHash "
	#'Numeric'.
	self value: [float2 identityHash]
		should: [:r | r = float2 identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [float2 identityHash]
		shouldnt: [:r | r = 2.1 identityHash]
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

	self value: [float2 == float2]
		should: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [float2 == 2.1]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.!

testXintegerDivideOp
	" <number>#// "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	"The sign of the result is positive if the receiver and operand
		have the same sign, and negative if the signs are different."
	retVals := #(1 -1 0 1 4 1).
	1 to: numList size do: [ :ndx |
		self value: [float2 // (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'.
	].

	retVals := #(-1 0 -1 -1 -4 -1).
	1 to: numList size do: [ :ndx |
		self value: [float2 // ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'
	].


	self should: [25.5 // 5.1 = 5].
	self should: [25.5 // 5 = 5].
	self should: [25500000000.5 // 5000000000 = 5].
	self should: [-25500000000.5 // -5000000000 = 5].
	self should: [25.5 // (51/10) = 5].
	self should: [25.5 // 5.1s1 = 5].

	self value: [0.0 // float2] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'//'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [float2 // 0.0] shouldRaise: ZeroDivide.!

testXintegerPart
	" <number>#integerPart (returnRule - :receiver) "
	| rcvr |
	#'Numeric'.
	rcvr := 2.5.
	self value: [rcvr integerPart] should: [:result | result = 2.0]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := 2.0.
	self value: [rcvr integerPart] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := -2.0.
	self value: [rcvr integerPart] should: [:result | result = -2.0]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := 0.0.
	self value: [rcvr integerPart] should: [:result | result = 0.0]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.!

testXisKindOfX
	" <Object>#isKindOf: "
	#'Numeric'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
#todo. "Fix find a test for unspecified rule above ???"
	self value: [float2 isKindOf: Float]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Metaclass tests:"
	self value: [float2 class isKindOf: (Float class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Inherit tests:"
	self value: [float2 class isKindOf: (Number class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	self value: [float2 isKindOf: Symbol]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.!

testXisMemberOfX
	" <Object>#isMemberOf: "
	#'Numeric'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
		#'Fundamental'.
#todo. "Fix find a test for unspecified rule above ???"
	self value: [float2 isMemberOf: FloatD]
		should: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	"Metaclass tests:"
	self value: [float2 class isMemberOf: (FloatD class)]
		should: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	"Fail inherit tests:"
	self value: [float2 class isMemberOf: (Number class)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	self value: [float2 isMemberOf: Symbol]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.!

testXlessThanOp
	" <number>#< "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small < Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3 < tstNum] should: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [-2000000005.0 < -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [0.25 < (1/2)] should: [:r | r] conformTo: #'number' selector: #'<'.

	"Num < Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) < (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'<'
	].

	"Big < Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0 < tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [9000000000.0 < 2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [-1000000005.0 < -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [9.0 < (1/2)] shouldnt: [:r | r] conformTo: #'number' selector: #'<'.!

testXlessThanOrEqualToOp
	" <magnitude>#<= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small <= Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [0.3 <= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [-2000000005.0 <= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [0.25 <= (1/2)] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.

	"Num <= Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) <= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'<='
	].

	"Big <= Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [5.0 <= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [9000000000.0 <= 2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [-1000000005.0 <= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [9.0 <= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.!

testXln
	" <Float>#ln "
	#'Numeric'.!

testXlogX
	" <Float>#log: "
	#'Numeric'.!

testXmaxX
	" <magnitude>#max: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver and operand are not comparable."

	self value: [2.0 max: 3] should: [:r | r = 3]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [-3000000000.0 max: -2000000000] should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2000000000.0 max: 2000000003] should: [:r | r = 2000000003]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2.0 max: 3.0] should: [:r | r = 3.0]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2.0 max: (5/2)] should: [:r | r = (5/2)]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [2.0 max: 3.0s3] should: [:r | r = 3.0s3]
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

	self value: [2.0 min: 1] should: [:r | r = 1]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [-1000000000.0 min: -2000000000] should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2000000003.0 min: 2000000001] should: [:r | r = 2000000001]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2.0 min: 1.0] should: [:r | r = 1.0]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2.0 min: (3/2)] should: [:r | r = (3/2)]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [2.0 min: 1.0s5] should: [:r | r = 1.0s5]
		conformTo: #'magnitude' selector: #'min:'.

	"Num min: Num -> Num"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) min: (numList at: ndx)]
			should: [:r | r = (numList at: ndx)]
			conformTo: #'magnitude' selector: #'min:'
	].!

testXmultiplyOp
	" <number>#* (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(4.0 -4000000000.0 4000000000.0 4.0 1.0 4.0).
	1 to: numList size do: [ :ndx |
		self value: [float2 * (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'*'
			ruleReceiver: float2 operand: (numList at: ndx)
	].!

testXnegated
	" <number>#negated (Return Values: <RECEIVER>) "
	| rcvr |
	#'Numeric'.
	rcvr := 2.0.
	self value: [rcvr negated] should: [:r | r = -2.0]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.
	rcvr := -2.0.
	self value: [rcvr negated] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.
	rcvr := 0.0.
	self value: [rcvr negated] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.!

testXnegative
	" <number>#negative "
	#'Numeric'.
	self value: [-2.0 negative] should: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [2.0 negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [0.0 negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.!

testXnotIdentityOp
	" <Object>#~~ "
	#'Numeric'.
"	The value of receiver ~~ comparand is true if and only if the value of comparand ~~ receiver would also be true.
"
	self should: [smallInt2 ~~ float2 and: [float2 ~~ smallInt2]].

	self value: [float2 ~~ 2.1] should: [:r | r]
		conformTo: #'Object' selector: #'~~'.

	self value: [float2 ~~ float2] shouldnt: [:r | r]
		conformTo: #'Object' selector: #'~~'.!

testXpositive
	" <number>#positive "
	#'Numeric'.
	self value: [2.0 positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [0.0 positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [-2.0 positive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'positive'.!

testXprintString
	" <Float>#printString "
	#'Numeric'.
	"Answer a string which is a valid Smalltalk literal representation approximately equal to the receiver. An exponent literal form is produced if the value of the exponent is greater than the precision of the receiver."

	self value: [(2.0e0 raisedToInteger: 1.0e0 class precision + 1) printString ]
		should: [:r | r includes: $e ]
		conformTo: #'Float' selector: #'printString'.
	self value: [(-2.0e0 raisedToInteger: 1.0e0 class precision + 1) printString ]
		should: [:r | r includes: $e ]
		conformTo: #'Float' selector: #'printString'.
	self value: [(2.0e0 raisedToInteger: -1 - 1.0e0 class precision) printString ]
		should: [:r | r includes: $e ]
		conformTo: #'Float' selector: #'printString'.
	self value: [(-2.0e0 raisedToInteger: -1 - 1.0e0 class precision) printString ]
		 should: [:r | r includes: $e ]
		conformTo: #'Float' selector: #'printString'!

testXquoX
	" <number>#quo: "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(1 0 0 1 4 1 ).
	1 to: numList size do: [ :ndx |
		self value: [float2 quo: (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'.
	].

	retVals := #(-1 0 0 -1 -4 -1 ).
	1 to: numList size do: [ :ndx |
		self value: [float2 quo: ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'
	].

	self should: [(25.5 quo: 5.1) = 5].
	self should: [(25.5 quo: 5) = 5].
	self should: [(25500000000.5 quo: 5000000000) = 5].
	self should: [(-25500000000.5 quo: -5000000000) = 5].
	self should: [(25.5 quo: (51/10)) = 5].
	self should: [(25.5 quo: 5.1s1) = 5].

	self value: [0.0 quo: float2] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'quo:'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [float2 quo: 0.0] shouldRaise: ZeroDivide.!

testXradiansToDegrees
	" <Float>#radiansToDegrees "
	#'Numeric'.!

testXraisedToIntegerX
	" <number>#raisedToInteger: (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 5.1.
	self value: [rcvr raisedToInteger: 0] should: [:r | r = 1.0]
		conformTo: #'number' selector: #'raisedToInteger:' opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: 1] should: [:r | r = rcvr]
		conformTo: #'number' selector: #'raisedToInteger:' opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: 2] should: [:r | r closeTo: 26.01]
		conformTo: #'number' selector: #'raisedToInteger:' opRECEIVER: rcvr.

	self value: [rcvr negated raisedToInteger: 2] should: [:r | r closeTo: 26.01]
		conformTo: #'number' selector: #'raisedToInteger:' opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: -2]
		should: [:r | r closeTo: 0.0384467512495194]
		conformTo: #'number' selector: #'raisedToInteger:' opRECEIVER: rcvr.!

testXraisedToX
	" <number>#raisedTo: "

	| numVals retVals |
	#Numeric.
	numVals := #(2 2.0 0 2.0s3) copy.
	numVals at: 3 put: 1 / 2.
	retVals := #(4.0 4.0 1.414213562373095 4.0).
	1 to: numVals size
		do: 
			[:ndx | 
			self 
				value: [float2 raisedTo: (numVals at: ndx)]
				should: [:r | r closeTo: (retVals at: ndx)]
				conformTo: #number
				selector: #raisedTo:].
	retVals := #(0.25 0.25 0.7071067811865475 0.25).
	1 to: numVals size
		do: 
			[:ndx | 
			self 
				value: [float2 raisedTo: (numVals at: ndx) negated]
				should: [:r | r closeTo: (retVals at: ndx)]
				conformTo: #number
				selector: #raisedTo:].
	self 
		value: [float2 raisedTo: 0.0]
		should: [:r | r = 1.0]
		conformTo: #number
		selector: #raisedTo:.
	self 
		value: [0.0 raisedTo: float2]
		should: [:r | r = 0.0]
		conformTo: #number
		selector: #raisedTo:.
	self 
		value: [float2 raisedTo: 1.0]
		should: [:r | r = float2]
		conformTo: #number
		selector: #raisedTo:.

	"It is erroneous if the receiver equals zero
		and the operand is less than or equal to zero,"
	self value: [0.0 raisedTo: -2] shouldRaise: Error.

	"	or if the receiver is less than zero."
	#bsm.	"I believe this test to be incorrect, the receive can be negative as long as the argument is even."
	false ifTrue: [self value: [float2 negated raisedTo: 2.0] shouldRaise: Error]!

testXreciprocal
	" <number>#reciprocal (returnRule - :receiver) "
	#'Numeric'.
	self value: [float2 reciprocal] should: [:r | r = (1.0/float2)]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: float2.

	self value: [float2 negated reciprocal]
		should: [:r | r = (1.0/(float2 negated))]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: (float2 negated).

	"Signal a ZeroDivide exception if the receiver is equal to zero."
	self value: [0.0 reciprocal] shouldRaise: ZeroDivide.!

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
	retVals := #(1.0 4.0 1.0 1.0 1.5 1.0 ).
	ndx := 0.
	recList do: [ :rec |
		ndx := ndx + 1.
		self value: [rec \\ 5.0]
			should: [:r | r = (retVals at: ndx)
					& ((rec // 5.0) * 5.0 + (rec \\ 5.0) = rec)]
			conformTo: #'number' selector: #'\\'
			ruleReceiver: rec operand:  5.0.
	].

	"The remainder has the same sign as operand."
	retVals := #(-4.0 -1.0 -4.0 -4.0 -3.5 -4.0 ).
	ndx := 0.
	recList do: [ :rec |
		ndx := ndx + 1.
		self value: [rec \\ -5.0]
			should: [:r | r = (retVals at: ndx)
					& ((rec // -5.0) * -5.0 + (rec \\ -5.0) = rec)]
			conformTo: #'number' selector: #'\\'
			ruleReceiver: rec operand:  -5.0.
	].

	self should: [26.5 \\ 5.0 = 1.5 & ((26.5 // 5.0) * 5.0 + (26.5 \\ 5.0) = 26.5)].
	self should: [26.5 \\ -5.0 = -3.5
					& ((26.5 // -5.0) * -5.0 + (26.5 \\ -5.0) = 26.5)].

	self should: [0.0 \\ float2 = 0.0].

	"If the operand is zero, the implementation may signal
		the ZeroDivide exception or provide a continuation value."
	self value: [float2 \\ 0.0] shouldRaise: ZeroDivide.!

testXremX
	" <number>#rem: "
	| num2 flt |
	#'Numeric'.
	"Within the limits of representation, the following invariant should hold:
		(receiver quo: operand)*operand + (receiver rem: operand) = receiver"
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	numList := #( 5 5.0 5.0s3 ).
	flt := 26.5.
	numList do: [ :num |
		self value: [flt rem: num]
			should: [:r | r = 1.5
					& ((flt quo: num) * num + (flt rem: num) = flt)]
			conformTo: #'number' selector: #'rem:'
	].

	numList := numList collect: [ :num | num negated ].
	numList do: [ :num |
		self value: [flt rem: num]
			should: [:r | r = 1.5
					& ((flt quo: num) * num + (flt rem: num) = flt)]
			conformTo: #'number' selector: #'rem:'
	].

	numList := #( 5 5.0 5.0s3 ).
	flt := -26.5.
	numList do: [ :num |
		self should: [(flt rem: num) = -1.5
				& ((flt quo: num) * num + (flt rem: num) = flt)]
	].

	numList := numList collect: [ :num | num negated ].
	numList do: [ :num |
		self should: [(flt rem: num) = -1.5
					& ((flt quo: num) * num + (flt rem: num) = flt)]
	].

	flt := 26.5.
	num2 := (5/2).
	self value: [flt rem: num2]
		should: [:r | r = 1.5
				& ((flt quo: num2) * num2 + (flt rem: num2) = flt)]
		conformTo: #'number' selector: #'rem:'.

	numList := #( -2000000000 2000000000 ).
	flt :=  10000000001.5.
	numList do: [ :num |
		self value: [flt rem: num]
			should: [:r | r = 1.5
					& ((flt quo: num) * num + (flt rem: num) = flt)]
			conformTo: #'number' selector: #'rem:'
	].

	"If either the receiver or operand are of type <Float> and the operand has a value of zero, the result is implementation defined.  The implementation may signal the ZeroDivide exception or provide a continuation value "
	self value: [float2 rem: 0.0] shouldRaise: ZeroDivide.
	self value: [float2 rem: 0] shouldRaise: ZeroDivide.
	self value: [2 rem: 0.0] shouldRaise: ZeroDivide.!

testXrounded
	" <number>#rounded "
	#'Numeric'.
	self value: [2.0 rounded] should: [:r | r = 2]
		conformTo: #'number' selector: #'rounded'.
	self value: [2.1 rounded] should: [:r | r = 2]
		conformTo: #'number' selector: #'rounded'.
	self value: [2.5 rounded] should: [:r | r = 3]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2.0 rounded] should: [:r | r = -2]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2.1 rounded] should: [:r | r = -2]
		conformTo: #'number' selector: #'rounded'.
	self value: [-2.5 rounded] should: [:r | r = -3]
		conformTo: #'number' selector: #'rounded'.
	self value: [0.0 rounded] should: [:r | r = 0]
		conformTo: #'number' selector: #'rounded'.!

testXsign
	" <number>#sign "
	#'Numeric'.
	self value: [2.0 sign] should: [:r | r = 1]
		conformTo: #'number' selector: #'sign'.
	self value: [0.0 sign] should: [:r | r = 0]
		conformTo: #'number' selector: #'sign'.
	self value: [-2.0 sign] should: [:r | r = -1]
		conformTo: #'number' selector: #'sign'.!

testXsin
	" <Float>#sin "
	#'Numeric'.!

testXsqrt
	" <number>#sqrt "
	#'Numeric'.
	self value: [26.01 sqrt] should: [:r | r closeTo: 5.1]
		conformTo: #'number' selector: #'sqrt'.
	self value: [4.0 sqrt] should: [:r | r = 2.0]
		conformTo: #'number' selector: #'sqrt'.
	self value: [0.0 sqrt] should: [:r | r =  0.0]
		conformTo: #'number' selector: #'sqrt'!

testXsquared
	" <number>#squared (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 5.1.
	self value: [rcvr squared] should: [:r | r closeTo: 26.01]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

	rcvr := -5.1.
	self value: [rcvr squared] should: [:r | r closeTo: 26.01]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.
	rcvr := 0.0.
	self value: [rcvr squared] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.!

testXstrictlyPositive
	" <number>#strictlyPositive "
	#'Numeric'.
	self value: [2.0 strictlyPositive] should: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.

	self value: [0.0 strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.
	self value: [-2.0 strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.!

testXsubtractOp
	" <number>#- (returnRule - :receiver :operand) "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #(0.0 2000000002.0 -1999999998.0 0.0 1.5 0.0).
	1 to: numList size do: [ :ndx |
		self value: [float2 - (numList at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'-'
			ruleReceiver: float2 operand: (numList at: ndx)
	].!

testXtan
	" <Float>#tan "
	#'Numeric'.!

testXtoX
	" <number>#to: "

	| start middleNdx stop2 |
	#Numeric.
	start := 1.0.
	numList := #(2 2.0 0 2.0s3) copy.
	numList at: 3 put: 5 / 2.
	numList do: 
			[:stop | 
			self 
				value: [start to: stop]
				should: 
					[:r | 
					r size = 2 & (r last = (start + ((stop - start) // 1))) 
						& (r allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #Float])
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
						with: (r at: 3)) allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #Float])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.
	start := -2000000000.0.
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
						with: (r at: 3)) allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #Float])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.

	"The interval answered will be empty if the receiver is greater than stop."
	self 
		value: [1.0 to: -1.0]
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
	self value: [2.0 truncated] should: [:r | r = 2]
		conformTo: #'number' selector: #'truncated'.
	self value: [2.1 truncated] should: [:r | r = 2]
		conformTo: #'number' selector: #'truncated'.
	self value: [2.5 truncated] should: [:r | r = 2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2.0 truncated] should: [:r | r = -2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2.1 truncated] should: [:r | r = -2]
		conformTo: #'number' selector: #'truncated'.
	self value: [-2.5 truncated] should: [:r | r = -2]
		conformTo: #'number' selector: #'truncated'.
	self value: [0.0 truncated] should: [:r | r = 0]
		conformTo: #'number' selector: #'truncated'.! !
!FloatANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
testLiterals!public! !
testXabs!public! !
testXaddOp!public! !
testXarcCos!public! !
testXarcSin!public! !
testXarcTan!public! !
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
testXcos!public! !
testXdegreesToRadians!public! !
testXdivideOp!public! !
testXequalityOp!public! !
testXexp!public! !
testXfloor!public! !
testXfloorLogX!public! !
testXfractionPart!public! !
testXgreaterThanOp!public! !
testXgreaterThanOrEqualToOp!public! !
testXhash!public! !
testXidentityHash!public! !
testXidentityOp!public! !
testXintegerDivideOp!public! !
testXintegerPart!public! !
testXisKindOfX!public! !
testXisMemberOfX!public! !
testXlessThanOp!public! !
testXlessThanOrEqualToOp!public! !
testXln!public! !
testXlogX!public! !
testXmaxX!public! !
testXminX!public! !
testXmultiplyOp!public! !
testXnegated!public! !
testXnegative!public! !
testXnotIdentityOp!public! !
testXpositive!public! !
testXprintString!public! !
testXquoX!public! !
testXradiansToDegrees!public! !
testXraisedToIntegerX!public! !
testXraisedToX!public! !
testXreciprocal!public! !
testXremainderIntegerDivideOp!public! !
testXremX!public! !
testXrounded!public! !
testXsign!public! !
testXsin!public! !
testXsqrt!public! !
testXsquared!public! !
testXstrictlyPositive!public! !
testXsubtractOp!public! !
testXtan!public! !
testXtoX!public! !
testXtoXbyX!public! !
testXtoXbyXdoX!public! !
testXtoXdoX!public! !
testXtruncated!public! !
!

