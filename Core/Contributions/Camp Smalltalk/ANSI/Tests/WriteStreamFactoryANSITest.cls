"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #WriteStreamFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!WriteStreamFactoryANSITest categoriesFor: #canonicalObject!public! !
!WriteStreamFactoryANSITest categoriesFor: #protocol!public! !
!WriteStreamFactoryANSITest categoriesFor: #testXwithX!public! !

