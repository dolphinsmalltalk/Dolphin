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

testClassDecodeFrom
	#($\0 $\x7F $\x80 $\x7FF $\x800 $\xFFFD $\x10000 $\x1F42C $\x1FFFD) do: 
			[:each |
			| stream actual |
			stream := each asUtf8String readStream.
			actual := self collectionClass decodeFrom: stream.
			self assert: actual equals: each].
	"Invalid continuations"
	#(#[16rC0 16r41] #[16rE0 16r80 16r41] #[16rF0 16r80 16r80 16r41]) do: 
			[:each |
			| stream actual |
			stream := each readStream.
			actual := self collectionClass decodeFrom: stream.
			self assert: actual equals: $\xFFFD.
			actual := self collectionClass decodeFrom: stream.
			self assert: actual equals: $A].
	"Incomplete continuations"
	#(#[16rC0] #[16rE0 16r80] #[16rF0 16r80 16r80]) do: 
			[:each |
			| stream actual |
			stream := each readStream.
			actual := self collectionClass decodeFrom: stream.
			self assert: actual equals: $\xFFFD.
			self assert: stream atEnd]! !
!Utf8StringTest categoriesFor: #assimilateString:!helpers!private! !
!Utf8StringTest categoriesFor: #collectionClass!helpers!private! !
!Utf8StringTest categoriesFor: #testClassDecodeFrom!public! !

