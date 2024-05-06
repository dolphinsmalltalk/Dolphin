"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #FractionANSITest
	instanceVariableNames: 'smallInt2 largeNegInt2000000000 largePosInt2000000000 float2 fractionHalf sclDec2s3 numList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FractionANSITest guid: (GUID fromString: '{e0b31193-571f-4628-a0fb-3c93132af2c3}')!

FractionANSITest comment: ''!

!FractionANSITest categoriesForClass!Unclassified! !

!FractionANSITest methodsFor!

canonicalObject
	^1/3!

protocol
	^#'Fraction'!

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
	rcvr := 1/2.
	self value: [rcvr abs] should: [:r | r = (1/2)]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.
	rcvr := -1/2.
	self value: [rcvr abs] should: [:r | r = (1/2)]
		conformTo: #'number' selector: #'abs' opRECEIVER: rcvr.!

testXasFloat
	" <number>#asFloat "
	#'Numeric'.
	self value: [(1/2) asFloat] should: [:r | r = 0.5]
		conformTo: #'number' selector: #'asFloat'.
	self value: [(-1/2) asFloat] should: [:r | r = -0.5]
		conformTo: #'number' selector: #'asFloat'.!

testXasFloatD
	" <number>#asFloatD "
	#'Numeric'.
	self value: [(1/2) asFloatD] should: [:r | r = 0.5]
		conformTo: #'number' selector: #'asFloatD'.
	self value: [(-1/2) asFloatD] should: [:r | r = -0.5]
		conformTo: #'number' selector: #'asFloatD'.!

testXasFloatE
	" <number>#asFloatE "
	#'Numeric'.
	self value: [(1/2) asFloatE] should: [:r | r = 0.5]
		conformTo: #'number' selector: #'asFloatE'.
	self value: [(-1/2) asFloatE] should: [:r | r = -0.5]
		conformTo: #'number' selector: #'asFloatE'.!

testXasFloatQ
	" <number>#asFloatQ "
	#'Numeric'.
	self value: [(1/2) asFloatQ] should: [:r | r = 0.5]
		conformTo: #'number' selector: #'asFloatQ'.
	self value: [(-1/2) asFloatQ] should: [:r | r = -0.5]
		conformTo: #'number' selector: #'asFloatQ'.!

testXasFraction
	" <number>#asFraction "
	#'Numeric'.
	self value: [(1/2) asFraction] should: [:r | r = (1/2)]
		conformTo: #'number' selector: #'asFraction'.
	self value: [(-1/2) asFraction] should: [:r | r = (-1/2)]
		conformTo: #'number' selector: #'asFraction'.!

testXasInteger
	" <number>#asInteger "
	#'Numeric'.
	self value: [(1/3) asInteger] should: [:r | r = 0]
		conformTo: #'number' selector: #'asInteger'.
	self value: [(1/2) asInteger] should: [:r | r = 1]
		conformTo: #'number' selector: #'asInteger'.
	self value: [(-1/2) asInteger] should: [:r | r = -1]
		conformTo: #'number' selector: #'asInteger'.!

testXasScaledDecimalX
	" <number>#asScaledDecimal: "
	#'Numeric'.
	self value: [(1/2) asScaledDecimal: 2]
		should: [:r | r = 0.5s2 & (r scale = 2)]
		conformTo: #'number' selector: #'asScaledDecimal:'.
	self value: [(-1/2) asScaledDecimal: 2]
		should: [:r | r = -0.5s2 & (r scale = 2)]
		conformTo: #'number' selector: #'asScaledDecimal:'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver  and min or max are not comparable"

	self value: [(1/2) between: 0 and: 3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/ -2) between: -2000000003 and: 0]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: 0 and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: 0.0 and: 3.0]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: (1/4) and: (5/2)]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: 0.0s3 and: 3.0s3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	self value: [(1/2) between: -2000000001 and: 2000000003]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: 0.0 and: 3.0s3]
		should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"Num between: Num and: Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx)
					between: (numList at: ndx)
					and: (numList at: ndx)]
			should: [:r | r] conformTo: #'magnitude' selector: #'between:and:'
	].

	self value: [(1/2) between: 3 and: 4]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: -2000000003 and: -2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: 2000000003 and: 2000000005]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: 3.0 and: 5.0]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: (5/2) and: (7/2)]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.
	self value: [(1/2) between: 3.0s3 and: 5.0s3]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.

	"??? min not min but max and vice versa -> false ???"
	self value: [(1/2) between: 3 and: 1]
		shouldnt: [:r | r] conformTo: #'magnitude' selector: #'between:and:'.!

