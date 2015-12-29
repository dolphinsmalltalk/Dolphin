"Filed out from Dolphin Smalltalk X6.2"!

ODBFile subclass: #ODBOldHoldersFile
	instanceVariableNames: 'buffer bufPos filePos'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBOldHoldersFile guid: (GUID fromString: '{8162EE1F-0FB8-11D4-B091-000000000000}')!
ODBOldHoldersFile comment: ''!
!ODBOldHoldersFile categoriesForClass!No category! !
!ODBOldHoldersFile methodsFor!

allocateBuffer
	"Private - Allocate space in file for buffer so that less locking 
	and file I/O calls are needed when transaction is committing."

	self waitForAddingLock.
	
	[filePos := stream setToEnd.
	stream truncate: filePos + 512] ensure: [self unlockAdding].
	buffer := ByteArray new: 512.
	bufPos := 0!

descriptionString
	^'OmniBase Old Holders
OmniBase 1.0, David Gorisek (c) 1998

'!

flush
	(buffer isNil or: [bufPos == 0]) ifTrue: [^self].
	stream 
		atPosition: filePos
		putBytesFrom: buffer
		len: bufPos.
	buffer size - bufPos < 16 
		ifTrue: [buffer := nil]
		ifFalse: 
			[filePos := filePos + bufPos.
			buffer := buffer copyFrom: bufPos + 1 to: buffer size.
			bufPos := 0]!

loadAt: anInteger for: aByteArray 
	"Load holder contents at position anInteger."

	anInteger == 0 ifTrue: [OmniBase signalError: 'Previous version position error !!'].
	stream atPosition: anInteger getBytesFor: aByteArray!

loadAtOrNil: anInteger for: aByteArray 
	"Load holder contents at position anInteger.
	Answer <false> in case of doing online backup for a version in the past and the new version is not yet valid, else answer <true>."

	anInteger == 0 ifTrue: [^false].
	stream atPosition: anInteger getBytesFor: aByteArray.
	^true!

store: aByteArray 
	"Store holder contents and answer its position on the stream."

	| result |
	buffer isNil 
		ifTrue: [self allocateBuffer]
		ifFalse: 
			[buffer size - bufPos < aByteArray size 
				ifTrue: 
					[self
						flush;
						allocateBuffer]].
	buffer 
		replaceFrom: bufPos + 1
		to: bufPos + aByteArray size
		with: aByteArray
		startingAt: 1.
	result := filePos + bufPos.
	bufPos := bufPos + aByteArray size.
	^result!

truncate
	stream truncate: self headerLength! !
!ODBOldHoldersFile categoriesFor: #allocateBuffer!public! !
!ODBOldHoldersFile categoriesFor: #descriptionString!public! !
!ODBOldHoldersFile categoriesFor: #flush!public! !
!ODBOldHoldersFile categoriesFor: #loadAt:for:!public! !
!ODBOldHoldersFile categoriesFor: #loadAtOrNil:for:!public! !
!ODBOldHoldersFile categoriesFor: #store:!public! !
!ODBOldHoldersFile categoriesFor: #truncate!public! !

