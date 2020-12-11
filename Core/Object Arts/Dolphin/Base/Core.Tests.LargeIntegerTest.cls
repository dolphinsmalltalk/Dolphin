"Filed out from Dolphin Smalltalk 7"!

Core.Tests.IntegerTest subclass: #'Core.Tests.LargeIntegerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.LargeIntegerTest guid: (Core.GUID fromString: '{36a14bf1-e5f1-45a2-a72d-6e853ab71f46}')!
Core.Tests.LargeIntegerTest comment: ''!
!Core.Tests.LargeIntegerTest categoriesForClass!Unclassified! !
!Core.Tests.LargeIntegerTest methodsFor!

canonicalInstance
	^2 raisedToInteger: 63 - 1!

largeComparisonPairs
	^{{SmallInteger maximum + 1. SmallInteger maximum + 2}.
		#(16r7FFFFFFE 16r7FFFFFFF).
		#(16r7FFFFFFF 16r80000000).
		#(-16r80000000 16r80000000).
		#(-16r80000001 16r7FFFFFFF).
		#(16r80000000 16r80000001).
		#(16r7FFFFFFF 16r7FFFFFFFFFFFFFFF).
		#(16r80000000 16r7FFFFFFFFFFFFFFF).
		#(16r7FFFFFFF 16r8000000000000000).
		#(16r80000000 16r8000000000000000).
		#(16r7FFFFFFF00000000 16r7FFFFFFF7FFFFFFF).
		#(16r7FFFFFFF00000000 16r7FFFFFFFFFFFFFFF).
		#(16r7FFFFFFF7FFFFFFF 16r7FFFFFFF80000000).
		#(16r7FFFFFFF80000000 16r7FFFFFFF80000001).
		#(16r7FFFFFFFFFFFFFFF 16r8000000000000000).
		#(16r8000000000000000 16r8000000000000001).
		#(-16r7FFFFFFF -16r7FFFFFFE).
		#(-16r80000000 -16r7FFFFFFF).
		#(-16r80000001 -16r80000000).
		#(-16r80000002 -16r80000001).
		#(-16r100000000 -16rFFFFFFFF).
		#(-16r100000000 -16r80000001).
		#(-16r180000000 -16r17FFFFFFF).
		#(-16r180000001 -16r180000000).
		#(-16r180000002 -16r180000001).
		#(-16r180000001 -16r80000001).
		#(-16r8000000000000000 -16r7FFFFFFFFFFFFFFF).
		{100 factorial - 1. 100 factorial}}!

largeNegative
	^{SmallInteger minimum - 1.
		-2 ** 31.
		-2 ** 31 - 1.
		2 ** 32 * -1.
		-2 ** 63.
		-2 ** 63 - 1.
		99 factorial * -1}!

largePositive
	^{SmallInteger maximum + 1.
		2 ** 31 - 1.
		2 ** 31.
		2 ** 32 - 1.
		2 ** 32.
		2 ** 63 - 1.
		2 ** 63.
		99 factorial}!

smallIntegerComparisons
	^{SmallInteger minimum. -1. 0. 1. SmallInteger maximum}!

testAddDoubleToDoubleNeg
	"Test adding double limb addend to a double-limbed large negative integer."

	| res a |
	a := -16r80000001.	"Smallest double-limbed large negative integer"
	self assert: a byteSize identicalTo: 8.
	#(#(16r80000000 -1) #(16rFFFFFFFF 16r7FFFFFFE) #(16r7FFFFFFFFFFFFFFF 16r7FFFFFFF7FFFFFFE) #(-16r80000001 -16r100000002))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 8.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	"Largest 2-limb negative large integer - already added this to the smallest - check for correct carry"
	a := -16r8000000000000000.
	#(#(16r7FFFFFFFFFFFFFFF -1) #(-16r8000000000000000 -16r10000000000000000)) do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 8.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a]!

testAddDoubleToDoublePos
	"Test adding double limb addend to a double-limbed large positive integer."

	| res a |
	a := 16r80000000.	"Smallest double-limbed large positive integer"
	self assert: a byteSize identicalTo: 8.
	#(#(16r80000000 16r100000000) #(16rFFFFFFFF 16r17FFFFFFF) #(16r7FFFFFFFFFFFFFFF 16r800000007FFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 8.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	"Largest 2-limb positive large integer - already added this to the smallest - check largest"
	a := 16r7FFFFFFFFFFFFFFF.
	res := a + a.
	self assert: res equals: 16rFFFFFFFFFFFFFFFE!

testAddDoubleToTripleNeg
	"Test adding double limb addend to a triple-limbed large negative integer."

	| res a |
	a := -16r8000000000000001.	"Smallest triple-limbed large negative integer"
	self assert: a byteSize identicalTo: 12.
	#(#(16r80000000 -16r7FFFFFFF80000001) #(16rFFFFFFFF -16r7FFFFFFF00000002) #(16r7FFFFFFFFFFFFFFF -2) #(-16r8000000000000000 -16r10000000000000001))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 8.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	"Largest 2-limb negative large integer - already added this to the smallest - check for correct carry"
	a := -16r800000000000000000000000.
	self assert: a byteSize identicalTo: 12.
	#(#(16r7FFFFFFFFFFFFFFF -16r7FFFFFFF8000000000000001) #(-16r8000000000000000 -16r800000008000000000000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 8.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a]!

testAddDoubleToTriplePos
	"Test adding double limb addend to a triple-limbed large positive integer."

	| res a |
	a := 16r8000000000000000.	"Smallest triple-limbed negative integer"
	self assert: a byteSize identicalTo: 12.
	self assert: (a digitAt: 3) identicalTo: 0.
	#(#(16r80000000 16r8000000080000000) #(16rFFFFFFFF 16r80000000FFFFFFFF) #(16r7FFFFFFFFFFFFFFF 16rFFFFFFFFFFFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 8.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	a := 16r7FFFFFFFFFFFFFFFFFFFFFFF.	"Largest triple-limbed positive integer"
	self assert: a byteSize identicalTo: 12.
	#(#(16r80000000 16r80000000000000007FFFFFFF) #(16rFFFFFFFF 16r8000000000000000FFFFFFFE) #(16r7FFFFFFFFFFFFFFF 16r800000007FFFFFFFFFFFFFFE))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 8.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a]!

testAddSingleToDoubleNeg
	"Test adding single limb addend to a double-limbed large negative integer. The VM has special case logic
	for this as it is common and simpler (i.e. faster) than two multi-limb addends"

	"Interesting addends:
		0
		1
		-1
		16r3FFFFFFF	(max positive small integer)
		16r7FFFFFFF	(max positive single limb large integer
		-16r40000000	(max negative small integer)
		-16r80000000 	(max negative single limb large integer).
	"

	"Adding -1 to -2**63-1, no carry, but adding -2 or more requires sign word. Largest result possible with single limb addend is ((-2**63)-1 + (-2**31)) hex"

	| res a |
	a := -16r80000001.
	self assert: a byteSize identicalTo: 8.	"Smallest negative double-limbed integer"
	#(#(16r7FFFFFFF -2) #(16r3FFFFFFF -16r40000002) #(1 -16r80000000) #(0 -16r80000001) #(-1 -16r80000002) #(-2 -16r80000003) #(-16r40000000 -16rC0000001) #(-16r40000001 -16rC0000002) #(-16r7FFFFFFF -16r100000000) #(-16r80000000 -16r100000001))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize <= 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	a := -16r4000000000000000.
	self assert: a byteSize identicalTo: 8.
	#(#(0 -16r4000000000000000) #(-1 -16r4000000000000001) #(-2 -16r4000000000000002) #(-16r40000000 -16r4000000040000000) #(-16r40000001 -16r4000000040000001) #(-16r7FFFFFFF -16r400000007FFFFFFF) #(-16r80000000 -16r4000000080000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: 8.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	a := -16r7FFFFFFFFFFFFFFF.
	self assert: a byteSize identicalTo: 8.
	#(#(0 -16r7FFFFFFFFFFFFFFF) #(-1 -16r8000000000000000) #(-2 -16r8000000000000001) #(-16r40000000 -16r800000003FFFFFFF) #(-16r7FFFFFFF -16r800000007FFFFFFE) #(-16r80000000 -16r800000007FFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: (b < -1 ifTrue: [12] ifFalse: [8]).
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	"Adding any negative number to -2**63 requires sign word. Largest result possible with single limb addend is ((-2**63)-1 + (-2**31)) hex"
	a := -16r8000000000000000.	"Largest double-limbed negative integer"
	self assert: a byteSize identicalTo: 8.
	#(#(16r3FFFFFFF -16r7FFFFFFFC0000001) #(1 -16r7FFFFFFFFFFFFFFF) #(0 -16r8000000000000000) #(-1 -16r8000000000000001) #(-2 -16r8000000000000002) #(-16r3FFFFFFF -16r800000003FFFFFFF) #(-16r40000000 -16r8000000040000000) #(-16r7FFFFFFF -16r800000007FFFFFFF) #(-16r80000000 -16r8000000080000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: (b < 0 ifTrue: [12] ifFalse: [8]).
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b]!

