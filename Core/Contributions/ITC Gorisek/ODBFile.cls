"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBFile
	instanceVariableNames: 'stream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBFile guid: (GUID fromString: '{8162EDDA-0FB8-11D4-B091-000000000000}')!
ODBFile comment: ''!
!ODBFile categoriesForClass!No category! !
!ODBFile methodsFor!

close
	"Close stream associated with receiver."

	stream isNil 
		ifFalse: 
			[stream close.
			stream := nil]!

compareHeader
	"Private - Compare bytes in file with file header. Answer <nil>, 
	if the file does not have the appropriate description string."

	| header |
	header := self header.
	
	[(stream compare: (header copyFrom: 2 to: header size) at: 1) 
		ifFalse: [OmniBase signalError: 'File has bad header'].
	self opened] 
			ifCurtailed: [self close]!

created
	"Private - Implemented by subclasses."

	stream flush!

createOn: aString 
	stream := ODBFileStream createOn: aString.
	^self writeHeader!

descriptionString
	^'OmniBase File
OmniBase 1.0, David Gorisek (c) 1998

'!

finalize
	self close!

flush
	"Flush stream."

	stream flush!

header
	"Private - Answer receiver's header."

	| header desc |
	header := String new: self headerLength.
	desc := self descriptionString.
	header 
		replaceFrom: 1
		to: desc size
		with: desc
		startingAt: 1.
	^header!

headerLength
	"Private - Answer receiver's header length."

	^128!

initialize!

opened
	"Private - Implemented by subclasses."

	!

openExclusivelyOn: aString 
	stream := ODBFileStream openExclusivelyOn: aString.
	^self compareHeader!

openOn: aString 
	stream := ODBFileStream openOn: aString.
	^self compareHeader!

openReadOnlyOn: aString 
	stream := ODBFileStream openReadOnlyOn: aString.
	^self compareHeader!

remove
	"Close and remove file coressponding to receiver. 
        Answer <true> if successfull."

	| answer |
	answer := stream remove.
	stream := nil.
	^answer!

size
	^stream size!

stream
	^stream!

timeOutLength
	"Private - Answer number of seconds to wait for lock."

	^7!

unlockAdding
	"Unlock file for writing at the end of file."

	^stream unlockAt: 0 length: 1!

unlockAt: pos length: length 
	"Unlock file at pos."

	^stream unlockAt: pos length: length!

waitForAddingLock
	"Lock file for writing at the end of the file."

	^self 
		waitForLockAt: 0
		length: 1
		whileWaitingDo: [(Delay forMilliseconds: 250) wait]!

waitForAddingLockWhileWaitingDo: aBlock 
	"Lock file for writing at the end of the file."

	^self 
		waitForLockAt: 0
		length: 1
		whileWaitingDo: aBlock!

waitForLockAt: pos length: length 
	"Wait for lock at given position."

	^self 
		waitForLockAt: pos
		length: length
		whileWaitingDo: [(Delay forMilliseconds: 250) wait]!

waitForLockAt: pos length: length whileWaitingDo: aBlock 
	"Wait for lock at given position. 
        Evaluate aBlock in each iteration."

	| startTime currentTime |
	(stream lockAt: pos length: length) 
		ifFalse: 
			[startTime := Time secondClockValue.
			[stream lockAt: pos length: length] whileFalse: 
					[aBlock value.
					currentTime := Time secondClockValue.
					currentTime < startTime ifTrue: [currentTime := currentTime + 86400].
					currentTime - startTime < self timeOutLength 
						ifFalse: 
							[OmniBase signalFileLockWaitNotification 
								ifTrue: [startTime := currentTime]
								ifFalse: [OmniBase signalCannotSetFileLockError]]]]!

writeHeader
	"Private - Write file header to file and send #created to self."

	stream putBytesFrom: self header.
	^self created! !
!ODBFile categoriesFor: #close!public! !
!ODBFile categoriesFor: #compareHeader!public! !
!ODBFile categoriesFor: #created!public! !
!ODBFile categoriesFor: #createOn:!public! !
!ODBFile categoriesFor: #descriptionString!public! !
!ODBFile categoriesFor: #finalize!public! !
!ODBFile categoriesFor: #flush!public! !
!ODBFile categoriesFor: #header!public! !
!ODBFile categoriesFor: #headerLength!public! !
!ODBFile categoriesFor: #initialize!initialization!public! !
!ODBFile categoriesFor: #opened!public! !
!ODBFile categoriesFor: #openExclusivelyOn:!public! !
!ODBFile categoriesFor: #openOn:!public! !
!ODBFile categoriesFor: #openReadOnlyOn:!public! !
!ODBFile categoriesFor: #remove!public! !
!ODBFile categoriesFor: #size!public! !
!ODBFile categoriesFor: #stream!public! !
!ODBFile categoriesFor: #timeOutLength!public! !
!ODBFile categoriesFor: #unlockAdding!public! !
!ODBFile categoriesFor: #unlockAt:length:!public! !
!ODBFile categoriesFor: #waitForAddingLock!public! !
!ODBFile categoriesFor: #waitForAddingLockWhileWaitingDo:!public! !
!ODBFile categoriesFor: #waitForLockAt:length:!public! !
!ODBFile categoriesFor: #waitForLockAt:length:whileWaitingDo:!public! !
!ODBFile categoriesFor: #writeHeader!public! !

!ODBFile class methodsFor!

createOn: aString 
	^self new createOn: aString!

new
	^super new initialize!

openOn: aString 
	^self new openOn: aString! !
!ODBFile class categoriesFor: #createOn:!public! !
!ODBFile class categoriesFor: #new!public! !
!ODBFile class categoriesFor: #openOn:!public! !

