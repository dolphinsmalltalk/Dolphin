"Filed out from Dolphin Smalltalk 7"!

ExternalArrayTest subclass: #GenericExternalArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
			class := each asQualifiedReference value.
			array := self arrayClass length: 1 elementClass: class.
			self assert: array elementSize equals: class elementSize]!

testInvalidLength
	"#1051."

	self should: [self arrayClass length: -1 elementClass: DWORD] raise: Error! !
!GenericExternalArrayTest categoriesFor: #arrayValueString:!private!unit tests! !
!GenericExternalArrayTest categoriesFor: #elementClassNames!constants!private! !
!GenericExternalArrayTest categoriesFor: #elementFromValue:!private!unit tests! !
!GenericExternalArrayTest categoriesFor: #elementToValue:!private!unit tests! !
!GenericExternalArrayTest categoriesFor: #numericElementClass!constants!private! !
!GenericExternalArrayTest categoriesFor: #testElementSize!public!unit tests! !
!GenericExternalArrayTest categoriesFor: #testInvalidLength!public!unit tests! !

