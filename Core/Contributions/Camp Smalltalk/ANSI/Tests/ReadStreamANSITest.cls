"Filed out from Dolphin Smalltalk 7"!

SequencedStreamTest subclass: #ReadStreamANSITest
	instanceVariableNames: 'readStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ReadStreamANSITest guid: (GUID fromString: '{88580396-fadb-482e-9caf-c4f837c5074a}')!
ReadStreamANSITest comment: ''!
!ReadStreamANSITest categoriesForClass!Unclassified! !
!ReadStreamANSITest methodsFor!

canonicalObject

	^readStream!

protocol
	^#'ReadStream'!

setUp

	super setUp.
	readStream := ReadStream on: 'this is a string'! !
!ReadStreamANSITest categoriesFor: #canonicalObject!public! !
!ReadStreamANSITest categoriesFor: #protocol!public! !
!ReadStreamANSITest categoriesFor: #setUp!public! !

!ReadStreamANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: GettableStreamHelper.
	aBlock value: CollectionStreamHelper.
	aBlock value: ReadStreamHelper.! !
!ReadStreamANSITest class categoriesFor: #helperClassesDo:!public! !

