"Filed out from Dolphin Smalltalk X6.2"!

ODBFile subclass: #ODBGarbageCollectorFile
	instanceVariableNames: 'status'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBGarbageCollectorFile guid: (GUID fromString: '{8162EE19-0FB8-11D4-B091-000000000000}')!
ODBGarbageCollectorFile comment: ''!
!ODBGarbageCollectorFile categoriesForClass!No category! !
!ODBGarbageCollectorFile methodsFor!

created
	"status=1 byte"

	"new object space=1 byte"

	stream
		putBytesFrom: (ByteArray new: 4);
		flush!

createOn: aString 
	"Create garbage collector file. Answer <nil> if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeCreateNew
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareRead.
	^self writeHeader!

newObjectSpace
	"Answer garbage collector new object space."

	^stream
		position: self headerLength + 1;
		getByte!

newObjectSpace: anInteger 
	"Set garbage collector new object space."

	stream
		position: self headerLength + 1;
		putByte: anInteger;
		flush!

openOn: aString 
	"Open garbage collector file. Signal an error if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeOpenExisting
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareRead.
	^self compareHeader!

status
	"Answer garbage collector status."

	status isNil 
		ifTrue: 
			[status := stream
						position: self headerLength;
						getByte].
	^status!

status: anInteger 
	"Set garbage collector status."

	status := anInteger.
	stream
		position: self headerLength;
		putByte: anInteger;
		flush! !
!ODBGarbageCollectorFile categoriesFor: #created!public! !
!ODBGarbageCollectorFile categoriesFor: #createOn:!public! !
!ODBGarbageCollectorFile categoriesFor: #newObjectSpace!public! !
!ODBGarbageCollectorFile categoriesFor: #newObjectSpace:!public! !
!ODBGarbageCollectorFile categoriesFor: #openOn:!public! !
!ODBGarbageCollectorFile categoriesFor: #status!public! !
!ODBGarbageCollectorFile categoriesFor: #status:!public! !

