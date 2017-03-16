"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBContainer
	instanceVariableNames: 'objectManager id name path indexFile dbFiles dataFileA dataFileB activeDataFile byteStorageQueue queueSize dbFilesMutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBContainer guid: (GUID fromString: '{8162edd4-0fb8-11d4-b091-000000000000}')!
ODBContainer comment: ''!
!ODBContainer categoriesForClass!No category! !
!ODBContainer methodsFor!

addByteStorageRequest: anODBByteStorageRequest 
	byteStorageQueue add: anODBByteStorageRequest.
	queueSize := queueSize + anODBByteStorageRequest bytes size.
	queueSize > 65536 ifTrue: [self flushBytes]!

at: index 
	| bytes |
	(bytes := indexFile at: index) isNil ifTrue: [^nil].
	^(ODBObjectHolder createOn: bytes) setContainer: self
		objectID: (ODBObjectID containerID: id index: index)!

bytesAllocated
	| size1 size2 |
	size1 := 0.
	size2 := 0.
	dataFileA isNil ifFalse: [size1 := dataFileA size].
	dataFileB isNil ifFalse: [size2 := dataFileB size].
	^size1 + size2!

close
	dbFiles do: 
			[:each | 
			each isNil 
				ifFalse: 
					[each
						close;
						beUnfinalizable]].
	indexFile isNil ifFalse: [indexFile close].
	dataFileA isNil ifFalse: [dataFileA close].
	dataFileB isNil ifFalse: [dataFileB close]!

closeObjectFile: anInteger 
	"Remove database object file number anInteger from 
        dictionary of opened files and close it."

	| file |
	dbFilesMutex critical: 
			[file := dbFiles at: anInteger ifAbsent: [^self].
			dbFiles removeKey: anInteger.
			file
				close;
				beUnfinalizable]!

convertToLocalObjectSpaceNumber: objectSpaceNumber 
	^indexFile swappedObjectSpaces ifTrue: [1 - objectSpaceNumber] ifFalse: [objectSpaceNumber]!

createNewObjectSpace
	"Create new object space for garbage collection."

	dataFileA isNil 
		ifTrue: [dataFileA := ODBObjectStorage createOn: self dataFileNameA]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage createOn: self dataFileNameB]]!

createOn: aString 
	"Create new container on containerPath."

	path := aString.
	
	[indexFile := ODBObjectIndexFile createOn: self indexFileName.
	self localDefaultObjectSpace == 0 
		ifTrue: 
			[dataFileA := ODBObjectStorage createOn: self dataFileNameA.
			activeDataFile := dataFileA]
		ifFalse: 
			[dataFileB := ODBObjectStorage createOn: self dataFileNameB.
			activeDataFile := dataFileB]] 
			ifCurtailed: [self close]!

dataFileNameA
	^path , ODBFileStream pathSeparatorString , 'objects.a'!

dataFileNameB
	^path , ODBFileStream pathSeparatorString , 'objects.b'!

dataFileSize
	^activeDataFile stream size!

dirName
	"Private - Needed by database objects that are creating their own files."

	^path!

fileNameFromIndex: anInteger 
	"Private - Answer object file name from index."

	^path , ODBFileStream pathSeparatorString , anInteger printString , '.btr'!

flushBytes
	"Store byte array queue to dataFile and update object holders in queue."

	| pos bufPos stream buf size bytes objectPosition |
	queueSize == 0 ifTrue: [^self].
	self lockDataFile.
	stream := activeDataFile stream.
	pos := stream setToEnd.
	buf := ByteArray new: queueSize.
	bufPos := 0.
	byteStorageQueue do: 
			[:each | 
			bytes := each bytes.
			size := bytes size.
			buf 
				replaceFrom: bufPos + 1
				to: bufPos + size
				with: bytes
				startingAt: 1.
			objectPosition := pos + bufPos bitShift: 1.
			activeDataFile == dataFileA 
				ifTrue: [each objectPosition: objectPosition]
				ifFalse: [each objectPosition: (objectPosition bitOr: 1)].
			bufPos := bufPos + size].
	stream
		atPosition: pos
			putBytesFrom: buf
			len: queueSize;
		flush.
	activeDataFile unlockAdding.
	byteStorageQueue do: [:each | each bytesStored].
	byteStorageQueue := OrderedCollection new.
	queueSize := 0!

