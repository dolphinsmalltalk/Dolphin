"Filed out from Dolphin Smalltalk 7"!

SequencedReadableCollectionTest subclass: #StringANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StringANSITest guid: (GUID fromString: '{8d98dc8b-46ae-4a17-ab30-e909e195319a}')!
StringANSITest comment: ''!
!StringANSITest categoriesForClass!Unclassified! !
!StringANSITest methodsFor!

canonicalElement

	^self canonicalObject at: 2!

canonicalObject
	^'abcd'!

emptyCollection

	^self canonicalObject class new!

limitedElementTypes

	^1!

protocol
	^#String!

returnTypeHasLimitedElementTypes

	^true!

testXasLowercase
	" <readableString>#asLowercase "
	#'Collection'.!

testXasString
	" <String>#asString "
	#'Collection'.!

testXasSymbol
	" <readableString>#asSymbol "
	#'Collection'.!

testXasUppercase
	" <readableString>#asUppercase "
	#'Collection'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Collection'.!

testXgreaterThanOp
	" <readableString>#> "
	#'Collection'.!

testXgreaterThanOrEqualToOp
	" <readableString>#>= "
	#'Collection'.!

testXlessThanOp
	" <readableString>#< "
	#'Collection'.!

testXlessThanOrEqualToOp
	" <readableString>#<= "
	#'Collection'.!

testXmaxX
	" <magnitude>#max: "
	#'Collection'.!

testXminX
	" <magnitude>#min: "
	#'Collection'.!

testXsameAsX
	" <readableString>#sameAs: "
	#'Collection'.!

testXsubStringsX
	" <readableString>#subStrings: "
	#'Collection'.! !
!StringANSITest categoriesFor: #canonicalElement!public! !
!StringANSITest categoriesFor: #canonicalObject!public! !
!StringANSITest categoriesFor: #emptyCollection!public! !
!StringANSITest categoriesFor: #limitedElementTypes!public! !
!StringANSITest categoriesFor: #protocol!public! !
!StringANSITest categoriesFor: #returnTypeHasLimitedElementTypes!public! !
!StringANSITest categoriesFor: #testXasLowercase!public! !
!StringANSITest categoriesFor: #testXasString!public! !
!StringANSITest categoriesFor: #testXasSymbol!public! !
!StringANSITest categoriesFor: #testXasUppercase!public! !
!StringANSITest categoriesFor: #testXbetweenXandX!public! !
!StringANSITest categoriesFor: #testXgreaterThanOp!public! !
!StringANSITest categoriesFor: #testXgreaterThanOrEqualToOp!public! !
!StringANSITest categoriesFor: #testXlessThanOp!public! !
!StringANSITest categoriesFor: #testXlessThanOrEqualToOp!public! !
!StringANSITest categoriesFor: #testXmaxX!public! !
!StringANSITest categoriesFor: #testXminX!public! !
!StringANSITest categoriesFor: #testXsameAsX!public! !
!StringANSITest categoriesFor: #testXsubStringsX!public! !

!StringANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedCollectionHelper.
	aBlock value: SequencedReadableCollectionHelper! !
!StringANSITest class categoriesFor: #helperClassesDo:!public! !

