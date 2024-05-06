"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #WriteStreamFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WriteStreamFactoryANSITest guid: (GUID fromString: '{d552dfc9-c6b6-4dab-81b0-76f50f4cf251}')!

WriteStreamFactoryANSITest comment: ''!

!WriteStreamFactoryANSITest categoriesForClass!Unclassified! !

!WriteStreamFactoryANSITest methodsFor!

canonicalObject
	^WriteStream!

protocol
	^#'WriteStream factory'!

testXwithX
	self 
		value: [self canonicalObject with: 'this is a string']
		should: [:r | r position = 'this is a string' size & (r contents = 'this is a string')]
		conformTo: self protocol
		selector: #with:! !

!WriteStreamFactoryANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXwithX!public! !
!

