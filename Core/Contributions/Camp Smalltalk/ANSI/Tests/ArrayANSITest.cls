"Filed out from Dolphin Smalltalk"!

SequencedReadableCollectionTest subclass: #ArrayANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ArrayANSITest guid: (GUID fromString: '{d7a8afc6-0aa0-45b6-8cc9-e4cd2ab49bc4}')!

ArrayANSITest comment: ''!

!ArrayANSITest categoriesForClass!Unclassified! !

!ArrayANSITest methodsFor!

canonicalElement

	^self canonicalObject at: 2!

canonicalObject
	^#(1 2 3 4) copy!

emptyCollection

	^self canonicalObject class new!

protocol
	^#Array! !

!ArrayANSITest categoriesForMethods!
canonicalElement!public! !
canonicalObject!public! !
emptyCollection!public! !
protocol!public! !
!

!ArrayANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedCollectionHelper.
	aBlock value: SequencedReadableCollectionHelper! !

!ArrayANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

