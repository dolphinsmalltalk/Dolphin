"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ReadWriteStreamANSITest
	instanceVariableNames: 'readWriteStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!ReadWriteStreamANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
!

!ReadWriteStreamANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: ReadStreamHelper.
	aBlock value: WriteStreamHelper! !

!ReadWriteStreamANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

