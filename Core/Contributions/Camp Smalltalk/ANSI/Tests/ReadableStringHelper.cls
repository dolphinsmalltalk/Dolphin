"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #ReadableStringHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ReadableStringHelper guid: (GUID fromString: '{63cb81c2-114f-4a83-8cce-e943705be392}')!

ReadableStringHelper comment: ''!

!ReadableStringHelper categoriesForClass!Unclassified! !

!ReadableStringHelper methodsFor!

canonicalObject

	^testCase canonicalObject!

testXasLowercase

	" <readableString>#asLowercase "
	#'ReadableString'.

	self assertSend: #asLowercase!

testXasString

	" <readableString>#asString "
	#'ReadableString'.

	self assertSend: #asString!

testXasSymbol

	" <readableString>#asSymbol "
	#'ReadableString'.!

testXasUppercase

	" <readableString>#asSymbol "
	#'ReadableString'.!

testXsameAsX

	" <readableString>#sameAs:"
	#'ReadableString'.!

testXsubStringsX

	" <readableString>#subStrings:"
	#'ReadableString'.! !

!ReadableStringHelper categoriesForMethods!
canonicalObject!public! !
testXasLowercase!public! !
testXasString!public! !
testXasSymbol!public! !
testXasUppercase!public! !
testXsameAsX!public! !
testXsubStringsX!public! !
!

