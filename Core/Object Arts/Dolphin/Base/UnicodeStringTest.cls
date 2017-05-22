"Filed out from Dolphin Smalltalk 7"!

StringTest subclass: #UnicodeStringTest
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
	^UnicodeString! !
!UnicodeStringTest categoriesFor: #byteArrayForSequence:!helpers!private! !
!UnicodeStringTest categoriesFor: #collectionClass!helpers!private! !

