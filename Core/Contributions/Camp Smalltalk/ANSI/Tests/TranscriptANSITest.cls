"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #TranscriptANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TranscriptANSITest guid: (GUID fromString: '{1fcfa7b5-483c-4bfb-a670-bcae68b76be9}')!
TranscriptANSITest comment: ''!
!TranscriptANSITest categoriesForClass!Unclassified! !
!TranscriptANSITest methodsFor!

canonicalObject
	^Transcript!

protocol
	^#'Transcript'! !
!TranscriptANSITest categoriesFor: #canonicalObject!public! !
!TranscriptANSITest categoriesFor: #protocol!public! !

!TranscriptANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: PuttableStreamHelper! !
!TranscriptANSITest class categoriesFor: #helperClassesDo:!public! !

