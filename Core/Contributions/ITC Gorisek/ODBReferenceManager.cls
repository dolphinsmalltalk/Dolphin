"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBReferenceManager
	instanceVariableNames: 'references'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBReferenceManager guid: (GUID fromString: '{8162EDE1-0FB8-11D4-B091-000000000000}')!
ODBReferenceManager comment: ''!
!ODBReferenceManager categoriesForClass!No category! !
!ODBReferenceManager methodsFor!

addReference: aReference 
	references isNil ifTrue: [references := OrderedCollection new].
	references add: aReference.
	^references size!

asBytesWith: endBytes 
	"Answer aByteArray with reference manager and endBytes as a single byte array."

	| pos oidSize bytes refsSize len |
	references isNil ifTrue: [^endBytes].
	refsSize := references size.
	oidSize := ODBObjectID sizeInBytes.
	len := refsSize * oidSize + endBytes size.
	references size > 256 
		ifFalse: 
			[bytes := ByteArray new: len + 1.
			bytes at: 1 put: refsSize - 1.
			pos := 2]
		ifTrue: 
			[bytes := ByteArray new: len + 2.
			bytes
				at: 1 put: (refsSize - 1 bitAnd: 255);
				at: 2 put: (refsSize - 1 bitShift: -8).
			pos := 3].
	references do: 
			[:each | 
			each putBytesTo: bytes at: pos.
			pos := pos + oidSize].
	bytes 
		replaceFrom: pos
		to: bytes size
		with: endBytes
		startingAt: 1.
	^bytes!

createMax256From: bytes 
	"Update receiver from bytes. Answer number of bytes used."

	| pos oidSize refsSize |
	references := Array new: (refsSize := (bytes at: 1) + 1).
	pos := 2.
	oidSize := ODBObjectID sizeInBytes.
	1 to: refsSize
		do: 
			[:i | 
			references at: i put: (ODBObjectID new fromBytes: bytes at: pos).
			pos := pos + oidSize].
	^pos - 1!

createMax65536From: bytes 
	"Update receiver from bytes. Answer number of bytes used."

	| pos oidSize refsSize |
	references := Array new: (refsSize := ((bytes at: 2) bitShift: 8) + (bytes at: 1) + 1).
	pos := 3.
	oidSize := ODBObjectID sizeInBytes.
	1 to: refsSize
		do: 
			[:i | 
			references at: i put: (ODBObjectID new fromBytes: bytes at: pos).
			pos := pos + oidSize].
	^pos - 1!

databaseObjectClassID
	references isNil ifTrue: [^ODBSerializedDBObjectWithoutReferences classID].
	references size < 257 ifTrue: [^ODBSerializedDBObject256References classID].
	references size < 65537 ifTrue: [^ODBSerializedDBObject65536References classID]!

loadFromStream: stream 
	| n |
	n := stream getPositiveInteger.
	n > 10000 ifTrue: [self error: '[Deserialization] Too many external references'].
	n > 0 
		ifTrue: 
			[references := OrderedCollection new: n.
			n timesRepeat: [references add: (ODBObjectID new loadFromStream: stream)]]!

loadFromStream: stream externalReferencesLoaderBlock: referencedObjectLoaderBlock 
	| n |
	n := stream getPositiveInteger.
	n > 10000 ifTrue: [self error: '[Deserialization] Too many external references'].
	n > 0 
		ifTrue: 
			[references := OrderedCollection new: n.
			n timesRepeat: [references add: (referencedObjectLoaderBlock value: stream)]]!

referenceAt: index 
	^references at: index!

referencesDo: aBlock 
	references do: aBlock!

saveOnStream: stream 
	references isNil 
		ifTrue: [stream putPositiveInteger: 0]
		ifFalse: 
			[stream putPositiveInteger: references size.
			references do: [:each | each storeOnStream: stream]]!

transaction: aTransaction 
	1 to: references size
		do: [:index | references at: index put: (aTransaction referenceAt: (references at: index))]! !
!ODBReferenceManager categoriesFor: #addReference:!public! !
!ODBReferenceManager categoriesFor: #asBytesWith:!public! !
!ODBReferenceManager categoriesFor: #createMax256From:!public! !
!ODBReferenceManager categoriesFor: #createMax65536From:!public! !
!ODBReferenceManager categoriesFor: #databaseObjectClassID!public! !
!ODBReferenceManager categoriesFor: #loadFromStream:!load/store!private! !
!ODBReferenceManager categoriesFor: #loadFromStream:externalReferencesLoaderBlock:!load/store!private! !
!ODBReferenceManager categoriesFor: #referenceAt:!public! !
!ODBReferenceManager categoriesFor: #referencesDo:!public! !
!ODBReferenceManager categoriesFor: #saveOnStream:!load/store!private! !
!ODBReferenceManager categoriesFor: #transaction:!public! !

