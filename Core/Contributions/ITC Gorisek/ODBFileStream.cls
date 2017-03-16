"Filed out from Dolphin Smalltalk 7"!

ODBStream subclass: #ODBFileStream
	instanceVariableNames: 'fileHandle pathName kernelLibrary mutex'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
ODBFileStream guid: (GUID fromString: '{8162ee28-0fb8-11d4-b091-000000000000}')!
ODBFileStream comment: ''!
!ODBFileStream categoriesForClass!No category! !
!ODBFileStream methodsFor!

atPosition: anInteger getBytesFor: aByteCollection 
	"Read bytes from stream at position anInteger. 
        Answer number of bytes actualy read."

	| result |
	mutex critical: 
			[result := self
						basicPosition: anInteger;
						basicGetBytesFor: aByteCollection len: aByteCollection size].
	^result!

atPosition: anInteger getBytesFor: aByteCollection len: len 
	"Read len bytes from stream at position anInteger to aByteCollection. 
        Answer number of bytes actualy read."

	| result |
	mutex critical: 
			[result := self
						basicPosition: anInteger;
						basicGetBytesFor: aByteCollection len: len].
	^result!

atPosition: pos putBytesFrom: aByteCollection 
	"Write bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: aByteCollection size]!

atPosition: pos putBytesFrom: aByteCollection len: len 
	"Write len bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: len]!

atPosition: pos putLong: anInteger 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self 
		atPosition: pos
		putBytesFrom: buf
		len: 4!

atPositionGetLong: pos 
	"Read long integer from stream. 
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 4.
	^(self 
		atPosition: pos
		getBytesFor: buf
		len: 4) == 4 
		ifTrue: [buf dwordAtOffset: 0]!

basicGetBytesFor: aByteCollection len: len 
	"Private - Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."

	| startTime currentTime errorCode externalLong |
	externalLong := DWORD new.
	(kernelLibrary 
		readFile: fileHandle
		lpBuffer: aByteCollection
		nNumberOfBytesToRead: len
		lpNumberOfBytesRead: externalLong
		lpOverlapped: nil) 
			ifFalse: 
				[currentTime := startTime := Time secondClockValue.
				
				[errorCode := self lastOsError.
				errorCode = 33 or: [errorCode = 5	"access denied"]	"lock violation"] 
						whileTrue: 
							[currentTime - startTime < 12 
								ifFalse: 
									[ODBStreamLockedNotification signal 
										ifTrue: [startTime := currentTime]
										ifFalse: [self fileIOError: errorCode]].
							(kernelLibrary 
								readFile: fileHandle
								lpBuffer: aByteCollection
								nNumberOfBytesToRead: len
								lpNumberOfBytesRead: externalLong asParameter
								lpOverlapped: nil) ifTrue: [^externalLong asInteger].
							currentTime := Time secondClockValue.
							currentTime < startTime ifTrue: [currentTime := currentTime + 86400]].
				self fileIOError: errorCode].
	^externalLong asInteger!

basicPosition: anInteger 
	"Private - Positiones stream to anInteger. Answer anInteger."

	| result externalLong lowDWord hiDWord |
	anInteger < 0 ifTrue: [OmniBase signalError: 'File position can not be negative'].
	anInteger > 2147483647 
		ifFalse: 
			[lowDWord := anInteger.
			hiDWord := 0]
		ifTrue: 
			[lowDWord := (DWORD fromInteger: anInteger \\ (2 raisedTo: 32)) asSignedInteger.
			hiDWord := anInteger // (2 raisedTo: 32).
			externalLong := DWORD fromInteger: hiDWord].
	result := kernelLibrary 
				setFilePointer: fileHandle
				lDistanceToMove: lowDWord
				lpDistanceToMoveHigh: externalLong
				dwMoveMethod: FILE_BEGIN.
	^externalLong isNil 
		ifTrue: [16rFFFFFFFF = result ifFalse: [result] ifTrue: [self fileIOError]]
		ifFalse: 
			[(16rFFFFFFFF = result and: [kernelLibrary getLastError ~= 0]) 
				ifTrue: [self fileIOError]
				ifFalse: [result + (externalLong asUnsignedInteger * (2 raisedTo: 32))]]!