testAddSingleToDoublePos
	"Test adding single limb addend to a large positive integer of 1, 2, and 3 limbs"

	"Now add a single-limb to two limbs"

	| res a |
	res := 16rFFFFFFFF + 1.
	self assert: res equals: 16r100000000.
	"Smallest 2-limb large integer"
	a := 16r80000000.
	self assert: a byteSize identicalTo: 8.
	#(#(0 16r80000000) #(1 16r80000001) #(2 16r80000002) #(16r3FFFFFFF 16rBFFFFFFF) #(16r7FFFFFFF 16rFFFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res >= a.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: 8.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].

	"No carry possible from 16r7FFFFFFF when only adding a single 2's complement limb"
	a := 16r7FFFFFFF7FFFFFFF.
	self assert: a byteSize identicalTo: 8.
	#(#(0 16r7FFFFFFF7FFFFFFF) #(1 16r7FFFFFFF80000000) #(2 16r7FFFFFFF80000001) #(16r3FFFFFFF 16r7FFFFFFFBFFFFFFE) #(16r7FFFFFFF 16r7FFFFFFFFFFFFFFE))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res >= a.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: 8.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].

	"Any addend, other than zero, results in a bit of carry"
	a := 16r7FFFFFFFFFFFFFFF.
	self assert: a byteSize identicalTo: 8.
	#(#(0 16r7FFFFFFFFFFFFFFF) #(1 16r8000000000000000) #(2 16r8000000000000001) #(16r3FFFFFFF 16r800000003FFFFFFE) #(16r7FFFFFFF 16r800000007FFFFFFE))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: (b isZero ifTrue: [8] ifFalse: [12]).
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b]!

testAddSingleToSingleNeg
	"Test adding single limb addend to a single-limbed large negative integer. The VM has special case logic
	for this as it is common and simpler (i.e. faster) than two multi-limb addends"

	"Interesting addends:
		0
		1
		-1
		16r3FFFFFFF	(max positive small integer)
		16r7FFFFFFF	(max positive single limb large integer
		-16r40000000	(max negative small integer)
		-16r80000000 	(max negative single limb large integer).
	"

	| res a |
	a := -16r40000000.
	self assert: a byteSize equals: 4.
	#(#(-1 -16r40000001) #(-2 -16r40000002) #(-16r40000000 -16r80000000) #(-16r40000001 -16r80000001) #(-16r7FFFFFFF -16rBFFFFFFF) #(-16r80000000 -16rC0000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	a := -16r7FFFFFFF.
	self assert: a byteSize equals: 4.
	#(#(-1 -16r80000000) #(-2 -16r80000001) #(-16r40000000 -16rBFFFFFFF) #(-16r40000001 -16rC0000000) #(-16r7FFFFFFF -16rFFFFFFFE) #(-16r80000000 -16rFFFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	a := -16r80000000.
	self assert: a byteSize equals: 4.
	#(#(-1 -16r80000001) #(-2 -16r80000002) #(-16r40000000 -16rC0000000) #(-16r40000001 -16rC0000001) #(-16r7FFFFFFF -16rFFFFFFFF) #(-16r80000000 -16r100000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: 8.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b]!

testAddSingleToSinglePos
	"Test adding single limb addend to a large positive integer of 1, 2, and 3 limbs"

	| res a |
	a := 16r40000000.	"Min single-limb positive large integer"
	self assert: a byteSize equals: 4.
	#(#(0 16r40000000) #(1 16r40000001) #(2 16r40000002) #(16r3FFFFFFF 16r7FFFFFFF) #(16r7FFFFFFF 16rBFFFFFFF) #(-1 16r3FFFFFFF) #(-16r40000000 0) #(-16r40000001 -1) #(-16r7FFFFFFF -16r3FFFFFFF) #(-16r80000000 -16r40000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	a := 16r7FFFFFFF.	"Max single-limb positive large integer, i.e. 2**31-1"
	self assert: a byteSize equals: 4.
	#(#(0 16r7FFFFFFF) #(1 16r80000000) #(2 16r80000001) #(16r3FFFFFFF 16rBFFFFFFE) #(16r7FFFFFFF 16rFFFFFFFE) #(-1 16r7FFFFFFE) #(-16r40000000 16r3FFFFFFF) #(-16r40000001 16r3FFFFFFE) #(-16r7FFFFFFF 0) #(-16r80000000 -1))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: (b > 0 ifTrue: [8] ifFalse: [4]).
			self assert: res - b equals: a.
			self assert: res - a equals: b]!

testAddSingleToTripleNeg
	"Test adding single limb addend to a triple-limbed large negative integer. The VM has special case logic
	for this as it is common and simpler (i.e. faster) than two multi-limb addends"

	"Interesting addends:
		0
		1
		-1
		16r3FFFFFFF	(max positive small integer)
		16r7FFFFFFF	(max positive single limb large integer
		-16r40000000	(max negative small integer)
		-16r80000000 	(max negative single limb large integer).
	"

	"Adding -1 to -2**63-1, no carry, but adding -2 or more requires sign word. Largest result possible with single limb addend is ((-2**63)-1 + (-2**31)) hex"

	| res a |
	a := -16r8000000000000001.	"Smallest triple-limbed negative integer"
	self assert: a byteSize identicalTo: 12.
	#(#(0 -16r8000000000000001) #(-1 -16r8000000000000002) #(-2 -16r8000000000000003) #(-16r40000000 -16r8000000040000001) #(-16r40000001 -16r8000000040000002) #(-16r7FFFFFFF -16r8000000080000000) #(-16r80000000 -16r8000000080000001))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: 12.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	a := -16r400000000000000000000000.
	self assert: a byteSize identicalTo: 12.
	#(#(0 -16r400000000000000000000000) #(-1 -16r400000000000000000000001) #(-2 -16r400000000000000000000002) #(-16r40000000 -16r400000000000000040000000) #(-16r40000001 -16r400000000000000040000001) #(-16r7FFFFFFF -16r40000000000000007FFFFFFF) #(-16r80000000 -16r400000000000000080000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: 12.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].
	a := -16r7FFFFFFFFFFFFFFFFFFFFFFF.
	self assert: a byteSize identicalTo: 12.
	#(#(0 -16r7FFFFFFFFFFFFFFFFFFFFFFF) #(-1 -16r800000000000000000000000) #(-2 -16r800000000000000000000001) #(-16r40000000 -16r80000000000000003FFFFFFF) #(-16r7FFFFFFF -16r80000000000000007FFFFFFE) #(-16r80000000 -16r80000000000000007FFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + eachPair first.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: (eachPair first < -1 ifTrue: [16] ifFalse: [12]).
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b].

	"Adding any negative number to -2**63 requires sign word. Largest result possible with single limb addend is ((-2**63)-1 + (-2**31)) hex"
	a := -16r800000000000000000000000.
	self assert: a byteSize identicalTo: 12.
	#(#(16r3FFFFFFF -16r7FFFFFFFFFFFFFFFC0000001) #(1 -16r7FFFFFFFFFFFFFFFFFFFFFFF) #(0 -16r800000000000000000000000) #(-1 -16r800000000000000000000001) #(-2 -16r800000000000000000000002) #(-16r3FFFFFFF -16r80000000000000003FFFFFFF) #(-16r40000000 -16r800000000000000040000000) #(-16r7FFFFFFF -16r80000000000000007FFFFFFF) #(-16r80000000 -16r800000000000000080000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 4.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res byteSize equals: (eachPair first < 0 ifTrue: [16] ifFalse: [12]).
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - b equals: a.
			self assert: res - a equals: b]!

testAddSmall
	| res a |
	a := 16r40000000.
	self assert: a class identicalTo: LargeInteger.
	res := a + 0.
	"VM optimizes this caseas as a noop and returns the receiver"
	self assert: res identicalTo: a.
	res := a + 1.
	self assert: res equals: 16r40000001.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := a + SmallInteger maximum.
	self assert: res equals: 16r7FFFFFFF.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := a + -1.
	self assert: res equals: 16r3FFFFFFF.
	self assert: res class identicalTo: SmallInteger.
	self assert: res isImmutable.
	res := a + SmallInteger minimum.
	self assert: res equals: 0.
	self assert: res class identicalTo: SmallInteger.
	self assert: res isImmutable!

