"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #OmniBaseArchiver
	instanceVariableNames: 'db newDb versionDescriptor oldHolders newVersionNumber progressDialog progressValue'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OmniBaseArchiver guid: (GUID fromString: '{1B8A89B7-CAE9-42C3-B085-B3EA2FA89DB4}')!
OmniBaseArchiver comment: ''!
!OmniBaseArchiver categoriesForClass!Unclassified! !
!OmniBaseArchiver methodsFor!

copyClassManager
	| lastClassId classDescription |
	self progressNotification: 'Copying class meta information' value: 0.
	lastClassId := db classManager lastClassId.
	1 to: lastClassId
		do: 
			[:i | 
			classDescription := nil.
			[classDescription := db classManager classDescriptionAt: i] on: Error do: [:ex | ].
			newDb classManager addClassDescription: classDescription withId: i.
			self progressNotification: nil value: i / lastClassId]!

copyContainer: container 
	| size newContainer newIndexFile dbClass holderVisibilityResult |
	self progressNotification: 'Copying container ' , container name value: 0.
	newContainer := newDb objectManager containerAt: container id
				ifAbsent: [newDb objectManager containerNew: container name].
	newIndexFile := newContainer indexFile.
	newIndexFile setLastIndex: container indexFile getLastIndex.
	size := container numberOfObjects.
	container objectHoldersDo: 
			[:eachHolder | 
			eachHolder isRemoved 
				ifTrue: [newIndexFile removeIndex: eachHolder objectID index]
				ifFalse: 
					[holderVisibilityResult := true.
					[holderVisibilityResult == false or: [versionDescriptor versionOK: eachHolder versionNumber]] 
						whileFalse: [holderVisibilityResult := eachHolder loadPreviousVersionOrNilFrom: oldHolders].
					holderVisibilityResult 
						ifFalse: [newIndexFile removeIndex: eachHolder objectID index]
						ifTrue: 
							[eachHolder versionNumber: newVersionNumber.
							dbClass := ODBDatabaseObject persistentClassAt: eachHolder persistentClassID.
							dbClass hasBytes 
								ifTrue: 
									[eachHolder setContainer: newContainer.
									newContainer addByteStorageRequest: (ODBGarbageCollectorRequest new objectHolder: eachHolder
												bytes: (container loadBytesAt: eachHolder objectPosition length: eachHolder objectLength))]
								ifFalse: 
									[dbClass hasExternalFiles 
										ifTrue: 
											["backup objects using external files (b-trees)"
											eachHolder getObject 
												createBackupCopyIn: newContainer
												versionDescriptor: versionDescriptor
												oldHolders: db transactionManager oldHolders
												versionNumber: newVersionNumber].
									newIndexFile at: eachHolder objectID index put: eachHolder contents]]].
			self progressNotification: nil value: eachHolder objectID index / size].
	newContainer flushBytes!

copyContainers
	| container i |
	i := 1.
	
	[container := db objectManager containerAt: i ifAbsent: [].
	i := i + 1.
	container isNil] 
			whileFalse: [self copyContainer: container]!

copyDatabase
	self
		copyContainers;
		copyClassManager!

copyDatabase: silentBool 
	silentBool = true 
		ifTrue: [self copyDatabase]
		ifFalse: 
			[progressDialog := ProgressDialog operation: 
							[:valueHolder | 
							progressValue := valueHolder.
							[self copyDatabase] ifCurtailed: [progressDialog view close]].
			progressDialog
				caption: 'Starting on-line backup';
				showModal]!

onlineBackup: anOmniBase to: newPath 
	self 
		onlineBackup: anOmniBase
		to: newPath
		silent: false!

onlineBackup: anOmniBase to: newPath silent: silentBool 
	^self 
		onlineBackup: anOmniBase
		to: newPath
		silent: silentBool
		fromVersionNumber: nil!

onlineBackup: anOmniBase to: newPath silent: silentBool fromVersionNumber: anInteger 
	"Backup database into another database instance. Method arguments are as follows:

		anOmniBase - database instance of which a backup will be made
		newPath - location where new backup database will be stored
		silentBool - true if no progress bar should be shown
		anInteger - if nil, then data as it was when the backup started will be copied,
				else a historic version of anOmniBase will be created as it was visible in version anInteger.
	"

	newDb := OmniBase createOn: newPath.
	
	[newDb objectManager reopenExclusively.
	db := anOmniBase.
	oldHolders := db transactionManager oldHolders.
	versionDescriptor := db transactionManager versionControl versionDescriptor copy.
	anInteger isNil 
		ifFalse: 
			["create/reconstruct a copy of the database as it was in some particular moment in the past"
			versionDescriptor 
				topVersionNumber: anInteger
				readVersionNumber: anInteger
				committingTransactions: #()].
	newVersionNumber := newDb transactionManager versionControl 
				getNewVersionNumberFor: newDb localClient clientID.
	newDb transactionManager versionControl removeCommittingFor: newDb localClient clientID.
	self copyDatabase: silentBool] 
			ensure: [newDb close]!

progressNotification: aString value: aFraction 
	progressDialog isNil 
		ifFalse: 
			[aString isNil ifFalse: [progressDialog caption: aString].
			aFraction isNil ifFalse: [progressValue value: 100 * aFraction]]! !
!OmniBaseArchiver categoriesFor: #copyClassManager!private! !
!OmniBaseArchiver categoriesFor: #copyContainer:!private! !
!OmniBaseArchiver categoriesFor: #copyContainers!private! !
!OmniBaseArchiver categoriesFor: #copyDatabase!public! !
!OmniBaseArchiver categoriesFor: #copyDatabase:!public! !
!OmniBaseArchiver categoriesFor: #onlineBackup:to:!public! !
!OmniBaseArchiver categoriesFor: #onlineBackup:to:silent:!public! !
!OmniBaseArchiver categoriesFor: #onlineBackup:to:silent:fromVersionNumber:!public! !
!OmniBaseArchiver categoriesFor: #progressNotification:value:!private! !

