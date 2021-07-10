"Filed out from Dolphin Smalltalk"!

SequencedReadableCollectionTest subclass: #StringANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!StringANSITest categoriesForMethods!
canonicalElement!public! !
canonicalObject!public! !
emptyCollection!public! !
limitedElementTypes!public! !
protocol!public! !
returnTypeHasLimitedElementTypes!public! !
testXasLowercase!public! !
testXasString!public! !
testXasSymbol!public! !
testXasUppercase!public! !
testXbetweenXandX!public! !
testXgreaterThanOp!public! !
testXgreaterThanOrEqualToOp!public! !
testXlessThanOp!public! !
testXlessThanOrEqualToOp!public! !
testXmaxX!public! !
testXminX!public! !
testXsameAsX!public! !
testXsubStringsX!public! !
!

!StringANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedCollectionHelper.
	aBlock value: SequencedReadableCollectionHelper! !
!StringANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

