"Filed out from Dolphin Smalltalk 7"!

ODBFile subclass: #ODBVersionControlFile
	instanceVariableNames: 'lastReadTime versionDescriptor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBVersionControlFile guid: (GUID fromString: '{8162ee21-0fb8-11d4-b091-000000000000}')!
ODBVersionControlFile comment: ''!
!ODBVersionControlFile categoriesForClass!No category! !
!ODBVersionControlFile methodsFor!

created
	"Create version table for maximum 255 clients."

	stream
		putBytesFrom: (ByteArray new: (255 + 1) * 4);
		flush!

createOn: aString 
	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeCreateAlways
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareAll
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self writeHeader!

descriptionString
	^'OmniBase Version Control
OmniBase 1.0, David Gorisek (c) 1998

'!

getNewVersionNumberFor: clientID 
	"Answer new version number for clientID."

	| versionNumber |
	(clientID > 0 and: [clientID <= ODBClientTable maxClients]) 
		ifFalse: [OmniBase signalError: 'Bad OmniBase connection ID'].
	self waitForLockAt: self headerLength length: 4.
	versionNumber := (stream atPositionGetLong: self headerLength) + 1.
	stream
		atPosition: self headerLength putLong: versionNumber;
		atPosition: clientID * 4 + self headerLength putLong: versionNumber;
		flush.
	self unlockAt: self headerLength length: 4.
	^versionNumber!

openOn: aString 
	"Open transaction file. Signal an error if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeOpenExisting
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareAll
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self compareHeader!

removeCommittingFor: clientID 
	"Remove committing version number for clientID."

	(clientID > 0 and: [clientID <= ODBClientTable maxClients]) 
		ifFalse: [OmniBase signalError: 'Bad client ID'].
	stream atPosition: clientID * 4 + self headerLength putLong: 0.
	versionDescriptor := nil!

versionDescriptor
	"Answer read versionDescriptor."

	| versionTable size time |
	(versionDescriptor isNil 
		or: [((time := Time millisecondClockValue) - lastReadTime) abs > 500]) 
			ifTrue: 
				[size := (ODBClientTable maxClients + 1) * 4.
				versionTable := ByteArray new: size.
				stream 
					atPosition: self headerLength
					getBytesFor: versionTable
					len: size.
				lastReadTime := time isNil ifTrue: [Time millisecondClockValue] ifFalse: [time].
				versionDescriptor := ODBVersionDescriptor new fromVersionTable: versionTable].
	^versionDescriptor! !
!ODBVersionControlFile categoriesFor: #created!public! !
!ODBVersionControlFile categoriesFor: #createOn:!public! !
!ODBVersionControlFile categoriesFor: #descriptionString!public! !
!ODBVersionControlFile categoriesFor: #getNewVersionNumberFor:!public! !
!ODBVersionControlFile categoriesFor: #openOn:!public! !
!ODBVersionControlFile categoriesFor: #removeCommittingFor:!public! !
!ODBVersionControlFile categoriesFor: #versionDescriptor!public! !

