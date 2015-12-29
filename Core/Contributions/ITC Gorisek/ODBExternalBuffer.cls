"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBExternalBuffer
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBExternalBuffer guid: (GUID fromString: '{8162EDCB-0FB8-11D4-B091-000000000000}')!
ODBExternalBuffer comment: ''!
!ODBExternalBuffer categoriesForClass!No category! !
!ODBExternalBuffer methodsFor!

bytesAtOffset: offset count: count

	^contents copyFrom: offset + 1 to: offset + count!

bytesAtOffset: offset put: bytes

	^contents
		replaceFrom: offset + 1
		to: offset + bytes size
		with: bytes
		startingAt: 1.!

contents

	^contents!

contents: aByteArray

	contents := aByteArray!

loadFromStream: aStream 
	aStream getBytesFor: contents!

loadFromStream: aStream at: position 
	aStream atPosition: position getBytesFor: contents!

storeOnStream: aStream

	aStream putBytesFrom: contents!

storeOnStream: aStream at: position 
	aStream atPosition: position putBytesFrom: contents!

uLongAtOffset: offset

	^contents dwordAtOffset: offset!

uLongAtOffset: offset put: longValue

	^contents dwordAtOffset: offset put: longValue!

uShortAtOffset: offset

	^contents wordAtOffset: offset!

uShortAtOffset: offset put: longValue

	^contents wordAtOffset: offset put: longValue! !
!ODBExternalBuffer categoriesFor: #bytesAtOffset:count:!public! !
!ODBExternalBuffer categoriesFor: #bytesAtOffset:put:!public! !
!ODBExternalBuffer categoriesFor: #contents!public! !
!ODBExternalBuffer categoriesFor: #contents:!public! !
!ODBExternalBuffer categoriesFor: #loadFromStream:!public! !
!ODBExternalBuffer categoriesFor: #loadFromStream:at:!public! !
!ODBExternalBuffer categoriesFor: #storeOnStream:!public! !
!ODBExternalBuffer categoriesFor: #storeOnStream:at:!public! !
!ODBExternalBuffer categoriesFor: #uLongAtOffset:!public! !
!ODBExternalBuffer categoriesFor: #uLongAtOffset:put:!public! !
!ODBExternalBuffer categoriesFor: #uShortAtOffset:!public! !
!ODBExternalBuffer categoriesFor: #uShortAtOffset:put:!public! !

!ODBExternalBuffer class methodsFor!

createOn: aByteArray 
	^self basicNew contents: aByteArray!

new
	^self new: self sizeInBytes!

new: size 
	^self basicNew contents: (ByteArray new: size)! !
!ODBExternalBuffer class categoriesFor: #createOn:!instance creation!public! !
!ODBExternalBuffer class categoriesFor: #new!instance creation!public! !
!ODBExternalBuffer class categoriesFor: #new:!instance creation!OmniBase!public! !

