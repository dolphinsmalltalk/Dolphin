"Filed out from Dolphin Smalltalk 7"!

CollectionTest subclass: #IntervalANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IntervalANSITest guid: (GUID fromString: '{64086e40-bbed-4de2-b52b-2b8557ab27ec}')!
IntervalANSITest comment: ''!
!IntervalANSITest categoriesForClass!Unclassified! !
!IntervalANSITest methodsFor!

canonicalElement

	^2!

canonicalObject
	^1 to: 4!

emptyCollection

	^1 to: 0!

protocol
	^#Interval!

testXkeysAndValuesDoX
	" <sequencedReadableCollection>#keysAndValuesDo: "
	#'Collection'.!

testXlast
	" <sequencedReadableCollection>#last "
	#'Collection'.! !
!IntervalANSITest categoriesFor: #canonicalElement!public! !
!IntervalANSITest categoriesFor: #canonicalObject!public! !
!IntervalANSITest categoriesFor: #emptyCollection!public! !
!IntervalANSITest categoriesFor: #protocol!public! !
!IntervalANSITest categoriesFor: #testXkeysAndValuesDoX!public! !
!IntervalANSITest categoriesFor: #testXlast!public! !

!IntervalANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedReadableCollectionHelper! !
!IntervalANSITest class categoriesFor: #helperClassesDo:!public! !