testXceiling
	" <number>#ceiling "
	#'Numeric'.
	self value: [(1/3) ceiling] should: [:r | r = 1]
		conformTo: #'number' selector: #'ceiling'.
	self value: [(1/2) ceiling] should: [:r | r = 1]
		conformTo: #'number' selector: #'ceiling'.
	self value: [(-1/2) ceiling] should: [:r | r = 0]
		conformTo: #'number' selector: #'ceiling'.!

testXcopy
	" <Object>#copy (Return Values: <RECEIVER>) "
	#'Numeric'.
"	Return a new object that must be as similar as possible to the receiver in its initial state and behavior.  Any operation that changes the state of the new object should not as a side-effect change the state or behavior of the receiver.  Similarly, any change to the receiver should not as a side-effect change the new object.
	If the receiver is an identity object, return the receiver.
"
#todo. "??? add change-side-effect test ???"
	self value: [fractionHalf copy]
		should: [:r | (r = fractionHalf) ]
		conformTo: #'Object' selector: #'copy' opRECEIVER: fractionHalf.!

testXdenominator
	" <Fraction>#denominator "
	#'Numeric'.!

testXequalityOp
	" <number>#= "
	#'Numeric'.
"	receiver = comparand	=>
	receiver hash = comparand hash
"
	self value: [fractionHalf = fractionHalf]
		should: [:r | r & (fractionHalf hash = fractionHalf hash) ]
		conformTo: #'number' selector: #'='.
	self value: [ fractionHalf = (5/2) ]
		shouldnt: [ :r | r | (fractionHalf hash = (5/2) hash) ]
		conformTo: #'number' selector: #'='.

