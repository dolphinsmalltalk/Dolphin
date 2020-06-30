"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #BSTRTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BSTRTest guid: (GUID fromString: '{d5abc1df-26e1-4722-bcb6-51e4b5c406f6}')!
BSTRTest comment: ''!
!BSTRTest categoriesForClass!Unclassified! !
!BSTRTest methodsFor!

stringConversionCases
	^#('' 'a£🍺ö' 'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ')!

testAsString
	self stringConversionCases do: 
			[:each |
			| subject ptr |
			subject := BSTR fromString: each.
			self assert: subject asString isKindOf: Utf16String.
			self assert: subject asString equals: each.
			ptr := LPBSTR fromAddress: subject basicYourAddress.
			self assert: ptr asString isKindOf: Utf16String.
			self assert: ptr asString equals: each]!

testAsUtf8String
	self stringConversionCases do: 
			[:each |
			| subject ptr |
			subject := BSTR fromString: each.
			self assert: subject asUtf8String isKindOf: Utf8String.
			self assert: subject asUtf8String equals: each.
			ptr := LPBSTR fromAddress: subject basicYourAddress.
			self assert: ptr asUtf8String isKindOf: Utf8String.
			self assert: ptr asUtf8String equals: each]! !
!BSTRTest categoriesFor: #stringConversionCases!constants!private! !
!BSTRTest categoriesFor: #testAsString!public!unit tests! !
!BSTRTest categoriesFor: #testAsUtf8String!public!unit tests! !

