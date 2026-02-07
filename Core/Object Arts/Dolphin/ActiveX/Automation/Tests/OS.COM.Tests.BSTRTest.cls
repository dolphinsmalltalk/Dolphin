"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.BSTRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.BSTRTest guid: (Core.GUID fromString: '{d5abc1df-26e1-4722-bcb6-51e4b5c406f6}')!

OS.COM.Tests.BSTRTest comment: ''!

!OS.COM.Tests.BSTRTest methodsFor!

stringConversionCases
	^#('' 'a£🍺ö' 'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ') copyWith: self stringWithNull!

stringWithNull
	^'a🐬' , (String with: $\x0 with: $b)!

testAsString
	self stringConversionCases do: 
			[:each |
			| subject ptr |
			subject := BSTR fromString: each.
			self assert: subject isNull equals: each isEmpty.
			self assert: subject asString isKindOf: Utf16String.
			self assert: subject equals: each.
			self assert: each equals: subject.
			self assert: subject hash equals: each hash.
			ptr := LPBSTR fromAddress: subject basicYourAddress.
			self assert: ptr asString isKindOf: Utf16String.
			self assert: ptr asString equals: each]!

testAsUtf8String
	self stringConversionCases do: 
			[:each |
			| subject ptr |
			subject := BSTR fromString: each.
			self assert: subject asUtf8String isKindOf: Utf8String.
			self assert: subject equals: each.
			ptr := LPBSTR fromAddress: subject basicYourAddress.
			self assert: ptr asUtf8String isKindOf: Utf8String.
			self assert: ptr asUtf8String equals: each.
			subject free]!

testComparing
	self stringConversionCases do: 
			[:each |
			| subject |
			subject := BSTR fromString: each.
			self assert: subject equals: each.
			self assert: each equals: subject.
			self assert: subject hash equals: each hash.
			subject free.
			subject := BSTR fromString: each asUtf16String.
			self assert: subject equals: each.
			self assert: each equals: subject.
			self assert: subject hash equals: each hash. 
			subject free]!

testCopy
	self stringConversionCases do: 
			[:each |
			| subject copy |
			subject := each asBSTR.
			self assert: subject isFinalizable.
			self assert: subject equals: each.
			copy := subject copy.
			self deny: copy identicalTo: subject.
			each isEmpty
				ifTrue: [self assert: copy isNull]
				ifFalse: [self deny: copy asInteger equals: subject asInteger].
			self assert: copy equals: subject.
			self assert: copy isFinalizable.
			subject free.
			self assert: copy equals: each.
			copy free]! !

!OS.COM.Tests.BSTRTest categoriesForMethods!
stringConversionCases!constants!private! !
stringWithNull!constants!private! !
testAsString!public!unit tests! !
testAsUtf8String!public!unit tests! !
testComparing!public!unit tests! !
testCopy!public!unit tests! !
!

