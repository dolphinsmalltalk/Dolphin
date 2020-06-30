"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #ReadWriteStreamANSITest
	instanceVariableNames: 'readWriteStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ReadWriteStreamANSITest guid: (GUID fromString: '{0042fbf7-ada3-4a20-afc9-df870ffaedc1}')!
ReadWriteStreamANSITest comment: ''!
!ReadWriteStreamANSITest categoriesForClass!Unclassified! !
!ReadWriteStreamANSITest methodsFor!

canonicalObject
	^readWriteStream!

protocol
	^#'ReadWriteStream'!

setUp
	super setUp.
	readWriteStream := ReadWriteStream with: 'this is a string'! !
!ReadWriteStreamANSITest categoriesFor: #canonicalObject!public! !
!ReadWriteStreamANSITest categoriesFor: #protocol!public! !
!ReadWriteStreamANSITest categoriesFor: #setUp!public! !

!ReadWriteStreamANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: ReadStreamHelper.
	aBlock value: WriteStreamHelper! !
!ReadWriteStreamANSITest class categoriesFor: #helperClassesDo:!public! !

