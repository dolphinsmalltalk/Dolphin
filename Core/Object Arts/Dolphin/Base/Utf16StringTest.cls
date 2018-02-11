"Filed out from Dolphin Smalltalk 7"!

MultiByteStringTest subclass: #Utf16StringTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf16StringTest guid: (GUID fromString: '{e12792f7-8bb1-44b6-84ca-e8a620c9bc70}')!
Utf16StringTest comment: ''!
!Utf16StringTest categoriesForClass!Unclassified! !
!Utf16StringTest methodsFor!

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

testUtf8StringConversion
	| utf8Bytes byteString wideString bstr |
	utf8Bytes := #[228 184 128 233 187 158 230 184 172 232 169 166].
	byteString := Utf8String fromAddress: utf8Bytes yourAddress length: utf8Bytes size.
	"Byte strings don't correctly represent the multi-byte encoding of the test UTF8 string"
	self assert: byteString size equals: 12.
	wideString := byteString asUtf16String.
	self assert: wideString size equals: 4.
	"On VMs before 7.0.54, Utf16Strings may not be properly terminated (#155)"
	(self isAtLeastVmVersion: #(2016 7 0 54))
		ifTrue: 
			[| string2 |
			"Compiler bug #154: Have to use brace array here because a literal array with wide chars does not compile correctly."
			self assert: wideString asArray equals: {$\x4E00. $\x9EDE. $\x6E2C. $\x8A66}.
			self assert: wideString asUtf8String equals: byteString.
			string2 := Utf8String fromUtf16String: wideString.
			self assert: string2 equals: byteString].
	bstr := byteString asBSTR.
	self assert: bstr asArray equals: wideString asArray.
	self assert: bstr asUtf16String equals: wideString.
	self assert: bstr asUtf8String equals: byteString! !
!Utf16StringTest categoriesFor: #assimilateString:!helpers!private! !
!Utf16StringTest categoriesFor: #byteArrayForSequence:!helpers!private! !
!Utf16StringTest categoriesFor: #collectionClass!helpers!private! !
!Utf16StringTest categoriesFor: #testUtf8StringConversion!public! !

