"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBStream
	instanceVariableNames: 'position'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBStream guid: (GUID fromString: '{8162EDE4-0FB8-11D4-B091-000000000000}')!
ODBStream comment: ''!
!ODBStream categoriesForClass!No category! !
!ODBStream methodsFor!

atEnd
	"Answer <true> if at end of stream."

	^self position == self size!

flush
	!

getBoolean
	^self getByte = 1!

getBytesFor: aByteCollection 
	^self getBytesFor: aByteCollection len: aByteCollection size!

getChar
	^Character value: self getByte!

getInteger
	"Answer the next Integer encoded in the receiver."

	| int |
	((int := self getPositiveInteger) bitAnd: 1) == 0 ifTrue: [^int bitShift: -1].
	^0 - (int bitShift: -1)!

getLong
	^self getWord bitOr: (self getWord bitShift: 16)!

getPositiveInteger
	"Answer the next Integer encoded in the receiver."

	| answer |
	(answer := self getByte) < 128 ifTrue: [^answer].
	^(self getPositiveInteger bitShift: 7) bitOr: (answer bitAnd: 127)!

getString

	| size bytes |
	^(size := self getPositiveInteger) = 0
		ifTrue: [String new]
		ifFalse: [
			bytes := ByteArray new: size.
			self getBytesFor: bytes len: size.
			bytes asString ]!

getWord
	^self getByte bitOr: (self getByte bitShift: 8)!

putBoolean: aBool 
	self putByte: (aBool ifTrue: [1] ifFalse: [0])!

putBytesFrom: aByteCollection 
	^self putBytesFrom: aByteCollection len: aByteCollection size!

putChar: aCharacter 
	self putByte: aCharacter asInteger!

putInteger: anInteger 
	anInteger < 0 ifTrue: [^self putPositiveInteger: (0 - anInteger bitShift: 1) + 1].
	self putPositiveInteger: (anInteger bitShift: 1)!

putLong: anInteger 
	self
		putWord: (anInteger bitAnd: 65535);
		putWord: (anInteger bitShift: -16)!

putPositiveInteger: anInteger 
	anInteger < 128 ifTrue: [^self putByte: anInteger].
	self
		putByte: ((anInteger bitAnd: 127) bitOr: 128);
		putPositiveInteger: (anInteger bitShift: -7)!

putString: aString 
	self
		putPositiveInteger: aString basicSize;
		putBytesFrom: aString len: aString basicSize!

putWord: anInteger 
	self
		putByte: (anInteger bitAnd: 255);
		putByte: (anInteger bitShift: -8)!

setToEnd
	"Set to stream to end and answer position."

	^self position: self size! !
!ODBStream categoriesFor: #atEnd!public! !
!ODBStream categoriesFor: #flush!public! !
!ODBStream categoriesFor: #getBoolean!public! !
!ODBStream categoriesFor: #getBytesFor:!public! !
!ODBStream categoriesFor: #getChar!public! !
!ODBStream categoriesFor: #getInteger!public! !
!ODBStream categoriesFor: #getLong!public! !
!ODBStream categoriesFor: #getPositiveInteger!public! !
!ODBStream categoriesFor: #getString!public! !
!ODBStream categoriesFor: #getWord!public! !
!ODBStream categoriesFor: #putBoolean:!public! !
!ODBStream categoriesFor: #putBytesFrom:!public! !
!ODBStream categoriesFor: #putChar:!public! !
!ODBStream categoriesFor: #putInteger:!public! !
!ODBStream categoriesFor: #putLong:!public! !
!ODBStream categoriesFor: #putPositiveInteger:!public! !
!ODBStream categoriesFor: #putString:!public! !
!ODBStream categoriesFor: #putWord:!public! !
!ODBStream categoriesFor: #setToEnd!public! !

