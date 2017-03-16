"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBObjectManager
	instanceVariableNames: 'containers environment idTable infoFile'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectManager guid: (GUID fromString: '{8162ede0-0fb8-11d4-b091-000000000000}')!
ODBObjectManager comment: ''!
!ODBObjectManager categoriesForClass!No category! !
!ODBObjectManager methodsFor!

close
	"Close object manager and all opened containers."

	| cnt |
	1 to: containers size
		do: 
			[:i | 
			(cnt := containers at: i) notNil 
				ifTrue: 
					[cnt close.
					containers at: i put: nil]].
	containers := OrderedCollection new.
	idTable isNil ifFalse: [idTable close].
	infoFile isNil ifFalse: [infoFile close]!

containerAt: containerID 
	"Answer container at containerID or default container if none."

	^self containerAt: containerID ifAbsent: [^self defaultContainer]!

containerAt: containerID ifAbsent: aBlock 
	"Answer container at containerID. Evaluate aBlock if absent."

	| cont pos |
	containerID < 1 ifTrue: [^aBlock value].
	containerID > containers size 
		ifFalse: [(cont := containers at: containerID) isNil ifFalse: [^cont]].
	pos := idTable at: containerID ifAbsent: [^aBlock value].
	pos == 0 ifTrue: [^aBlock value].
	^self initContainerAt: pos!

containerNamed: containerName 
	"Answer container with containerName or 
        default container, if container is not found."

	^self containerNamed: containerName ifAbsent: [^self defaultContainer]!

containerNamed: containerName ifAbsent: aBlock 
	"Answer container with containerName. 
        Evaluate aBlock, if container is not found."

	| name pos |
	name := self unifyContainerName: containerName.
	containers do: [:each | (each isNil or: [each name ~= name]) ifFalse: [^each]].
	pos := infoFile at: name ifAbsent: [^aBlock value].
	pos == 0 ifTrue: [^aBlock value].
	^self initContainerAt: pos!

containerNew: aString 
	"Create new container named aString.
        Answer container created."

	^self containerNew: aString path: ''!

containerNew: aString path: path 
	"Private - Create new container named aString 
	on given path. Signal an error if failed."

	| containerName containerID containerPath dirName cont pos stream |
	path = '' ifFalse: [OmniBase signalError: 'Not supported'].
	infoFile isLocked ifTrue: [OmniBase signalError: 'Object manager is currently locked !!'].
	idTable waitForAddingLock.
	
	[(cont := self containerNamed: aString ifAbsent: []) isNil 
		ifFalse: [OmniBase signalError: 'Container with this name allready exists'].
	containerName := self unifyContainerName: aString.
	containerID := idTable add: 0.
	pos := 0.
	dirName := self convert: aString.
	
	[containerPath := (path isEmpty ifTrue: [self dirName] ifFalse: [path]) 
				, ODBFileStream pathSeparatorString , dirName.
	ODBFileStream directoryExists: containerPath] 
			whileTrue: 
				[pos := pos + 1.
				dirName := (dirName copyFrom: 1 to: (dirName size min: 7)) , pos printString].
	ODBFileStream directoryCreate: containerPath.
	cont := (ODBContainer new)
				name: containerName;
				id: containerID;
				objectManager: self;
				createOn: containerPath.
	stream := infoFile stream.
	pos := stream setToEnd.
	stream
		putWord: containerID;
		putString: containerName;
		putString: path;
		putString: dirName.
	idTable at: containerID put: pos.
	infoFile at: containerName put: pos] 
			ensure: [idTable unlockAdding].
	containerID > containers size 
		ifTrue: 
			[pos := Array new: containerID.
			pos 
				replaceFrom: 1
				to: containers size
				with: containers
				startingAt: 1.
			containers := pos].
	^containers at: containerID put: cont!

containers
	"Answer collection of all containers in database."

	| coll |
	coll := OrderedCollection new.
	idTable indexesAndValuesDo: [:i :pos | coll add: (self containerAt: i)].
	^coll!

convert: containerName 
	"Private - Answer a String which is a directory name 
	abbreviated from containerName. Lower case
	vowels are dropped from the right of containerName
	until it is less than or equal to 8 characters."

	| size dirName asciiInteger |
	dirName := containerName select: 
					[:char | 
					asciiInteger := char asInteger.
					((asciiInteger > 96 and: [asciiInteger < 123]) 
						or: [asciiInteger > 64 and: [asciiInteger < 91]]) 
							or: [asciiInteger > 47 and: [asciiInteger < 58]]].
	size := dirName size.
	dirName := (dirName reverse select: 
					[:char | 
					(char isVowel and: [char isLowercase]) ifTrue: [(size := size - 1) < 8] ifFalse: [true]]) 
				reverse.
	^dirName isEmpty 
		ifTrue: ['Contanr0']
		ifFalse: [dirName copyFrom: 1 to: (dirName size min: 8)]!

createOn: anOmniBase 
	"Create new object manager."

	environment := anOmniBase.
	
	[(ODBFileStream directoryExists: self dirName) 
		ifFalse: [ODBFileStream directoryCreate: self dirName].
	idTable := ODBIDTable createOn: self idFileName.
	infoFile := ODBContainerInfoFile createOn: self infoFileName.
	self containerNew: 'Default'] 
			ifCurtailed: [self close]!