testAddToQuad
	"Test adding various sized boundary case large integers to boundary case quad-limbed large positive integers."

	| res a |
	a := 2 ** 95.	"Smallest 4-limb large positive integer"
	self assert: a byteSize identicalTo: 16.
	self assert: (a - 1) byteSize identicalTo: 12.
	#(#(16r40000000 16r800000000000000040000000) #(-16r40000001 16r7FFFFFFFFFFFFFFFBFFFFFFF) #(16r7FFFFFFF 16r80000000000000007FFFFFFF) #(-16r80000000 16r7FFFFFFFFFFFFFFF80000000) #(16r80000000 16r800000000000000080000000) #(-16r80000001 16r7FFFFFFFFFFFFFFF7FFFFFFF) #(16rFFFFFFFF 16r8000000000000000FFFFFFFF) #(-16rFFFFFFFF 16r7FFFFFFFFFFFFFFF00000001) #(16r7FFFFFFFFFFFFFFF 16r800000007FFFFFFFFFFFFFFF) #(-16r8000000000000000 16r7FFFFFFF8000000000000000) #(16r8000000000000000 16r800000008000000000000000) #(-16r8000000000000001 16r7FFFFFFF7FFFFFFFFFFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	"Largest 4-limb large positive integer"
	a := 2 ** 127 - 1.
	self assert: a byteSize identicalTo: 16.
	self assert: (a + 1) byteSize identicalTo: 20.
	#(#(16r3FFFFFFF 16r8000000000000000000000003FFFFFFE) #(16r40000000 16r8000000000000000000000003FFFFFFF) #(-16r40000000 16r7FFFFFFFFFFFFFFFFFFFFFFFBFFFFFFF) #(-16r40000001 16r7FFFFFFFFFFFFFFFFFFFFFFFBFFFFFFE) #(16r7FFFFFFF 16r8000000000000000000000007FFFFFFE) #(-16r80000000 16r7FFFFFFFFFFFFFFFFFFFFFFF7FFFFFFF) #(16r80000000 16r8000000000000000000000007FFFFFFF) #(-16r80000001 16r7FFFFFFFFFFFFFFFFFFFFFFF7FFFFFFE) #(16rFFFFFFFF 16r800000000000000000000000FFFFFFFE) #(-16rFFFFFFFF 16r7FFFFFFFFFFFFFFFFFFFFFFF00000000) #(16r7FFFFFFFFFFFFFFF 16r80000000000000007FFFFFFFFFFFFFFE) #(-16r8000000000000000 16r7FFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF) #(16r8000000000000000 16r80000000000000007FFFFFFFFFFFFFFF) #(-16r8000000000000001 16r7FFFFFFFFFFFFFFF7FFFFFFFFFFFFFFE))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].

	"Negative case with max value lower limbs"
	a := -16r7FFFFFFF000000000000000000000001.
	#(#(16r3FFFFFFF -16r7FFFFFFEFFFFFFFFFFFFFFFFC0000002) #(16r7FFFFFFF -16r7FFFFFFEFFFFFFFFFFFFFFFF80000002) #(16r7FFFFFFFFFFFFFFF -16r7FFFFFFEFFFFFFFF8000000000000002) #(16r7FFFFFFFFFFFFFFFFFFFFFFF -16r7FFFFFFE800000000000000000000002))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a]!

testAddToQuadNeg
	"Test adding various sized boundary case large integers to boundardy case quad-limbed large negative integers."

	| res a |
	a := -2 ** 95 - 1.	"Smallest 4-limb large negative integer"
	self assert: a byteSize identicalTo: 16.
	self assert: (a + 1) byteSize identicalTo: 12.
	#(#(16r3FFFFFFF -16r7FFFFFFFFFFFFFFFC0000002) #(16r40000000 -16r7FFFFFFFFFFFFFFFC0000001) #(-16r40000000 -16r800000000000000040000001) #(-16r40000001 -16r800000000000000040000002) #(16r7FFFFFFF -16r7FFFFFFFFFFFFFFF80000002) #(-16r80000000 -16r800000000000000080000001) #(16r80000000 -16r7FFFFFFFFFFFFFFF80000001) #(-16r80000001 -16r800000000000000080000002) #(16rFFFFFFFF -16r7FFFFFFFFFFFFFFF00000002) #(-16rFFFFFFFF -16r800000000000000100000000) #(16r7FFFFFFFFFFFFFFF -16r7FFFFFFF8000000000000002) #(-16r8000000000000000 -16r800000008000000000000001) #(16r8000000000000000 -16r7FFFFFFF8000000000000001) #(-16r8000000000000001 -16r800000008000000000000002))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	"Largest 4-limb negative large integer"
	a := -2 ** 127.
	self assert: a byteSize identicalTo: 16.
	self assert: (a - 1) byteSize identicalTo: 20.
	#(#(16r3FFFFFFF -16r7FFFFFFFFFFFFFFFFFFFFFFFC0000001) #(16r40000000 -16r7FFFFFFFFFFFFFFFFFFFFFFFC0000000) #(-16r40000000 -16r80000000000000000000000040000000) #(-16r40000001 -16r80000000000000000000000040000001) #(16r7FFFFFFF -16r7FFFFFFFFFFFFFFFFFFFFFFF80000001) #(-16r80000000 -16r80000000000000000000000080000000) #(16r80000000 -16r7FFFFFFFFFFFFFFFFFFFFFFF80000000) #(-16r80000001 -16r80000000000000000000000080000001) #(16rFFFFFFFF -16r7FFFFFFFFFFFFFFFFFFFFFFF00000001) #(-16rFFFFFFFF -16r800000000000000000000000FFFFFFFF) #(16r7FFFFFFFFFFFFFFF -16r7FFFFFFFFFFFFFFF8000000000000001) #(-16r8000000000000000 -16r80000000000000008000000000000000) #(16r8000000000000000 -16r7FFFFFFFFFFFFFFF8000000000000000) #(-16r8000000000000001 -16r80000000000000008000000000000001))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a + b.
			self assert: res equals: eachPair second.
			res := b + a.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a]!

testAddTripleToTripleNeg
	"Test adding triple limb addend to a triple-limbed large negative integer."

	| res a |
	a := -16r8000000000000001.	"Smallest triple-limbed large negative integer"
	self assert: a byteSize identicalTo: 12.
	self assert: (a + 1) byteSize identicalTo: 8.
	#(#(-16r8000000000000001 -16r10000000000000002) #(16r8000000000000000 -1) #(-16r7FFFFFFFFFFFFFFFFFFFFFFF -16r800000008000000000000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 12.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	"Largest 2-limb negative large integer - already added this to the smallest - check for correct carry"
	a := -16r800000000000000000000000.
	self assert: a byteSize identicalTo: 12.
	self assert: (a - 1) byteSize identicalTo: 16.
	#(#(16r7FFFFFFFFFFFFFFFFFFFFFFF -1) #(-16r800000000000000000000000 -16r1000000000000000000000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b byteSize equals: 12.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a]!

testAddTripleToTriplePos
	"Test adding triple limb addend to a triple-limbed large positive integer."

	| res a |
	a := 16r8000000000000000.	"Smallest triple-limbed negative integer"
	self assert: a byteSize identicalTo: 12.
	self assert: (a digitAt: 3) identicalTo: 0.
	#(#(16r8000000000000000 16r10000000000000000) #(16r7FFFFFFFFFFFFFFFFFFFFFFF 16r800000007FFFFFFFFFFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b limbSize equals: 3.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a].
	a := 16r7FFFFFFFFFFFFFFFFFFFFFFF.	"Largest triple-limbed positive integer"
	self assert: a byteSize identicalTo: 12.
	#(#(16r7FFFFFFFFFFFFFFFFFFFFFFF 16rFFFFFFFFFFFFFFFFFFFFFFFE)) do: 
			[:eachPair |
			| b |
			b := eachPair first.
			self assert: b limbSize equals: 3.	"Sanity check"
			res := a + b.
			self assert: res equals: eachPair second.
			res := a + b.
			self assert: res equals: eachPair second.
			self assert: res - a equals: b.
			self assert: res - b equals: a]!

