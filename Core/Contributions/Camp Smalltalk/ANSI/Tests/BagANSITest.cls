"Filed out from Dolphin Smalltalk 7"!

CollectionTest subclass: #BagANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BagANSITest guid: (GUID fromString: '{b2f8f5c3-d96e-491a-b977-be7fda80f1b9}')!
BagANSITest comment: ''!
!BagANSITest categoriesForClass!Unclassified! !
!BagANSITest methodsFor!

canonicalElement

	^2!

canonicalObject
	^Bag with: 1 with: 2 with: 3 with: 4!

emptyCollection

	^self canonicalObject class new!

limitedElementType

	^nil!

limitedElementTypes

	^nil!

protocol
	^#'Bag'!

returnTypeHasLimitedElementTypes

	^true!

testXaddXwithOccurrencesX
	" <Bag>#add:withOccurrences: "
	| it |
	it := Bag new.
	self
		value: [it add: 42 withOccurrences: 3]
		should: [:r | (it occurrencesOf: 42) = 3]
		conformTo: #Bag
		selector: #add:withOccurrences:! !
!BagANSITest categoriesFor: #canonicalElement!public! !
!BagANSITest categoriesFor: #canonicalObject!public! !
!BagANSITest categoriesFor: #emptyCollection!public! !
!BagANSITest categoriesFor: #limitedElementType!public! !
!BagANSITest categoriesFor: #limitedElementTypes!public! !
!BagANSITest categoriesFor: #protocol!public! !
!BagANSITest categoriesFor: #returnTypeHasLimitedElementTypes!public! !
!BagANSITest categoriesFor: #testXaddXwithOccurrencesX!public! !

!BagANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: ExtensibleCollectionHelper.! !
!BagANSITest class categoriesFor: #helperClassesDo:!public! !

