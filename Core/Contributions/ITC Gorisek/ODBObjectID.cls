"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBObjectID
	instanceVariableNames: 'containerID index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectID guid: (GUID fromString: '{8162edde-0fb8-11d4-b091-000000000000}')!
ODBObjectID comment: ''!
!ODBObjectID categoriesForClass!No category! !
!ODBObjectID methodsFor!

= anObjectID 
	^anObjectID index == index and: [anObjectID containerID == containerID]!

containerID
	^containerID!

containerID: byte index: ulong 
	containerID := byte.
	index := ulong!

contents
	"Answer ByteArray representing receiver."

	| bytes |
	bytes := ByteArray new: 4.
	bytes
		dwordAtOffset: 0 put: index;
		at: 4 put: containerID.
	^bytes!

contents: aByteArray 
	"Initialize receiver from aByteArray."

	containerID := aByteArray at: 4.
	index := ((aByteArray at: 3) bitShift: 16) + ((aByteArray at: 2) bitShift: 8) 
				+ (aByteArray at: 1)!

fromBytes: aByteArray at: pos 
	"Initialize receiver from aByteArray at pos."

	containerID := aByteArray at: pos + 3.
	index := ((aByteArray at: pos + 2) bitShift: 16) + ((aByteArray at: pos + 1) bitShift: 8) 
				+ (aByteArray at: pos)!

hash
	^index + (containerID bitShift: 17)!

index
	^index!

index: ulong 
	index := ulong!

loadFromStream: aStream 
	| bytes |
	bytes := ByteArray new: self class sizeInBytes.
	aStream getBytesFor: bytes.
	self fromBytes: bytes at: 1!

printOn: aStream 
	super printOn: aStream.
	aStream nextPut: $(.
	containerID printOn: aStream.
	aStream nextPut: $:.
	index printOn: aStream.
	aStream nextPut: $)!

putBytesTo: bytes at: pos 
	bytes
		dwordAtOffset: pos - 1 put: index;
		at: pos + 3 put: containerID!

storeOnStream: aStream 
	aStream putBytesFrom: self contents! !
!ODBObjectID categoriesFor: #=!public! !
!ODBObjectID categoriesFor: #containerID!accessing!public! !
!ODBObjectID categoriesFor: #containerID:index:!accessing!public! !
!ODBObjectID categoriesFor: #contents!accessing!public! !
!ODBObjectID categoriesFor: #contents:!accessing!public! !
!ODBObjectID categoriesFor: #fromBytes:at:!accessing!public! !
!ODBObjectID categoriesFor: #hash!public! !
!ODBObjectID categoriesFor: #index!accessing!public! !
!ODBObjectID categoriesFor: #index:!accessing!public! !
!ODBObjectID categoriesFor: #loadFromStream:!load/store!public! !
!ODBObjectID categoriesFor: #printOn:!accessing!public! !
!ODBObjectID categoriesFor: #putBytesTo:at:!accessing!public! !
!ODBObjectID categoriesFor: #storeOnStream:!load/store!public! !

!ODBObjectID class methodsFor!

containerID: containerID index: index 
	^super new containerID: containerID index: index!

new
	^super new containerID: 0 index: 0!

sizeInBytes
	"Answer OID size in bytes.
	Note: If you change ODBObjectID>>sizeInBytes, then 
        you have to update ODBValueHolder>>sizeInBytes too."

	^4! !
!ODBObjectID class categoriesFor: #containerID:index:!instance creation!public! !
!ODBObjectID class categoriesFor: #new!instance creation!public! !
!ODBObjectID class categoriesFor: #sizeInBytes!private! !