testBitAnd
	self assert: (16r7FFFFFFF bitAnd: 16r80000000) equals: 0.
	self assert: (16r80000000 bitAnd: 16r7FFFFFFF) equals: 0.
	self assert: (16r7FEDCBA9 bitAnd: 16r81123456) identicalTo: 16r1000000.
	self assert: (16r81123456 bitAnd: 16r7FEDCBA9) identicalTo: 16r1000000.
	self assert: (16r7FEDCBA9 bitAnd: 16r81123456) identicalTo: 16r1000000.
	self assert: (16r81123456 bitAnd: 16r7FEDCBA9) identicalTo: 16r1000000.
	self assert: (16r7FEDCBA9 bitAnd: 16r40123456) equals: 16r40000000.
	self assert: (16r40123456 bitAnd: 16r7FEDCBA9) equals: 16r40000000.
	self assert: (16rFFEDCBA9 bitAnd: 16r80123456) equals: 16r80000000.
	self assert: (16r80123456 bitAnd: 16rFFEDCBA9) equals: 16r80000000.
	self assert: (16rF1234567 bitAnd: 16r89ABCDEF40000123) equals: 16r40000123.
	self assert: (16r89ABCDEF40000123 bitAnd: 16rF1234567) equals: 16r40000123.
	self assert: (16r80000000 bitAnd: -16r80000000) equals: 16r80000000.
	self assert: (-16r80000000 bitAnd: 16r80000000) equals: 16r80000000.
	self assert: (-16r80000000 bitAnd: -16r80000000) equals: -16r80000000.
	self assert: (16r7FFFFFFF bitAnd: -16r7FFFFFFF) identicalTo: 1.
	self assert: (16r7FFFFFFFFFFFFFFFFFFFFFFF bitAnd: 16r7FFFFFFF) equals: 16r7FFFFFFF.
	self assert: (16r7FFFFFFF bitAnd: 16r7FFFFFFFFFFFFFFFFFFFFFFF) equals: 16r7FFFFFFF.
	self assert: (16r8000000010000000 bitAnd: 16r7FFFFFFFFFFFFFFFFFFFFFFF) equals: 16r8000000010000000.
	self assert: (16r7FFFFFFFFFFFFFFFFFFFFFFF bitAnd: 16r8000000010000000) equals: 16r8000000010000000!

testBitAndSmall
	| res a |
	a := 16r7FFFFFFF.
	res := a + 0.
	"VM optimizes this caseas as a noop and returns the receiver"
	self assert: res identicalTo: a.
	res := a bitAnd: 1.
	self assert: res identicalTo: 1.
	res := a bitAnd: SmallInteger maximum.
	self assert: res identicalTo: 16r3FFFFFFF.
	res := a bitAnd: -1.
	self assert: res equals: a.
	self assert: res isImmutable.
	res := a bitAnd: SmallInteger minimum.
	self assert: res equals: 16r40000000.
	self assert: res isImmutable!

testBitOr
	self assert: (16r7FFFFFFF bitOr: 16r80000000) equals: 16rFFFFFFFF.
	self assert: (16r80000000 bitOr: 16r7FFFFFFF) equals: 16rFFFFFFFF.
	self assert: (16r7FEDCBA9 bitOr: 16r80123456) equals: 16rFFFFFFFF.
	self assert: (16r80123456 bitOr: 16r7FEDCBA9) equals: 16rFFFFFFFF.
	self assert: (16rF1234567 bitOr: 16r89ABCDEF00003210) equals: 16r89ABCDEFF1237777.
	self assert: (16r89ABCDEF00003210 bitOr: 16rF1234567) equals: 16r89ABCDEFF1237777.
	self assert: (-16r80000000 bitOr: 16r7FFFFFFF) identicalTo: -1.
	self assert: (16r7FFFFFFF bitOr: -16r80000000) identicalTo: -1

!

testBitOrSmall
	| res a |
	a := 16r7FFFFFFF.
	res := a bitOr: 0.
	"VM optimizes this case as as a noop and returns the receiver"
	self assert: res identicalTo: a.
	res := a bitOr: 1.
	self assert: res equals: a.
	res := a bitOr: SmallInteger maximum.
	self assert: res equals: a.
	res := a bitOr: -1.
	self assert: res identicalTo: -1.
	res := a bitOr: SmallInteger minimum.
	self assert: res identicalTo: -1.
	a := 16r40000000.
	res := a bitOr: SmallInteger maximum.
	self assert: res equals: 16r7FFFFFFF!

testBitShiftRand2048n
	| expectedNRightShift expectedNLeftShift shiftAmount n result |
	n := 16r27DD8385F44CF2F62FBA638E23151ADEC436688686D5EA9ED8C92F09326FD166C466AB65E163DB79CC6EB808CE262B4C7317B66B360C97460464D7C237709A342EE973FC04C9089660790E40FF5247F8864D5F5BCF8E856759782B4327CFBB820DC53A898072E526CF44D0D14EEAC325CB1C91AA8D09C910E13AB08E656235EFB553255C8709557A7F809100F47C7ACF9C70A17F8C1B2AA31D6F0CEC9C1CA046AAC3C552D04318FC5C2172958DEB3C73AA03958372CCFBC691783EE6E325719470E54A120B29E5B90B4C883CAF2FE46021F86D3B35CE8FC79F336FC83E0E1AA0ED8EC9F1C10572D926FB856E96F425C2F73F62F4A0690BB735875324513E84B7.
	shiftAmount := 48.
	expectedNLeftShift := 16r27DD8385F44CF2F62FBA638E23151ADEC436688686D5EA9ED8C92F09326FD166C466AB65E163DB79CC6EB808CE262B4C7317B66B360C97460464D7C237709A342EE973FC04C9089660790E40FF5247F8864D5F5BCF8E856759782B4327CFBB820DC53A898072E526CF44D0D14EEAC325CB1C91AA8D09C910E13AB08E656235EFB553255C8709557A7F809100F47C7ACF9C70A17F8C1B2AA31D6F0CEC9C1CA046AAC3C552D04318FC5C2172958DEB3C73AA03958372CCFBC691783EE6E325719470E54A120B29E5B90B4C883CAF2FE46021F86D3B35CE8FC79F336FC83E0E1AA0ED8EC9F1C10572D926FB856E96F425C2F73F62F4A0690BB735875324513E84B7000000000000.
	expectedNRightShift := 16r27DD8385F44CF2F62FBA638E23151ADEC436688686D5EA9ED8C92F09326FD166C466AB65E163DB79CC6EB808CE262B4C7317B66B360C97460464D7C237709A342EE973FC04C9089660790E40FF5247F8864D5F5BCF8E856759782B4327CFBB820DC53A898072E526CF44D0D14EEAC325CB1C91AA8D09C910E13AB08E656235EFB553255C8709557A7F809100F47C7ACF9C70A17F8C1B2AA31D6F0CEC9C1CA046AAC3C552D04318FC5C2172958DEB3C73AA03958372CCFBC691783EE6E325719470E54A120B29E5B90B4C883CAF2FE46021F86D3B35CE8FC79F336FC83E0E1AA0ED8EC9F1C10572D926FB856E96F425C2F73F62F4A0690BB73587.
	result := n << shiftAmount.
	self assert: result equals: expectedNLeftShift.
	result := n >> shiftAmount.
	self assert: result equals: expectedNRightShift!

testBitShiftRand512n
	| expectedNRightShift expectedNLeftShift shiftAmount n result |
	n := 16rB29696B08A8674B9ABF0F8B7B873579F88D90993697C9290BB70F64C77F4C61660BAB19739884B0D37E831318DE30D79AE47B2E26771849723559359C4C9259C.
	shiftAmount := 12.
	expectedNLeftShift := 16rB29696B08A8674B9ABF0F8B7B873579F88D90993697C9290BB70F64C77F4C61660BAB19739884B0D37E831318DE30D79AE47B2E26771849723559359C4C9259C000.
	expectedNRightShift := 16rB29696B08A8674B9ABF0F8B7B873579F88D90993697C9290BB70F64C77F4C61660BAB19739884B0D37E831318DE30D79AE47B2E26771849723559359C4C92.
	result := n << shiftAmount.
	self assert: result equals: expectedNLeftShift.
	result := n >> shiftAmount.
	self assert: result equals: expectedNRightShift!

