"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest subclass: #'External.Tests.GenericExternalArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.GenericExternalArrayTest guid: (Core.GUID fromString: '{69952948-3aa8-44c5-956f-8731aa221d5f}')!
External.Tests.GenericExternalArrayTest isNonInstantiable: true!
External.Tests.GenericExternalArrayTest comment: ''!
!External.Tests.GenericExternalArrayTest categoriesForClass!Unclassified! !
!External.Tests.GenericExternalArrayTest methodsFor!

arrayValueString: eachValue
	^eachValue displayString!

elementClassNames
	^#(#SWORD #SDWORD #FLOAT #DOUBLE #'COM.CURRENCY' #'COM.BSTR' #HRESULT #'COM.VARIANT_BOOL' #'COM.VARIANT' #'COM.DECIMAL' #SBYTE #BYTE)!

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
			class := each asQualifiedReference value.
			array := self arrayClass length: 1 elementClass: class.
			self assert: array elementSize equals: class elementSize]!

testInvalidLength
	"#1051."

	self should: [self arrayClass length: -1 elementClass: DWORD] raise: Error! !
!External.Tests.GenericExternalArrayTest categoriesForMethods!
arrayValueString:!private!unit tests! !
elementClassNames!constants!private! !
elementFromValue:!private!unit tests! !
elementToValue:!private!unit tests! !
numericElementClass!constants!private! !
testElementSize!public!unit tests! !
testInvalidLength!public!unit tests! !
!

