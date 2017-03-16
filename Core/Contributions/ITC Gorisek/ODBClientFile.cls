"Filed out from Dolphin Smalltalk 7"!

ODBFile subclass: #ODBClientFile
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClientFile guid: (GUID fromString: '{8162ee17-0fb8-11d4-b091-000000000000}')!
ODBClientFile comment: ''!
!ODBClientFile categoriesForClass!No category! !
!ODBClientFile methodsFor!

clientDescription
	"Answer client description string."

	| str |
	str := String new: 128.
	stream atPosition: self headerLength getBytesFor: str.
	^(ReadStream on: str) upTo: 0 asCharacter!

clientDescription: aString 
	"Set client description string."

	stream 
		atPosition: self headerLength
		putBytesFrom: ((String new: 128) 
				replaceFrom: 1
				to: (aString size min: 128)
				with: aString
				startingAt: 1)
		len: 128!

created
	"Private - Put default values into file."

	"client description = 128 bytes"

	"distributed objects hostname=32 bytes"

	"transactions count = 4 bytes"

	stream
		putBytesFrom: (ByteArray new: 164);
		flush!

createOn: aString 
	"Create client file. Signal an error if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeCreateNew
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareRead.
	^self writeHeader!

descriptionString
	^'OmniBase Client File
OmniBase 1.0, David Gorisek (c) 1998

'!

openOn: aString 
	"Open client file. Signal an error if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeOpenExisting
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareRead.
	^self compareHeader!

transactionIDs
	"Answer array of transaction IDs."

	| buf array count |
	buf := ByteArray new: 128.
	stream
		position: self headerLength + 160;
		getBytesFor: buf.
	count := buf odbLongAt: 1.
	array := Array new: count.
	1 to: (count min: 31) do: [:i | array at: i put: (buf odbLongAt: (i * 4) + 1)].
	count > 31 
		ifTrue: 
			[buf := ByteArray new: (count - 31) * 4.
			stream getBytesFor: buf.
			32 to: count do: [:i | array at: i put: (buf odbLongAt: (i * 4) - 127)]].
	^array!

transactionIDs: anArray 
	"Set array of transaction IDs."

	| buf count |
	count := anArray size.
	buf := ByteArray new: count * 4 + 4.
	buf odbLongAt: 1 put: count.
	1 to: count do: [:i | buf odbLongAt: (i * 4) + 1 put: (anArray at: i)].
	stream
		position: self headerLength + 160;
		putBytesFrom: buf;
		flush! !
!ODBClientFile categoriesFor: #clientDescription!public! !
!ODBClientFile categoriesFor: #clientDescription:!public! !
!ODBClientFile categoriesFor: #created!public! !
!ODBClientFile categoriesFor: #createOn:!public! !
!ODBClientFile categoriesFor: #descriptionString!public! !
!ODBClientFile categoriesFor: #openOn:!public! !
!ODBClientFile categoriesFor: #transactionIDs!public! !
!ODBClientFile categoriesFor: #transactionIDs:!public! !

