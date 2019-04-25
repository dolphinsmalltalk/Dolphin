"Filed out from Dolphin Smalltalk 7"!

MultiByteStringTest subclass: #Utf8StringTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf8StringTest guid: (GUID fromString: '{cc364a8d-e3ae-493e-8856-3f10c847c10d}')!
Utf8StringTest comment: ''!
!Utf8StringTest categoriesForClass!Unclassified! !
!Utf8StringTest methodsFor!

assimilateString: aString
	^aString asUtf8String!

collectionClass
	^Utf8String!

testDecodeNextFrom
	| subject bytes |
	subject := self collectionClass new.
	#($\0 $\x7F $\x80 $\x7FF $\x800 $\xFFFD $\x10000 $\x1F42C $\x1FFFD $\x10FFFD) do: 
			[:each |
			| stream actual |
			stream := each asUtf8String readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: each].
	"Invalid continuations"
	#(#[16rC0 16r41] #[16rE0 16r80 16r41] #[16rF0 16r80 16r80 16r41]) do: 
			[:each |
			| stream actual |
			stream := each readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: Character replacement.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: $A].
	"Incomplete continuations"
	#(#[16rC0] #[16rE0 16r80] #[16rF0 16r80 16r80]) do: 
			[:each |
			| stream actual |
			stream := each readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: Character replacement.
			self assert: stream atEnd].
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

testEncodedSizeOf
	| subject max |
	subject := Utf8String new.
	"Larger encoded values are possible, but we can't represent them as characters because I allowed only 24 bits for the code point (more than adequate for Unicode, which requires a maximum of 4 bytes in UTF-8)."
	#(16r0 1 16r7F 1 16r80 2 16r7FF 2 16r800 3 16rFFFF 3 16r10000 4 16r1FFFFF 4 16r200000 5 16rFFFFFF 5)
		pairsDo: 
			[:cp :bytes |
			| ch |
			"Some of these chars are invalid, so use basic constructor"
			ch := Character codePoint: cp ifInvalid: [Character newCode: Character.Utf32Mask | cp].
			self assert: (subject encodedSizeOf: ch) equals: bytes].
	"The maximum Unicode code point is a non-character."
	max := Character newCode: Character.Utf32Mask | Win32Constants.MAX_UCSCHAR.
	self assert: (subject encodedSizeOf: max) equals: 4! !
!Utf8StringTest categoriesFor: #assimilateString:!helpers!private! !
!Utf8StringTest categoriesFor: #collectionClass!helpers!private! !
!Utf8StringTest categoriesFor: #testDecodeNextFrom!public! !
!Utf8StringTest categoriesFor: #testEncodedSizeOf!public! !

