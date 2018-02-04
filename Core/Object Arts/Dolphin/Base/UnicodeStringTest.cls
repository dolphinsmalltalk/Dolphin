"Filed out from Dolphin Smalltalk 7"!

AbstractStringTest subclass: #UnicodeStringTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UnicodeStringTest guid: (GUID fromString: '{e12792f7-8bb1-44b6-84ca-e8a620c9bc70}')!
UnicodeStringTest comment: ''!
!UnicodeStringTest categoriesForClass!Unclassified! !
!UnicodeStringTest methodsFor!

byteArrayForSequence: aCollection
	| answer |
	answer := ByteArray new: aCollection size * 2.
	1 to: aCollection size
		do: [:each | answer at: (each - 1) * 2 + 1 put: (aCollection at: each) asInteger].
	^answer!

collectionClass
	^UnicodeString!

testUtf8StringConversion
	| utf8Bytes byteString wideString bstr |
	utf8Bytes := #[228 184 128 233 187 158 230 184 172 232 169 166].
	byteString := String fromAddress: utf8Bytes yourAddress length: utf8Bytes size.
	"Byte strings don't correctly represent the multi-byte encoding of the test UTF8 string"
	self assert: byteString size equals: 12.
	wideString := byteString asUnicodeString.
	self assert: wideString size equals: 4.
	"On VMs before 7.0.54, UnicodeStrings may not be properly terminated (#155)"
	(self isAtLeastVmVersion: #(2016 7 0 54))
		ifTrue: 
			[| string2 |
			"Compiler bug #154: Have to use brace array here because a literal array with wide chars does not compile correctly."
			self assert: wideString asArray equals: {$\x4E00. $\x9EDE. $\x6E2C. $\x8A66}.
			self assert: wideString asString equals: byteString.
			string2 := String fromUnicodeString: wideString.
			self assert: string2 equals: byteString].
	bstr := byteString asBSTR.
	self assert: bstr asArray equals: wideString asArray.
	self assert: bstr asUnicodeString equals: wideString.
	self assert: bstr asString equals: byteString! !
!UnicodeStringTest categoriesFor: #byteArrayForSequence:!helpers!private! !
!UnicodeStringTest categoriesFor: #collectionClass!helpers!private! !
!UnicodeStringTest categoriesFor: #testUtf8StringConversion!public! !

