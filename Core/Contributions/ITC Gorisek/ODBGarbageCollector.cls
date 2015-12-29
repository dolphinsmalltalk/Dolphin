"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBGarbageCollector
	instanceVariableNames: 'gcFile containers objectManager reorganizeDictionaries reorganizeIndexSets progressDialog progressValue'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBGarbageCollector guid: (GUID fromString: '{8162EDDB-0FB8-11D4-B091-000000000000}')!
ODBGarbageCollector comment: ''!
!ODBGarbageCollector categoriesForClass!No category! !
!ODBGarbageCollector methodsFor!

basicCompactContainerNamed: aString 
	| container |
	
	[container := objectManager containerNamed: aString
				ifAbsent: [OmniBase signalError: 'Container named ' , aString , ' does not exist'].
	(self checkDiskSpace: (Array with: container)) ifFalse: [^false].
	container
		createNewObjectSpace;
		swapObjectSpaces.
	self compactObjectSpaceForContainer: container reachableObjectsSet: nil] 
			ensure: 
				[self close.
				objectManager reopen.
				objectManager environment globalUnlock]!

basicRun
	
	[self progressNotification: 'Starting garbage collection' value: 0.
	self lockObjectManager.	"doesn't realy lock it, see method #lockObjectManager"
	containers := objectManager containers.
	(self checkDiskSpace: containers) ifFalse: [^false].
	self
		createNewObjectSpaces;
		selectNewObjectSpace;
		swapObjectSpaces;
		walkObjects;
		copyObjects;
		complete] 
			ensure: 
				[self close.
				objectManager reopen.
				objectManager environment globalUnlock]!

