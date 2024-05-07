"Filed out from Dolphin Smalltalk"!

ExternalArrayTest subclass: #GenericExternalArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GenericExternalArrayTest guid: (GUID fromString: '{69952948-3aa8-44c5-956f-8731aa221d5f}')!

GenericExternalArrayTest isAbstract: true!

GenericExternalArrayTest comment: ''!

!GenericExternalArrayTest categoriesForClass!Unclassified! !

!GenericExternalArrayTest methodsFor!

arrayValueString: eachValue
	^eachValue displayString!

elementClassNames
	^#(#SWORD #SDWORD #FLOAT #DOUBLE #CURRENCY #BSTR #HRESULT #VARIANT_BOOL #VARIANT #DECIMAL #SBYTE #BYTE)!

elementFromValue: anObject
	^self numericElementClass fromObject: anObject!

elementToValue: element 
	^element value!

numericElementClass
	^SDWORD!

testElementSize
	self elementClassNames do: 
			[:each |
			| class array |
			class := Smalltalk at: each.
			array := self arrayClass length: 1 elementClass: class.
			self assert: array elementSize equals: class elementSize]!

testInvalidLength
	"#1051."

	self should: [self arrayClass length: -1 elementClass: DWORD] raise: Error! !

!GenericExternalArrayTest categoriesForMethods!
arrayValueString:!private!unit tests! !
elementClassNames!constants!private! !
elementFromValue:!private!unit tests! !
elementToValue:!private!unit tests! !
numericElementClass!constants!private! !
testElementSize!public!unit tests! !
testInvalidLength!public!unit tests! !
!