"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	self value: [ fractionHalf = 2 ]
		should: [ :r | r  ifTrue: [ fractionHalf hash = 2 hash ]
							ifFalse: [ fractionHalf hash ~= 2 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ fractionHalf = -2000000000 ]
		should: [ :r | r ifTrue: [ fractionHalf hash = -2000000000 hash ]
						ifFalse: [ fractionHalf hash ~= -2000000000 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ fractionHalf = 2000000000 ]
		should: [ :r | r ifTrue: [ fractionHalf hash = 2000000000 hash ]
						ifFalse: [ fractionHalf hash ~= 2000000000 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ fractionHalf = 0.5 ]
		should: [ :r | r ifTrue: [ fractionHalf hash = 0.5 hash ]
						ifFalse: [ fractionHalf hash ~= 0.5 hash ]  ]
		conformTo: #'number' selector: #'='.
	self value: [ fractionHalf = 0.5s3 ]
		should: [ :r | r ifTrue: [ fractionHalf hash = 0.5s3 hash ]
						ifFalse: [ fractionHalf hash ~= 0.5s3 hash ]  ]
		conformTo: #'number' selector: #'='.!

testXfloor
	" <number>#floor "
	#'Numeric'.
	self value: [(1/3) floor] should: [:r | r = 0]
		conformTo: #'number' selector: #'floor'.
	self value: [(1/2) floor] should: [:r | r = 0]
		conformTo: #'number' selector: #'floor'.
	self value: [(3/2) floor] should: [:r | r = 1]
		conformTo: #'number' selector: #'floor'.
	self value: [(-1/2) floor] should: [:r | r = -1]
		conformTo: #'number' selector: #'floor'.!

testXfractionPart
	" <number>#fractionPart (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	"Within the limits of representation, the following invariants should hold:

		receiver integerPart + receiver fractionPart = receiver
		receiver \\1 = receiver fractionPart	(RAH - erroneous, add #'abs')
"
	rcvr := (3/2).
	self value: [rcvr fractionPart]
		should: [:r | r = (1/2) & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.

	rcvr := (-3/2).
	self value: [rcvr fractionPart]
		should: [:r | r = (-1/2) & (rcvr integerPart + rcvr fractionPart = rcvr)
					& (rcvr \\ 1 = rcvr fractionPart abs)]
		conformTo: #'number' selector: #'fractionPart' opRECEIVER: rcvr.!

testXgreaterThanOp
	" <number>#> "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small > Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(1/3) > tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [(-9000000005/3) > -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [(1/4) > (1/2)] shouldnt: [:r | r]
		conformTo: #'number' selector: #'>'.

	"Num > Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) > (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'>'
	].

	"Big > Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(11/2) > tstNum] should: [:r | r]
			conformTo: #'number' selector: #'>'
	].
	self value: [(9000000005/3) > 2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [(-1000000005/3) > -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'>'.
	self value: [(11/2) > (1/2)] should: [:r | r]
		conformTo: #'number' selector: #'>'.!

testXgreaterThanOrEqualToOp
	" <magnitude>#>= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small >= Big -> false"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(1/3) >= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [(-9000000005/3) >= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [(1/4) >= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'>='.

	"Num >= Num -> true"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) >= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'>='
	].

	"Big >= Small -> true"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(11/2) >= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'>='
	].
	self value: [(9000000005/3) >= 2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [(-1000000005/3) >= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.
	self value: [(11/2) >= (1/2)] should: [:r | r]
		conformTo: #'magnitude' selector: #'>='.!

testXhash
	" <Object>#hash "
	#'Numeric'.
"	Any two objects that are considered equivalent using the #= message must have the same hash value.  More formally:

	receiver = comparand	=>
	receiver hash = comparand hash
"
#'testAnom'. "??? <Object> test of equivalence seems to confilict
				with <Number> convert then test.
	self shouldnt: [smallInt2 = float2].
	self shouldnt: [smallInt2 hash = float2 hash].
 ???"
	self value: [fractionHalf hash]
		should: [:r | r = fractionHalf hash]
		conformTo: #'Object' selector: #'hash'.

	self value: [fractionHalf hash]
		shouldnt: [:r | r = (2/3) hash] conformTo: #'Object' selector: #'hash'.!

testXidentityHash
	" <Object>#identityHash "
	#'Numeric'.
	self value: [fractionHalf identityHash]
		should: [:r | r = fractionHalf identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [smallInt2 identityHash]
		should: [:r | r = (4/2) identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [fractionHalf identityHash]
		shouldnt: [:r | r = (2/3) identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [smallInt2 identityHash]
		shouldnt: [:r | r = (6/2) identityHash]
		conformTo: #'Object' selector: #'identityHash'.!

testXidentityOp
	" <Object>#== "
	#'Numeric'.
"	The value of receiver == comparand is true if and only if the value of comparand == receiver would also be true. If the value of receiver == comparand is true then the receiver and comparand must have equivalent identity hash values.  Or more formally:

	receiver == comparand =>
	receiver identityHash = comparand identityHash
"
	self value: [fractionHalf == fractionHalf]
		should: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [smallInt2 == (4/2)]
		should: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [fractionHalf == (2/3)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [smallInt2 == (6/2)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.!

testXintegerDivideOp
	" <number>#// "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	"The sign of the result is positive if the receiver and operand
		have the same sign, and negative if the signs are different."
	retVals := #(666666666 -1 0 666666666 2666666666 666666666 ).
	1 to: numList size do: [ :ndx |
		self value: [(4000000000/3) // (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'.
	].

"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #( -666666667 0 -1 -666666667 -2666666667 -666666667 ).
	1 to: numList size do: [ :ndx |
		self value: [(4000000000/3) // ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'//'
	].

	self should: [(256/5) // (50/5) = 5].

	self should: [(126/5) // 5 = 5].
	self should: [(125000000001/5) // 5000000000 = 5].
	self should: [(-125000000001/5) // -5000000000 = 5].
	self should: [(131/5) // 5.1 = 5].
	self should: [(131/5) // 5.1s1 = 5].

	self value: [0 // fractionHalf] should: [:r | r = 0]
		conformTo: #'number' selector: #'//'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [fractionHalf // 0] shouldRaise: ZeroDivide.!

testXintegerPart
	" <number>#integerPart (returnRule - :receiver) "
	| rcvr |
	#'Numeric'.
	rcvr := (1/2).
	self value: [rcvr integerPart] should: [:result | result = 0]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := (3/2).
	self value: [rcvr integerPart] should: [:result | result = 1]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.

	rcvr := (-3/2).
	self value: [rcvr integerPart] should: [:result | result = -1]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: rcvr.!

testXisKindOfX
	" <Object>#isKindOf: "
	#'Numeric'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
#todo. "Fix find a test for unspecified rule above ???"
	self value: [fractionHalf isKindOf: Fraction]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Metaclass tests:"
	self value: [fractionHalf class isKindOf: (Fraction class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Inherit tests:"
	self value: [fractionHalf class isKindOf: (Number class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	self value: [fractionHalf isKindOf: Symbol]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.!

testXisMemberOfX
	" <Object>#isMemberOf: "
	#'Numeric'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
#todo. "Fix find a test for unspecified rule above ???"
	self value: [fractionHalf isMemberOf: Fraction]
		should: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	"Metaclass tests:"
	self value: [fractionHalf class isMemberOf: (Fraction class)]
		should: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	"Fail inherit tests:"
	self value: [fractionHalf class isMemberOf: (Number class)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	self value: [fractionHalf isMemberOf: Float]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.!

testXlessThanOp
	" <number>#< "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small < Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(1/3) < tstNum] should: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [(-9000000005/3) < -2000000000] should: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [(1/4) < (1/2)] should: [:r | r]
		conformTo: #'number' selector: #'<'.

	"Num < Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) < (numList at: ndx)]
			shouldnt: [:r | r ] conformTo: #'number' selector: #'<'
	].

	"Big < Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(11/2) < tstNum] shouldnt: [:r | r]
			conformTo: #'number' selector: #'<'
	].
	self value: [(9000000005/3) < 2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [(-1000000005/3) < -2000000000] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.
	self value: [(11/2) < (1/2)] shouldnt: [:r | r]
		conformTo: #'number' selector: #'<'.!

testXlessThanOrEqualToOp
	" <magnitude>#<= "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."

#'todo'."It is erroneous if the receiver and operand are not comparable."
	"Small <= Big -> true"
	#( 2 2000000000 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(1/3) <= tstNum] should: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [(-9000000005/3) <= -2000000000] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [(1/4) <= (1/2)] should: [:r | r]
		conformTo: #'magnitude' selector: #'<='.

	"Num <= Num -> false"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) <= (numList at: ndx)]
			should: [:r | r ] conformTo: #'magnitude' selector: #'<='
	].

	"Big <= Small -> false"
	#( 2 2.0 2.0s3 ) do: [ :tstNum |
		self value: [(11/2) <= tstNum] shouldnt: [:r | r]
			conformTo: #'magnitude' selector: #'<='
	].
	self value: [(9000000005/3) <= 2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [(-1000000005/3) <= -2000000000] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.
	self value: [(11/2) <= (1/2)] shouldnt: [:r | r]
		conformTo: #'magnitude' selector: #'<='.!

testXmaxX
	" <magnitude>#max: "
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
#'todo'."It is erroneous if the receiver and operand are not comparable."

	self value: [(1/2) max: 3] should: [:r | r = 3]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [(-9000000000/2) max: -2000000000]
		should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [(1/2) max: 2000000003] should: [:r | r = 2000000003]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [(1/2) max: 3.0] should: [:r | r = 3.0]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [(1/2) max: (5/2)] should: [:r | r = (5/2)]
		conformTo: #'magnitude' selector: #'max:'.
	self value: [(1/2) max: 3.0s3] should: [:r | r = 3.0s3]
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

	self value: [(1/2) min: 0] should: [:r | r = 0]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [(-2000000000/2) min: -2000000000]
		should: [:r | r = -2000000000]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [(9000000000/2) min: 2000000003]
		should: [:r | r = 2000000003]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [(1/2) min: 0.0] should: [:r | r = 0.0]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [(1/2) min: (1/4)] should: [:r | r = (1/4)]
		conformTo: #'magnitude' selector: #'min:'.
	self value: [(1/2) min: 0.1s3] should: [:r | r = 0.1s3]
		conformTo: #'magnitude' selector: #'min:'.

	"Num min: Num -> Num"
	1 to: numList size do: [ :ndx |
		self value: [(numList at: ndx) min: (numList at: ndx)]
			should: [:r | r = (numList at: ndx)]
			conformTo: #'magnitude' selector: #'min:'
	].!

testXnegated
	" <number>#negated (Return Values: <RECEIVER>) "
	| rcvr |
	#'Numeric'.
	rcvr := 3/2.
	self value: [rcvr negated] should: [:r | r = (-3/2)]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.
	rcvr := -3/2.
	self value: [rcvr negated] should: [:r | r = (3/2)]
		conformTo: #'number' selector: #'negated' opRECEIVER: rcvr.!

testXnegative
	" <number>#negative "
	#'Numeric'.
	self value: [(-1/2) negative] should: [:r | r]
		conformTo: #'number' selector: #'negative'.
	self value: [(1/2) negative] shouldnt: [:r | r]
		conformTo: #'number' selector: #'negative'.!

testXnotEqualityOp
	" <Object>#~= "
	#'Numeric'.
"	The value of receiver ~= comparand is true if and only if the value of
comparand ~= receiver would also be true.
"
	self value: [fractionHalf ~= (2/3)]
		should: [:r | r] conformTo: #'Object' selector: #'~='.

	self value: [smallInt2 ~= (6/2)]
		should: [:r | r] conformTo: #'Object' selector: #'~='.

	self value: [fractionHalf ~= fractionHalf]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.

	self value: [smallInt2 ~= (4/2)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.!

testXnotIdentityOp
	" <Object>#~~ "
	#'Numeric'.
"	The value of receiver ~~ comparand is true if and only if the value of comparand ~~ receiver would also be true.
"
	self should: [fractionHalf ~~ (2/3) and: [(2/3) ~~ fractionHalf]].

	self value: [fractionHalf ~~ (2/3)]
		should: [:r | r] conformTo: #'Object' selector: #'~~'.

	self value: [smallInt2 ~~ (6/2)]
		should: [:r | r] conformTo: #'Object' selector: #'~~'.

	self value: [fractionHalf ~~ fractionHalf]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~~'.

	self value: [smallInt2 ~~ (4/2)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~~'.!

testXnumerator
	" <Fraction>#numerator "
	#'Numeric'.!

testXpositive
	" <number>#positive "
	#'Numeric'.
	self value: [(1/2) positive] should: [:r | r]
		conformTo: #'number' selector: #'positive'.
	self value: [(-1/2) positive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'positive'.!

testXprintString
	" <Fraction>#printString "

	#bsm.	"Modified to correct error in the ANSI standard that requires the printString of a Fraction to be unbracketed"
	#Numeric.
	self 
		value: [(1 / 2) printString]
		should: [:r | r = '(1/2)']
		conformTo: #Fraction
		selector: #printString.
	self 
		value: [(1 / -2) printString]
		should: [:r | r = '(-1/2)']
		conformTo: #Fraction
		selector: #printString.
	self 
		value: [(3 / 33) printString]
		should: [:r | r = '(1/11)']
		conformTo: #Fraction
		selector: #printString!

testXquoX
	" <number>#quo: "
	| retVals |
	#'Numeric'.
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #( 666666666 0 0 666666666 2666666666 666666666 ).
	1 to: numList size do: [ :ndx |
		self value: [(4000000000/3) quo: (numList at: ndx)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'.
	].

"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	retVals := #( -666666666 0 0 -666666666 -2666666666 -666666666 ).
	1 to: numList size do: [ :ndx |
		self value: [(4000000000/3) quo: ((numList at: ndx) negated)]
			should: [:r | r = (retVals at: ndx)]
			conformTo: #'number' selector: #'quo:'
	].

	self should: [((256/5) quo: (50/5)) = 5].

	self should: [((126/5) quo: 5) = 5].
	self should: [((125000000001/5) quo: 5000000000) = 5].
	self should: [((-125000000001/5) quo: -5000000000) = 5].
	self should: [((131/5) quo: 5.1) = 5].
	self should: [((131/5) quo: 5.1s1) = 5].

	self value: [0 quo: fractionHalf] should: [:r | r = 0]
		conformTo: #'number' selector: #'quo:'.

	"If the operand has a value of zero the ZeroDivide exception is signaled."
	self value: [fractionHalf quo: 0] shouldRaise: ZeroDivide.!

testXraisedToIntegerX
	" <number>#raisedToInteger: (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 51/10.
	self value: [rcvr raisedToInteger: 0] should: [:r | r = 1]
		conformTo: #'number' selector: #'raisedToInteger:' opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: 1] should: [:r | r = rcvr]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: 2] should: [:r | r = (2601/100)]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	self value: [rcvr negated raisedToInteger: 2]
		should: [:r | r = (2601/100)]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	self value: [rcvr raisedToInteger: -2] should: [:r | r = ( 100/2601)]
		conformTo: #'number' selector: #'raisedToInteger:'
		opRECEIVER: rcvr.

	"It is erroneous if the operand does not conform
		to the protocol <integer>."
	self value: [rcvr raisedToInteger: (51/10)]
		shouldRaise: Error.!

testXraisedToX
	" <number>#raisedTo: "
	| numVals retVals |
	#'Numeric'.
	numVals := #(2 2.0 0 2.0s3 ) copy.
	numVals at: 3 put: (1/2).
	retVals := #(0 0.25 0.7071067811865475 0.25 ) copy.
	retVals at: 1 put: (1/4).
	1 to: numVals size do: [ :ndx |
		self value: [fractionHalf raisedTo: (numVals at: ndx)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'raisedTo:'.
	].


	retVals := #(4 4.0 1.414213562373095 4.0 ).
	1 to: numVals size do: [ :ndx |
		self value: [fractionHalf raisedTo: ((numVals at: ndx) negated)]
			should: [:r | r closeTo: (retVals at: ndx)]
			conformTo: #'number' selector: #'raisedTo:'
	].

	self value: [fractionHalf raisedTo: 0.0] should: [:r | r = 1]
		conformTo: #'number' selector: #'raisedTo:'.

	self value: [0.0 raisedTo: fractionHalf] should: [:r | r = 0.0]
		conformTo: #'number' selector: #'raisedTo:'.

	self value: [fractionHalf raisedTo: 1.0] should: [:r | r = fractionHalf]
		conformTo: #'number' selector: #'raisedTo:'.

	"It is erroneous if the receiver equals zero
		and the operand is less than or equal to zero,"
	self value: [0.0 raisedTo: (fractionHalf negated)]
		shouldRaise: Error.

	"	or if the receiver is less than zero."
	self value: [fractionHalf negated raisedTo: 2.0]
		shouldRaise: Error.!

testXreciprocal
	" <number>#reciprocal (returnRule - :receiver) "
	#'Numeric'.
	self value: [fractionHalf reciprocal] should: [:r | r = 2]
		conformTo: #'number' selector: #'reciprocal'
		ruleReceiver: fractionHalf!

testXremX
	" <number>#rem: "
	| retVals ndx num2 frac |
	#'Numeric'.
	"Within the limits of representation, the following invariant should hold:
		(receiver quo: operand)*operand + (receiver rem: operand) = receiver"
"	#( 2 -2000000000 2000000000 2.0 1/2 2.0s3 )."
	numList := #( 5 5.0 5.0s3 ).
	frac := (53/2).
	retVals := Array with: (3/2) with: 1.5 with: (3/2).
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self value: [frac rem: num]
			should: [:r | r = (retVals at: ndx)
					& ((frac quo: num) * num + (frac rem: num)
						= frac)]
			conformTo: #'number' selector: #'rem:'
	].

	numList := numList collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self value: [frac rem: num]
			should: [:r | r = (retVals at: ndx)
					& ((frac quo: num) * num + (frac rem: num)
						= frac)]
			conformTo: #'number' selector: #'rem:'
	].

	frac := (-53/2).
	numList := #( 5 5.0 5.0s3 ).
	retVals := retVals collect: [ :num | num negated ].
	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self should: [(frac rem: num) = (retVals at: ndx)
					& ((frac quo: num) * num + (frac rem: num)
						= frac)]
	].

	ndx := 0.
	numList do: [ :num |
		ndx := ndx + 1.
		self should: [(frac rem: num) = (retVals at: ndx)
					& ((frac quo: num) * num + (frac rem: num)
						= frac)]
	].

	frac := (53/2).
	num2 := (5/2).
	self value: [frac rem: num2]
		should: [:r | r = (3/2)
				& ((frac quo: num2) * num2 + (frac rem: num2)
					= frac)]
		conformTo: #'number' selector: #'rem:'.

	frac := (20000000003/2).
	numList := #( -2000000000 2000000000 ).
	numList do: [ :num |
		self value: [frac rem: num]
			should: [:r | r = (3/2)
					& ((frac quo: num) * num + (frac rem: num)
						= frac)]
			conformTo: #'number' selector: #'rem:'
	].

	"If either the receiver or operand are of type <Float> and the operand has a value of zero, the result is implementation defined.  The implementation may signal the ZeroDivide exception or provide a continuation value "
	self value: [fractionHalf rem: 0.0] shouldRaise: ZeroDivide.
	self value: [fractionHalf rem: 0] shouldRaise: ZeroDivide.!

testXrounded
	" <number>#rounded "
	#'Numeric'.
	self value: [(1/3) rounded] should: [:r | r = 0]
		conformTo: #'number' selector: #'rounded'.
	self value: [(1/2) rounded] should: [:r | r = 1]
		conformTo: #'number' selector: #'rounded'.
	self value: [(-1/2) rounded] should: [:r | r = -1]
		conformTo: #'number' selector: #'rounded'.!

testXsign
	" <number>#sign "
	#'Numeric'.
	self value: [(1/2) sign] should: [:r | r = 1]
		conformTo: #'number' selector: #'sign'.
	self value: [(-1/2) sign] should: [:r | r = -1]
		conformTo: #'number' selector: #'sign'.!

testXsqrt
	" <number>#sqrt "
	self value: [(2601/100) sqrt] should: [:r | r closeTo: 5.1]
		conformTo: #'number' selector: #'sqrt'.
	self value: [(1/4) sqrt] should: [:r | r = 0.5]
		conformTo: #'number' selector: #'sqrt'!

testXsquared
	" <number>#squared (Return Values: <RECEIVER>)"
	| rcvr |
	#'Numeric'.
	rcvr := 51/10.
	self value: [rcvr squared] should: [:r | r = (2601/100)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.

	rcvr := -51/10.
	self value: [rcvr squared] should: [:r | r = (2601/100)]
		conformTo: #'number' selector: #'squared' opRECEIVER: rcvr.!

testXstrictlyPositive
	" <number>#strictlyPositive "
	#'Numeric'.
	self value: [(1/2) strictlyPositive] should: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.

	self value: [(-1/2) strictlyPositive] shouldnt: [:r | r]
		conformTo: #'number' selector: #'strictlyPositive'.!

testXtoX
	" <number>#to: "

	| start middleNdx stop2 |
	#Numeric.
	start := 1 / 2.
	numList := #(2 2.0 0 2.0s3) copy.
	numList at: 3 put: 3 / 2.
	numList do: 
			[:stop | 
			self 
				value: [start to: stop]
				should: 
					[:r | 
					r size = 2 & (r last = (start + ((stop - start) // 1))) 
						& (r allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #Fraction])
					". . . the last element in the sequence . . . is . . .[:]
						receiver + ((stop - receiver) // 1)"
					"The elements conform to the receiver's protocol."]
				conformTo: #number
				selector: #to:].
	start := 3 / 2.
	stop2 := 4000000001 / 2.
	middleNdx := 1000000000.	"Check conformance of first, middle and last."
	self 
		value: [start to: stop2]
		should: 
			[:r | 
			r size = 2000000000 & (r last = (start + ((stop2 - start) // 1))) 
				& ((Array 
						with: (r at: 1)
						with: (r at: middleNdx)
						with: (r at: 3)) allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #Fraction])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.
	start := -4000000001 / 2.
	stop2 := -3 / 2.
	middleNdx := 1000000000.	"Check conformance of first, middle and last."
	self 
		value: [start to: stop2]
		should: 
			[:r | 
			r size = 2000000000 & (r last = (start + ((stop2 - start) // 1))) 
				& ((Array 
						with: (r at: 1)
						with: (r at: middleNdx)
						with: (r at: 3)) allSatisfy: [:elem | elem class conformsToAnsiProtocolNamed: #Fraction])
			". . . the last element in the sequence . . . is . . .[:]
					receiver + ((stop - receiver) // 1)"
			"The elements conform to the receiver's protocol."]
		conformTo: #number
		selector: #to:.

	"The interval answered will be empty if the receiver is greater than stop."
	self 
		value: [1 / 2 to: -1 / 2]
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
	self value: [(1/3) truncated] should: [:r | r = 0]
		conformTo: #'number' selector: #'truncated'.
	self value: [(3/2) truncated] should: [:r | r = 1]
		conformTo: #'number' selector: #'truncated'.
	self value: [(-1/2) truncated] should: [:r | r = 0]
		conformTo: #'number' selector: #'truncated'.! !

!FractionANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
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
testXdenominator!public! !
testXequalityOp!public! !
testXfloor!public! !
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
testXmaxX!public! !
testXminX!public! !
testXnegated!public! !
testXnegative!public! !
testXnotEqualityOp!public! !
testXnotIdentityOp!public! !
testXnumerator!public! !
testXpositive!public! !
testXprintString!public! !
testXquoX!public! !
testXraisedToIntegerX!public! !
testXraisedToX!public! !
testXreciprocal!public! !
testXremX!public! !
testXrounded!public! !
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

