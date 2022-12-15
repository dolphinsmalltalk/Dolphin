"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'External.Tests.ExternalArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.ExternalArrayTest guid: (Core.GUID fromString: '{356dac42-9b9c-4970-87d2-bfd4846fafa4}')!
External.Tests.ExternalArrayTest isNonInstantiable: true!
External.Tests.ExternalArrayTest comment: ''!
!External.Tests.ExternalArrayTest methodsFor!

arrayClass
	^self subclassResponsibility!

arrayValueString: eachValue
	^eachValue printString!

canonicalizeValue: anObject 
	^self elementToValue: (self elementFromValue: anObject)!

elementFromValue: anObject 
	^anObject!

elementToValue: element 
	^element!

newArrayOfIntegers: anArray 
	^self arrayClass withAll: anArray!

newNumericArray: anInteger 
	^self newArrayOfIntegers: (1 to: anInteger)!

numericElementClass
	^self subclassResponsibility!

testAllSatisfy
	0 to: 4
		do: 
			[:count |
			| array elements |
			array := self newNumericArray: count.
			elements := Array writeStream.
			array allSatisfy: 
					[:each |
					elements nextPut: each.
					true].
			self assert: elements contents equals: ((1 to: count) collect: [:i | self elementFromValue: i]).
			elements reset.
			array allSatisfy: 
					[:each |
					elements nextPut: each.
					false].
			self assert: elements contents
				equals: ((1 to: (count min: 1)) collect: [:i | self elementFromValue: i])]!

testAtAllPut
	0 to: 4
		do: 
			[:count |
			| array elements element |
			array := self newNumericArray: count.
			array atAllPut: (self elementFromValue: count).
			elements := Array writeStream.
			array do: [:each | elements nextPut: each].
			element := self elementFromValue: count.
			self assert: elements contents equals: ((1 to: count) collect: [:i | element])].
	self should: [self arrayClass new: 1 withAll: Object new] raise: Error!

testAtAndAtPut
	| array |
	array := self newNumericArray: 0.
	#(-1 0 1 2) do: 
			[:each |
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	array := self newNumericArray: 1.
	#(-1 0 2 3) do: 
			[:each |
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	#(1) do: 
			[:each |
			| elem |
			elem := self elementFromValue: each.
			self assert: (array at: each put: elem) equals: elem.
			self assert: (self elementToValue: (array at: each)) equals: (self canonicalizeValue: each)].
	array := self newNumericArray: 2.
	#(-1 0 3) do: 
			[:each |
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	#(1 2) do: 
			[:each |
			| elem |
			elem := self elementFromValue: each.
			self assert: (array at: each put: elem) equals: elem.
			self assert: (self elementToValue: (array at: each)) equals: (self canonicalizeValue: each)].
	array := self newNumericArray: 3.
	#(-1 0 4) do: 
			[:each |
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	#(1 2 3) do: 
			[:each |
			| elem |
			elem := self elementFromValue: each.
			self assert: (array at: each put: elem) equals: elem.
			self assert: (self elementToValue: (array at: each)) equals: (self canonicalizeValue: each)]!

testComparing
	| subject array |
	subject := self newNumericArray: 0.
	self assert: subject equals: #().
	self assert: subject hash equals: #() hash.
	subject := self newNumericArray: 5.
	array := subject asArray.
	self assert: subject hash equals: array hash.
	self assert: subject equals: array.
	self assert: array equals: subject!

testCopyFromTo
	| array |
	array := self newNumericArray: 0.
	self assert: (array copyFrom: 1 to: 0) equals: #().
	self
		should: [array copyFrom: 0 to: 0]
		raise: BoundsError
		matching: [:ex | ex tag = 0].
	self
		should: [array copyFrom: 1 to: 2]
		raise: BoundsError
		matching: [:ex | ex tag = 1].
	array := self newNumericArray: 1.
	self assert: (array copyFrom: 1 to: 0) equals: #().
	self assert: (array copyFrom: 1 to: 1) equals: {self elementFromValue: 1}.
	2 to: 3
		do: 
			[:i |
			self
				should: [array copyFrom: 1 to: i]
				raise: BoundsError
				matching: [:ex | ex tag = 2]].
	array := self newNumericArray: 2.
	self assert: (array copyFrom: 1 to: 0) equals: #().
	self assert: (array copyFrom: 1 to: 1) equals: {self elementFromValue: 1}.
	self assert: (array copyFrom: 2 to: 2) equals: {self elementFromValue: 2}.
	self assert: (array copyFrom: 1 to: 2) equals: {self elementFromValue: 1. self elementFromValue: 2}.
	3 to: 4
		do: 
			[:i |
			self
				should: [array copyFrom: 1 to: i]
				raise: BoundsError
				matching: [:ex | ex tag = 3]].
	array := self newNumericArray: 3.
	self assert: (array copyFrom: 1 to: 0) equals: #().
	self assert: (array copyFrom: 1 to: 1) equals: {self elementFromValue: 1}.
	self assert: (array copyFrom: 2 to: 2) equals: {self elementFromValue: 2}.
	self assert: (array copyFrom: 3 to: 3) equals: {self elementFromValue: 3}.
	self assert: (array copyFrom: 1 to: 2) equals: {self elementFromValue: 1. self elementFromValue: 2}.
	self assert: (array copyFrom: 2 to: 3) equals: {self elementFromValue: 2. self elementFromValue: 3}.
	self assert: (array copyFrom: 1 to: 3)
		equals: {self elementFromValue: 1. self elementFromValue: 2. self elementFromValue: 3}.
	1 to: 3
		do: 
			[:j |
			4 to: 5
				do: 
					[:i |
					self
						should: [array copyFrom: j to: i]
						raise: BoundsError
						matching: [:ex | ex tag = 4]]]!

testDoSeparatedBy
	0 to: 4
		do: 
			[:count |
			| interstices array elements |
			array := self newNumericArray: count.
			elements := Array writeStream.
			interstices := 0.
			array do: [:each | elements nextPut: each] separatedBy: [interstices := interstices + 1].
			self assert: elements contents equals: ((1 to: count) collect: [:i | self elementFromValue: i]).
			self assert: interstices equals: (count - 1 max: 0)]!

testElementClass
	self assert: (self newNumericArray: 1) elementClass identicalTo: self numericElementClass!

testFromToKeysAndValuesDo
	"Empty array"

	| array pairs |
	array := self newNumericArray: 0.
	pairs := OrderedCollection new.
	#(#(1 0)) do: 
			[:each |
			array
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue].
			self assert: pairs isEmpty].
	#(#(0 -1) #(-1 0) #(0 1) #(1 1) #(2 2) #(2 1) #(3 2)) do: 
			[:each |
			self should: 
					[array
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue]]
				raise: BoundsError.
			self assert: pairs isEmpty].
	"Array of 1 element"
	array := self newNumericArray: 1.
	#(#(1 0) #(2 1)) do: 
			[:each |
			array
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue].
			self assert: pairs isEmpty].
	#(#(1 1)) do: 
			[:each |
			| expected |
			pairs := OrderedCollection new.
			array
				from: 1
				to: 1
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> (self arrayValueString: eachValue)].
			expected := (each first to: each last) collect: [:i | i -> (self canonicalizeValue: i) printString].
			self assert: pairs asArray equals: expected].
	#(#(1 2) #(2 2) #(3 2)) do: 
			[:each |
			self should: 
					[array
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> (self arrayValueString: eachValue)]]
				raise: BoundsError].
	pairs := OrderedCollection new.
	"Array of two elements"
	array := self newNumericArray: 2.
	#(#(1 0) #(2 1) #(3 2)) do: 
			[:each |
			array
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> (self arrayValueString: eachValue)].
			self assert: pairs isEmpty].
	#(#(1 1) #(1 2) #(2 2)) do: 
			[:each |
			| expected |
			pairs := OrderedCollection new.
			array
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> (self arrayValueString: eachValue)].
			expected := (each first to: each last) collect: [:i | i -> (self canonicalizeValue: i) printString].
			self assert: pairs asArray equals: expected].
	#(#(1 3) #(2 3) #(3 3)) do: 
			[:each |
			self should: 
					[array
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> (self arrayValueString: eachValue)]]
				raise: BoundsError].
	"Array of three elements"
	pairs := OrderedCollection new.
	array := self newNumericArray: 3.
	#(#(1 0) #(2 1) #(3 2) #(4 3)) do: 
			[:each |
			array
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> (self arrayValueString: eachValue)].
			self assert: pairs isEmpty].
	#(#(1 1) #(1 2) #(2 2) #(1 3) #(2 3) #(3 3)) do: 
			[:each |
			| expected |
			pairs := OrderedCollection new.
			array
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> (self arrayValueString: eachValue)].
			expected := (each first to: each last) collect: [:i | i -> (self canonicalizeValue: i) printString].
			self assert: pairs asArray equals: expected].
	#(#(1 4) #(2 4) #(3 4) #(4 4)) do: 
			[:each |
			self should: 
					[array
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | ]]
				raise: BoundsError]!

