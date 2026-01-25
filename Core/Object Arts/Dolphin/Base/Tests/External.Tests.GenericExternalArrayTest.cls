"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.GenericExternalArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.GenericExternalArrayTest guid: (Core.GUID fromString: '{69952948-3aa8-44c5-956f-8731aa221d5f}')!

External.Tests.GenericExternalArrayTest isNonInstantiable: true!

External.Tests.GenericExternalArrayTest comment: ''!

!External.Tests.GenericExternalArrayTest methodsFor!

arrayValueString: eachValue
	^eachValue displayString!

elementClassNames
	^#(#Int16 #Int32 #FLOAT #DOUBLE #'COM.CURRENCY' #'COM.BSTR' #HRESULT #'COM.VARIANT_BOOL' #'COM.VARIANT' #'COM.DECIMAL' #Int8 #UInt8)!

elementToValue: element 
	^element value!

testAsArray
	"GenericExternalArrays do not compare equal to Arrays of equivalent values (or indeed ExternalArrays of the same value type) because the elements as enumerated are structures, not values."

	| subject array elements |
	subject := self newMultiElementSubject.
	array := subject asArray.
	elements := array collect: [:each | self elementFromIndex: each].
	self assert: subject equals: elements.
	self assert: subject hash equals: elements hash.
	self assert: elements equals: subject!

testComparing
	"GenericExternalArrays do not compare equal to Arrays of equivalent values (or indeed ExternalArrays of the same value type) because the elements as enumerated are structures."

	| subject1 subject2 |
	subject1 := self newMultiElementSubject.
	subject2 := self newMultiElementSubject.
	self assert: subject1 hash equals: subject2 hash.
	self assert: subject1 equals: subject2.
	(subject1 at: 1) value: 10.
	self deny: subject1 hash equals: subject2 hash.
	self deny: subject1 equals: subject2!

testElementClass
	^self assert: (self newTestSubjectOfSize: 1) elementClass identicalTo: self class numericElementClass!

testElementSize
	self elementClassNames do: 
			[:each |
			| class array |
			class := each asQualifiedReference value.
			array := self arrayClass length: 1 elementClass: class.
			self assert: array elementSize equals: class elementSize]!

testInvalidLength
	"#1051."

	self should: [self arrayClass length: -1 elementClass: UInt32] raise: Error!

testSelfEvaluating
	| subject |
	subject := self newMultiElementSubject.
	self deny: subject isSelfEvaluating!

testWithDo
	| count validationBlock subject |
	count := 1.
	validationBlock := 
			[:a :b |
			self assert: b equals: count.
			self assert: a isKindOf: Int32.
			self assert: a value equals: b.
			count := count + 1.
			a value: count].
	#(1 2 5) do: 
			[:each |
			subject := self newTestSubjectOfSize: each.
			subject with: (1 to: each) do: validationBlock.
			self assert: subject asArray equals: (2 to: each + 1).
			count := 1].
	subject := self newMultiElementSubject.
	{ 0. 1. subject size - 1. subject size + 1 } do: 
			[:each |
			self
				should: [subject with: (1 to: each) do: [:a :b | ]]
				raise: Error
				matching: [:ex | ex description = 'collections are of different sizes']].
	subject := self newTestSubjectOfSize: 0.
	subject with: (1 to: 0) do: [:a :b | self assert: false]! !

!External.Tests.GenericExternalArrayTest categoriesForMethods!
arrayValueString:!private!unit tests! !
elementClassNames!constants!private! !
elementToValue:!private!unit tests! !
testAsArray!public!unit tests! !
testComparing!public!unit tests! !
testElementClass!public! !
testElementSize!public!unit tests! !
testInvalidLength!public!unit tests! !
testSelfEvaluating!public!unit tests! !
testWithDo!public!unit tests! !
!

!External.Tests.GenericExternalArrayTest class methodsFor!

elementFromIndex: anObject
	^self numericElementClass fromObject: anObject!

numericElementClass
	^Int32! !

!External.Tests.GenericExternalArrayTest class categoriesForMethods!
elementFromIndex:!private!unit tests! !
numericElementClass!constants!private! !
!

