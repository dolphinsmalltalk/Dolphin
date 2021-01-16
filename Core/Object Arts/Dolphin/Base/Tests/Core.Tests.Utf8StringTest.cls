"Filed out from Dolphin Smalltalk 7"!

Core.Tests.UtfEncodedStringTest subclass: #'Core.Tests.Utf8StringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.Utf8StringTest guid: (Core.GUID fromString: '{cc364a8d-e3ae-493e-8856-3f10c847c10d}')!
Core.Tests.Utf8StringTest comment: ''!
!Core.Tests.Utf8StringTest categoriesForClass!Unclassified! !
!Core.Tests.Utf8StringTest methodsFor!

assimilateString: aString
	^aString asUtf8String!

collectionClass
	^Utf8String!

decodeIncompleteContinuations
	^#(#[16rC0] #[16rE0 16r80] #[16rF0 16r80 16r80])!

decodeInvalidContinuations
	^#(#(#[16rC0 16r41] $A) #(#[16rE0 16r80 16r41] $A) #(#[16rF0 16r80 16r80 16r41] $A))!

decodeTestCases
	^#($\0 $\x7F $\x80 $\x7FF $\x800 $\xFFFD $\x10000 $\x1F42C $\x1FFFD $\x10FFFD)!

testAssociations
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject associations
		equals: {1 -> $a. 2 -> $£. 4 -> $\x6587. 7 -> $\x1F42C. 11 -> $1. 12 -> $\x1F37A}!

testCopyWith
	| string |
	string := self assimilateString: 'a£文1🍺'.
	self assert: (string copyWith: Character dolphin) equals: 'a£文1🍺🐬'!

testCopyWithAtIndex
	| string |
	string := self assimilateString: 'a£文1🍺'.
	self assert: (string copyWith: Character dolphin atIndex: 4) equals: 'a£🐬文1🍺'.
	self should: [string copyWith: Character dolphin atIndex: 5] raise: Error!

testDecodeNextFrom5and6Byte
	| subject bytes |
	subject := self collectionClass empty.
	"5 and 6 byte encodings - not actually valid Unicode characters, but valid UTF-8 encodings"
	bytes := (#[16rF8 16r88 16r80 16r80 16r80] , Character dolphin asString asByteArray
				, #[16rFB 16rBF 16rBF 16rBF 16rBF] , $£ asUtf8String asByteArray
				, #[16rFC 16r84 16r80 16r80 16r80] , $\x20AC asUtf8String asByteArray
				, #[16rFD 16rBF 16rBF 16rBF 16rBF 16rBF] , $\x4F60 asUtf8String asByteArray)
				readStream.
	self assert: (subject decodeNextFrom: bytes) equals: Character replacement.
	self assert: (subject decodeNextFrom: bytes) equals: Character dolphin.
	self assert: (subject decodeNextFrom: bytes) equals: Character replacement.
	self assert: (subject decodeNextFrom: bytes) equals: $£.
	self assert: (subject decodeNextFrom: bytes) equals: Character replacement.
	self assert: (subject decodeNextFrom: bytes) equals: $\x20AC.
	self assert: (subject decodeNextFrom: bytes) equals: Character replacement.
	self assert: (subject decodeNextFrom: bytes) equals: $\x4F60.
	self assert: bytes atEnd!

testDecodeNextFromOverlong
	| subject bytes |
	subject := self collectionClass empty.
	"4.1 Overlong ASCII character encodings"
	bytes := #[16rC0 16rAF 95 16rE0 16r80 16rAF 95 16rF0 16r80 16r80 16rAF 95 16rF8 16r80 16r80 16r80 16rAF 95 16rFC 16r80 16r80 16r80 16r80 16rAF 95]
				readStream.
	5 timesRepeat: 
			[self assert: (subject decodeNextFrom: bytes) equals: Character replacement.
			self assert: (subject decodeNextFrom: bytes) equals: $_].
	"4.2 Maximum overlong sequences"
	bytes := #[16rC1 16rBF 10 16rE0 16r9F 16rBF 10 16rF0 16r8F 16rBF 16rBF 10 16rF8 16r87 16rBF 16rBF 16rBF 10 16rFC 16r83 16rBF 16rBF 16rBF 16rBF 10]
				readStream.
	5 timesRepeat: 
			[self assert: (subject decodeNextFrom: bytes) equals: Character replacement.
			self assert: (subject decodeNextFrom: bytes) equals: Character lf].
	"4.3 Overlong representations of NUL"
	bytes := #[16rC0 16r80 10 16rE0 16r80 16r80 10 16rF0 16r80 16r80 16r80 10 16rF8 16r80 16r80 16r80 16r80 10 16rFC 16r80 16r80 16r80 16r80 16r80 10]
				readStream.
	5 timesRepeat: 
			[self assert: (subject decodeNextFrom: bytes) equals: Character replacement.
			self assert: (subject decodeNextFrom: bytes) equals: Character lf]!

testEncodedSizeOf
	| subject max |
	subject := self collectionClass empty.
	"Larger encoded values are possible, but we can't represent them as characters because I allowed only 24 bits for the code point (more than adequate for Unicode, which requires a maximum of 4 bytes in UTF-8)."
	#(16r0 1 16r7F 1 16r80 2 16r7FF 2 16r800 3 16rFFFF 3 16r10000 4 16r1FFFFF 4 16r200000 5 16rFFFFFF 5)
		pairsDo: 
			[:cp :bytes |
			| ch |
			"Some of these chars are invalid, so use basic constructor"
			ch := Character codePoint: cp ifInvalid: [Character newCode: Character.Utf32Mask | cp].
			self assert: (subject encodedSizeOf: ch) equals: bytes].
	"The maximum Unicode code point is a non-character."
	max := Character newCode: Character.Utf32Mask | OS.Win32Constants.MAX_UCSCHAR.
	self assert: (subject encodedSizeOf: max) equals: 4!

testKeys
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject keys equals: #(1 2 4 7 11 12)! !
!Core.Tests.Utf8StringTest categoriesFor: #assimilateString:!helpers!private! !
!Core.Tests.Utf8StringTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.Utf8StringTest categoriesFor: #decodeIncompleteContinuations!constants!private! !
!Core.Tests.Utf8StringTest categoriesFor: #decodeInvalidContinuations!constants!private! !
!Core.Tests.Utf8StringTest categoriesFor: #decodeTestCases!constants!private! !
!Core.Tests.Utf8StringTest categoriesFor: #testAssociations!public!unit tests! !
!Core.Tests.Utf8StringTest categoriesFor: #testCopyWith!public!unit tests! !
!Core.Tests.Utf8StringTest categoriesFor: #testCopyWithAtIndex!public!unit tests! !
!Core.Tests.Utf8StringTest categoriesFor: #testDecodeNextFrom5and6Byte!public! !
!Core.Tests.Utf8StringTest categoriesFor: #testDecodeNextFromOverlong!public! !
!Core.Tests.Utf8StringTest categoriesFor: #testEncodedSizeOf!public! !
!Core.Tests.Utf8StringTest categoriesFor: #testKeys!public!unit tests! !