basicPutBytesFrom: aByteCollection len: len 
	"Private - Write len bytes from aByteCollection to file."

	| externalLong |
	externalLong := DWORD new.
	(kernelLibrary 
		writeFile: fileHandle
		lpBuffer: aByteCollection
		nNumberOfBytesToWrite: len
		lpNumberOfBytesWritten: externalLong
		lpOverlapped: nil) ifFalse: [self fileIOError]!

close
	"Close file associatied with receiver."

	kernelLibrary closeHandle: fileHandle.
	fileHandle := nil!

compare: aString at: pos 
	"Answer <true>, if aString is stored at pos."

	| str str2 len |
	len := aString size.
	str := String new: len.
	(self 
		atPosition: pos
		getBytesFor: str
		len: len) == len ifFalse: [^false].
	str := str select: [:each | each isDigit or: [each isLetter]].
	str2 := aString select: [:each | each isDigit or: [each isLetter]].
	^str = str2!

fileIOError
	^self fileIOError: self lastOsError!

fileIOError: errorCode 
	errorCode = 59 ifTrue: [ODBUnexpectedNetworkError signal].
	FileException signalOn: self!

flush
	"Force all data written to the receiver to be recorded on disk."

	(kernelLibrary flushFileBuffers: fileHandle) ifFalse: [^self fileIOError]!

getByte
	"Read byte from file stream. Answer <nil> if
	end of file has been reached."

	| buf |
	buf := ByteArray new: 1.
	^(self getBytesFor: buf len: 1) == 1 ifTrue: [buf at: 1]!

getBytesFor: aByteCollection len: len 
	"Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."

	| result |
	mutex critical: [result := self basicGetBytesFor: aByteCollection len: len].
	^result!

getLong
	"Read long integer from stream. 
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 4.
	^(self getBytesFor: buf len: 4) == 4 ifTrue: [buf odbLongAt: 1]!

getWord
	"Read word from file stream.
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 2.
	^(self getBytesFor: buf len: 2) == 2 ifTrue: [buf odbShortAt: 1]!

lastOsError
	^kernelLibrary getLastError!

lockAt: pos length: length 
	"Lock portion of file starting at position pos. 
        Answer <true> if successfull."

	| errorCode |
	(kernelLibrary 
		odbLockFile: fileHandle
		offsetLow: pos
		offsetHigh: 0
		lengthLow: length
		lengthHigh: 0) ifTrue: [^true].
	"is lock violation ?"
	(errorCode := self lastOsError) = 33 ifTrue: [^false].
	^self fileIOError: errorCode!

name
	^pathName!

openOn: aString fileHandle: aFileHandle 
	"Private - Initialize receiver."

	pathName := aString.
	fileHandle := aFileHandle.
	kernelLibrary := KernelLibrary default.
	mutex := Semaphore forMutualExclusion!

pathName
	^pathName!

position
	| pos |
	pos := kernelLibrary 
				setFilePointer: fileHandle
				lDistanceToMove: 0
				lpDistanceToMoveHigh: nil
				dwMoveMethod: FILE_CURRENT.
	^16rFFFFFFFF = pos ifFalse: [pos] ifTrue: [self fileIOError]!

position: anInteger 
	"Positiones stream to anInteger. Answer anInteger."

	| result |
	mutex critical: [result := self basicPosition: anInteger].
	^result!