testBitXor
	| larger large |
	self assert: (16rFFFFFFFF bitXor: 16rFFFFFFFF) identicalTo: 0.
	self assert: (16rC0000000 bitXor: 16rFFFFFFFF) identicalTo: 16r3FFFFFFF.
	self assert: (16r7FFFFFFF bitXor: 16r40000000) identicalTo: 16r3FFFFFFF.
	self assert: (16r800000007FFFFFFF bitXor: 16r8000000040000000) identicalTo: 16r3FFFFFFF.
	self assert: (16rFFFFFFFF bitXor: 16r7FFFFFFF) equals: 16r80000000.
	self assert: (16r80000000 bitXor: 16rFFFFFFFF) equals: 16r7FFFFFFF.
	self assert: (16rFFFFFFFF bitXor: 16rFFFFFFFFFFFFFFFF) equals: 16rFFFFFFFF00000000.
	self assert: (16rFFFFFFFFFFFFFFFF bitXor: 16rFFFFFFFF) equals: 16rFFFFFFFF00000000.
	self assert: (16r88442211FFFFFFFF bitXor: 16r88442211C0000000) identicalTo: 16r3FFFFFFF.
	self assert: (16rFFFFFFFFFFFFFFFF bitXor: 16rFFFFFFFF00000000) equals: 16rFFFFFFFF.
	self assert: (16r89ABCDEFF1234567 bitXor: 16r80000000) equals: 16r89ABCDEF71234567.
	self assert: (16r89ABCDEFF1234567 bitXor: -16r80000000) equals: -16r89ABCDEF8EDCBA99.
	self assert: (-16r80000000 bitXor: 16r89ABCDEFF1234567) equals: -16r89ABCDEF8EDCBA99.
	self assert: (16r80000000 bitXor: 16r89ABCDEFF1234567) equals: 16r89ABCDEF71234567.
	larger := 99 factorial.
	large := 91 factorial.
	self assert: ((larger bitXor: large) bitXor: large) equals: larger.
	self assert: ((large bitXor: larger) bitXor: larger) equals: large!

testBitXorSmall
	| res a |
	a := 16r7FFFFFFF.
	res := a bitXor: 0.
	"VM optimizes this caseas as a noop and returns the receiver"
	self assert: res identicalTo: a.
	res := a bitXor: 1.
	self assert: res equals: 16r7FFFFFFE.
	res := a bitXor: SmallInteger maximum.
	self assert: res equals: 16r40000000.
	res := a bitXor: -1.
	self assert: res equals: -16r80000000.
	self assert: res isImmutable.
	"2's complement representation of -16r40000000 is actually 16rC0000000, so result is (in binary)
	16rBFFFFFFF, which is 2's complement representation of -16r40000001"
	res := a bitXor: SmallInteger minimum.
	self assert: res equals: -16r40000001.
	self assert: (res dwordAtOffset: 0) equals: 16rBFFFFFFF.
	a := 16r40000000.
	res := a bitXor: SmallInteger maximum.
	self assert: res equals: 16r7FFFFFFF.
	res := a bitXor: a.
	self assert: res identicalTo: 0!

testDigitLength
	"Note that the digitLength is the number of bytes required to represent the positive magnitude,
	not the 2's complement value."

	#(-16rFFFFFFFF -16r80000000 -16r7FFFFFFF -16r40000001 -16r80000000 16r40000000 16r7FFFFFFF 16r80000000 16rFFFFFFFF)
		do: 
			[:each |
			self assert: each isImmutable.
			self assert: each digitLength identicalTo: 4].
	self assert: (SmallInteger minimum - 1) digitLength equals: 4.
	self assert: (SmallInteger maximum + 1) digitLength equals: 4.
	8 to: 256
		by: 8
		do: 
			[:each |
			| pos neg digits |
			pos := 2 raisedToInteger: each.
			self assert: pos isImmutable.
			digits := each / 8.
			self assert: pos digitLength equals: digits + 1.
			self assert: (pos - 1) digitLength equals: digits.
			neg := pos negated.
			self assert: neg isImmutable.
			self assert: neg digitLength equals: digits + 1.
			self assert: (neg + 1) digitLength equals: digits]!

testDivideSmall
	| int32 result int64 int96 |
	int32 := SmallInteger maximum + 1.
	self assert: int32 isImmutable.
	self assert: int32 equals: 2 ** 30.
	self assert: int32 class identicalTo: LargeInteger.
	self assert: int32 / int32 equals: 1.
	"Divide large pos 32-bit by pos small and get small"
	result := int32 / 2.
	self assert: result isImmutable.
	self assert: result identicalTo: 2 ** 29.
	self assert: result class identicalTo: SmallInteger.
	"Repeat but neg. divisor"
	result := int32 / -2.
	self assert: result isImmutable.
	self assert: result identicalTo: -2 ** 29.
	self assert: result class identicalTo: SmallInteger.
	"Smallest 64-bit positive integer"
	int64 := 2 ** 31.
	self assert: int64 isImmutable.
	self assert: int64 basicSize equals: 8.
	self assert: int64 / int64 equals: 1.
	result := int64 / 2.
	self assert: result isImmutable.
	"Should shrink to 32-bits"
	self assert: result basicSize equals: 4.
	self assert: result class equals: LargeInteger.
	self assert: result equals: 2 ** 30.
	"Largest positive 32-bit divided by SmallInteger yielding ?"
	int64 := 2 ** 63 - 1.
	self assert: int64 isImmutable.
	self assert: int64 / int64 equals: 1.
	""
	int64 := 2 ** 62.
	self assert: int64 isImmutable.
	self assert: int64 basicSize equals: 8.
	self assert: int64 / 2 equals: 2 ** 61.
	"96-bit"
	int96 := 2 ** 63.
	self assert: int96 isImmutable.
	self assert: int96 / int96 equals: 1.
	self assert: int96 basicSize equals: 12.
	result := int96 / 2.
	self assert: result isImmutable.
	self assert: result basicSize equals: 8.
	self assert: result equals: 2 ** 62!

testEqual
	self largePositive do: 
			[:each |
			self assert: each = each.
			self smallIntegerComparisons do: [:i | self deny: each = i]].
	self largeNegative do: 
			[:each |
			self assert: each = each.
			self smallIntegerComparisons do: [:i | self deny: each = i]].
	self largeComparisonPairs do: 
			[:pair |
			self assert: pair first = pair first.
			self assert: pair last = pair last.
			self deny: pair first = pair last.
			self deny: pair last = pair first]!

testEven
	#(1073741824 4294967294 9223372036854775808) do: 
			[:each | 
			self assert: each isImmutable.
			self assert: each even.
			self deny: (each + 1) even]!

testGcd
	| expectedAgcdB a b |
	a := 16rAAE18FA158E1E9FC836350A023D2A12D1AEC1BDCAD4A3B3040DC1D27625277FBDDFBEE25C1820DAC4418603A5AEC122C58B70181129D6B336C4ED37E70808DD0ED55B079706F15F31A84B3AC088F1679CBF2BE66B97A885EA2C95B95D44EBB8369351A3821D3CDB230844C5C5ABF8D7AB663C3DE3CE2FCC580B42A05A0A8ACA331D42948469D8AD5E0F66F7E3250DAC1B4450067B247AD34BFD74C70FD1E29FA4050DC77827763B9BA41410D42494B6299EF13A155C957EC1E7DD0FC6C4CCCDF981128E0C7C016884AE5116C9B24D3C8623AF29031AC1C1E0891F2F1678AB7EE6169AF022479511C7CEA2114F13D541C0F54F253F5DD2553C0EA961384A0C7B2.
	b := 16r83AB64EF1350B335BF5F150D399A2487C1B76D63DF3E59AD2ED3B4FA9A6AD972B6E791C5DD7A8664802F8364F1A8617FB036A74A452AC130727E194F3DD8CFE8.
	expectedAgcdB := 16r00000006.
	self assert: (a gcd: b) equals: expectedAgcdB.
	a := 16r7BC1FB0E0335547E0E85B7461E7554D277515958ADF072C8DB03EB22DCEDF7E28F923F6AF124052D55D623F429083F6266EAA78EFE819E63F8229BDEE155C05B.
	b := 16rE5320F2E379803D724363D84FD61C43CA4E6CA6F16628F59DDEB6557D904639C55F59C2F6BA21E5481107AA947A4653CCC0A5889B6ABCAECF6B58D60F8CC7EEB.
	expectedAgcdB := 16r00000001.
	self assert: (a gcd: b) equals: expectedAgcdB!

testGreaterOrEqual
	self largePositive do: 
			[:each |
			self assert: each >= each.
			self smallIntegerComparisons do: [:i | self assert: each >= i]].
	self largeNegative do: 
			[:each |
			self deny: each > each.
			self smallIntegerComparisons do: [:i | self deny: each >= i]].
	self largeComparisonPairs do: 
			[:pair |
			self assert: pair first >= pair first.
			self assert: pair last >= pair last.
			self deny: pair first >= pair last.
			self assert: pair last >= pair first].
	self should: [SmallInteger maximum + 1 >= nil] raise: MessageNotUnderstood!