id
	^id!

id: anInteger 
	id := anInteger!

indexFile
	^indexFile!

indexFileName
	^path , ODBFileStream pathSeparatorString , 'objects.idx'!

initHolders: holders 
	indexFile addHolders: holders!

initialize
	dbFiles := ODBWeakValueIdentityDictionary new.
	dbFilesMutex := Semaphore forMutualExclusion.
	byteStorageQueue := OrderedCollection new.
	queueSize := 0!

loadBytesAt: anInteger length: length 
	| byteArray stream bytesRead |
	(anInteger bitAnd: 1) == 0 
		ifTrue: 
			[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
			stream := dataFileA stream]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
			stream := dataFileB stream].
	byteArray := ByteArray new: length.
	bytesRead := stream 
				atPosition: (anInteger bitShift: -1)
				getBytesFor: byteArray
				len: length.
	bytesRead == length ifTrue: [^byteArray].
	^OmniBase signalError: 'Can not read object'!

localDefaultObjectSpace
	^self convertToLocalObjectSpaceNumber: objectManager defaultObjectSpace!

lockDataFile
	| currentSpace defaultSpace |
	activeDataFile waitForAddingLockWhileWaitingDo: 
			[currentSpace := activeDataFile == dataFileA ifTrue: [0] ifFalse: [1].
			defaultSpace := self localDefaultObjectSpace.
			currentSpace == defaultSpace 
				ifFalse: 
					[defaultSpace == 0 
						ifTrue: 
							[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
							activeDataFile := dataFileA]
						ifFalse: 
							[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
							activeDataFile := dataFileB].
					^self lockDataFile]]!

lockObjectSpace: anInteger 
	(self convertToLocalObjectSpaceNumber: anInteger) = 0 
		ifTrue: [dataFileA waitForAddingLock]
		ifFalse: [dataFileB waitForAddingLock]!

name
	^name!

name: aString 
	name := aString!

newObjectHolder
	^ODBObjectHolder new setContainer: self objectID: (ODBObjectID containerID: id index: 0)!

numberOfObjects
	"Answer number of objects in container."

	^indexFile getLastIndex!

objectHoldersDo: aBlock 
	| objectHolder |
	indexFile indexesAndValuesDo: 
			[:index :value | 
			objectHolder := (ODBObjectHolder createOn: value) setContainer: self
						objectID: (ODBObjectID containerID: id index: index).
			aBlock value: objectHolder]!

objectManager
	^objectManager!

objectManager: anODBObjectManager 
	objectManager := anODBObjectManager!

onNewObjectFileDo: aBlock 
	| file newIndex |
	dbFilesMutex critical: 
			[newIndex := indexFile newObjectFileID.
			file := aBlock value: newIndex value: (self fileNameFromIndex: newIndex).
			file notNil 
				ifTrue: 
					[dbFiles at: newIndex put: file.
					file beFinalizable]].
	^file!

openObjectFile: index ifAbsentPut: aBlock 
	| file |
	dbFilesMutex critical: 
			[((file := dbFiles at: index) isNil or: [file stream isNil]) 
				ifTrue: 
					[file := aBlock value: (self fileNameFromIndex: index).
					file beFinalizable.
					dbFiles at: index put: file]].
	^file!

openOn: aString 
	path := aString.
	
	[indexFile := ODBObjectIndexFile openOn: self indexFileName.
	[dataFileA := ODBObjectStorage openOn: self dataFileNameA] on: Error do: [:ex | ].
	[dataFileB := ODBObjectStorage openOn: self dataFileNameB] on: Error do: [:ex | ].
	self localDefaultObjectSpace = 0 
		ifTrue: [(activeDataFile := dataFileA) isNil ifTrue: [activeDataFile := dataFileB]]
		ifFalse: [(activeDataFile := dataFileB) isNil ifTrue: [activeDataFile := dataFileA]].
	activeDataFile isNil 
		ifTrue: [OmniBase signalError: 'Object storage file ' , self dataFileNameA , ' can not be opened']] 
			ifCurtailed: [self close]!

removeHolderAt: index 
	indexFile removeIndex: index!

removeObjectFile: anInteger 
	| file |
	dbFilesMutex critical: 
			[file := dbFiles at: anInteger ifAbsent: [^self].
			dbFiles removeKey: anInteger.
			file
				close;
				beUnfinalizable.
			ODBFileStream remove: (self fileNameFromIndex: anInteger)]!

