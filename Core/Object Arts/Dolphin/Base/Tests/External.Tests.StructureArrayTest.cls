"Filed out from Dolphin Smalltalk"!

External.Tests.GenericExternalArrayTest
	subclass: #'External.Tests.StructureArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.StructureArrayTest guid: (Core.GUID fromString: '{1ab5e35e-9c82-4aa7-9c28-f51cb3baa646}')!
External.Tests.StructureArrayTest comment: ''!
!External.Tests.StructureArrayTest methodsFor!

arrayClass
	^StructureArray!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])
		elementClass: self numericElementClass!

testMarshal
	self
		should: [super testMarshal]
		raise: Error
		matching: [:ex | ex description = 'StructureArray class should not implement #withAll:']! !
!External.Tests.StructureArrayTest categoriesForMethods!
arrayClass!constants!private! !
newArrayOfIntegers:!helpers!private! !
testMarshal!public!unit tests! !
!

