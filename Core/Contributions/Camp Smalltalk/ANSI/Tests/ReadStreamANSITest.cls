"Filed out from Dolphin Smalltalk"!

SequencedStreamTest subclass: #ReadStreamANSITest
	instanceVariableNames: 'readStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!ReadStreamANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
!

!ReadStreamANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: GettableStreamHelper.
	aBlock value: CollectionStreamHelper.
	aBlock value: ReadStreamHelper.! !

!ReadStreamANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