printOn: aStream 
	aStream nextPutAll: 'ODBFileStream on: ''' , pathName , ''''!

putByte: anInteger 
	self putBytesFrom: (ByteArray with: anInteger) len: 1!

putBytesFrom: aByteCollection len: len 
	"Write len bytes from aByteCollection to file."

	mutex critical: [self basicPutBytesFrom: aByteCollection len: len]!

putLong: anInteger 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self putBytesFrom: buf len: 4!

putWord: anInteger 
	| buf |
	buf := ByteArray new: 2.
	buf odbShortAt: 1 put: anInteger.
	self putBytesFrom: buf len: 2!

remove
	"Close and remove receiver. Answer <true> if removed."

	self close.
	^self class remove: pathName!

size
	"Answer the size of the file in bytes or
	signal a FileException if the operation fails."

	| result |
	result := kernelLibrary getFileSize: fileHandle lpFileSizeHigh: nil.
	^16rFFFFFFFF = result ifFalse: [result] ifTrue: [self fileIOError]!

truncate: anInteger 
	"Truncate stream so that its size will be anInteger. 
        Position to anInteger."

	mutex critical: 
			[self basicPosition: anInteger.
			(kernelLibrary odbSetEndOfFile: fileHandle) ifFalse: [self fileIOError]]!

unlockAt: pos length: length 
	"Unlock portion of file at position pos. 
        Answer <true> if successfull, <false> if failed."

	^kernelLibrary 
		odbUnlockFile: fileHandle
		offsetLow: pos
		offsetHigh: 0
		lengthLow: length
		lengthHigh: 0! !
!ODBFileStream categoriesFor: #atPosition:getBytesFor:!public! !
!ODBFileStream categoriesFor: #atPosition:getBytesFor:len:!public! !
!ODBFileStream categoriesFor: #atPosition:putBytesFrom:!public! !
!ODBFileStream categoriesFor: #atPosition:putBytesFrom:len:!public! !
!ODBFileStream categoriesFor: #atPosition:putLong:!public! !
!ODBFileStream categoriesFor: #atPositionGetLong:!public! !
!ODBFileStream categoriesFor: #basicGetBytesFor:len:!private! !
!ODBFileStream categoriesFor: #basicPosition:!private! !
!ODBFileStream categoriesFor: #basicPutBytesFrom:len:!private! !
!ODBFileStream categoriesFor: #close!public! !
!ODBFileStream categoriesFor: #compare:at:!public! !
!ODBFileStream categoriesFor: #fileIOError!private! !
!ODBFileStream categoriesFor: #fileIOError:!private! !
!ODBFileStream categoriesFor: #flush!public! !
!ODBFileStream categoriesFor: #getByte!public! !
!ODBFileStream categoriesFor: #getBytesFor:len:!public! !
!ODBFileStream categoriesFor: #getLong!public! !
!ODBFileStream categoriesFor: #getWord!public! !
!ODBFileStream categoriesFor: #lastOsError!private! !
!ODBFileStream categoriesFor: #lockAt:length:!public! !
!ODBFileStream categoriesFor: #name!public! !
!ODBFileStream categoriesFor: #openOn:fileHandle:!private! !
!ODBFileStream categoriesFor: #pathName!public! !
!ODBFileStream categoriesFor: #position!public! !
!ODBFileStream categoriesFor: #position:!public! !
!ODBFileStream categoriesFor: #printOn:!private! !
!ODBFileStream categoriesFor: #putByte:!public! !
!ODBFileStream categoriesFor: #putBytesFrom:len:!public! !
!ODBFileStream categoriesFor: #putLong:!public! !
!ODBFileStream categoriesFor: #putWord:!public! !
!ODBFileStream categoriesFor: #remove!public! !
!ODBFileStream categoriesFor: #size!public! !
!ODBFileStream categoriesFor: #truncate:!public! !
!ODBFileStream categoriesFor: #unlockAt:length:!public! !

!ODBFileStream class methodsFor!

accessModeReadOnly
	^GENERIC_READ!

accessModeReadWrite
	^GENERIC_READ | GENERIC_WRITE!

accessModeWriteOnly
	^GENERIC_WRITE!

cacheModeAtomicWrite
	"FILE_FLAG_ATOMIC_WRITE"

	^512!

cacheModeRandomAccess
	"FILE_FLAG_RANDOMACCESS"

	^268435456!

cacheModeSequentialScan
	"FILE_FLAG_SEQUENTIAL_SCAN"

	^134217728!

cacheModeWriteThrough
	"FILE_FLAG_WRITE_THROUGH"

	^2147483648!

createModeCreateAlways
	^CREATE_ALWAYS!

createModeCreateNew
	^CREATE_NEW!

createModeOpenAlways
	^OPEN_ALWAYS!

createModeOpenExisting
	^OPEN_EXISTING!

createNewOn: pathName 
	"Create new file on pathName. Trigger an error 
        if the file allready exists or if it can not be created."

	^self 
		createOn: pathName
		createMode: self createModeCreateNew
		accessMode: self accessModeReadWrite
		shareMode: self shareModeShareAll!

createOn: pathName 
	"Create new file on pathName. Trigger an 
        exception if the file can not be created."

	^self 
		createOn: pathName
		createMode: self createModeCreateAlways
		accessMode: self accessModeReadWrite
		shareMode: self shareModeShareAll!

createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode 
	"Create new instance of file stream on pathName with given flags."

	^self 
		createOn: pathName
		createMode: createMode
		accessMode: accessMode
		shareMode: shareMode
		cacheMode: 0!

createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode 
	"Create new instance of file stream on pathName with given flags."

	| fd repeat |
	repeat := true.
	
	[(fd := KernelLibrary default 
				createFile: pathName
				dwDesiredAccess: accessMode
				dwSharedMode: shareMode
				lpSecurityAttributes: nil
				dwCreationDistribution: createMode
				dwFlagsAndAttributes: FILE_ATTRIBUTE_NORMAL | cacheMode
				hTemplateFile: nil) = INVALID_HANDLE_VALUE 
		ifFalse: [^self new openOn: pathName fileHandle: fd].
	repeat] 
			whileTrue: [repeat := false].
	^Win32Error signal!

directoryCreate: aString 
	File createDirectory: aString!

directoryExists: aString 
	^false!

exists: aString 
	^File exists: aString!

openExclusivelyOn: pathName 
	"Open an existing file on pathName. Trigger an 
	exception if the file can not be opened."

	^self 
		createOn: pathName
		createMode: self createModeOpenExisting
		accessMode: self accessModeReadWrite
		shareMode: self shareModeShareNone!

openOn: pathName 
	"Open an existing file on pathName. Trigger an 
        exception if the file can not be opened."

	^self 
		createOn: pathName
		createMode: self createModeOpenExisting
		accessMode: self accessModeReadWrite
		shareMode: self shareModeShareAll!

openReadOnlyOn: pathName 
	"Open an existing file on pathName. Trigger an 
        exception if the file can not be opened."

	^self 
		createOn: pathName
		createMode: self createModeOpenExisting
		accessMode: self accessModeReadOnly
		shareMode: self shareModeShareAll!

pathSeparatorString
	^'\'!

remove: fileName 
	"Remove file named fileName. Answer <true> if successfull, <false> if failed."

	
	[File delete: fileName.
	^true] on: Error do: [:ex | ^false]!

shareModeShareAll
	^FILE_SHARE_READ | FILE_SHARE_WRITE!

shareModeShareNone
	^0!

shareModeShareRead
	^FILE_SHARE_READ!

shareModeShareWrite
	^FILE_SHARE_WRITE! !
!ODBFileStream class categoriesFor: #accessModeReadOnly!public! !
!ODBFileStream class categoriesFor: #accessModeReadWrite!public! !
!ODBFileStream class categoriesFor: #accessModeWriteOnly!public! !
!ODBFileStream class categoriesFor: #cacheModeAtomicWrite!public! !
!ODBFileStream class categoriesFor: #cacheModeRandomAccess!public! !
!ODBFileStream class categoriesFor: #cacheModeSequentialScan!public! !
!ODBFileStream class categoriesFor: #cacheModeWriteThrough!public! !
!ODBFileStream class categoriesFor: #createModeCreateAlways!public! !
!ODBFileStream class categoriesFor: #createModeCreateNew!public! !
!ODBFileStream class categoriesFor: #createModeOpenAlways!public! !
!ODBFileStream class categoriesFor: #createModeOpenExisting!public! !
!ODBFileStream class categoriesFor: #createNewOn:!public! !
!ODBFileStream class categoriesFor: #createOn:!public! !
!ODBFileStream class categoriesFor: #createOn:createMode:accessMode:shareMode:!public! !
!ODBFileStream class categoriesFor: #createOn:createMode:accessMode:shareMode:cacheMode:!public! !
!ODBFileStream class categoriesFor: #directoryCreate:!public! !
!ODBFileStream class categoriesFor: #directoryExists:!public! !
!ODBFileStream class categoriesFor: #exists:!public! !
!ODBFileStream class categoriesFor: #openExclusivelyOn:!public! !
!ODBFileStream class categoriesFor: #openOn:!public! !
!ODBFileStream class categoriesFor: #openReadOnlyOn:!public! !
!ODBFileStream class categoriesFor: #pathSeparatorString!public! !
!ODBFileStream class categoriesFor: #remove:!public! !
!ODBFileStream class categoriesFor: #shareModeShareAll!public! !
!ODBFileStream class categoriesFor: #shareModeShareNone!public! !
!ODBFileStream class categoriesFor: #shareModeShareRead!public! !
!ODBFileStream class categoriesFor: #shareModeShareWrite!public! !