removeObjectSpace: anInteger 
	(self convertToLocalObjectSpaceNumber: anInteger) = 0 
		ifTrue: 
			[dataFileA isNil 
				ifFalse: 
					[activeDataFile == dataFileA ifTrue: [activeDataFile := dataFileB].
					dataFileA
						unlockAdding;
						removeAll;
						remove.
					dataFileA := nil]]
		ifFalse: 
			[dataFileB isNil 
				ifFalse: 
					[activeDataFile == dataFileB ifTrue: [activeDataFile := dataFileA].
					dataFileB
						unlockAdding;
						removeAll;
						remove.
					dataFileB := nil]]!

setNewObjectSpace: newSpace 
	| currentSpace newLocalSpace |
	newLocalSpace := self convertToLocalObjectSpaceNumber: newSpace.
	currentSpace := activeDataFile == dataFileA ifTrue: [0] ifFalse: [1].
	currentSpace = newLocalSpace ifTrue: [^self].
	newLocalSpace = 0 
		ifTrue: 
			[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
			activeDataFile := dataFileA]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
			activeDataFile := dataFileB]!

swapObjectSpaces
	indexFile swappedObjectSpaces: indexFile swappedObjectSpaces not! !
!ODBContainer categoriesFor: #addByteStorageRequest:!public! !
!ODBContainer categoriesFor: #at:!public! !
!ODBContainer categoriesFor: #bytesAllocated!byte storage management!public! !
!ODBContainer categoriesFor: #close!creating!public! !
!ODBContainer categoriesFor: #closeObjectFile:!public! !
!ODBContainer categoriesFor: #convertToLocalObjectSpaceNumber:!byte storage management!private! !
!ODBContainer categoriesFor: #createNewObjectSpace!public! !
!ODBContainer categoriesFor: #createOn:!creating!public! !
!ODBContainer categoriesFor: #dataFileNameA!private! !
!ODBContainer categoriesFor: #dataFileNameB!private! !
!ODBContainer categoriesFor: #dataFileSize!public! !
!ODBContainer categoriesFor: #dirName!private! !
!ODBContainer categoriesFor: #fileNameFromIndex:!private! !
!ODBContainer categoriesFor: #flushBytes!public! !
!ODBContainer categoriesFor: #id!accessing!public! !
!ODBContainer categoriesFor: #id:!private! !
!ODBContainer categoriesFor: #indexFile!private! !
!ODBContainer categoriesFor: #indexFileName!private! !
!ODBContainer categoriesFor: #initHolders:!public! !
!ODBContainer categoriesFor: #initialize!private! !
!ODBContainer categoriesFor: #loadBytesAt:length:!public! !
!ODBContainer categoriesFor: #localDefaultObjectSpace!byte storage management!private! !
!ODBContainer categoriesFor: #lockDataFile!byte storage management!private! !
!ODBContainer categoriesFor: #lockObjectSpace:!byte storage management!public! !
!ODBContainer categoriesFor: #name!accessing!public! !
!ODBContainer categoriesFor: #name:!private! !
!ODBContainer categoriesFor: #newObjectHolder!public! !
!ODBContainer categoriesFor: #numberOfObjects!public! !
!ODBContainer categoriesFor: #objectHoldersDo:!public! !
!ODBContainer categoriesFor: #objectManager!accessing!public! !
!ODBContainer categoriesFor: #objectManager:!private! !
!ODBContainer categoriesFor: #onNewObjectFileDo:!public! !
!ODBContainer categoriesFor: #openObjectFile:ifAbsentPut:!public! !
!ODBContainer categoriesFor: #openOn:!creating!public! !
!ODBContainer categoriesFor: #removeHolderAt:!public! !
!ODBContainer categoriesFor: #removeObjectFile:!public! !
!ODBContainer categoriesFor: #removeObjectSpace:!byte storage management!public! !
!ODBContainer categoriesFor: #setNewObjectSpace:!byte storage management!public! !
!ODBContainer categoriesFor: #swapObjectSpaces!byte storage management!public! !

!ODBContainer class methodsFor!

new

    ^super new initialize! !
!ODBContainer class categoriesFor: #new!public! !