testGreaterThan
	self largePositive do: 
			[:each |
			self deny: each > each.
			self smallIntegerComparisons do: [:i | self assert: each > i]].
	self largeNegative do: 
			[:each |
			self deny: each > each.
			self smallIntegerComparisons do: [:i | self deny: each > i]].
	self largeComparisonPairs do: 
			[:pair |
			self deny: pair first > pair first.
			self deny: pair last > pair last.
			self deny: pair first > pair last.
			self assert: pair last > pair first].
	self should: [SmallInteger maximum + 1 > nil] raise: MessageNotUnderstood!

testHighBit
	31 to: 256 do: [:each | self assert: (2 ** each) highBit equals: each + 1]!

testImmutable
	| result |
	result := 16rFFFFFFF * 16.
	self assert: result isImmutable.
	#('-16rFFFFFFFF' '-16r80000000' '-16r7FFFFFFF' '-16r40000001' '-16r80000000' '16r40000000' '16r7FFFFFFF' '16r80000000' '16rFFFFFFFF' '-16rFFFFFFFFFFFFFFFF' '-16r8000000000000000' '-16r7FFFFFFFFFFFFFFF' '-16r4000000000000001' '-16r8000000000000000' '16r4000000000000000' '16r7FFFFFFFFFFFFFFF' '16r8000000000000000' '16rFFFFFFFFFFFFFFFF')
		do: 
			[:each |
			| int |
			int := each asNumber.
			self assert: int isImmutable.
			(OrderedCollection new
				add: SmallInteger maximum;
				add: SmallInteger minimum;
				add: int;
				add: SmallInteger maximum + 1;
				add: SmallInteger maximum - 1;
				add: (2 raisedToInteger: 63) - 1;
				add: (2 raisedToInteger: 63);
				yourself) do: 
						[:x |
						| tmp |
						self assert: x isImmutable.
						tmp := int * x.
						self assert: tmp isImmutable.
						"Sanity check"
						self assert: tmp // x * x + (tmp \\ x) equals: tmp.
						tmp := tmp / x.
						self assert: tmp isImmutable.
						tmp := x * int.
						self assert: tmp isImmutable.
						tmp := tmp / x.
						self assert: tmp isImmutable.
						tmp := int // x.
						self assert: tmp isImmutable.
						tmp := int \\ x.
						self assert: tmp isImmutable.
						tmp := int + x.
						self assert: tmp isImmutable.
						tmp := tmp - x.
						self assert: tmp isImmutable.
						tmp := x + int.
						self assert: tmp isImmutable.
						tmp := int bitOr: x.
						self assert: tmp isImmutable.
						tmp := x bitOr: int.
						self assert: tmp isImmutable.
						tmp := int bitAnd: x.
						self assert: tmp isImmutable.
						tmp := x bitAnd: int.
						self assert: tmp isImmutable.
						tmp := int bitXor: x.
						self assert: tmp isImmutable.
						tmp := x bitXor: int.
						self assert: tmp isImmutable.
						self assert: int bitInvert isImmutable]]!

testLessOrEqual
	self largePositive do: 
			[:each |
			self assert: each <= each.
			self smallIntegerComparisons do: [:i | self deny: each <= i]].
	self largeNegative do: 
			[:each |
			self deny: each < each.
			self smallIntegerComparisons do: [:i | self assert: each <= i]].
	self largeComparisonPairs do: 
			[:pair |
			self assert: pair first <= pair first.
			self assert: pair last <= pair last.
			self assert: pair first <= pair last.
			self deny: pair last <= pair first].
	self should: [SmallInteger maximum + 1 <= nil] raise: MessageNotUnderstood!

testLessThan
	self largePositive do: 
			[:each |
			self deny: each < each.
			self smallIntegerComparisons do: [:i | self deny: each < i]].
	self largeNegative do: 
			[:each |
			self deny: each < each.
			self smallIntegerComparisons do: [:i | self assert: each < i]].
	self largeComparisonPairs do: 
			[:pair |
			self deny: pair first < pair first.
			self deny: pair last < pair last.
			self assert: pair first < pair last.
			self deny: pair last < pair first].
	self should: [SmallInteger maximum + 1 < nil] raise: MessageNotUnderstood!

testLowBit
	#(#(16r40000000 31) #(16r80000000 32) #(16r70000000 29) #(16r10000000000000000 65))
		do: [:each | self assert: each first lowBit equals: each second.
	self assert: each first negated lowBit equals: each second]!

testMod
	| b mod expected result |
	b := 16r10000000000000000.
	mod := 16r29BB3920EF5E958B9.
	expected := 16r44FB1C6472B59405.
	result := b * b % mod.
	self assert: result equals: expected!

testModulo
	"Test #\\, which is mathetical modulo with truncation towards negative infinity (not zero"

	#(-16rFFFFFFFFFFFFFFFFFFFFFFFF -16rFFFFFFFFFFFFFFF -16rFFFFFFFF ##(SmallInteger maximum + 1) ##(SmallInteger
		maximum + 2) 16rFFFFFFFF 16rFFFFFFFFFFFFFFF 16rFFFFFFFFFFFFFFFFFFFFFFFF)
		do: 
			[:dividend |
			self should: [dividend \\ 0] raise: ZeroDivide.
			#(-16r7FFFFFFFFFFFFFFFFFFFFFFF -16r7FFFFFFFFFFFFFFF ##(SmallInteger minimum * 2 - 1) ##(SmallInteger
				minimum / 2) -3 -2 -1 2 3 ##(SmallInteger maximum) ##(SmallInteger maximum + 1) 16r7FFFFFFF 16r7FFFFFFFFFFFFFFF 16r7FFFFFFFFFFFFFFFFFFFFFFF)
				do: 
					[:divisor |
					| expected actual quotient |
					quotient := dividend // divisor.
					expected := dividend - (quotient * divisor).
					actual := dividend \\ divisor.
					self assert: actual equals: expected.
					"Sanity check"
					self assert: quotient * divisor + actual equals: dividend]]!

testMulSmall
	| res a |
	a := 16r40000000.
	self assert: a class identicalTo: LargeInteger.
	res := a * 0.
	self assert: res identicalTo: 0.
	res := a * 1.
	self assert: res equals: a.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := a * SmallInteger maximum.
	self assert: res equals: 16rFFFFFFFC0000000.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := a * -1.
	self assert: res equals: -16r40000000.
	self assert: res class identicalTo: SmallInteger.
	self assert: res isImmutable.
	res := a * SmallInteger minimum.
	self assert: res equals: -16r1000000000000000.
	self assert: res isImmutable.
	"Two limbs"
	a := 16r7FFFFFFFFFFFFFFF.
	res := a * 2.
	self assert: res equals: 16rFFFFFFFFFFFFFFFE.
	self assert: res isImmutable.
	res := a * 3.
	self assert: res equals: 16r17FFFFFFFFFFFFFFD.
	self assert: res isImmutable.
	res := a * -1.
	self assert: res equals: -16r7FFFFFFFFFFFFFFF.
	self assert: res isImmutable.
	res := a * -2.
	self assert: res equals: -16rFFFFFFFFFFFFFFFE.
	self assert: res isImmutable.
	res := a * -3.
	self assert: res equals: -16r17FFFFFFFFFFFFFFD.
	self assert: res isImmutable.
	res := a * SmallInteger maximum.
	self assert: res equals: 16r1FFFFFFF7FFFFFFFC0000001.
	self assert: res isImmutable!

testNegate
	| res a |
	a := SmallInteger minimum.
	res := a negated.
	self assert: res equals: 16r40000000.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := res negated.
	self assert: res identicalTo: SmallInteger minimum.
	"Largest single limb positive still single limb (simple case)"
	a := 16r7FFFFFFF.
	self assert: (a limbSize == 1 and: [(a + 1) limbSize == 2]).
	res := a negated.
	self assert: a negated equals: -16r7FFFFFFF.
	"Largest single limb negative becomes positive"
	a := -16r80000000.
	self assert: (a limbSize == 1 and: [(a - 1) limbSize == 2]).
	res := a negated.
	self assert: res equals: 16r80000000.
	self assert: res limbSize identicalTo: 2.
	res := res negated.
	self assert: res equals: a.
	"2 limbs - first smallest"
	a := 16r80000000.
	res := a negated.
	self assert: res equals: -16r80000000.
	res := res negated.
	self assert: res equals: a.
	"Still no carry from least-significant limb"
	a := 16r8FFFFFFE.
	res := a negated.
	self assert: res equals: -16r8FFFFFFE.
	res := res negated.
	self assert: res equals: a.
	a := 16r89ABCDEF.
	res := a negated.
	self assert: res equals: -16r89ABCDEF.
	res := res negated.
	self assert: res equals: a.
	"Requires carry from least significant limb"
	a := 16r8FFFFFFFF.
	res := a negated.
	self assert: res equals: -16r8FFFFFFFF.
	res := res negated.
	self assert: res equals: a.
	"Max 2-limbed negative negates to three limbed positive"
	a := -16r8000000000000000.
	res := a negated.
	self assert: res equals: 16r8000000000000000.
	res := res negated.
	self assert: res equals: a.
	"Three limbs "
	a := 16r8000000000000001.
	res := a negated.
	self assert: res equals: -16r8000000000000001.
	res := res negated.
	self assert: res equals: a.
	a := 16r7FFFFFFFFFFFFFFFFFFFFFF.
	res := a negated.
	self assert: res equals: -16r7FFFFFFFFFFFFFFFFFFFFFF.
	res := res negated.
	self assert: res equals: a.
	"Zero limbs will require ripple carry (maximum value of addition in add loop is 16rFFFFFFFF + 1)"
	a := 16r800000000000000000000000.
	res := a negated.
	self assert: res equals: -16r800000000000000000000000.
	res := res negated.
	self assert: res equals: a!

