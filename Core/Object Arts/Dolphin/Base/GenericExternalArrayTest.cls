"Filed out from Dolphin Smalltalk 7"!

ExternalArrayTest subclass: #GenericExternalArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GenericExternalArrayTest guid: (GUID fromString: '{69952948-3AA8-44C5-956F-8731AA221D5F}')!
GenericExternalArrayTest comment: ''!
!GenericExternalArrayTest categoriesForClass!Unclassified! !
!GenericExternalArrayTest methodsFor!

elementClassNames
	^#(#SWORD #SDWORD #FLOAT #DOUBLE #CURRENCY #BSTR #HRESULT #VARIANT_BOOL #VARIANT #DECIMAL #SBYTE #BYTE)!

elementFromValue: anObject 
	^self elementClass fromObject: anObject!

elementToValue: element 
	^element value!

testElementSize
	self elementClassNames do: 
			[:each | 
			| class array |
			class := Smalltalk at: each.
			array := self arrayClass length: 1 elementClass: class.
			self assert: array elementSize = class elementSize]!

testInvalidLength
	"#1051."

	self should: [self arrayClass length: -1 elementClass: BSTR] raise: Error! !
!GenericExternalArrayTest categoriesFor: #elementClassNames!constants!private! !
!GenericExternalArrayTest categoriesFor: #elementFromValue:!private!unit tests! !
!GenericExternalArrayTest categoriesFor: #elementToValue:!private!unit tests! !
!GenericExternalArrayTest categoriesFor: #testElementSize!public!unit tests! !
!GenericExternalArrayTest categoriesFor: #testInvalidLength!public!unit tests! !

!GenericExternalArrayTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!GenericExternalArrayTest class categoriesFor: #isAbstract!public!Testing! !