testMarshal
	| subject |
	subject := self arrayClass marshal: ((1 to: 3) collect: [:each | self canonicalizeValue: each]).
	self assert: subject equals: (self newNumericArray: 3).
	self assert: (self arrayClass marshal: subject) identicalTo: subject!

testMaxEncoding
	| subject |
	subject := self newNumericArray: 5.
	self assert: subject maxEncoding equals: 1!

testSelfEvaluating
	| subject |
	subject := self newNumericArray: 3.
	self assert: subject isSelfEvaluating.
	self assert: subject printString
		equals: '(<1p> withAll: #(<2p> <3p> <4p>))'
				<< ({self arrayClass} , ((1 to: 3) collect: [:i | self elementFromValue: i]))!

testWithDo
	| count validationBlock subject |
	count := 1.
	validationBlock := 
			[:a :b |
			self assert: b equals: count.
			self assert: a value equals: (self canonicalizeValue: b).
			count := count + 1].
	#(1 2 5) do: 
			[:each |
			subject := self newNumericArray: each.
			subject with: (1 to: each) do: validationBlock.
			count := 1].
	subject := self newNumericArray: 5.
	{0. 1. subject size - 1. subject size + 1} do: 
			[:each |
			self
				should: [subject with: (1 to: each) do: [:a :b | ]]
				raise: Error
				matching: [:ex | ex description = 'collections are of different sizes']].
	subject := self newNumericArray: 0.
	subject with: (1 to: 0) do: [:a :b | self assert: false]! !
!External.Tests.ExternalArrayTest categoriesForMethods!
arrayClass!constants!private! !
arrayValueString:!private!unit tests! !
canonicalizeValue:!private!unit tests! !
elementFromValue:!private!unit tests! !
elementToValue:!private!unit tests! !
newArrayOfIntegers:!helpers!private! !
newNumericArray:!helpers!private! !
numericElementClass!constants!private! !
testAllSatisfy!public! !
testAtAllPut!public! !
testAtAndAtPut!public!unit tests! !
testComparing!public!unit tests! !
testCopyFromTo!public!unit tests! !
testDoSeparatedBy!public!unit tests! !
testElementClass!public!unit tests! !
testFromToKeysAndValuesDo!public!unit tests! !
testMarshal!public!unit tests! !
testMaxEncoding!public!unit tests! !
testSelfEvaluating!public!unit tests! !
testWithDo!public!unit tests! !
!

