"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.COM.Tests.BSTRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.BSTRTest guid: (Core.GUID fromString: '{d5abc1df-26e1-4722-bcb6-51e4b5c406f6}')!
OS.COM.Tests.BSTRTest comment: ''!
!OS.COM.Tests.BSTRTest categoriesForClass!Unclassified! !
!OS.COM.Tests.BSTRTest methodsFor!

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
!OS.COM.Tests.BSTRTest categoriesFor: #stringConversionCases!constants!private! !
!OS.COM.Tests.BSTRTest categoriesFor: #testAsString!public!unit tests! !
!OS.COM.Tests.BSTRTest categoriesFor: #testAsUtf8String!public!unit tests! !

