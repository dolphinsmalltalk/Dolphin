"Filed out from Dolphin Smalltalk"!

CollectionTest subclass: #IntervalANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!IntervalANSITest categoriesForMethods!
canonicalElement!public! !
canonicalObject!public! !
emptyCollection!public! !
protocol!public! !
testXkeysAndValuesDoX!public! !
testXlast!public! !
!

!IntervalANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedReadableCollectionHelper! !

!IntervalANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

