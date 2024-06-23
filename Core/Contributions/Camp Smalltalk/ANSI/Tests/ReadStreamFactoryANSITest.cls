"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ReadStreamFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ReadStreamFactoryANSITest guid: (GUID fromString: '{87304b11-3a5a-4886-afc4-36204464919d}')!

ReadStreamFactoryANSITest comment: ''!

!ReadStreamFactoryANSITest categoriesForClass!Unclassified! !

!ReadStreamFactoryANSITest methodsFor!

canonicalObject
	^ReadStream!

protocol
	^#'ReadStream factory'!

testXonX
	self 
		value: [self canonicalObject on: 'this is a string']
		should: [:r | r position = 0 & (r contents = 'this is a string')]
		conformTo: self protocol
		selector: #on:! !

!ReadStreamFactoryANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXonX!public! !
!