checkDiskSpace: containersColl 
	"Private - Check for avaiable disk space and set total number of objects in wait dialog."

	| maxContainerSize n gcSpace |
	maxContainerSize := 0.
	gcSpace := 0.
	containersColl do: 
			[:container | 
			n := container numberOfObjects.
			gcSpace := n // 8 + gcSpace.
			maxContainerSize := container bytesAllocated max: maxContainerSize].
	maxContainerSize + gcSpace < objectManager environment freeDiskSpace ifTrue: [^true].
	^progressDialog isNil 
		ifTrue: [OmniBase logWarning: '[OmniBase GC] Warning disk space low']
		ifFalse: [OmniBase confirmationMessage: 'Disk space low.
Are you sure you want to continue ?']!

close
	gcFile notNil ifTrue: [gcFile close]!

compactContainerNamed: aString silentMode: silenceBool 
	gcFile isNil 
		ifFalse: 
			[OmniBase 
				signalError: 'Previous garbage collection did not complete. Please re-start full garbage collection.'].
	(objectManager environment globalLock and: [objectManager reopenExclusively]) 
		ifFalse: 
			[objectManager environment globalUnlock.
			self close.
			silenceBool = true 
				ifFalse: [OmniBase warningMessage: 'Database is still being accessed by other users !!'].
			^false].
	silenceBool = true 
		ifTrue: [self basicCompactContainerNamed: aString]
		ifFalse: 
			[progressDialog := ProgressDialog operation: 
							[:valueHolder | 
							progressValue := valueHolder.
							[self basicCompactContainerNamed: aString] ifCurtailed: [progressDialog view close]].
			progressDialog
				caption: 'Compacting container ' , aString;
				showModal].
	^true!

compactObjectSpaceForContainer: container reachableObjectsSet: set 
	"Private - Copy compact container objects space and remove objects which are not included in the set. If set is nil, then just compact the object space."

	| dbObject index count |
	count := 0.
	self progressNotification: 'Compacting container ' , container name value: 0.
	container objectHoldersDo: 
			[:holder | 
			count := count + 1.
			self progressNotification: nil value: count / container numberOfObjects.
			index := holder objectID index.
			dbObject := holder getObject.
			(set isNil or: [set includes: index]) 
				ifTrue: [dbObject garbageCollectOn: self]
				ifFalse: 
					[dbObject remove.
					container removeHolderAt: index]].
	container flushBytes!

complete
	"Private - Complete garbage collection."

	gcFile status = 6 ifFalse: [^self].
	objectManager environment transactionManager oldHolders truncate.
	objectManager unlock.
	gcFile remove.
	gcFile := nil!

copyObjects
	"Private - Copy objects from oldObject space to new object space."

	| set objectSpace |
	gcFile status = 5 ifFalse: [^self].
	objectSpace := objectManager defaultObjectSpace.
	containers do: 
			[:container | 
			[set := ODBIntegerSet openOn: (self oidSetFilenameFor: container)] on: Error do: [set := nil].
			set isNil 
				ifFalse: 
					[self compactObjectSpaceForContainer: container reachableObjectsSet: set.
					set remove.
					container removeObjectSpace: 1 - objectSpace]].
	gcFile status: 6!

createNewObjectSpaces
	"Private - Create new object space for each container."

	gcFile status = 1 ifFalse: [^self].
	containers do: [:each | each createNewObjectSpace].
	"new object spaces created"
	gcFile status: 2!

gcFileName
	^objectManager environment dirName , ODBFileStream pathSeparatorString , 'GC.log'!

lockObjectManager
	gcFile status = 0 ifFalse: [^self].
	"objectManager lock."	"don't lock it because db is allready opened exclusively"
	"object manager has been locked"
	gcFile status: 1!

oidSetFilenameFor: anODBContainer 
	^anODBContainer dirName , ODBFileStream pathSeparatorString , 'Marked.set'!

oidStackFileName
	^objectManager environment dirName , ODBFileStream pathSeparatorString , 'GC.oid'!

openOn: anOmniBase 
	"Open garbage collector on anOmnibase. If garbage collector file exists
	then previous garbage collection was interrupted.
	Answer <true> if previous GC was completed, <false> if it wasn't."

	objectManager := anOmniBase objectManager.
	(ODBFileStream exists: self gcFileName) 
		ifTrue: 
			[(gcFile := ODBGarbageCollectorFile openOn: self) isNil 
				ifFalse: 
					[gcFile status < 3 
						ifTrue: 
							[gcFile remove.
							gcFile := nil]]].
	^gcFile isNil!

progressNotification: aString value: aFraction 
	progressDialog isNil 
		ifFalse: 
			[aString isNil ifFalse: [progressDialog caption: aString].
			aFraction isNil ifFalse: [progressValue value: 100 * aFraction]]!

reorganizeDictionaries
	^reorganizeDictionaries == true!

reorganizeDictionaries: aBoolean 
	reorganizeDictionaries := aBoolean!

reorganizeIndexSets
	"Answer <true> if B-Tree index sets should be reorganized."

	^reorganizeIndexSets == true!

reorganizeIndexSets: aBoolean 
	reorganizeIndexSets := aBoolean!

run
	^self run: false!

run: silenceBool 
	(objectManager environment globalLock and: [objectManager reopenExclusively]) 
		ifFalse: 
			[objectManager environment globalUnlock.
			self close.
			silenceBool = true 
				ifFalse: [OmniBase warningMessage: 'Database is still being accessed by other users !!'].
			^false].
	silenceBool = true 
		ifTrue: [self basicRun]
		ifFalse: 
			[progressDialog := ProgressDialog operation: 
							[:valueHolder | 
							progressValue := valueHolder.
							[self basicRun] ifCurtailed: [progressDialog view close]].
			progressDialog
				caption: 'Starting garbage collection';
				showModal].
	^true!

runOn: anOmniBase 
	"Run garbage collection on anOmniBase."

	^self runOn: anOmniBase silentMode: false!

runOn: anOmniBase silentMode: silenceBool 
	"Run garbage collection on anOmniBase."

	objectManager := anOmniBase objectManager.
	[gcFile := ODBGarbageCollectorFile openOn: self gcFileName] on: Error
		do: 
			[:ex | 
			objectManager isLocked ifTrue: [OmniBase signalError: 'Object manager is locked !!'].
			gcFile := ODBGarbageCollectorFile createOn: self gcFileName].
	^self run: silenceBool!

selectNewObjectSpace
	"Private - Select new object space."

	gcFile status = 2 ifFalse: [^self].
	gcFile newObjectSpace: 1 - objectManager defaultObjectSpace.
	gcFile status: 3!

swapObjectSpaces
	"Private - Swap default object spaces."

	| newObjectSpace |
	gcFile status = 3 ifFalse: [^self].
	newObjectSpace := gcFile newObjectSpace.
	objectManager defaultObjectSpace == newObjectSpace 
		ifFalse: 
			[containers do: [:each | each lockObjectSpace: 1 - newObjectSpace].
			objectManager defaultObjectSpace: newObjectSpace].
	"object spaces have been swaped"
	gcFile status: 4!

walkObjects
	"Private - Object traversal."

	| toDo firstToDo oidSets set containerID totalObjects objectID holder dbObject count |
	gcFile status = 6 ifTrue: [^self].
	"create OID sets"
	oidSets := OrderedCollection new.
	
	[totalObjects := 0.
	containers do: 
			[:container | 
			set := ODBIntegerSet createOn: (self oidSetFilenameFor: container).
			[oidSets size < container id] whileTrue: [oidSets add: nil].
			oidSets at: container id put: set.
			totalObjects := totalObjects + container numberOfObjects].
	count := 0.
	self progressNotification: 'Traversing objects' value: 0.
	"first load all from rootObject"
	firstToDo := OrderedCollection new.
	"create OID stack"
	toDo := ODBObjectIdStack createOn: self oidStackFileName.
	"walk objects"
	(oidSets at: 1) add: 1.	"mark (1:1)"
	firstToDo add: (ODBObjectID containerID: 1 index: 1).
	[firstToDo size = 1] whileTrue: 
			[objectID := firstToDo removeLast.
			self progressNotification: nil value: (count := count + 1) / (totalObjects * 2).
			(holder := objectManager holderAt: objectID) isNil 
				ifFalse: 
					[dbObject := holder getObject.
					dbObject referencesDo: 
							[:oid | 
							containerID := oid containerID.
							(containerID == 0 or: [(oidSets at: containerID) includes: oid index]) 
								ifFalse: 
									[(oidSets at: containerID) add: oid index.
									firstToDo add: oid.
									self progressNotification: nil value: (count := count + 1) / (totalObjects * 2)]].
					dbObject close]
				ifTrue: [OmniBase signalError: 'Invalid object ID']].
	firstToDo do: 
			[:eachOID | 
			self progressNotification: nil value: (count := count + 1) / (totalObjects * 2).
			(holder := objectManager holderAt: eachOID) == nil 
				ifFalse: 
					[dbObject := holder getObject.
					dbObject referencesDo: 
							[:oid | 
							containerID := oid containerID.
							(containerID == 0 or: [(oidSets at: containerID) includes: oid index]) 
								ifFalse: 
									[(oidSets at: containerID) add: oid index.
									toDo add: oid.
									self progressNotification: nil value: (count := count + 1) / (totalObjects * 2)]].
					dbObject close]
				ifTrue: [OmniBase signalError: 'Invalid object ID']].
	[toDo isEmpty] whileFalse: 
			[objectID := toDo removeLast.
			self progressNotification: nil value: (count := count + 1) / (totalObjects * 2).
			(holder := objectManager holderAt: objectID) == nil 
				ifFalse: 
					[dbObject := holder getObject.
					dbObject referencesDo: 
							[:oid | 
							containerID := oid containerID.
							(containerID == 0 or: [(oidSets at: containerID) includes: oid index]) 
								ifFalse: 
									[(oidSets at: containerID) add: oid index.
									toDo add: oid.
									self progressNotification: nil value: (count := count + 1) / (totalObjects * 2)]].
					dbObject close]
				ifTrue: [OmniBase signalError: 'Invalid object ID']]] 
			ensure: 
				["remove OID stack"
				toDo isNil ifFalse: [toDo remove].
				"close OID sets"
				oidSets do: [:each | each notNil ifTrue: [each close]]].
	gcFile status: 5! !
!ODBGarbageCollector categoriesFor: #basicCompactContainerNamed:!private! !
!ODBGarbageCollector categoriesFor: #basicRun!private! !
!ODBGarbageCollector categoriesFor: #checkDiskSpace:!private! !
!ODBGarbageCollector categoriesFor: #close!public! !
!ODBGarbageCollector categoriesFor: #compactContainerNamed:silentMode:!public! !
!ODBGarbageCollector categoriesFor: #compactObjectSpaceForContainer:reachableObjectsSet:!private! !
!ODBGarbageCollector categoriesFor: #complete!private! !
!ODBGarbageCollector categoriesFor: #copyObjects!private! !
!ODBGarbageCollector categoriesFor: #createNewObjectSpaces!private! !
!ODBGarbageCollector categoriesFor: #gcFileName!private! !
!ODBGarbageCollector categoriesFor: #lockObjectManager!private! !
!ODBGarbageCollector categoriesFor: #oidSetFilenameFor:!private! !
!ODBGarbageCollector categoriesFor: #oidStackFileName!private! !
!ODBGarbageCollector categoriesFor: #openOn:!public! !
!ODBGarbageCollector categoriesFor: #progressNotification:value:!private! !
!ODBGarbageCollector categoriesFor: #reorganizeDictionaries!public! !
!ODBGarbageCollector categoriesFor: #reorganizeDictionaries:!public! !
!ODBGarbageCollector categoriesFor: #reorganizeIndexSets!public! !
!ODBGarbageCollector categoriesFor: #reorganizeIndexSets:!public! !
!ODBGarbageCollector categoriesFor: #run!public! !
!ODBGarbageCollector categoriesFor: #run:!public! !
!ODBGarbageCollector categoriesFor: #runOn:!public! !
!ODBGarbageCollector categoriesFor: #runOn:silentMode:!public! !
!ODBGarbageCollector categoriesFor: #selectNewObjectSpace!private! !
!ODBGarbageCollector categoriesFor: #swapObjectSpaces!private! !
!ODBGarbageCollector categoriesFor: #walkObjects!private! !