testPrintLargeBase2
	"#1664."

	| l l2 binary |
	l := 600 factorial.
	self assert: l isImmutable.
	binary := l printStringRadix: 2.
	l2 := Integer readFrom: binary readStream.
	self assert: l equals: l2!

testPrintStringBase
	2 to: 32
		do: 
			[:b |
			1 to: 1000 // b
				do: 
					[:n |
					| bRaisedToN |
					bRaisedToN := b raisedTo: n.
					self assert: (bRaisedToN - 1 printStringBase: b)
						equals: (String new: n withAll: (Character digitValue: b - 1)).
					self assert: (bRaisedToN printStringBase: b) equals: '1' , (String new: n withAll: $0).
					self assert: (bRaisedToN negated + 1 printStringBase: b)
						equals: '-' , (String new: n withAll: (Character digitValue: b - 1)).
					self assert: (bRaisedToN negated printStringBase: b) equals: '-1' , (String new: n withAll: $0)]]!

testQuo
	| u v |
	u := 1490632608.
	v := -14.
	self assert: (u quo: v) equals: -106473757.

	"Bug in primitive for optimised case where numerator has more 32-bit digits than denominator
	(and therefore quo of 0 can be determined very quickly), causes crash in unpatched VM"
	u := -2 ** 63 - 1.
	v := 2 ** 96 - 1.
	self assert: (u quo: v) identicalTo: 0.
	v := v negated.
	self assert: (u quo: v) identicalTo: 0!

testQuoRem
	| u v qr q r |
	u := 5316911983139663491639247439134020953.
	v := 48038396025285298.
	qr := u quoAndRem: v.
	"qr := u liDiv: v."
	q := qr first.
	r := qr second.

	"Check basic attributes of quo and rem"
	self assert: q * v + r equals: u.

	"Remainder should be less than divisor"
	self assert: r < v.

	"Actual results should be"
	self assert: q equals: 110680464442257292800!

testQuoRem2
	#(16rFFFFFFFFFFFFFFFF 16rFFFFFFFEFFFFFFFF 16rFFFFFFFF7FFFFFFF 16rFFFFFFFE7FFFFFFF) do: 
			[:each |
			| qr r q2 v u |
			v := 16r100000003.
			u := each * v.
			qr := u quoAndRem: v.
			q2 := qr first.
			r := qr second.
			"A basic invariant is that the quotient * denominator + remainder = numerator"
			self assert: q2 * v + r equals: u.
			"But this is a special case where the numerator divides exactly"
			self assert: q2 equals: each.
			self assert: r identicalTo: 0]!

testQuoRem3
	#(#(16r1000000000 1) #(16rFFFFFFFF00000000 16rFFFFFFFF) #(1 1) #(7 3) #(16r00000000FFFFFFFF 16r00000001) #(16r0123456789ABCDEF 16r01234568) #(16r0123456789ABCDEF 16r12345678) #(16r0123456789ABCDEF 16r80000000) #(16r0123456789ABCDEF 16r80000001) #(16r0123456789ABCDEF 16r80007FFF) #(16r0123456789ABCDEF 16r80008000) #(16r0123456789ABCDEF 16r80008001) #(16r0123456789ABCDEF 16r8000FFFF) #(16r0000000000000000 16r0000FFFF) #(16r000000000000FFFF 16r0000FFFF) #(16r00000000FFFF0000 16r0000FFFF) #(16r00000000FFFFFFFF 16r0000FFFF) #(16r0000FFFE00000000 16r0000FFFF) #(16r0000FFFE0000FFFF 16r0000FFFF) #(16r0000FFFEFFFF0000 16r0000FFFF) #(16r0000FFFEFFFFFFFF 16r0000FFFF) #(16r0000000000000000 16rFFFF0000) #(16r000000000000FFFF 16rFFFF0000) #(16r00000000FFFF0000 16rFFFF0000) #(16r00000000FFFFFFFF 16rFFFF0000) #(16r0000FFFF00000000 16rFFFF0000) #(16r0000FFFF0000FFFF 16rFFFF0000) #(16r0000FFFFFFFF0000 16rFFFF0000) #(16r0000FFFFFFFFFFFF 16rFFFF0000) #(16rFFFE000000000000 16rFFFF0000) #(16rFFFE00000000FFFF 16rFFFF0000) #(16rFFFE0000FFFF0000 16rFFFF0000) #(16rFFFE0000FFFFFFFF 16rFFFF0000) #(16rFFFEFFFF00000000 16rFFFF0000) #(16rFFFEFFFF0000FFFF 16rFFFF0000) #(16rFFFEFFFFFFFF0000 16rFFFF0000) #(16rFFFEFFFFFFFFFFFF 16rFFFF0000) #(16r0000000000000000 16rFFFFFFFF) #(16r000000000000FFFF 16rFFFFFFFF) #(16r00000000FFFF0000 16rFFFFFFFF) #(16r00000000FFFFFFFF 16rFFFFFFFF) #(16r0000FFFF00000000 16rFFFFFFFF) #(16r0000FFFF0000FFFF 16rFFFFFFFF) #(16r0000FFFFFFFF0000 16rFFFFFFFF) #(16r0000FFFFFFFFFFFF 16rFFFFFFFF) #(16rFFFF000000000000 16rFFFFFFFF) #(16rFFFF00000000FFFF 16rFFFFFFFF) #(16rFFFF0000FFFF0000 16rFFFFFFFF) #(16rFFFF0000FFFFFFFF 16rFFFFFFFF) #(16rFFFFFFFE00000000 16rFFFFFFFF) #(16rFFFFFFFE0000FFFF 16rFFFFFFFF) #(16rFFFFFFFEFFFF0000 16rFFFFFFFF) #(16rFFFFFFFEFFFFFFFF 16rFFFFFFFF) #(16r123456789ABCDEF0 16r12345679) #(16r0001000000000000 16r00010001) #(16r8000800000000000 16r80008001) #(16r8000FFFEFFFFFFFF 16r8000FFFF) #(16r7FFF800000000000 16r8000FFFF) #(16r7FFFFFFFFFFFFFFFFFFFFFFF 16r80000000))
		do: 
			[:each |
			| qr r q2 v u |
			v := each second.
			u := each first.
			qr := u quoAndRem: v.
			q2 := qr first.
			r := qr second.
			"A basic invariant is that the quotient * denominator + remainder = numerator"
			self assert: q2 * v + r equals: u.
			"And the remainders should be less than the denominator"
			self assert: r < v]!

testRaisedToInteger
	| subject |
	subject := 20 factorial.
	self assert: (subject raisedToInteger: 0) equals: 1.
	self assert: (subject raisedToInteger: 1) equals: subject.
	self assert: (subject raisedToInteger: 3) equals: subject * subject * subject.
	self assert: (subject raisedToInteger: -2) equals: 1 / (subject * subject).
	self assert: (10 raisedToInteger: 255) printString size equals: 256!

testRem
	#(-16rFFFFFFFFFFFFFFFFFFFFFFFF -16rFFFFFFFFFFFFFFF -16rFFFFFFFF ##(SmallInteger maximum + 1) ##(SmallInteger
		maximum + 2) 16rFFFFFFFF 16rFFFFFFFFFFFFFFF 16rFFFFFFFFFFFFFFFFFFFFFFFF)
		do: 
			[:dividend |
			#(-16r7FFFFFFFFFFFFFFFFFFFFFFF -16r7FFFFFFFFFFFFFFF ##(SmallInteger minimum * 2 - 1) ##(SmallInteger
				minimum / 2) -3 -2 -1 2 3 ##(SmallInteger maximum) ##(SmallInteger maximum + 1) 16r7FFFFFFF 16r7FFFFFFFFFFFFFFF 16r7FFFFFFFFFFFFFFFFFFFFFFF)
				do: 
					[:divisor |
					| expected actual quotient |
					quotient := dividend quo: divisor.
					expected := dividend - (quotient * divisor).
					actual := dividend rem: divisor.
					self assert: actual equals: expected.
					"% is the operator equivalent of #rem:"
					actual := dividend % divisor.
					self assert: actual equals: expected.
					"Sanity check"
					self assert: quotient * divisor + actual equals: dividend]]!

