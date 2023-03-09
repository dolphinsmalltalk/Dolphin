"Filed out from Dolphin Smalltalk"!

Core.Tests.UtfEncodedStringTest
	subclass: #'Core.Tests.Utf16StringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.Utf16StringTest guid: (Core.GUID fromString: '{e12792f7-8bb1-44b6-84ca-e8a620c9bc70}')!
Core.Tests.Utf16StringTest comment: ''!
!Core.Tests.Utf16StringTest methodsFor!

assimilate: anObject
	^Character utf16Value: anObject asInteger!

assimilateString: aString
	^aString asUtf16String!

byteArrayForSequence: aCollection
	| answer |
	answer := ByteArray new: aCollection size * 2.
	1 to: aCollection size
		do: [:each | answer at: (each - 1) * 2 + 1 put: (aCollection at: each) asInteger].
	^answer!

collectionClass
	^Utf16String!

decodeIncompleteContinuations
	^#(#(16rD800))!

decodeInvalidContinuations
	^#(#(#(16rD800 16rD83D 16rDC2C) 1 $\x1F42C) #(#(16rD800 16rA1) 1 ##(Character value: 16rA1)) #(#(16rD800 16rD800) 1 $\xFFFD))!

decodeTestCases
	^#(#(0) $\0 #(16r7F) $\x7F #(16r80) $\x80 #(16r7FF) $\x7FF #(16r800) $\x800 #(16r7FFF) $\x7FFF #(16r8000) $\x8000 #(16rE000) $\xE000 #(16rFFFD) $\xFFFD #(16rD800 16rDC00) $\x10000 #(16rD83D 16rDC2C) $🐬 #(16rD83F 16rDFFD) $\x1FFFD #(16rD8C0 16rDC00) $\x40000 #(16rDBFF 16rDFFD) $\x10FFFD #(16rDBFE 16rDFFF) $\x10FBFF)!

testAssociations
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject associations
		equals: {1 -> $a. 2 -> $£. 3 -> $\x6587. 4 -> $\x1F42C. 6 -> $1. 7 -> $\x1F37A}!

testConcatenateInvalidUtf16
	"No conversions, invalid chars copied verbatim to result"

	| actual invalid invalidBytes |
	invalidBytes := #[98 0 163 0 172 32 0 220 61 216].
	invalid := Utf16String fromByteArray: invalidBytes.
	actual := invalid , invalid.
	self assert: actual isKindOf: Utf16String.
	self assert: actual equals: (Utf16String fromByteArray: invalidBytes , invalidBytes)!

testConcatenateInvalidUtf8
	"Invalid UTF-8 will be converted to UTF-16, so replacement characters will appear instead of the incomplete/invalid characters.
	The UTF-16 prefix is assumed to be well-formed, so any invalid characters in it are copied verbatim to the result."

	| actual |
	actual := (Utf16String fromByteArray: #[44 220 65 0])
				, (Utf8String fromByteArray: #[98 194 226 130 172 144 128 128 240 159 172]).
	self assert: actual isKindOf: Utf16String.
	self assert: actual
		equals: (Utf16String
				fromByteArray: #[44 220 65 0 98 0 253 255 172 32 253 255 253 255 253 255 253 255])!

testCopyWithAtIndex
	| string |
	string := self assimilateString: 'a£🍺文1'.
	self assert: (string copyWith: Character dolphin atIndex: 5) equals: 'a£🍺🐬文1'.
	self should: [string copyWith: Character dolphin atIndex: 4] raise: Error!

testKeys
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject keys equals: #(1 2 3 4 6 7)!

testLastCodeUnit
	| subject last |
	super testLastCodeUnit.
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: (subject basicAt: subject size) equals: 16rDF7A.
	last := subject lastCodeUnit.
	self assert: last isUtf16Trail.
	self assert: last equals: (Character utf16Value: 16rDF7A)!

testMixedConcatenation
	| subjects |
	subjects := #('' 'd' 'ef') collect: [:each | self assimilateString: each].
	{{String empty. Utf8String empty. Utf16String empty}.
		{'c'. 'c' asUtf8String. 'c' asUtf16String}.
		{'cd'.
			'cd' asUtf8String.
			'cd' asUtf16String.
			'一點測試'.
			#($a $b).
			OrderedCollection with: $x.
			($x codePoint to: $z codePoint) collect: [:each | Character codePoint: each]}}
			do: 
				[:args |
				args do: 
						[:eachCase |
						subjects do: 
								[:each |
								| result |
								result := self verifyConcatenation: eachCase with: each.
								self deny: each identicalTo: result]]].
	^self!

testUtf8StringConversion
	| utf8Bytes byteString wideString bstr string2 |
	utf8Bytes := #[228 184 128 233 187 158 230 184 172 232 169 166].
	byteString := Utf8String fromByteArray: utf8Bytes.
	"Ansi strings don't correctly represent the multi-byte encoding of the test UTF8 string"
	self assert: byteString size equals: 12.
	self assert: byteString equals: '一點測試'.
	wideString := byteString asUtf16String.
	self assert: wideString size equals: 4.
	self assert: wideString asArray equals: #($一 $點 $測 $試).
	self assert: wideString asUtf8String equals: byteString.
	string2 := Utf8String fromUtf16String: wideString.
	self assert: string2 equals: byteString.
	bstr := byteString asBSTR.
	self assert: bstr asArray equals: wideString asArray.
	self assert: bstr asUtf16String equals: wideString.
	self assert: bstr asUtf8String equals: byteString.
	"Invalid UTF-16 containing unmatched surrogates"
	self
		assert: (Utf16String
				with: $a
				with: (Character utf16Value: 16rDC00)
				with: $b
				with: (Character utf16Value: 16rD800)
				with: $c) asUtf8String
		equals: (Utf8String
				with: $a
				with: $\xFFFD
				with: $b
				with: $\xFFFD
				with: $c).
	self assert: (Utf16String withAll: #($£ $🐬 $€ $\x10000 $€)) asUtf8String
		equals: '£🐬€𐀀€'.
	"U+10FFFD is the largest valid character"
	self assert: (Utf16String with: $\x10FFFD) asUtf8String equals: (Utf8String with: $\x10FFFD)! !
!Core.Tests.Utf16StringTest categoriesForMethods!
assimilate:!helpers!private! !
assimilateString:!helpers!private! !
byteArrayForSequence:!helpers!private! !
collectionClass!helpers!private! !
decodeIncompleteContinuations!constants!private! !
decodeInvalidContinuations!constants!private! !
decodeTestCases!constants!private! !
testAssociations!public!unit tests! !
testConcatenateInvalidUtf16!public!unit tests! !
testConcatenateInvalidUtf8!public!unit tests! !
testCopyWithAtIndex!public!unit tests! !
testKeys!public!unit tests! !
testLastCodeUnit!public!unit tests! !
testMixedConcatenation!public! !
testUtf8StringConversion!public!unit tests! !
!