defaultContainer
	"Answer default container."

	| cont |
	^(cont := containers at: 1) isNil 
		ifFalse: [cont]
		ifTrue: [self initContainerAt: (idTable at: 1)]!

defaultObjectSpace
	^infoFile defaultObjectSpace!

defaultObjectSpace: anInteger 
	^infoFile defaultObjectSpace: anInteger!

dirName
	"Private - Answer directory where containers are placed."

	^environment dirName , ODBFileStream pathSeparatorString , 'Objects'!

environment
	^environment!

flushContainers
	"Flush all containers before commit."

	containers do: [:each | each isNil ifFalse: [each flushBytes]]!

holderAt: objectID 
	"Answer persistent object holder at objectID."

	^(self containerAt: objectID containerID ifAbsent: [^nil]) at: objectID index!

idFileName
	^environment dirName , ODBFileStream pathSeparatorString , 'omnibase.cid'!

infoFileName
	^environment dirName , ODBFileStream pathSeparatorString , 'omnibase.cif'!

initContainerAt: position 
	"Private - Initialize container stored in infoFile at position.
	Answer container."

	| id name path cont dirName stream newArray |
	stream := infoFile stream.
	stream position: position.
	id := stream getWord.
	name := stream getString.
	path := stream getString.
	path isEmpty ifTrue: [path := self dirName].
	dirName := stream getString.
	id > containers size 
		ifTrue: 
			[newArray := Array new: id.
			newArray 
				replaceFrom: 1
				to: containers size
				with: containers
				startingAt: 1.
			containers := newArray].
	cont := (ODBContainer new)
				name: name;
				id: id;
				objectManager: self;
				openOn: path , ODBFileStream pathSeparatorString , dirName.
	^containers at: id put: cont!

initialize
	"Private - Initialize receiver."

	containers := Array new: 32!

isLocked
	"Answer <true> if object manager is locked."

	^infoFile isLocked!

lock
	"Lock object manager."

	^infoFile lock!

openOn: anOmniBase 
	"Open receiver. Trigger an exception if failed."

	environment := anOmniBase.
	
	[idTable := ODBIDTable openOn: self idFileName.
	infoFile := ODBContainerInfoFile openOn: self infoFileName] 
			ifCurtailed: [self close]!

reopen
	idTable close.
	[idTable := ODBIDTable openOn: self idFileName] ifCurtailed: [environment close]!

reopenExclusively
	| result |
	result := false.
	idTable close.
	
	[idTable := ODBIDTable new openExclusivelyOn: self idFileName.
	result := true] on: Error
			do: [:ex | [idTable := ODBIDTable openOn: self idFileName] ifCurtailed: [environment close]].
	^result!

unifyContainerName: aString 
	"Private - unifies aString that represents a container name."

	aString trimBlanks.
	^aString size > 20 ifTrue: [aString copyFrom: 1 to: 20] ifFalse: [aString]!

unlock
	"Unlock object manager."

	^infoFile unlock! !
!ODBObjectManager categoriesFor: #close!public! !
!ODBObjectManager categoriesFor: #containerAt:!public! !
!ODBObjectManager categoriesFor: #containerAt:ifAbsent:!public! !
!ODBObjectManager categoriesFor: #containerNamed:!public! !
!ODBObjectManager categoriesFor: #containerNamed:ifAbsent:!public! !
!ODBObjectManager categoriesFor: #containerNew:!public! !
!ODBObjectManager categoriesFor: #containerNew:path:!public! !
!ODBObjectManager categoriesFor: #containers!public! !
!ODBObjectManager categoriesFor: #convert:!private! !
!ODBObjectManager categoriesFor: #createOn:!public! !
!ODBObjectManager categoriesFor: #defaultContainer!public! !
!ODBObjectManager categoriesFor: #defaultObjectSpace!public! !
!ODBObjectManager categoriesFor: #defaultObjectSpace:!private! !
!ODBObjectManager categoriesFor: #dirName!private! !
!ODBObjectManager categoriesFor: #environment!public! !
!ODBObjectManager categoriesFor: #flushContainers!public! !
!ODBObjectManager categoriesFor: #holderAt:!public! !
!ODBObjectManager categoriesFor: #idFileName!private! !
!ODBObjectManager categoriesFor: #infoFileName!private! !
!ODBObjectManager categoriesFor: #initContainerAt:!private! !
!ODBObjectManager categoriesFor: #initialize!private! !
!ODBObjectManager categoriesFor: #isLocked!public! !
!ODBObjectManager categoriesFor: #lock!public! !
!ODBObjectManager categoriesFor: #openOn:!public! !
!ODBObjectManager categoriesFor: #reopen!public! !
!ODBObjectManager categoriesFor: #reopenExclusively!public! !
!ODBObjectManager categoriesFor: #unifyContainerName:!private! !
!ODBObjectManager categoriesFor: #unlock!public! !

!ODBObjectManager class methodsFor!

new
	^super new initialize! !
!ODBObjectManager class categoriesFor: #new!private! !