testSubFromQuad
	"Test adding various sized boundary case large integers to boundary case quad-limbed large positive integers."

	| res a |
	a := 2 ** 95.	"Smallest 4-limb large positive integer"
	self assert: a byteSize identicalTo: 16.
	self assert: (a - 1) byteSize identicalTo: 12.
	#(#(16r40000000 16r7FFFFFFFFFFFFFFFC0000000) #(-16r40000001 16r800000000000000040000001) #(16r7FFFFFFF 16r7FFFFFFFFFFFFFFF80000001) #(-16r80000000 16r800000000000000080000000) #(16r80000000 16r7FFFFFFFFFFFFFFF80000000) #(-16r80000001 16r800000000000000080000001) #(16rFFFFFFFF 16r7FFFFFFFFFFFFFFF00000001) #(-16rFFFFFFFF 16r8000000000000000FFFFFFFF) #(16r7FFFFFFFFFFFFFFF 16r7FFFFFFF8000000000000001) #(-16r8000000000000000 16r800000008000000000000000) #(16r8000000000000000 16r7FFFFFFF8000000000000000) #(-16r8000000000000001 16r800000008000000000000001))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a - b.
			self assert: res equals: eachPair second.
			self assert: res + b equals: a].
	"Largest 4-limb large positive integer"
	a := 2 ** 127 - 1.
	self assert: a byteSize identicalTo: 16.
	self assert: (a + 1) byteSize identicalTo: 20.
	#(#(16r3FFFFFFF 16r7FFFFFFFFFFFFFFFFFFFFFFFC0000000) #(16r40000000 16r7FFFFFFFFFFFFFFFFFFFFFFFBFFFFFFF) #(-16r40000000 16r8000000000000000000000003FFFFFFF) #(-16r40000001 16r80000000000000000000000040000000) #(16r7FFFFFFF 16r7FFFFFFFFFFFFFFFFFFFFFFF80000000) #(-16r80000000 16r8000000000000000000000007FFFFFFF) #(16r80000000 16r7FFFFFFFFFFFFFFFFFFFFFFF7FFFFFFF) #(-16r80000001 16r80000000000000000000000080000000) #(16rFFFFFFFF 16r7FFFFFFFFFFFFFFFFFFFFFFF00000000) #(-16rFFFFFFFF 16r800000000000000000000000FFFFFFFE) #(16r7FFFFFFFFFFFFFFF 16r7FFFFFFFFFFFFFFF8000000000000000) #(-16r8000000000000000 16r80000000000000007FFFFFFFFFFFFFFF) #(16r8000000000000000 16r7FFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF) #(-16r8000000000000001 16r80000000000000008000000000000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a - b.
			self assert: res equals: eachPair second.
			self assert: res + b equals: a]!

testSubFromQuadNeg
	"Test adding various sized boundary case large integers to boundardy case quad-limbed large negative integers."

	| res a |
	a := -2 ** 95 - 1.	"Smallest 4-limb large negative integer"
	self assert: a byteSize identicalTo: 16.
	self assert: (a + 1) byteSize identicalTo: 12.
	#(#(16r3FFFFFFF -16r800000000000000040000000) #(16r40000000 -16r800000000000000040000001) #(-16r40000000 -16r7FFFFFFFFFFFFFFFC0000001) #(-16r40000001 -16r7FFFFFFFFFFFFFFFC0000000) #(16r7FFFFFFF -16r800000000000000080000000) #(-16r80000000 -16r7FFFFFFFFFFFFFFF80000001) #(16r80000000 -16r800000000000000080000001) #(-16r80000001 -16r7FFFFFFFFFFFFFFF80000000) #(16rFFFFFFFF -16r800000000000000100000000) #(-16rFFFFFFFF -16r7FFFFFFFFFFFFFFF00000002) #(16r7FFFFFFFFFFFFFFF -16r800000008000000000000000) #(-16r8000000000000000 -16r7FFFFFFF8000000000000001) #(16r8000000000000000 -16r800000008000000000000001) #(-16r8000000000000001 -16r7FFFFFFF8000000000000000))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a - b.
			self assert: res equals: eachPair second.
			self assert: res + b equals: a].
	"Largest 4-limb negative large integer"
	a := -2 ** 127.
	self assert: a byteSize identicalTo: 16.
	self assert: (a - 1) byteSize identicalTo: 20.
	#(#(16r3FFFFFFF -16r8000000000000000000000003FFFFFFF) #(16r40000000 -16r80000000000000000000000040000000) #(-16r40000000 -16r7FFFFFFFFFFFFFFFFFFFFFFFC0000000) #(-16r40000001 -16r7FFFFFFFFFFFFFFFFFFFFFFFBFFFFFFF) #(16r7FFFFFFF -16r8000000000000000000000007FFFFFFF) #(-16r80000000 -16r7FFFFFFFFFFFFFFFFFFFFFFF80000000) #(16r80000000 -16r80000000000000000000000080000000) #(-16r80000001 -16r7FFFFFFFFFFFFFFFFFFFFFFF7FFFFFFF) #(16rFFFFFFFF -16r800000000000000000000000FFFFFFFF) #(-16rFFFFFFFF -16r7FFFFFFFFFFFFFFFFFFFFFFF00000001) #(16r7FFFFFFFFFFFFFFF -16r80000000000000007FFFFFFFFFFFFFFF) #(-16r8000000000000000 -16r7FFFFFFFFFFFFFFF8000000000000000) #(16r8000000000000000 -16r80000000000000008000000000000000) #(-16r8000000000000001 -16r7FFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF))
		do: 
			[:eachPair |
			| b |
			b := eachPair first.
			res := a - b.
			self assert: res equals: eachPair second.
			self assert: res + b equals: a]!

testSubtractSmall
	| res |
	res := 16r40000000 - 1.
	self assert: res equals: 16r3FFFFFFF.
	self assert: res class identicalTo: SmallInteger.
	self assert: res isImmutable.
	res := 16r80000000 - 1.
	self assert: res equals: 16r7FFFFFFF.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := 16r80000000 - SmallInteger maximum.
	self assert: res equals: 16r40000001.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := 16r40000000 - SmallInteger minimum.
	self assert: res equals: 16r80000000.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := 16r80000000 - SmallInteger minimum.
	self assert: res equals: 16rC0000000.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable.
	res := 16r7FFFFFFF - SmallInteger minimum.
	self assert: res equals: 16rBFFFFFFF.
	self assert: res class identicalTo: LargeInteger.
	self assert: res isImmutable! !
!Core.Tests.LargeIntegerTest categoriesFor: #canonicalInstance!constants!private! !
!Core.Tests.LargeIntegerTest categoriesFor: #largeComparisonPairs!constants!private! !
!Core.Tests.LargeIntegerTest categoriesFor: #largeNegative!constants!private! !
!Core.Tests.LargeIntegerTest categoriesFor: #largePositive!constants!private! !
!Core.Tests.LargeIntegerTest categoriesFor: #smallIntegerComparisons!constants!private! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddDoubleToDoubleNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddDoubleToDoublePos!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddDoubleToTripleNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddDoubleToTriplePos!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddSingleToDoubleNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddSingleToDoublePos!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddSingleToSingleNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddSingleToSinglePos!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddSingleToTripleNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddSmall!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddToQuad!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddToQuadNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddTripleToTripleNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testAddTripleToTriplePos!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitAnd!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitAndSmall!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitOr!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitOrSmall!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitShiftRand2048n!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitShiftRand512n!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitXor!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testBitXorSmall!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testDigitLength!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testDivideSmall!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testEqual!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testEven!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testGcd!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testGreaterOrEqual!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testGreaterThan!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testHighBit!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testImmutable!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testLessOrEqual!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testLessThan!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testLowBit!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testMod!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testModulo!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testMulSmall!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testNegate!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testPrintLargeBase2!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testPrintStringBase!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testQuo!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testQuoRem!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testQuoRem2!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testQuoRem3!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testRaisedToInteger!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testRem!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testSubFromQuad!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testSubFromQuadNeg!public!unit tests! !
!Core.Tests.LargeIntegerTest categoriesFor: #testSubtractSmall!public!unit tests! !

