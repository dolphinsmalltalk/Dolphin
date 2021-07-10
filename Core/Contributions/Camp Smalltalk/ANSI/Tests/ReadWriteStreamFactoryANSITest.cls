"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ReadWriteStreamFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReadWriteStreamFactoryANSITest guid: (GUID fromString: '{7643e15d-4b6b-442a-a1d6-303e952aa1f6}')!
ReadWriteStreamFactoryANSITest comment: ''!
!ReadWriteStreamFactoryANSITest categoriesForClass!Unclassified! !
!ReadWriteStreamFactoryANSITest methodsFor!

canonicalObject
	^ReadWriteStream!

protocol
	^#'ReadWriteStream factory'!

testXwithX
	self 
		value: [self canonicalObject with: 'this is a string']
		should: [:r | r position = 'this is a string' size & (r contents = 'this is a string')]
		conformTo: self protocol
		selector: #with:! !
!ReadWriteStreamFactoryANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXwithX!public! !
!

