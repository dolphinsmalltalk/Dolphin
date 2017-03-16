"Filed out from Dolphin Smalltalk 7"!

ODBBTreeIterator subclass: #ODBContainerInfoFile
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBContainerInfoFile guid: (GUID fromString: '{8162ee23-0fb8-11d4-b091-000000000000}')!
ODBContainerInfoFile comment: ''!
!ODBContainerInfoFile categoriesForClass!No category! !
!ODBContainerInfoFile methodsFor!

created
	"Private - File has just been created."

	stream putWord: 0.
	(self pageClass 
		createOnFile: self
		position: rootPagePosition
		keyLength: keyLength
		valueLength: valueLength) store.
	currentKey := ByteArray new: keyLength.
	stream flush!

defaultObjectSpace
	^stream
		position: self headerLength;
		getByte!

defaultObjectSpace: anInteger 
	stream
		position: self headerLength;
		putByte: anInteger!

descriptionString
	^'Container Info File
OmniBase 1.0, David Gorisek (c) 1998

'!

initialize
	"Private - Initialize receiver."

	super initialize.
	keyLength := 20.
	valueLength := 4.
	rootPagePosition := self headerLength + 2!

isLocked
	^(stream
		position: self headerLength + 1;
		getByte) == 1!

lock
	| pos |
	pos := self headerLength + 1.
	self waitForLockAt: pos length: 1.
	
	[(stream
		position: pos;
		getByte) == 0 
		ifFalse: [^false]
		ifTrue: 
			[stream
				position: pos;
				putByte: 1.
			^true]] 
			ensure: [self unlockAt: pos length: 1]!

opened
	!

unlock
	| pos |
	pos := self headerLength + 1.
	self waitForLockAt: pos length: 1.
	
	[(stream
		position: pos;
		getByte) == 1 
		ifFalse: [^false]
		ifTrue: 
			[stream
				position: pos;
				putByte: 0.
			^true]] 
			ensure: [self unlockAt: pos length: 1]! !
!ODBContainerInfoFile categoriesFor: #created!public! !
!ODBContainerInfoFile categoriesFor: #defaultObjectSpace!public! !
!ODBContainerInfoFile categoriesFor: #defaultObjectSpace:!public! !
!ODBContainerInfoFile categoriesFor: #descriptionString!public! !
!ODBContainerInfoFile categoriesFor: #initialize!public! !
!ODBContainerInfoFile categoriesFor: #isLocked!public! !
!ODBContainerInfoFile categoriesFor: #lock!public! !
!ODBContainerInfoFile categoriesFor: #opened!public! !
!ODBContainerInfoFile categoriesFor: #unlock!public! !

