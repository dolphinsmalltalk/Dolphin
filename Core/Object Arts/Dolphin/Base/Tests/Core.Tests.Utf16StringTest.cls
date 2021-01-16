"Filed out from Dolphin Smalltalk 7"!

Core.Tests.UtfEncodedStringTest subclass: #'Core.Tests.Utf16StringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.Utf16StringTest guid: (Core.GUID fromString: '{e12792f7-8bb1-44b6-84ca-e8a620c9bc70}')!
Core.Tests.Utf16StringTest comment: ''!
!Core.Tests.Utf16StringTest categoriesForClass!Unclassified! !
!Core.Tests.Utf16StringTest methodsFor!

assimilate: each
	^Character utf16Value: each asInteger!

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
	^#(#(#(16rD800 16rD83D 16rDC2C) $\x1F42C) #(#(16rD800 16rA1) ##(Character value: 16rA1)) #(#(16rD800 16rD800) $\xFFFD))!

decodeTestCases
	^#($\0 $\x7F $\x80 $\x7FF $\x800 $\xFFFD $\x10000 $\x1F42C $\x1FFFD)!

testAssociations
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject associations
		equals: {1 -> $a. 2 -> $£. 3 -> $\x6587. 4 -> $\x1F42C. 6 -> $1. 7 -> $\x1F37A}!

testCopyWithAtIndex
	| string |
	string := self assimilateString: 'a£🍺文1'.
	self assert: (string copyWith: Character dolphin atIndex: 5) equals: 'a£🍺🐬文1'.
	self should: [string copyWith: Character dolphin atIndex: 4] raise: Error!

testKeys
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject keys equals: #(1 2 3 4 6 7)!

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
	| utf8Bytes byteString wideString bstr |
	utf8Bytes := #[228 184 128 233 187 158 230 184 172 232 169 166].
	byteString := Utf8String fromByteArray: utf8Bytes.
	"Ansi strings don't correctly represent the multi-byte encoding of the test UTF8 string"
	self assert: byteString size equals: 12.
	self assert: byteString equals: '一點測試'.
	wideString := byteString asUtf16String.
	self assert: wideString size equals: 4.
	"On VMs before 7.0.54, Utf16Strings may not be properly terminated (#155)"
	(self isAtLeastVmVersion: #(2016 7 0 54))
		ifTrue: 
			[| string2 |
			"Compiler bug #154: Have to use brace array here because a literal array with wide chars does not compile correctly."
			self assert: wideString asArray equals: #($\x4E00 $\x9EDE $\x6E2C $\x8A66).
			self assert: wideString asUtf8String equals: byteString.
			string2 := Utf8String fromUtf16String: wideString.
			self assert: string2 equals: byteString].
	bstr := byteString asBSTR.
	self assert: bstr asArray equals: wideString asArray.
	self assert: bstr asUtf16String equals: wideString.
	self assert: bstr asUtf8String equals: byteString! !
!Core.Tests.Utf16StringTest categoriesFor: #assimilate:!helpers!private! !
!Core.Tests.Utf16StringTest categoriesFor: #assimilateString:!helpers!private! !
!Core.Tests.Utf16StringTest categoriesFor: #byteArrayForSequence:!helpers!private! !
!Core.Tests.Utf16StringTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.Utf16StringTest categoriesFor: #decodeIncompleteContinuations!constants!private! !
!Core.Tests.Utf16StringTest categoriesFor: #decodeInvalidContinuations!constants!private! !
!Core.Tests.Utf16StringTest categoriesFor: #decodeTestCases!constants!private! !
!Core.Tests.Utf16StringTest categoriesFor: #testAssociations!public!unit tests! !
!Core.Tests.Utf16StringTest categoriesFor: #testCopyWithAtIndex!public!unit tests! !
!Core.Tests.Utf16StringTest categoriesFor: #testKeys!public!unit tests! !
!Core.Tests.Utf16StringTest categoriesFor: #testMixedConcatenation!public! !
!Core.Tests.Utf16StringTest categoriesFor: #testUtf8StringConversion!public!unit tests! !

