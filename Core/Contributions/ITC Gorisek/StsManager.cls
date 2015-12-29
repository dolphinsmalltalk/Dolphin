"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #StsManager
	instanceVariableNames: 'repositoryPath db methodDictOIDs developer ignoreCompilerEventsFlag globalTransaction classEditions packageEditions currentServerURL loginData'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'!
StsManager guid: (GUID fromString: '{D2238700-0F19-11D4-B08F-000000000000}')!
StsManager comment: '"Evaluate the following line to initialize Source Tracking System."

	StsManager startUp'!
!StsManager categoriesForClass!Unclassified! !
!StsManager methodsFor!

addPackageEdition: aPackageEdition beforeIndex: aNumber onProjectEdition: aProjectEdition 
	| transaction projectEdition packageEdition containedEditions existingEdition |
	self checkIfConnected ifFalse: [^self].
	transaction := db newTransaction.
	
	[projectEdition := transaction objectAt: aProjectEdition odbObjectID.
	packageEdition := transaction objectAt: aPackageEdition odbObjectID.
	containedEditions := projectEdition packageEditions.
	existingEdition := containedEditions detect: [:each | each name = packageEdition name] ifNone: [].
	existingEdition isNil 
		ifFalse: [containedEditions removeAtIndex: (containedEditions indexOf: existingEdition odbResolve)].
	containedEditions add: packageEdition beforeIndex: aNumber.
	transaction
		markDirty: projectEdition;
		commit] 
			ifCurtailed: [transaction abort]!

addPackageEdition: aPackageEdition toProjectEdition: aProjectEdition 
	| transaction projectEdition packageEdition containedEditions existingEdition |
	self checkIfConnected ifFalse: [^self].
	transaction := db newTransaction.
	
	[projectEdition := transaction objectAt: aProjectEdition odbObjectID.
	packageEdition := transaction objectAt: aPackageEdition odbObjectID.
	containedEditions := projectEdition packageEditions.
	existingEdition := containedEditions detect: [:each | each name = packageEdition name] ifNone: [].
	existingEdition isNil 
		ifTrue: [containedEditions add: packageEdition]
		ifFalse: 
			[containedEditions at: (containedEditions indexOf: existingEdition odbResolve) put: packageEdition].
	transaction
		markDirty: projectEdition;
		commit] 
			ifCurtailed: [transaction abort]!

allPrerequisitePackageNamesOf: aPackageEdition prereqs: prereqs visited: visited includeBasePackages: includeBasePackages 
	(visited includes: aPackageEdition name) ifTrue: [^self].
	visited add: aPackageEdition name.
	aPackageEdition prerequisiteNames do: 
			[:eachPrereqName | 
			| latestEdition |
			((visited includes: eachPrereqName) not 
				and: [(latestEdition := self getLatestPackageEditionFor: eachPrereqName) notNil]) 
					ifTrue: 
						[(includeBasePackages or: [latestEdition isBaseImagePackage not]) 
							ifTrue: 
								[self 
									allPrerequisitePackageNamesOf: latestEdition
									prereqs: prereqs
									visited: visited
									includeBasePackages: includeBasePackages.
								prereqs add: eachPrereqName]]].
	^visited!

basicPurgePackageEdition: aStsPackageEdition 
	| transaction oid dict packageEdition editions |
	Cursor wait showWhile: 
			[transaction := db newTransaction.
			oid := aStsPackageEdition odbObjectID.
			
			[packageEdition := transaction objectAt: oid.
			dict := transaction root at: self classesKey.
			packageEdition classes do: 
					[:eachClassEditionToPurge | 
					(self doesAnyPackageEditionUse: eachClassEditionToPurge) 
						ifFalse: 
							["remove class edition"
							| index |
							editions := dict at: eachClassEditionToPurge name.
							index := editions findFirst: [:e | e isIdenticalTo: eachClassEditionToPurge].
							index > 0 ifTrue: [editions removeAtIndex: index].
							transaction markDirty: editions]].
			((transaction root at: self packagesKey) at: aStsPackageEdition name ifAbsent: [#()]) do: 
					[:eachPackageEdition | 
					(eachPackageEdition previousEdition notNil 
						and: [eachPackageEdition previousEdition odbObjectID = oid]) 
							ifTrue: 
								[eachPackageEdition previousEdition: nil.
								transaction markDirty: eachPackageEdition]].
			transaction commit] 
					ifCurtailed: [transaction abort]]!

basicVersionPackage: aPackage versionDescriptor: versionDescriptor developer: aDeveloper previousEdition: aPackageEdition blessing: aBlessing comment: aComment versionComment: versionComment checkExisting: checkExisting silentBool: silentBool 
	"Version aPackage.
	Answer aPackage persistent OID."

	| editions packageOID classEditionOIDs packageEdition dict transaction progressDialog progressCounter size lastIndex packageTS packageDeveloper versioningBlock classEdition asoc previousEdition |
	transaction := db newTransaction.
	dict := transaction root at: self packagesKey.
	editions := dict at: aPackage name ifAbsent: [OrderedCollection new].
	checkExisting == true 
		ifTrue: 
			[(packageEdition := self findExistingPackage: aPackage in: editions) isNil 
				ifFalse: [^transaction getObjectID: packageEdition]].
	size := aPackage classes size.
	progressCounter := Array with: 0 with: size + 2.
	versioningBlock := 
			[:progress | 
			progressDialog caption: 'Versioning classes in package ' , aPackage name.
			progress value: 100 * progressCounter first / progressCounter last.
			"first version all classes and remember their OIDs (version in groups of 7)"
			lastIndex := 1.
			classEditionOIDs := OrderedCollection new.
			transaction := db newTransaction.
			
			[(aPackage classes asSortedCollection: [:a :b | self byteCompare: a name with: b name]) do: 
					[:each | 
					classEdition := self findOrCreateClassEditionFor: each in: transaction.
					classEditionOIDs add: (Association key: each value: classEdition).
					(classEditionOIDs size \\ 7 = 0 or: [classEditionOIDs size = size]) 
						ifTrue: 
							[transaction checkpoint.
							lastIndex to: classEditionOIDs size
								do: 
									[:i | 
									asoc := classEditionOIDs at: i.
									asoc value: (transaction getObjectID: asoc value)].
							lastIndex := classEditionOIDs size + 1.
							transaction abort.
							transaction := db newTransaction].
					progressCounter at: 1 put: progressCounter first + 1.
					progress value: 100 * progressCounter first / progressCounter last]] 
					ensure: [transaction abort].
			transaction := db newTransaction.
			
			[dict := transaction root at: self packagesKey.
			editions := dict at: aPackage name
						ifAbsentPut: 
							[transaction markDirty: dict.
							OrderedCollection new].
			previousEdition := aPackageEdition isNil 
						ifTrue: 
							[(editions detect: [:eachExistingEdition | eachExistingEdition isLoadedOrChangedAfterLoad] ifNone: []) 
								ifNotNil: [:value | transaction objectAt: value odbObjectID]]
						ifFalse: [transaction objectAt: aPackageEdition odbObjectID].
			(aPackage isKindOf: StsPackageProxy) 
				ifTrue: 
					[packageDeveloper := aPackage developer.
					packageTS := aPackage timestamp].
			(packageDeveloper isNil or: [packageDeveloper isEmpty]) ifTrue: [packageDeveloper := aDeveloper].
			packageTS isNil 
				ifTrue: [packageTS := TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds)].
			packageEdition := (StsPackageEdition new)
						name: aPackage name;
						pathName: aPackage packagePathname;
						versionDescriptor: versionDescriptor;
						developer: packageDeveloper;
						timestamp: packageTS;
						previousEdition: previousEdition;
						blessing: aBlessing;
						comment: aComment;
						versionComment: versionComment;
						imageStripperBytes: (transaction makePersistent: aPackage imageStripperBytes);
						aboutBlock: aPackage aboutBlock;
						manualPrerequisites: aPackage manualPrerequisites asArray;
						prerequisiteNames: aPackage prerequisiteNames asArray.
			packageEdition scriptNames do: [:each | packageEdition script: each put: (aPackage scriptAt: each)].
			editions addFirst: packageEdition.
			transaction
				store: editions;
				makePersistent: packageEdition.
			packageEdition 
				classes: (classEditionOIDs collect: 
							[:each | 
							self setLoadedClassIdentifiersFor: each key to: each value.
							transaction referenceAt: each value]) 
						asArray.
			aPackage methods 
				do: [:each | packageEdition methods add: (self getMethodEditionFor: each in: transaction)].
			progressCounter at: 1 put: progressCounter first + 1.
			progress value: 100 * progressCounter first / progressCounter last.
			aPackage allResourceIdentifiers size > 0 
				ifTrue: 
					[progressCounter := Array with: 0 with: aPackage allResourceIdentifiers size.
					progress value: 0.
					progressDialog caption: 'Versioning resources in package ' , aPackage name.
					packageEdition 
						resources: (aPackage allResourceIdentifiers collect: 
									[:each | 
									progressCounter at: 1 put: progressCounter first + 1.
									progress value: 100 * progressCounter first / progressCounter last.
									self getResourceEditionFor: each in: transaction]) 
								asArray]
				ifFalse: [packageEdition resources: #()].
			aPackage globalNames do: 
					[:eachName | 
					packageEdition globals at: eachName
						put: (transaction makePersistent: (StsStbProxy on: (aPackage globalFromName: eachName)))].
			Cursor wait showWhile: [transaction checkpoint].
			packageOID := transaction getObjectID: packageEdition] 
					ensure: [transaction abort].
			(aPackage isKindOf: StsPackageProxy) 
				ifFalse: 
					[SessionManager current 
						logComment: '[STS] New package version created in repository: ' , aPackage name , ' ' 
								, versionDescriptor , ' in ' 
								, db dirName.
					aPackage
						packageVersion: versionDescriptor;
						isChanged: false.
					aPackage classes do: [:each | each isChanged: false].
					self setLoadedPackageIdentifiersFor: packageEdition to: packageEdition identifiers]].
	silentBool 
		ifTrue: 
			["for STS server mode operation"
			progressDialog := #ItcSystemManager itcAsClassOrNil.
			versioningBlock value: progressDialog]
		ifFalse: 
			[progressDialog := ProgressDialog operation: versioningBlock.
			progressDialog
				caption: 'Please wait';
				showModal].
	^packageOID!

basicVersionPackage: aPackage versionDescriptor: versionDescriptor previousEdition: aPackageEdition blessing: aBlessing comment: aComment versionComment: versionComment checkExisting: checkExisting silentBool: silentBool 
	^self 
		basicVersionPackage: aPackage
		versionDescriptor: versionDescriptor
		developer: developer
		previousEdition: aPackageEdition
		blessing: aBlessing
		comment: aComment
		versionComment: versionComment
		checkExisting: checkExisting
		silentBool: silentBool!

basicVersionPackage: aPackage versionDescriptor: versionDescriptor previousEdition: aPackageEdition versionComment: versionComment checkExisting: checkExisting silentBool: silentBool 
	^self 
		basicVersionPackage: aPackage
		versionDescriptor: versionDescriptor
		developer: developer
		previousEdition: aPackageEdition
		blessing: nil
		comment: aPackage comment
		versionComment: versionComment
		checkExisting: checkExisting
		silentBool: silentBool!

basicVersionProject: aProject previousEdition: aProjectEdition 
	| packageEditionOIDs progressDialog progressCounter size |
	size := aProject packages size.
	progressCounter := Array with: 1 with: size + 2.
	progressDialog := ProgressDialog operation: 
					[:progress | 
					progressDialog caption: 'Versioning project ' , aProject name.
					progress value: 100 * progressCounter first / progressCounter last.
					packageEditionOIDs := OrderedCollection new.
					aProject packages do: 
							[:each | 
							packageEditionOIDs add: (self 
										basicVersionPackage: each
										versionDescriptor: each version
										previousEdition: nil
										versionComment: each comment
										checkExisting: true
										silentBool: false).
							progressCounter at: 1 put: progressCounter first + 1.
							progress value: 100 * progressCounter first / progressCounter last].
					self 
						basicVersionProject: aProject
						versionDescriptor: aProject projectVersion
						previousEdition: aProjectEdition
						blessing: aProject blessing
						comment: aProject comment
						versionComment: aProject versionComment
						packageEditionOIDs: packageEditionOIDs
						progress: progress
						tick: progressCounter
						timestamp: nil
						developer: developer.
					aProject version: aProject projectVersion].
	progressDialog
		caption: 'Please wait';
		showModal!

basicVersionProject: aProject versionDescriptor: versionDescriptor previousEdition: aProjectEdition blessing: aBlessing comment: aComment versionComment: versionComment packageEditionOIDs: packageEditionOIDs progress: progress tick: progressCounter timestamp: aTimestamp developer: projectDeveloper 
	| previousEdition editions projectEdition dict transaction |
	transaction := db newTransaction.
	
	[dict := transaction root at: self projectsKey.
	editions := dict at: aProject name
				ifAbsentPut: 
					[transaction markDirty: dict.
					OrderedCollection new].
	previousEdition := aProjectEdition isNil 
				ifFalse: [transaction objectAt: aProjectEdition odbObjectID].
	projectEdition := (StsProjectEdition new)
				name: aProject name;
				versionDescriptor: versionDescriptor;
				blessing: aBlessing;
				comment: aComment;
				versionComment: versionComment;
				developer: projectDeveloper;
				timestamp: (aTimestamp isNil 
							ifTrue: [TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds)]
							ifFalse: [aTimestamp]);
				previousEdition: previousEdition.
	editions addFirst: projectEdition.
	transaction
		store: editions;
		makePersistent: projectEdition.
	projectEdition 
		packageEditions: (packageEditionOIDs collect: [:each | transaction referenceAt: each]).
	progress isNil 
		ifFalse: 
			[progressCounter at: 1 put: progressCounter first + 1.
			progress value: 100 * progressCounter first / progressCounter last.
			Cursor wait showWhile: [transaction checkpoint]]
		ifTrue: [transaction checkpoint]] 
			ensure: [transaction abort]!

browseAvailableMethodsFor: aClass 
	| selectors selector |
	self checkIfConnected 
		ifTrue: 
			[(selectors := self getAvailableMethodsFor: aClass) isEmpty 
				ifTrue: [MessageBox notify: 'All methods are loaded']
				ifFalse: 
					[(selector := ChoicePrompter choices: selectors caption: 'Available Methods') notNil 
						ifTrue: 
							[(StsMethodEditionsBrowserShell create)
								setClass: aClass selector: selector;
								showShell]]]!

browseChangesBetween: packageEdition1 and: packageEdition2 
	| changes |
	changes := OrderedCollection new.
	Cursor wait showWhile: [packageEdition1 compareWith: packageEdition2 on: changes].
	changes isEmpty 
		ifFalse: 
			[| owningPackage |
			owningPackage := Package manager packageNamed: packageEdition1 name ifNone: [packageEdition1 name].
			changes do: [:each | each owningPackage isNil ifTrue: [each owningPackage: owningPackage]].
			(StsComparisonBrowser create)
				setChanges: changes;
				caption: 'Changes Browser - ' , packageEdition1 name , ': Version ' , packageEdition1 packageVersion 
							, ' vs Version ' , packageEdition2 packageVersion;
				showShell]
		ifTrue: [MessageBox notify: 'There were no changes between these two package editions']!

browseChangeSetsList
	StsStoredChangeSetsBrowserShell create showShell!

browseClassEditions: aSymbol 
	self checkIfConnected 
		ifTrue: 
			[(StsClassEditionsBrowserShell create)
				setClassName: aSymbol;
				showShell]!

browseMethodEditions: selector class: aClass 
	self checkIfConnected 
		ifTrue: 
			[(StsMethodEditionsBrowserShell create)
				setClass: aClass selector: selector;
				showShell]!

browsePackageEditions: packageName 
	self checkIfConnected 
		ifTrue: 
			[(StsPackageEditionsBrowserShell create)
				setPackageName: packageName;
				showShell]!

byteCompare: str1 with: str2 
	| length bytes1 bytes2 |
	length := str1 size max: str2 size.
	bytes1 := ByteArray new: length.
	bytes1 
		replaceFrom: 1
		to: str1 size
		with: str1
		startingAt: 1.
	bytes2 := ByteArray new: length.
	bytes2 
		replaceFrom: 1
		to: str2 size
		with: str2
		startingAt: 1.
	^bytes1 odbIsLessOrEqualTo: bytes2!

changeSetsKey
	"Private - Answers root dictionary key at which 
		a dictionary of change sets collections is stored."

	^'sts.changeSets'!

checkIfConnected
	^self isConnected 
		ifFalse: 
			[MessageBox errorMsg: 'Please connect to repository first'.
			false]
		ifTrue: [true]!

chooseRepository
	^(BrowseFolderDialog new)
		value: self class defaultRepositoryPath;
		caption: 'Please select location of your code repository';
		showModal!

classesKey
	"Private - Answers root dictionary key at which 
		a dictionary of class editions collections is stored."

	^'sts.classes'!

collectOIDsFrom: aCollection in: transaction 
	"Private - Answer collection of persistent object OIDs or nil 
	if any one of them is not persistent (yet)."

	| oid |
	^aCollection collect: 
			[:each | 
			(oid := transaction getObjectIDOrNil: each) isNil ifTrue: [^nil].
			oid]!

compareObjectIDsOf: objects with: oids in: transaction 
	"Private - Compare if objects in collections are identical without actualy loading them."

	objects size = oids size ifFalse: [^false].
	1 to: objects size
		do: [:i | (transaction getObjectIDOrNil: (objects at: i)) = (oids at: i) ifFalse: [^false]].
	^true!

comparePackage: aPackage with: aPackageEdition 
	| changes |
	Cursor wait showWhile: 
			[changes := OrderedCollection new.
			aPackageEdition compareWithLoadedPackage: aPackage on: changes].
	changes isEmpty 
		ifTrue: [self notifyImageSameAsPackageEdition: aPackageEdition]
		ifFalse: 
			[| comparisonBrowser |
			changes do: [:each | each owningPackage isNil ifTrue: [each owningPackage: aPackage]].
			comparisonBrowser := (StsComparisonBrowser create)
						setChanges: changes;
						caption: 'Changes Browser - ' , aPackage name , ': Loaded package vs Version ' 
									, aPackageEdition packageVersion.
			[comparisonBrowser showShell] postToInputQueue]!

compareRepositoryEditionWithClass: aClass 
	| transaction editions repositoryEdition changes |
	self checkIfConnected ifFalse: [^self].
	transaction := db newLongReadOnlyTransaction.
	(editions := self getClassEditions: aClass name in: transaction) isEmpty 
		ifTrue: [^MessageBox notify: 'No previous editions were found in the repository'].
	(repositoryEdition := ChoicePrompter choices: editions caption: 'Available Editions') isNil 
		ifTrue: [^self].
	changes := OrderedCollection new.
	(self findOrCreateClassEditionFor: aClass in: transaction) compareWith: repositoryEdition
		on: changes.
	changes isEmpty 
		ifTrue: [MessageBox notify: 'No changes were found between loaded class and edition in repository.']
		ifFalse: 
			[(StsComparisonBrowser create)
				setChanges: changes;
				caption: 'Changes Browser - ' , aClass name , ': Loaded class vs ' , repositoryEdition name , ' ' 
							, repositoryEdition displayString;
				showShell]!

compareRepositoryEditionWithPackage: aPackage 
	| edition |
	self checkIfConnected ifFalse: [^self].
	(edition := StsPackageEditionPrompter chooseWithDefault: aPackage name) isNil ifTrue: [^self].
	self comparePackage: aPackage with: edition!

compressToByteArray: contents 
	| inLen outLen outData |
	inLen := contents size.
	outLen := ByteArray new: 4.
	outLen dwordAtOffset: 0 put: inLen + 20.
	outData := ByteArray new: inLen + 20.
	ZLibInterface 
		compress: contents
		len: inLen
		out: outData
		len: outLen
		level: ZLibInterface Z_best_compression.
	^outData copyFrom: 1 to: (outLen dwordAtOffset: 0)!

connectToDatabase
	| transaction |
	[db := self databaseClass openOn: repositoryPath] on: Error do: [:ex | db := nil].
	db isNil 
		ifTrue: 
			[self shutdown.
			MessageBox 
				errorMsg: 'Source Tracking System cannot connect to repository.

Source Tracking System has been shutdown.'
				caption: 'Cannot open OmniBase database'.
			^nil].
	
	[transaction := db newTransaction.
	methodDictOIDs := IdentityDictionary new: Smalltalk size * 2.
	Smalltalk allClasses do: 
			[:each | 
			self
				createMethodDictionaryFor: each in: transaction;
				createMethodDictionaryFor: each class in: transaction].
	transaction root at: self projectsKey
		ifAbsentPut: 
			["migrate repository to STS version 2.0"
			(transaction root at: self packagesKey) do: 
					[:eachCollection | 
					eachCollection do: [:eachPackageEdition | transaction store: eachPackageEdition].
					transaction markDirty: eachCollection].
			LookupTable new].
	transaction checkpoint.
	(transaction root at: self methodDictionariesKey) 
		associationsDo: [:each | methodDictOIDs at: each key put: (transaction getObjectID: each value)].
	transaction abort] 
			ifCurtailed: 
				[db close.
				db := nil]!

createMethodDictionaryFor: aClassOrSymbol in: transaction 
	| dict |
	dict := transaction root at: self methodDictionariesKey
				ifAbsentPut: [transaction makePersistent: IdentityDictionary new].
	^dict 
		at: (aClassOrSymbol class == Symbol ifTrue: [aClassOrSymbol] ifFalse: [aClassOrSymbol name asSymbol])
		ifAbsentPut: 
			[transaction
				markDirty: dict;
				makePersistent: IdentityDictionary new]!

createNewProjectEditionFrom: aProjectEdition in: projectName 
	"Create a dictionary entry for new project named aString. If there is no object with this
	name already then create an initial opened edition for editing."

	| originalEdition projectEditions |
	self checkIfConnected ifFalse: [^self].
	
	[originalEdition := OmniBase objectAt: aProjectEdition odbObjectID.
	projectEditions := (OmniBase root at: self projectsKey) at: projectName.
	projectEditions
		addFirst: ((StsProjectEdition newPersistent)
					name: projectName;
					previousEdition: originalEdition;
					developer: developer;
					timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds));
					packageEditions: originalEdition packageEditions asOrderedCollection);
		markDirty] 
			evaluateAndCommitIn: db newTransaction!

createNewProjectNamed: aString createInitialOpenEdition: aBoolean 
	"Create a dictionary entry for new project named aString. If there is no object with this
		name already then create an initial opened edition for editing."

	| projectsDict projectEditions newProject |
	self checkIfConnected ifFalse: [^self].
	
	[projectsDict := OmniBase root at: self projectsKey.
	projectEditions := projectsDict at: aString
				ifAbsentPut: 
					[projectsDict markDirty.
					OrderedCollection newPersistent].
	projectEditions isEmpty 
		ifTrue: 
			[projectEditions add: ((newProject := StsProjectEdition newPersistent)
						name: aString;
						developer: developer;
						timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds)))]] 
			evaluateAndCommitIn: db newTransaction.
	^newProject!

createRepositoryOn: aString 
	| transaction odb |
	odb := self databaseClass createOn: aString , '\Repository'.
	
	[transaction := odb newTransaction.
	(transaction root)
		at: self packagesKey put: LookupTable new;
		at: self classesKey put: IdentityDictionary new;
		at: self resourcesKey put: LookupTable new;
		at: self projectsKey put: LookupTable new.
	Smalltalk allClasses do: 
			[:each | 
			self
				createMethodDictionaryFor: each in: transaction;
				createMethodDictionaryFor: each class in: transaction].
	transaction commit] 
			ensure: [odb close]!

databaseClass
	^OmniBase!

databaseConnection
	^db!

disconnectFromDatabase
	db notNil 
		ifTrue: 
			[db close.
			db := nil]!

doesAnyPackageEditionUse: aStsClassEdition 
	| oid t holder |
	oid := aStsClassEdition odbObjectID.
	t := db newTransaction.
	(t root at: self packagesKey) do: 
			[:eachDict | 
			eachDict do: 
					[:eachProxy | 
					(holder := t objectHolderAt: eachProxy odbObjectID) isNil 
						ifFalse: [holder getObject referencesDo: [:eachOID | eachOID = oid ifTrue: [^true]]]]].
	^false!

exportPackageEdition: packageEdition 
	| filename stream fileStream inLen outData outLen contents |
	filename := (FileSaveDialog new)
				caption: 'Exporting ' , packageEdition name , ': Version ' , packageEdition packageVersion;
				fileTypes: #(#('STS XML Export (*.stx)' '*.stx') #('STS zipped XML Export (*.stz)' '*.stz'));
				value: packageEdition name , '.stx';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			packageEdition exportAsXmlOn: stream.
			fileStream := FileStream write: filename.
			contents := stream contents.
			(filename endsWith: '.stz') 
				ifTrue: 
					[inLen := contents size.
					outLen := ByteArray new: 4.
					outLen dwordAtOffset: 0 put: inLen + 20.
					outData := contents class new: inLen + 20.
					ZLibInterface 
						compress: contents
						len: inLen
						out: outData
						len: outLen
						level: ZLibInterface Z_best_compression.
					contents := outData copyFrom: 1 to: (outLen dwordAtOffset: 0)].
			[fileStream nextPutAll: contents] ensure: [fileStream close]]!

exportPackageEditions: editions 
	| filename stream fileStream inLen outData outLen contents |
	filename := (FileSaveDialog new)
				caption: 'Exporting packages...';
				fileTypes: #(#('STS XML Export (*.stx)' '*.stx') #('STS zipped XML Export (*.stz)' '*.stz'));
				showModal.
	filename notNil 
		ifTrue: 
			[| writer |
			stream := WriteStream on: String new.
			stream nextPutAll: '<?xml version="1.0"?>

<stsExport>'.
			writer := StsXmlWriter on: stream.
			editions do: [:each | each basicExportAsXmlOn: writer].
			stream nextPutAll: '
</stsExport>'.
			fileStream := FileStream write: filename.
			contents := stream contents.
			(filename endsWith: '.stz') 
				ifTrue: 
					[inLen := contents size.
					outLen := ByteArray new: 4.
					outLen dwordAtOffset: 0 put: inLen + 20.
					outData := contents class new: inLen + 20.
					ZLibInterface 
						compress: contents
						len: inLen
						out: outData
						len: outLen
						level: ZLibInterface Z_best_compression.
					contents := outData copyFrom: 1 to: (outLen dwordAtOffset: 0)].
			[fileStream nextPutAll: contents] ensure: [fileStream close]]!

exportProjectEdition: projectEdition 
	| filename |
	filename := (FileSaveDialog new)
				caption: 'Exporting ' , projectEdition name , ': Version ' , projectEdition versionDescriptor;
				fileTypes: self projectEditionFileTypes;
				value: (self toFilenameString: projectEdition name , ' ' , projectEdition versionDescriptor) 
							, '.stp';
				showModal.
	filename notNil 
		ifTrue: 
			[(filename asUppercase endsWith: '.STP') 
				ifTrue: [self exportProjectEditionNewFormat: projectEdition toFileNamed: filename]
				ifFalse: [self exportProjectEditionOldFormat: projectEdition toFileNamed: filename]]!

exportProjectEditionNewFormat: projectEdition toFileNamed: filename 
	"This method will export project edition in new format where each package edition is compressed separately.
	This way project edition import is much faster because only package editions which are not already in repository are decompressed and XML-parsed."

	| stream fileStream contents progressDialog tick packageEditionOIDs transaction |
	tick := 100 / (projectEdition packageEditions size + 1).
	progressDialog := ProgressDialog operation: 
					[:progress | 
					stream := WriteStream on: String new.
					projectEdition exportHeaderAsXmlOn: stream.
					fileStream := FileStream write: filename text: false.
					
					[contents := stream contents asByteArray.
					"write project edition header first, then followed by EOF"
					fileStream
						nextPutAll: self projectExportHeaderString asByteArray;
						nextPutAll: ((ByteArray new: 4)
									odbLongAt: 1 put: contents size;
									yourself);
						nextPutAll: contents.
					progressDialog caption: 'Exporting Project Edition: ' , projectEdition name , ' ' 
								, projectEdition versionDescriptor.
					progress value: tick.
					packageEditionOIDs := OrderedCollection new.
					projectEdition packageEditions 
						do: [:eachPackageEdition | packageEditionOIDs add: eachPackageEdition odbGetOID].
					packageEditionOIDs do: 
							[:eachOID | 
							| eachPackageEdition |
							transaction := db newTransaction.
							eachPackageEdition := transaction objectAt: eachOID.
							stream := WriteStream on: String new.
							Cursor wait showWhile: 
									[progressDialog caption: 'Exporting Package Edition: ' , eachPackageEdition name , ' ' 
												, eachPackageEdition versionDescriptor.
									eachPackageEdition exportAsXmlOn: stream.
									transaction abort.
									contents := self compressToByteArray: stream contents.
									fileStream
										nextPutAll: ((ByteArray new: 4)
													odbLongAt: 1 put: contents size;
													yourself);
										nextPutAll: contents].
							progress value: progress progress + tick.
							progressDialog caption: 'Exporting Project Edition: ' , projectEdition name , ' ' 
										, projectEdition versionDescriptor]] 
							ensure: [fileStream close]].
	progressDialog
		caption: 'Please wait';
		showModal!

exportProjectEditionOldFormat: projectEdition toFileNamed: filename 
	| stream fileStream contents |
	stream := WriteStream on: String new.
	projectEdition exportAsXmlOn: stream.
	fileStream := FileStream write: filename text: false.
	contents := stream contents.
	(filename asUppercase endsWith: '.PEZ') ifTrue: [contents := self compressToByteArray: contents].
	[fileStream nextPutAll: contents asByteArray] ensure: [fileStream close]!

findExistingPackage: aPackageEdition in: anOrderedCollection 
	^anOrderedCollection detect: 
			[:each | 
			each versionDescriptor = aPackageEdition version 
				and: [each developer = aPackageEdition developer and: [each timestamp = aPackageEdition timestamp]]]
		ifNone: []!

findExistingPackageEdition: packageName versionDescriptor: packageVersion developer: packageDeveloper timestamp: timestamp 
	"Metoda poisce obstojeci package edition pri verzioniranju projekta.
	Ce ima ze obstojeci edition v repositoriju enake podatke, potem se XML sploh ne parsa niti se package ne importira."

	| transaction editions dict existingPackageEdition |
	transaction := db newTransaction.
	dict := transaction root at: self packagesKey.
	editions := dict at: packageName ifAbsent: [^nil].
	existingPackageEdition := editions detect: 
					[:each | 
					each versionDescriptor = packageVersion 
						and: [each developer = packageDeveloper and: [each timestamp = timestamp]]]
				ifNone: [^nil].
	^transaction getObjectID: existingPackageEdition!

findExistingProjectEdition: projectName versionDescriptor: versionDescriptor developer: projectDeveloper timestamp: timestamp 
	"Find existing project edition when versioning projects.
	If there already exists a project edition with identical version data, then do not import XML and do not import packages.
	Answer object ID of the existing edition, or <nil> if none."

	| transaction editions dict existingProjectEdition |
	transaction := db newTransaction.
	dict := transaction root at: self projectsKey.
	editions := dict at: projectName ifAbsent: [^nil].
	existingProjectEdition := editions detect: 
					[:each | 
					each projectVersion = versionDescriptor 
						and: [each developer = projectDeveloper and: [each timestamp = timestamp]]]
				ifNone: [^nil].
	^transaction getObjectID: existingProjectEdition!

findMethodEditionFor: aCompiledMethod 
	| dict |
	(dict := self getMethodDictionaryFor: aCompiledMethod methodClass in: db newTransaction) isNil 
		ifTrue: [^nil].
	^(dict at: aCompiledMethod selector ifAbsent: [^nil]) 
		detect: [:each | each correspondsTo: aCompiledMethod]
		ifNone: []!

findOrCreateClassEditionFor: aClass in: transaction 
	| oid edition |
	(aClass isChanged or: [(oid := self getClassEditionOIDforLoadedClass: aClass) isNil]) 
		ifFalse: 
			[(edition := transaction objectAt: oid) isNil 
				ifFalse: [edition realClass == aClass ifTrue: [^edition]]].
	^self findOrCreateClassEditionForInRepository: aClass in: transaction!

findOrCreateClassEditionForInRepository: aClass in: transaction 
	| classesDict editions edition instanceMethods instanceMethodsOIDs classMethods classMethodsOIDs |
	classesDict := transaction root at: self classesKey.
	editions := (classesDict at: aClass name
				ifAbsentPut: 
					[transaction
						markDirty: classesDict;
						makePersistent: OrderedCollection new]) 
					odbResolve.
	instanceMethods := self getMethodEditionsFor: aClass in: transaction.
	classMethods := self getMethodEditionsFor: aClass metaClass in: transaction.
	((instanceMethodsOIDs := self collectOIDsFrom: instanceMethods in: transaction) isNil 
		or: [(classMethodsOIDs := self collectOIDsFrom: classMethods in: transaction) isNil]) 
			ifFalse: 
				[editions do: 
						[:each | 
						(each definition = aClass definition and: 
								[each classDefinition = aClass metaClass definition and: 
										[each guid = aClass guid and: 
												[each comment = aClass comment and: 
														[(self 
															compareObjectIDsOf: each methods
															with: instanceMethodsOIDs
															in: transaction) and: 
																	[self 
																		compareObjectIDsOf: each classMethods
																		with: classMethodsOIDs
																		in: transaction]]]]]) 
							ifTrue: [^each]	"edition equal to the one currently loaded was found in the repository"]].
	"no edition was found so new class edition will be created"
	transaction markDirty: editions.
	edition := editions 
				addFirst: (transaction makePersistent: ((StsClassEdition new)
								developer: developer;
								timestamp: (transaction isReadOnly 
											ifFalse: [TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds)]);
								name: aClass name;
								guid: aClass guid;
								definition: aClass definition;
								classDefinition: aClass metaClass definition;
								comment: aClass comment;
								methods: instanceMethods asArray;
								classMethods: classMethods asArray)).
	transaction isReadOnly 
		ifFalse: 
			[(aClass isKindOf: StsBehaviorProxy) 
				ifTrue: 
					[aClass timestamp isNil ifFalse: [edition timestamp: aClass timestamp].
					aClass developer isNil ifFalse: [edition developer: aClass developer]]].
	^edition!

findOrCreateMethodEditionFor: aCompiledMethod methodDictionary: dict in: transaction 
	| editions edition source privacy categoriesString |
	editions := dict at: aCompiledMethod selector
				ifAbsentPut: 
					[transaction
						markDirty: dict;
						makePersistent: OrderedCollection new].
	source := aCompiledMethod getSource.
	privacy := aCompiledMethod isPrivate.
	categoriesString := StsMethodEdition categoriesStringFor: aCompiledMethod.
	(edition := editions detect: 
					[:each | 
					each 
						correspondsTo: source
						privacy: privacy
						categories: categoriesString]
				ifNone: []) isNil 
		ifTrue: 
			["add only if there is really no such method"
			edition := (StsMethodEdition new)
						methodClass: aCompiledMethod methodClass;
						selector: aCompiledMethod selector;
						timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds));
						source: source;
						developer: developer;
						isPrivate: privacy;
						categoriesString: categoriesString.
			aCompiledMethod class == StsCompiledMethodProxy 
				ifTrue: 
					[aCompiledMethod timestamp isNil ifFalse: [edition timestamp: aCompiledMethod timestamp].
					aCompiledMethod developer isNil ifFalse: [edition developer: aCompiledMethod developer]].
			editions addFirst: edition.
			transaction
				makePersistent: edition;
				markDirty: editions].
	^edition!

findProjectEditionForPreviousVersionData: previousVersionData projectName: defaultProjectName 
	| nameEditionsDict projectName previousEdition editions |
	nameEditionsDict := LookupTable new.
	previousVersionData do: 
			[:each | 
			projectName := each isString ifTrue: [defaultProjectName] ifFalse: [each at: #name].
			editions := nameEditionsDict at: projectName ifAbsentPut: [self getProjectEditionsFor: projectName].
			each isString 
				ifTrue: 
					["old XML format, only version description without timestamp and developer is given"
					previousEdition := editions detect: [:eachEdition | eachEdition versionDescriptor = each] ifNone: []]
				ifFalse: 
					["new format, check developer, timestamp and version descriptor"
					editions do: 
							[:eachEdition | 
							(eachEdition versionDescriptor = (each at: #versionDescriptor ifAbsent: []) and: 
									[eachEdition developer = (each at: #developer ifAbsent: []) 
										and: [eachEdition timestamp = (each at: #timestamp ifAbsent: [])]]) 
								ifTrue: 
									["first match is the right one"
									^eachEdition]]]].
	^previousEdition!

getAllMethodEditionsFor: aClass from: fromDate until: toDate 
	| transaction dict coll |
	transaction := db newLongReadOnlyTransaction.
	coll := OrderedCollection new.
	(dict := self getMethodDictionaryFor: aClass in: transaction) isNil 
		ifFalse: 
			[dict do: 
					[:eachCollection | 
					eachCollection do: 
							[:eachMethodEdition | 
							(eachMethodEdition timestamp isKindOf: TimeStamp) 
								ifTrue: 
									[((fromDate isNil or: [eachMethodEdition timestamp date >= fromDate]) 
										and: [toDate isNil or: [eachMethodEdition timestamp date <= toDate]]) 
											ifTrue: [coll add: eachMethodEdition]]]]].
	^coll!

getAllPackageNames
	^(db newLongReadOnlyTransaction root at: self packagesKey) keys asSortedCollection!

getAllProjectNames
	^(db newLongReadOnlyTransaction root at: self projectsKey) keys asSortedCollection!

getAvailableMethodsFor: aClass 
	| transaction dict |
	transaction := db newLongReadOnlyTransaction.
	(dict := self getMethodDictionaryFor: aClass in: transaction) isNil ifTrue: [^Array new].
	^(dict keys reject: [:each | aClass includesSelector: each]) asSortedCollection!

getChangeNodeOwningPackageFor: packageEdition 
	^Package manager packageNamed: packageEdition name ifNone: [packageEdition name]!

getClassEditionOIDforLoadedClass: aClass 
	(aClass isKindOf: StsImportProxy) ifTrue: [^nil].
	^classEditions isNil ifFalse: [classEditions at: aClass name ifAbsent: []]!

getClassEditions: aSymbol 
	^(db newLongReadOnlyTransaction root at: self classesKey) at: aSymbol
		ifAbsent: [OrderedCollection new]!

getClassEditions: aSymbol in: transaction 
	^((transaction root at: self classesKey) at: aSymbol ifAbsent: [^OrderedCollection new]) 
		collect: [:each | each odbResolve]!

getCurrentDeveloper
	^developer!

getLatestPackageEditionFor: packageName 
	| editions |
	editions := self getPackageEditionsFor: packageName.
	^editions notEmpty ifTrue: [editions first]!

getLoadedPackageFor: packageName 
	| transaction dict editions |
	transaction := db newLongReadOnlyTransaction.
	dict := transaction root at: self packagesKey.
	editions := dict at: packageName ifAbsentPut: [nil].
	editions isNil 
		ifFalse: 
			[^editions detect: [:eachExistingEdition | eachExistingEdition isLoadedOrChangedAfterLoad] ifNone: []].
	^nil!

getLoadedPackageIdentifiersFor: aPackageOrPackageEdition 
	^packageEditions isNil ifFalse: [packageEditions at: aPackageOrPackageEdition name ifAbsent: []]!

getMethodDictionaryFor: aClassOrSymbol in: transaction 
	^transaction objectAt: (methodDictOIDs 
				at: (aClassOrSymbol class == Symbol ifTrue: [aClassOrSymbol] ifFalse: [aClassOrSymbol name asSymbol])
				ifAbsent: [^nil])!

getMethodEditionFor: aCompiledMethod in: transaction 
	| dict |
	(dict := self getMethodDictionaryFor: aCompiledMethod methodClass in: transaction) isNil 
		ifTrue: [dict := self createMethodDictionaryFor: aCompiledMethod methodClass in: transaction].
	^self 
		findOrCreateMethodEditionFor: aCompiledMethod
		methodDictionary: dict
		in: transaction!

getMethodEditions: selector class: aClassOrSymbol 
	| transaction dict |
	transaction := db newLongReadOnlyTransaction.
	^(dict := self getMethodDictionaryFor: aClassOrSymbol in: transaction) isNil 
		ifTrue: [#()]
		ifFalse: [dict at: selector ifAbsent: [#()]]!

getMethodEditionsFor: aClass in: transaction 
	"Private - Answer array of method editions from repository that
		represent current methods of aClass which is currently loaded."

	| methodDictionary editions |
	(methodDictionary := self getMethodDictionaryFor: aClass in: transaction) isNil 
		ifTrue: [methodDictionary := self createMethodDictionaryFor: aClass in: transaction].
	editions := OrderedCollection new.
	(aClass methodDictionary associations 
		asSortedCollection: [:a :b | self byteCompare: a key with: b key]) do: 
				[:each | 
				(Package manager isLooseMethod: each value) 
					ifFalse: 
						[editions add: (self 
									findOrCreateMethodEditionFor: each value
									methodDictionary: methodDictionary
									in: transaction)]].
	^editions!

getPackageEditionsFor: packageName 
	^(db newLongReadOnlyTransaction root at: self packagesKey) at: packageName
		ifAbsent: [OrderedCollection new]!

getProjectEditionsFor: projectName 
	"Answer project editions for project named <aString>"

	| coll |
	coll := (db newLongReadOnlyTransaction root at: self projectsKey) at: projectName
				ifAbsent: [OrderedCollection new].
	coll do: [:each | each odbResolve].
	^coll!

getProjectOrPackageFor: projectOrPackageEdition 
	| coll omniKey |
	(omniKey := (projectOrPackageEdition isKindOf: StsProjectEdition) 
				ifTrue: [self projectsKey]
				ifFalse: [(projectOrPackageEdition isKindOf: StsPackageEdition) ifTrue: [self packagesKey]]) isNil 
		ifTrue: [^nil].
	((coll := OmniBase root at: omniKey ifAbsent: []) notNil 
		and: [(coll := coll at: projectOrPackageEdition name ifAbsent: []) notNil]) 
			ifTrue: 
				[^coll detect: 
						[:eachPersistent | 
						eachPersistent developer = projectOrPackageEdition developer and: 
								[eachPersistent timestamp = projectOrPackageEdition timestamp and: 
										[eachPersistent comment = projectOrPackageEdition comment 
											and: [eachPersistent versionDescriptor = projectOrPackageEdition versionDescriptor]]]]
					ifNone: []].
	^nil!

getRepositoryPath
	^repositoryPath!

getResourceEditionFor: aResourceIdentifier in: transaction 
	| edition |
	edition := (StsResourceEdition new)
				developer: developer;
				timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds));
				name: aResourceIdentifier name;
				className: aResourceIdentifier owningClass name;
				resource: (transaction makePersistent: aResourceIdentifier resource).
	aResourceIdentifier class == StsDolphinResourceProxy 
		ifTrue: 
			[aResourceIdentifier developer isNil ifFalse: [edition developer: aResourceIdentifier developer].
			aResourceIdentifier timestamp isNil ifFalse: [edition timestamp: aResourceIdentifier timestamp]].
	transaction makePersistent: edition.
	^edition!

getStoredChangeSets
	^self isConnected 
		ifFalse: [#()]
		ifTrue: [db newLongReadOnlyTransaction root at: self changeSetsKey ifAbsent: [#()]]!

getVersionInfoFor: aCompiledMethod 
	| edition |
	^(db notNil and: [(edition := self findMethodEditionFor: aCompiledMethod) notNil]) 
		ifTrue: [StsMethodVersionNotification new edition: edition]!

ignoreCompilerWhile: aBlock 
	ignoreCompilerEventsFlag := true.
	^aBlock ensure: [ignoreCompilerEventsFlag := false]!

importFromSqueakFileOut
	| pathname coll changes comment blessing |
	(pathname := (FileOpenDialog new)
				fileTypes: (Array with: #('Squeak Change Set (*.st)' '*.st') with: FileDialog allFilesType);
				caption: 'Import Change Set from Squeak File Out';
				showModal) isNil 
		ifTrue: [^nil].
	Cursor wait showWhile: [changes := StsSqueakChangeSetProxy new loadFrom: pathname].
	changes isEmpty ifTrue: [^MessageBox notify: 'No changes parsed from selected file.'].
	comment := Prompter 
				on: ''
				prompt: 'Please enter comment/description:'
				caption: 'Importing Change Set from Squeak file out'.
	(blessing := ChoicePrompter choices: StsEdition possibleBlessingLevels
				caption: 'Select blessing level') isNil 
		ifTrue: [^nil].
	
	[coll := OmniBase currentTransaction root at: self changeSetsKey ifAbsentPut: [OrderedCollection new].
	coll
		add: ((StsChangeSet newPersistent)
					timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds));
					developer: developer;
					comment: (comment ifNil: ['']);
					browserTitle: 'Change Set from Squeak file out';
					changeNodes: changes;
					blessing: blessing;
					yourself);
		markDirty] 
			evaluateAndCommitIn: self databaseConnection newTransaction!

importPackage
	"Request the file name of the existing package to import into repository,
	then import the package into repository without loading it into the image.
	Answer imported package name[String] or <nil> if nothing was done. "

	| pathname package importInformation currentDeveloper packageImporter fileTypes |
	currentDeveloper := developer.
	fileTypes := (OrderedCollection new)
				add: #('Dolphin Package (*.pac)' '*.pac');
				add: #('STS export (*.stx)' '*.stx');
				add: #('STS compressed export (*.stz)' '*.stz');
				add: #('VisualWorks 5i.x/7 Parcel (*.pst)' '*.pst');
				add: #('IBM VAST Application file-out (*.app)' '*.app');
				add: #('SqueakMap/Monticello (*.mcz)' '*.mcz');
				add: #('Squeak package file-out (*.st)' '*.st');
				yourself.
	(pathname := (FileOpenDialog new)
				fileTypes: fileTypes;
				caption: 'Import Package into STS Repository';
				showModal) isNil 
		ifTrue: [^nil].
	packageImporter := self importPackageObjectFor: pathname.
	
	[Cursor wait showWhile: [package := packageImporter loadFrom: pathname].
	package isNil ifTrue: [^nil].
	(importInformation := (StsImportInformationDialog 
				createOn: (StsImportInformationModel package: package))
				caption: 'Importing package ' , package name;
				showModal) isNil 
		ifTrue: [^nil].
	developer := importInformation developer.
	self 
		basicVersionPackage: package
		versionDescriptor: importInformation version
		previousEdition: importInformation previousEdition
		blessing: importInformation blessing
		comment: (importInformation comment isNilOrEmpty 
				ifTrue: [package comment]
				ifFalse: [importInformation comment])
		versionComment: importInformation versionComment
		checkExisting: true
		silentBool: false] 
			ensure: [developer := currentDeveloper].
	^package name!

importPackageObjectFor: pathname 
	"Private - answer package importer object for given file name."

	| extension |
	extension := File splitExtensionFrom: pathname.
	(extension sameAs: 'st') ifTrue: [^StsSqueakPackageProxy new].
	(extension sameAs: 'mcz') ifTrue: [^StsSqueakMonticelloPackageImporter new].
	(extension sameAs: 'app') ifTrue: [^StsVastPackageProxy new].
	(extension sameAs: 'pst') ifTrue: [^StsVisualWorksParcelPackageProxy new].
	(extension sameAs: 'pac') ifTrue: [^StsDolphinPackageProxy].
	^StsXMLPackageProxy new!

importProject
	"Request the file name of an existing project to import into repository,
	then import the project into repository without loading it first.
	Answer imported project name[String] or <nil> if nothing was done. "

	| pathname |
	(pathname := (FileOpenDialog new)
				fileTypes: self projectEditionFileTypes;
				caption: 'Import Project Edition into STS Repository';
				showModal) isNil 
		ifTrue: [^nil].
	^(pathname asUppercase endsWith: '.STP') 
		ifTrue: [self importProjectNewFormatFrom: pathname]
		ifFalse: [self importProjectOldFormatFrom: pathname]!

importProjectNewFormatFrom: pathname 
	"Private - Request the file name of an existing project to import into repository,
	then import the project into repository without loading it first.
	Answer imported project name[String] or <nil> if nothing was done. "

	| project fileStream doc nextLen packageEditionsOIDs oid progressDialog packageIndex packageProxy atLeastOnePackage |
	atLeastOnePackage := false.
	fileStream := FileStream read: pathname text: false.
	
	[Cursor wait showWhile: 
			[fileStream skip: self projectExportHeaderString size.
			nextLen := (fileStream next: 4) odbLongAt: 1.
			doc := XMLDOMParser parseDocumentFrom: (ReadStream on: (fileStream next: nextLen) asString).
			project := StsProjectProxy new basicImportHeaderFromDocument: doc].
	project isNil 
		ifTrue: 
			[^MessageBox errorMsg: 'Can not read file with exported project edition. Bad file format.'
				caption: 'Importing project from file'].
	packageIndex := 0.
	progressDialog := ProgressDialog operation: 
					[:progress | 
					progressDialog caption: 'Importing Project Edition: ' , project name , ' ' , project projectVersion.
					packageIndex := packageIndex + 1.
					progress value: 100 * packageIndex / (project packages size + 1).
					packageEditionsOIDs := OrderedCollection new.
					project packages do: 
							[:eachPackageEdition | 
							oid := self 
										findExistingPackageEdition: eachPackageEdition name
										versionDescriptor: eachPackageEdition packageVersion
										developer: eachPackageEdition developer
										timestamp: eachPackageEdition timestamp.
							nextLen := (fileStream next: 4) odbLongAt: 1.
							oid isNil 
								ifFalse: [fileStream skip: nextLen]
								ifTrue: 
									[| decompressedString |
									decompressedString := nil.
									
									[decompressedString := ZLibInterface decompress: (fileStream next: nextLen)
												resultCollectionClass: String] 
											on: Error
											do: 
												[:ex | 
												Transcript
													nextPutAll: 'ERROR unzipping package ' , eachPackageEdition name , '(' , ex displayString 
																, '). Package will be skipped.';
													cr].
									decompressedString isNil 
										ifFalse: 
											[doc := XMLDOMParser parseDocumentFrom: (ReadStream on: decompressedString).
											packageProxy := StsXMLPackageProxy new basicImportFrom: doc topElement.
											Transcript
												nextPutAll: 'Versioning imported package ' , eachPackageEdition name , ' version ' 
															, packageProxy version;
												cr.
											oid := self 
														basicVersionPackage: packageProxy
														versionDescriptor: packageProxy version
														previousEdition: nil
														blessing: packageProxy blessing
														comment: packageProxy comment
														versionComment: packageProxy versionComment
														checkExisting: false
														silentBool: false.
											atLeastOnePackage := true]].
							packageEditionsOIDs add: oid].
					((packageEditionsOIDs allSatisfy: [:each | each notNil]) and: 
							[atLeastOnePackage or: 
									[(self 
										findExistingProjectEdition: project name
										versionDescriptor: project projectVersion
										developer: project developer
										timestamp: project timestamp) isNil]]) 
						ifTrue: 
							[self 
								basicVersionProject: project
								versionDescriptor: project projectVersion
								previousEdition: (self findProjectEditionForPreviousVersionData: project previousVersionsData
										projectName: project name)
								blessing: project blessing
								comment: project comment
								versionComment: project versionComment
								packageEditionOIDs: packageEditionsOIDs
								progress: progress
								tick: (Array with: 100 with: 100)
								timestamp: project timestamp
								developer: project developer]].
	progressDialog
		caption: 'Please wait';
		showModal] 
			ensure: [fileStream close].
	^project name!

importProjectOldFormatFrom: pathname 
	| project currentDeveloper |
	currentDeveloper := developer.
	
	[Cursor wait showWhile: [project := StsProjectProxy new loadFrom: pathname].
	project isNil ifTrue: [^nil].
	developer := project developer.
	self basicVersionProject: project
		previousEdition: (self findProjectEditionForPreviousVersionData: project previousVersionsData
				projectName: project name)] 
			ensure: [developer := currentDeveloper].
	^project name!

incrementOne: aString 
	| lastWasDigit from to number replacement |
	lastWasDigit := false.
	aString keysAndValuesDo: 
			[:i :ch | 
			| isDigit |
			isDigit := ch isDigit.
			isDigit 
				ifTrue: 
					[lastWasDigit ifFalse: [from := i].
					to := i].
			lastWasDigit := isDigit].
	from isNil ifTrue: [^aString copy].
	number := Integer fromString: (aString copyFrom: from to: to).
	number := number + 1.
	replacement := '%0*d' sprintfWith: to - from + 1 with: number.
	^aString 
		copyReplaceFrom: from
		to: to
		with: replacement!

install
	| path odb exists newDeveloper dict originalDeveloper |
	
	[path := self chooseRepository.
	path isNil 
		ifTrue: 
			[^MessageBox 
				notify: 'Source Tracking System repository connection was aborted.
Please read the STS package comment to learn more on how to 
create new repository or connect to an existing repository.'].
	exists := false.
	
	[odb := self databaseClass openOn: path , '\Repository'.
	odb close.
	exists := true] on: Error
			do: [:ex | ].
	exists ifTrue: [self startUpOn: path].
	exists or: [MessageBox confirm: 'Repository does not exist. Do you want to create new repository?']] 
			whileFalse: [].
	exists 
		ifFalse: 
			[Cursor wait showWhile: 
					[self
						createRepositoryOn: path;
						startUpOn: path].
			(MessageBox 
				confirm: 'Do you want to add all loaded packages to newly created repository?

This is recommended if you are installing STS for the first time or 
if you are upgrading from a previous version of Dolphin Smalltalk on the same repository.') 
					ifTrue: 
						[originalDeveloper := developer.
						Package manager packages do: 
								[:each | 
								(self objectArtsPackageNames includes: each name) 
									ifTrue: 
										[developer := 'Object Arts Ltd.'.
										each packageVersion: SessionManager current imageVersion].
								(self refactoryPackageNames includes: each name) ifTrue: [developer := 'John Brant & Don Roberts'].
								(self stsPackageNames includes: each name) ifTrue: [developer := 'David Gorisek'].
								self 
									basicVersionPackage: each
									versionDescriptor: (each packageVersion notEmpty ifTrue: [each packageVersion] ifFalse: ['0.001'])
									previousEdition: nil
									versionComment: 'Initial package version upon STS installation.'
									checkExisting: false
									silentBool: false.
								developer := originalDeveloper]]].
	"check if this user@machine already used this STS repository, if yes, take the last name as default"
	originalDeveloper := developer.
	
	[(dict := OmniBase root at: 'sts.developerNameMap' ifAbsent: []) isNil 
		ifFalse: [developer := dict at: originalDeveloper ifAbsent: [developer]]] 
			evaluateIn: db newReadOnlyTransaction.
	newDeveloper := Prompter 
				on: developer
				prompt: 'Please enter the name of developer using Dolphin'
				caption: 'Set current STS developer name'.
	(newDeveloper isNil or: [newDeveloper = developer]) 
		ifFalse: 
			["save developer name mapping at username@machine for the next time"
			
			[(OmniBase root at: 'sts.developerNameMap' ifAbsentPut: [LookupTable newPersistent]) 
				at: originalDeveloper
				put: newDeveloper] 
					evaluateAndCommitIn: db newTransaction.
			developer := newDeveloper]!

isConnected
	^db notNil!

markClassAsChanged: aClass 
	((aClass isKindOf: StsImportProxy) or: [aClass isNil]) 
		ifFalse: 
			[classEditions isNil ifFalse: [classEditions removeKey: aClass instanceClass name ifAbsent: []]]!

markPackageAsChanged: aPackage 
	| a |
	aPackage isNil 
		ifFalse: 
			[((a := self getLoadedPackageIdentifiersFor: aPackage) isNil or: [a size < 4]) 
				ifFalse: [a at: 4 put: true]]!

methodDictionariesKey
	"Private - Answers root dictionary key at which 
		an identity dictionary of method dictionaries is stored."

	^'sts.methodDictionaries'!

notifyImageSameAsPackageEdition: aPackageEdition 
	| okToMark isMarkedAsLoaded |
	isMarkedAsLoaded := (self getLoadedPackageIdentifiersFor: aPackageEdition) notNil.
	isMarkedAsLoaded 
		ifTrue: 
			[^MessageBox 
				notify: ('No changes were found between the "<2d>" package in the image and edition <1d> in the repository.' 
						expandMacrosWith: aPackageEdition versionDescriptor
						with: aPackageEdition name)
				caption: 'No Changes Found'].
	okToMark := MessageBox 
				confirm: ('No changes were found between the "<2d>" package in the image and edition <1d> in the repository. They appear to be identical.

Would you like to mark this edition as being the one that is currently loaded (Recommended)?' 
						expandMacrosWith: aPackageEdition versionDescriptor
						with: aPackageEdition name)
				caption: 'No Changes Found'.
	okToMark ifFalse: [^self].
	self setLoadedPackageIdentifiersFor: aPackageEdition to: aPackageEdition identifiers!

objectArtsPackageNames

	^#(
'ActiveX (Deprecated)'
'ActiveX Automation'
'ActiveX Automation Development'
'ActiveX Categories'
'ActiveX Connection Points'
'ActiveX Control Hosting'
'ActiveX DLL Server Kit'
'ActiveX Property Bags'
'ActiveX Scripting'
'ADODB'
'AgentObjects'
'Animals'
'Application Deployment Kit'
'Autoplay'
'AvatarChat'
'Bouncing Balls'
'Calculator'
'Calculator (Console)'
'Catenate'
'CDO'
'Chat'
'ColorPickerApplet'
'COM Random Stream'
'Database Connection'
'Database Connection (Deprecated)'
'Database Connection Base'
'Debug Trace Stream'
'Development System'
'Dolphin'
'Dolphin Base (Deprecated)'
'Dolphin Collection Presenters'
'Dolphin Common Controls'
'Dolphin Control Bars'
'Dolphin Folder Presenter'
'Dolphin IDE Extension Example'
'Dolphin MoenTree View'
'Dolphin MVP (Deprecated)'
'Dolphin MVP Base'
'Dolphin Refactoring Browser'
'Dolphin Registry Access'
'Dolphin Tree List Presenter'
'Dolphin Tree Models'
'Dolphin Type Converters'
'Dolphin Value Models'
'DolphinSure'
'DolphinSure UI'
'EnumRECT'
'Etch-a-Sketch'
'Hello World'
'Hello World (Console)'
'Hello World Applet'
'Internet Explorer'
'Lagoon Image Stripper'
'Masked Edit'
'Month View'
'Notepad'
'OA SUnit Extensions'
'OLE COM'
'OLE Font'
'OLE Persistence Base'
'OLE Picture'
'OLE Structured Storage'
'PersonalMoney'
'Playground'
'Product Protection'
'Protected Scribble'
'RBParser'
'RegEdit'
'Scribble'
'Simple Web Browser'
'SlidingBallDemo'
'Smalltalk Parser'
'Sockets Connection'
'Standard Edition Tools'
'Value Edition Tools'
'Video Library'
'Web Deployment Kit'
'Web Plugin Builder'
'Windows Shell'
'XML DOM'
)!

onAboutToSave: aPackage 
	"TO DO: prompt here to version aPackage ..."

	!

onClassRepackaged: aClass from: p1 to: p2 
	p1 == p2 
		ifFalse: 
			[self
				markClassAsChanged: aClass;
				markPackageAsChanged: p1;
				markPackageAsChanged: p2]!

onGlobalRepackaged: aGlobal from: p1 to: p2 
	p1 == p2 
		ifFalse: 
			[self
				markPackageAsChanged: p1;
				markPackageAsChanged: p2]!

onLoadedPackagesChanged
	| packagesNamesRemoved |
	packageEditions isNil ifTrue: [^self].
	packagesNamesRemoved := packageEditions keys difference: Package manager packageNames.
	packageEditions removeAllKeys: packagesNamesRemoved!

onMethodRepackaged: aMethod from: p1 to: p2 
	(p1 == p2 or: [ignoreCompilerEventsFlag == true]) 
		ifFalse: 
			[self
				markClassAsChanged: aMethod methodClass;
				markPackageAsChanged: p1;
				markPackageAsChanged: p2]!

onPackageChanged: aPackage 
	self markPackageAsChanged: aPackage!

onResourceRepackaged: aResource from: p1 to: p2 
	p1 == p2 
		ifFalse: 
			[self
				markPackageAsChanged: p1;
				markPackageAsChanged: p2]!

onSystemClassAdded: aClass 
	| transaction instanceDict classDict |
	transaction := db newTransaction.
	
	[instanceDict := self createMethodDictionaryFor: aClass in: transaction.
	classDict := self createMethodDictionaryFor: aClass class in: transaction.
	transaction checkpoint.
	methodDictOIDs
		at: aClass name asSymbol put: (transaction getObjectID: instanceDict);
		at: aClass class name asSymbol put: (transaction getObjectID: classDict)] 
			ensure: [transaction abort].
	self
		markClassAsChanged: aClass;
		markPackageAsChanged: aClass owningPackage!

onSystemClassUpdated: aClass 
	self
		markClassAsChanged: aClass;
		markPackageAsChanged: aClass owningPackage!

onSystemGlobalRemoved: aVariableBinding 
	(aVariableBinding value isKindOf: Class) 
		ifTrue: 
			[self
				markClassAsChanged: aVariableBinding value;
				markPackageAsChanged: aVariableBinding value owningPackage]!

onSystemGlobalRenamed: newNameAndGlobal from: oldName 
	| global newName transaction |
	global := newNameAndGlobal value.
	newName := newNameAndGlobal key.
	(global isKindOf: Class) 
		ifTrue: 
			[Cursor wait showWhile: 
					[classEditions isNil 
						ifFalse: 
							[classEditions
								at: newName put: nil;
								removeKey: oldName ifAbsent: []].
					self onSystemClassAdded: global.
					transaction := db newTransaction.
					
					[global methodDictionary do: [:each | self getMethodEditionFor: each in: transaction].
					global class methodDictionary do: [:each | self getMethodEditionFor: each in: transaction].
					transaction commit] 
							ifCurtailed: [transaction abort]].
			global allSubclasses do: [:eachSubclass | self onSystemClassUpdated: eachSubclass].
			self markPackageAsChanged: global owningPackage]!

onSystemMethodCompiled: aCompilationResult 
	self onSystemMethodUpdated: aCompilationResult method!

onSystemMethodRemoved: aCompiledMethod 
	ignoreCompilerEventsFlag ifTrue: [^self].
	self
		markClassAsChanged: aCompiledMethod methodClass;
		markPackageAsChanged: aCompiledMethod owningPackage!

onSystemMethodUpdated: aCompiledMethod 
	| transaction |
	ignoreCompilerEventsFlag ifTrue: [^self].
	aCompiledMethod isLoose ifFalse: [self markClassAsChanged: aCompiledMethod methodClass].
	self markPackageAsChanged: aCompiledMethod owningPackage.
	globalTransaction isNil ifFalse: [^self getMethodEditionFor: aCompiledMethod in: globalTransaction].
	transaction := db newTransaction.
	
	[self getMethodEditionFor: aCompiledMethod in: transaction.
	transaction commit] 
			ifCurtailed: [transaction abort]!

packageNames: packageNames usingMethodEdition: methodEdition 
	| col |
	col := OrderedCollection new.
	packageNames do: 
			[:pkgName | 
			(self getPackageEditionsFor: pkgName) do: 
					[:pkgEdition | 
					pkgEdition classes do: 
							[:clsEdition | 
							clsEdition methods , clsEdition classMethods do: 
									[:mthdEdition | 
									mthdEdition = methodEdition 
										ifTrue: 
											[col add: (Array 
														with: pkgEdition
														with: clsEdition
														with: mthdEdition)]]]]].
	^col!

packagesKey
	"Private - Answers root dictionary key at which 
		a dictionary of package editions collections is stored."

	^'sts.packages'!

projectEditionFileTypes
	^#(#('Project edition compressed XML Export (*.stp)' '*.stp') #('Project edition XML Export (*.pex)' '*.pex') #('Project edition zipped XML Export (*.pez)' '*.pez'))!

projectExportHeaderString
	^'STS-ProjectEditionCompressedXmlExport3.2'!

projectsKey
	"Private - Answers root dictionary key at which 
		a dictionary of project editions collections is stored."

	^'sts.projects'!

purgePackage: packageName 
	| transaction dict editions |
	transaction := db newTransaction.
	
	[dict := transaction root at: self packagesKey.
	editions := dict at: packageName ifAbsent: [self error: 'Package not found'].
	dict removeKey: packageName.
	transaction root at: 'lastPurgedPackage' put: (Association key: packageName value: editions).
	transaction
		markDirty: dict;
		commit] 
			ifCurtailed: [transaction abort]!

purgePackageEdition: aStsPackageEdition 
	| transaction dict packageEdition editions lastEdition |
	transaction := db newTransaction.
	
	[packageEdition := transaction objectAt: aStsPackageEdition odbObjectID.
	dict := transaction root at: self packagesKey.
	editions := dict at: packageEdition name ifAbsent: [self error: 'Package not found'].
	editions size = 1 
		ifTrue: 
			[^MessageBox 
				notify: 'At least one package edition must remain in the repository.
Else the package has to be removed from the repository.'].
	editions remove: packageEdition.
	(lastEdition := transaction root at: 'lastPurgedPackageEdition' ifAbsent: []) isNil 
		ifFalse: [self basicPurgePackageEdition: lastEdition].
	transaction root at: 'lastPurgedPackageEdition' put: packageEdition.
	transaction
		markDirty: editions;
		commit.
	self removeLoadedPackageIdentifiersForEdition: packageEdition] 
			ifCurtailed: [transaction abort]!

purgeProject: projectName 
	| transaction dict projectEditions |
	transaction := db newTransaction.
	
	[dict := transaction root at: self projectsKey.
	projectEditions := dict at: projectName ifAbsent: [self error: 'Project not found'].
	dict removeKey: projectName.
	transaction root at: 'lastPurgedProject' put: (Association key: projectName value: projectEditions).
	transaction
		markDirty: dict;
		commit] 
			ifCurtailed: [transaction abort]!

purgeProjectEdition: aStsProjectEdition 
	| transaction dict projectEdition projectEditions |
	transaction := db newTransaction.
	
	[projectEdition := transaction objectAt: aStsProjectEdition odbObjectID.
	dict := transaction root at: self projectsKey.
	projectEditions := dict at: projectEdition name ifAbsent: [self error: 'Project not found'].
	projectEditions size = 1 
		ifTrue: 
			[^MessageBox 
				notify: 'At least one project edition must remain in the repository.
Else the project has to be removed.'].
	projectEditions remove: projectEdition.
	transaction root at: 'lastPurgedProjectEdition' put: projectEdition.
	transaction
		markDirty: projectEditions;
		commit] 
			ifCurtailed: [transaction abort]!

purgeUnusedClassEditions
	"This method will clean up repository and remove all references to class editions that are not used by any package edition.
	Purging unused class editions will speed up versioning process significantly since STS does not need to compare so many class editions anymore when versioning a package.
	Also you can run database garbage collection after purge to reduce repository database size (presuming you have OmniBase registered version)."

	| t1 dict t2 size index progressDialog totalEditions totalPurged editions toRemove |
	(MessageBox 
		confirm: 'This operation will remove all unused Class Editions from the Repository.

Purging unused Class Editions is a lengthy operation which can take a long time if there are many classes in the Repository.

You can press Cancel at any time without fear of corrupting your Repository.

After completing the purge there is now way to recover removed Class Editions back.

Are you sure you want to continue?'
		caption: 'Purge Unused Class Editions') = true 
		ifFalse: [^self].
	totalEditions := 0.
	totalPurged := 0.
	progressDialog := ProgressDialog operation: 
					[:progress | 
					Transcript
						cr;
						nextPutAll: 'Purging unused Class Editions...';
						cr.
					t1 := db newTransaction.
					dict := t1 root at: self classesKey.
					size := dict size.
					index := 0.
					
					[dict keysDo: 
							[:eachKey | 
							index := index + 1.
							progressDialog
								caption: 'Purging Class Editions for ' , eachKey;
								value: 100.0 * index / size.
							
							[t2 := db newTransaction.
							toRemove := nil.
							editions := (t2 root at: self classesKey) at: eachKey.
							totalEditions := totalEditions + editions size.
							editions do: 
									[:eachEdition | 
									(self doesAnyPackageEditionUse: eachEdition) 
										ifFalse: 
											[toRemove isNil ifTrue: [toRemove := OrderedCollection new].
											toRemove add: eachEdition.
											totalPurged := totalPurged + 1.
											Transcript
												nextPutAll: eachEdition name , ' ' , eachEdition displayString;
												cr]].
							(toRemove notNil or: [editions isEmpty]) 
								ifTrue: 
									[toRemove isNil 
										ifFalse: 
											[toRemove do: [:each | editions removeAtIndex: (editions findFirst: [:e | e isIdenticalTo: each])]].
									editions isEmpty 
										ifTrue: 
											[Transcript
												nextPutAll: 'Removing class ' , eachKey , ' since the are no editions left in the repository';
												cr.
											t2 markDirty: ((t2 root at: self methodDictionariesKey)
														removeKey: eachKey;
														yourself).
											t2 markDirty: ((t2 root at: self classesKey)
														removeKey: eachKey;
														yourself)]
										ifFalse: [t2 markDirty: editions]].
							t2 commit] 
									ifCurtailed: [t2 abort]]] 
							ensure: 
								[Transcript
									nextPutAll: 'Total classes: ' , size printString;
									cr;
									nextPutAll: 'Classes checked: ' , index printString;
									cr;
									nextPutAll: 'Editions checked: ' , totalEditions printString;
									cr;
									nextPutAll: 'Editions removed: ' , totalPurged printString;
									cr]].
	progressDialog
		allowCancel: true;
		caption: 'Please wait';
		showModal!

refactoryPackageNames

	^#(
'RBChangeObjects'
'RBEnvironments'
'RBFormatters'
'RBRefactorings'
'RBSmallLint'
)!

registerEventHandlers
	(Smalltalk developmentSystem)
		when: #classAdded:
			send: #onSystemClassAdded:
			to: self;
		when: #classRemoved:
			send: #onSystemClassUpdated:
			to: self;
		when: #classUpdated:
			send: #onSystemClassUpdated:
			to: self;
		when: #classCommented:
			send: #onSystemClassUpdated:
			to: self;
		when: #classCategorized:
			send: #onSystemClassUpdated:
			to: self;
		when: #globalRemoved:
			send: #onSystemGlobalRemoved:
			to: self;
		when: #globalRenamed:from:
			send: #onSystemGlobalRenamed:from:
			to: self;
		when: #methodAdded:
			send: #onSystemMethodCompiled:
			to: self;
		when: #methodRemoved:
			send: #onSystemMethodRemoved:
			to: self;
		when: #methodUpdated:
			send: #onSystemMethodCompiled:
			to: self;
		when: #methodCategorized:
			send: #onSystemMethodUpdated:
			to: self.
	(SessionManager current)
		when: #sessionStarted
			send: #connectToDatabase
			to: self;
		when: #sessionStopped
			send: #shutdown
			to: self;
		when: #imageSaveStarting
			send: #disconnectFromDatabase
			to: self;
		when: #imageSaveCompleted
			send: #connectToDatabase
			to: self.
	(Package manager)
		when: #packageChanged:
			send: #onPackageChanged:
			to: self;
		when: #loadedChanged
			send: #onLoadedPackagesChanged
			to: self;
		when: #methodRepackaged:from:to:
			send: #onMethodRepackaged:from:to:
			to: self;
		when: #classRepackaged:from:to:
			send: #onClassRepackaged:from:to:
			to: self;
		when: #resourceRepackaged:from:to:
			send: #onResourceRepackaged:from:to:
			to: self;
		when: #globalRepackaged:from:to:
			send: #onGlobalRepackaged:from:to:
			to: self;
		when: #aboutToSave:
			send: #onAboutToSave:
			to: self!

remoteLoginData
	loginData ifNil: [loginData := LookupTable new].
	^loginData!

removeLoadedPackageIdentifiersForEdition: aPackageEdition 
	packageEditions isNil ifTrue: [^self].
	(packageEditions at: aPackageEdition name) = aPackageEdition identifiers 
		ifTrue: [packageEditions removeKey: aPackageEdition name]!

removePackageNamed: aString fromProjectEdition: aProjectEdition 
	| transaction projectEdition |
	transaction := db newTransaction.
	
	[projectEdition := transaction objectAt: aProjectEdition odbObjectID.
	projectEdition 
		packageEditions: (projectEdition packageEditions reject: [:each | each name = aString]).
	transaction
		markDirty: projectEdition;
		commit] 
			ifCurtailed: [transaction abort]!

removeStoredChangeSets: changeSets 
	| coll obj |
	
	[coll := OmniBase root at: self changeSetsKey ifAbsent: [].
	coll isNil 
		ifFalse: 
			[changeSets do: 
					[:eachChangeSet | 
					obj := coll detect: 
									[:eachPersistent | 
									eachPersistent developer = eachChangeSet developer and: 
											[eachPersistent timestamp = eachChangeSet timestamp and: 
													[eachPersistent comment = eachChangeSet comment 
														and: [eachPersistent browserTitle = eachChangeSet browserTitle]]]]
								ifNone: [].
					obj isNil 
						ifFalse: 
							[coll remove: obj.
							coll markDirty]]]] 
			evaluateAndCommitIn: db newTransaction!

renamePackage: oldName to: newName 
	| transaction dict editions existingEditions |
	newName isEmpty 
		ifTrue: 
			[MessageBox errorMsg: 'Please enter a valid name' caption: 'Renaming package'.
			^false].
	transaction := db newTransaction.
	dict := transaction root at: self packagesKey.
	(existingEditions := dict at: newName ifAbsent: []) notNil 
		ifTrue: 
			[(MessageBox confirm: 'Package ' , newName 
						, ' already exists.
Do you want to merge editions into a single package history?'
				caption: 'Renaming package') ifFalse: [^false]].
	
	[editions := dict at: oldName.
	editions do: 
			[:eachPackageEdition | 
			eachPackageEdition name: newName.
			transaction markDirty: eachPackageEdition].
	existingEditions isNil 
		ifTrue: 
			[dict at: newName put: editions.
			transaction markDirty: editions]
		ifFalse: 
			[editions do: 
					[:each | 
					| i |
					i := 1.
					[i <= existingEditions size and: [(existingEditions at: i) timestamp > each timestamp]] 
						whileTrue: [i := i + 1].
					existingEditions add: each beforeIndex: i].
			transaction markDirty: existingEditions].
	dict removeKey: oldName.
	transaction
		markDirty: dict;
		commit] 
			ifCurtailed: [transaction abort].
	^true!

renamePackageVersion: aStsPackageEdition newVersionDescriptor: newVersionDescriptor 
	| transaction packageEdition |
	newVersionDescriptor isEmpty ifTrue: [self error: 'Invalid package version descriptor'].
	transaction := db newTransaction.
	
	[packageEdition := transaction objectAt: aStsPackageEdition odbObjectID.
	packageEdition versionDescriptor: newVersionDescriptor.
	transaction
		markDirty: packageEdition;
		commit] 
			ifCurtailed: [transaction abort]!

renameProject: oldName to: newName 
	| transaction dict editions existingEditions |
	newName isEmpty 
		ifTrue: 
			[MessageBox errorMsg: 'Please enter a valid name' caption: 'Renaming project'.
			^false].
	transaction := db newTransaction.
	dict := transaction root at: self projectsKey.
	(existingEditions := dict at: newName ifAbsent: []) notNil 
		ifTrue: 
			[(MessageBox confirm: 'Project ' , newName 
						, ' already exists.
Do you want to merge editions into a single project history?'
				caption: 'Renaming project') ifFalse: [^false]].
	
	[editions := dict at: oldName.
	editions do: 
			[:eachProjectEdition | 
			eachProjectEdition name: newName.
			transaction markDirty: eachProjectEdition].
	existingEditions isNil 
		ifTrue: 
			[dict at: newName put: editions.
			transaction markDirty: editions]
		ifFalse: 
			[editions do: 
					[:each | 
					| i |
					i := 1.
					[i <= existingEditions size and: [(existingEditions at: i) timestamp > each timestamp]] 
						whileTrue: [i := i + 1].
					existingEditions add: each beforeIndex: i].
			transaction markDirty: existingEditions].
	dict removeKey: oldName.
	transaction
		markDirty: dict;
		commit] 
			ifCurtailed: [transaction abort].
	^true!

renameProjectVersion: aStsProjectEdition newVersionDescriptor: newVersionDescriptor 
	| transaction projectEdition |
	newVersionDescriptor isEmpty ifTrue: [self error: 'Invalid project version descriptor'].
	transaction := db newTransaction.
	
	[projectEdition := transaction objectAt: aStsProjectEdition odbObjectID.
	projectEdition versionDescriptor: newVersionDescriptor.
	transaction
		markDirty: projectEdition;
		commit] 
			ifCurtailed: [transaction abort]!

repositoryPath
	^repositoryPath!

resourcesKey
	"Private - Answers root dictionary key at which 
		a dictionary of resource editions collections is stored."

	^'sts.resources'!

salvageLastPurgedPackage
	| transaction package dict |
	transaction := db newTransaction.
	
	[dict := transaction root at: self packagesKey.
	"is there already package with the same name?"
	((package := transaction root at: 'lastPurgedPackage' ifAbsent: []) isNil 
		or: [dict includesKey: package key]) 
			ifTrue: 
				[MessageBox notify: 'There is no package to salvage.'.
				^false].
	transaction root removeKey: 'lastPurgedPackage'.
	dict at: package key put: package value.
	transaction
		markDirty: dict;
		commit] 
			ifCurtailed: [transaction abort].
	^true!

salvageLastPurgedPackageEditionFor: packageName 
	| transaction packageEdition dict editions |
	transaction := db newTransaction.
	
	[dict := transaction root at: self packagesKey.
	((packageEdition := transaction root at: 'lastPurgedPackageEdition' ifAbsent: []) notNil 
		and: [packageEdition name = packageName]) 
			ifFalse: 
				[MessageBox notify: 'There is no package edition to salvage for selected package.'.
				^false].
	transaction root removeKey: 'lastPurgedPackageEdition'.
	editions := dict at: packageEdition name.
	editions addFirst: packageEdition.
	transaction
		markDirty: editions;
		commit] 
			ifCurtailed: [transaction abort].
	^true!

salvageLastPurgedProject
	| transaction project dict |
	transaction := db newTransaction.
	
	[dict := transaction root at: self projectsKey.
	"is there already project with the same name?"
	((project := transaction root at: 'lastPurgedProject' ifAbsent: []) isNil 
		or: [dict includesKey: project key]) 
			ifTrue: 
				[MessageBox notify: 'There is no project to salvage.'.
				^false].
	transaction root removeKey: 'lastPurgedProject'.
	dict at: project key put: project value.
	transaction
		markDirty: dict;
		commit] 
			ifCurtailed: [transaction abort].
	^true!

salvageLastPurgedProjectEditionFor: projectName 
	| transaction projectEdition dict projectEditions |
	transaction := db newTransaction.
	
	[dict := transaction root at: self projectsKey.
	((projectEdition := transaction root at: 'lastPurgedProjectEdition' ifAbsent: []) notNil 
		and: [projectEdition name = projectName]) 
			ifFalse: 
				[MessageBox notify: 'There is no project edition to salvage for selected project.'.
				^false].
	transaction root removeKey: 'lastPurgedProjectEdition'.
	projectEditions := dict at: projectEdition name.
	projectEditions addFirst: projectEdition.
	transaction
		markDirty: projectEditions;
		commit] 
			ifCurtailed: [transaction abort].
	^true!

setChangeSetBlessingLevelFor: changeSet newBlessing: newBlessing 
	| coll obj |
	
	[(coll := OmniBase root at: self changeSetsKey ifAbsent: []) isNil 
		ifFalse: 
			[(obj := coll detect: 
							[:eachPersistent | 
							eachPersistent developer = changeSet developer and: 
									[eachPersistent timestamp = changeSet timestamp and: 
											[eachPersistent comment = changeSet comment 
												and: [eachPersistent browserTitle = changeSet browserTitle]]]]
						ifNone: []) isNil 
				ifFalse: 
					[obj
						blessing: newBlessing;
						markDirty]]] 
			evaluateAndCommitIn: db newTransaction!

setCurrentDeveloper: aString 
	developer := aString!

setLoadedClassIdentifiersFor: aClass to: anArray 
	((aClass isKindOf: StsImportProxy) or: [aClass isNil]) 
		ifFalse: [classEditions isNil ifFalse: [classEditions at: aClass instanceClass name put: anArray]]!

setLoadedPackageIdentifiersFor: aPackageOrPackageEdition to: anArray 
	packageEditions isNil ifFalse: [packageEditions at: aPackageOrPackageEdition name put: anArray]!

setPackageBlessingLevelFor: packageEdition newBlessing: newBlessing 
	
	[(self getProjectOrPackageFor: packageEdition) 
		ifNotNil: 
			[:value | 
			value
				blessing: newBlessing;
				markDirty]] 
			evaluateAndCommitIn: db newTransaction!

setProjectBlessingLevelFor: projectEdition newBlessing: newBlessing 
	
	[(self getProjectOrPackageFor: projectEdition) 
		ifNotNil: 
			[:value | 
			value
				blessing: newBlessing;
				markDirty]] 
			evaluateAndCommitIn: db newTransaction!

setProjectCommentFor: projectEdition newComment: newComment 
	
	[(self getProjectOrPackageFor: projectEdition) 
		ifNotNil: 
			[:value | 
			value
				comment: newComment;
				markDirty]] 
			evaluateAndCommitIn: db newTransaction!

setProjectVersionCommentFor: projectEdition newComment: newComment 
	
	[(self getProjectOrPackageFor: projectEdition) 
		ifNotNil: 
			[:value | 
			value
				versionComment: newComment;
				markDirty]] 
			evaluateAndCommitIn: db newTransaction!

setRemoteServerUrl: aString 
	currentServerURL := aString!

shutdown
	self unregisterEventHandlers.
	db isNil 
		ifFalse: 
			[db close.
			db := nil]!

startUpOn: aString 
	"Starts a session using database in directory aString."

	self shutdown.
	ignoreCompilerEventsFlag := false.
	repositoryPath := aString , '\Repository'.
	packageEditions := LookupTable new.
	classEditions := LookupTable new.
	self connectToDatabase.
	developer := (SessionManager current userName , '@' , SessionManager current computerName) 
				asLowercase.
	self registerEventHandlers!

stsPackageNames
	^#('OmniBase' 'Source Tracking System' 'Source Tracking System Base' 'Source Tracking System Professional' 'Dialect Abstraction Layer' 'Source Tracking System Remote Client' 'Source Tracking System Server' 'Web Server' 'HTML Parser' 'HTTP Client' 'HTML Forms Generator' 'Web Frameworks OmniBase' 'WikiDoc' 'Web Server Administration')!

toFilenameString: aString 
	"Private - Returns string filtered as filename string, removing/replacing forbidden characters.
	Character $. is also removed, so extension must be added after this."

	| str |
	str := ''.
	aString do: 
			[:ch | 
			('abcdefghijklmnopqrstuvwxyz1234567890-_' includes: ch asLowercase) 
				ifTrue: [str := str , ch asString]
				ifFalse: [ch = $/ ifTrue: [str := str , '-'] ifFalse: [ch = $  ifTrue: [str := str , '_']]]].
	^str isEmpty ifTrue: ['New file'] ifFalse: [str]!

unregisterEventHandlers
	Smalltalk developmentSystem removeEventsTriggeredFor: self.
	SessionManager current removeEventsTriggeredFor: self.
	Package manager removeEventsTriggeredFor: self!

versionPackage: aPackage 
	| importInformation |
	self checkIfConnected ifFalse: [^self].
	^(importInformation := (StsImportInformationDialog 
				createOn: (StsImportInformationModel package: aPackage))
				caption: 'Versioning package ' , aPackage name;
				showModal) isNil 
		ifFalse: 
			[self
				basicVersionPackage: aPackage
					versionDescriptor: importInformation version
					developer: importInformation developer
					previousEdition: importInformation previousEdition
					blessing: importInformation blessing
					comment: importInformation comment asString
					versionComment: importInformation versionComment asString
					checkExisting: false
					silentBool: false;
				getLatestPackageEditionFor: aPackage name]!

versionProjectEdition: aProjectEdition 
	| projectEdition transaction importInformation |
	self checkIfConnected ifFalse: [^self].
	transaction := db newTransaction.
	
	[projectEdition := transaction objectAt: aProjectEdition odbObjectID.
	(importInformation := (StsImportInformationDialog 
				createOn: (StsImportInformationModel project: projectEdition))
				caption: 'Versioning project ' , projectEdition name;
				showModal) isNil 
		ifFalse: 
			[projectEdition
				versionDescriptor: importInformation version;
				developer: importInformation developer;
				previousEdition: (importInformation previousEdition isNil 
							ifFalse: [transaction objectAt: importInformation previousEdition odbObjectID]);
				blessing: importInformation blessing;
				comment: importInformation comment asString;
				versionComment: importInformation versionComment asString;
				timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds)).
			transaction
				markDirty: projectEdition;
				commit]] 
			ifCurtailed: [transaction abort]! !
!StsManager categoriesFor: #addPackageEdition:beforeIndex:onProjectEdition:!operations!public! !
!StsManager categoriesFor: #addPackageEdition:toProjectEdition:!operations!public! !
!StsManager categoriesFor: #allPrerequisitePackageNamesOf:prereqs:visited:includeBasePackages:!helpers!private! !
!StsManager categoriesFor: #basicPurgePackageEdition:!operations!private! !
!StsManager categoriesFor: #basicVersionPackage:versionDescriptor:developer:previousEdition:blessing:comment:versionComment:checkExisting:silentBool:!*/compilation issues!private! !
!StsManager categoriesFor: #basicVersionPackage:versionDescriptor:previousEdition:blessing:comment:versionComment:checkExisting:silentBool:!private! !
!StsManager categoriesFor: #basicVersionPackage:versionDescriptor:previousEdition:versionComment:checkExisting:silentBool:!private! !
!StsManager categoriesFor: #basicVersionProject:previousEdition:!private! !
!StsManager categoriesFor: #basicVersionProject:versionDescriptor:previousEdition:blessing:comment:versionComment:packageEditionOIDs:progress:tick:timestamp:developer:!private! !
!StsManager categoriesFor: #browseAvailableMethodsFor:!public! !
!StsManager categoriesFor: #browseChangesBetween:and:!public! !
!StsManager categoriesFor: #browseChangeSetsList!public!to be merged list! !
!StsManager categoriesFor: #browseClassEditions:!public! !
!StsManager categoriesFor: #browseMethodEditions:class:!public! !
!StsManager categoriesFor: #browsePackageEditions:!public! !
!StsManager categoriesFor: #byteCompare:with:!private! !
!StsManager categoriesFor: #changeSetsKey!db root key definitions!private! !
!StsManager categoriesFor: #checkIfConnected!private! !
!StsManager categoriesFor: #chooseRepository!public! !
!StsManager categoriesFor: #classesKey!db root key definitions!private! !
!StsManager categoriesFor: #collectOIDsFrom:in:!private! !
!StsManager categoriesFor: #compareObjectIDsOf:with:in:!private! !
!StsManager categoriesFor: #comparePackage:with:!public! !
!StsManager categoriesFor: #compareRepositoryEditionWithClass:!public! !
!StsManager categoriesFor: #compareRepositoryEditionWithPackage:!public! !
!StsManager categoriesFor: #compressToByteArray:!operations!private! !
!StsManager categoriesFor: #connectToDatabase!private! !
!StsManager categoriesFor: #createMethodDictionaryFor:in:!private! !
!StsManager categoriesFor: #createNewProjectEditionFrom:in:!public! !
!StsManager categoriesFor: #createNewProjectNamed:createInitialOpenEdition:!public! !
!StsManager categoriesFor: #createRepositoryOn:!public! !
!StsManager categoriesFor: #databaseClass!private! !
!StsManager categoriesFor: #databaseConnection!public! !
!StsManager categoriesFor: #disconnectFromDatabase!private! !
!StsManager categoriesFor: #doesAnyPackageEditionUse:!operations!private! !
!StsManager categoriesFor: #exportPackageEdition:!operations!public! !
!StsManager categoriesFor: #exportPackageEditions:!operations!public! !
!StsManager categoriesFor: #exportProjectEdition:!operations!public! !
!StsManager categoriesFor: #exportProjectEditionNewFormat:toFileNamed:!operations!private! !
!StsManager categoriesFor: #exportProjectEditionOldFormat:toFileNamed:!operations!private! !
!StsManager categoriesFor: #findExistingPackage:in:!private! !
!StsManager categoriesFor: #findExistingPackageEdition:versionDescriptor:developer:timestamp:!private! !
!StsManager categoriesFor: #findExistingProjectEdition:versionDescriptor:developer:timestamp:!private! !
!StsManager categoriesFor: #findMethodEditionFor:!private! !
!StsManager categoriesFor: #findOrCreateClassEditionFor:in:!private! !
!StsManager categoriesFor: #findOrCreateClassEditionForInRepository:in:!private! !
!StsManager categoriesFor: #findOrCreateMethodEditionFor:methodDictionary:in:!private! !
!StsManager categoriesFor: #findProjectEditionForPreviousVersionData:projectName:!operations!private! !
!StsManager categoriesFor: #getAllMethodEditionsFor:from:until:!public! !
!StsManager categoriesFor: #getAllPackageNames!public! !
!StsManager categoriesFor: #getAllProjectNames!public! !
!StsManager categoriesFor: #getAvailableMethodsFor:!public! !
!StsManager categoriesFor: #getChangeNodeOwningPackageFor:!private! !
!StsManager categoriesFor: #getClassEditionOIDforLoadedClass:!operations!private! !
!StsManager categoriesFor: #getClassEditions:!public! !
!StsManager categoriesFor: #getClassEditions:in:!public! !
!StsManager categoriesFor: #getCurrentDeveloper!accessing!public! !
!StsManager categoriesFor: #getLatestPackageEditionFor:!public! !
!StsManager categoriesFor: #getLoadedPackageFor:!operations!public! !
!StsManager categoriesFor: #getLoadedPackageIdentifiersFor:!operations!private! !
!StsManager categoriesFor: #getMethodDictionaryFor:in:!private! !
!StsManager categoriesFor: #getMethodEditionFor:in:!private! !
!StsManager categoriesFor: #getMethodEditions:class:!public! !
!StsManager categoriesFor: #getMethodEditionsFor:in:!private! !
!StsManager categoriesFor: #getPackageEditionsFor:!public! !
!StsManager categoriesFor: #getProjectEditionsFor:!public! !
!StsManager categoriesFor: #getProjectOrPackageFor:!public! !
!StsManager categoriesFor: #getRepositoryPath!accessing!public! !
!StsManager categoriesFor: #getResourceEditionFor:in:!private! !
!StsManager categoriesFor: #getStoredChangeSets!public!to be merged list! !
!StsManager categoriesFor: #getVersionInfoFor:!public! !
!StsManager categoriesFor: #ignoreCompilerWhile:!public! !
!StsManager categoriesFor: #importFromSqueakFileOut!operations!public! !
!StsManager categoriesFor: #importPackage!operations!public! !
!StsManager categoriesFor: #importPackageObjectFor:!operations!private! !
!StsManager categoriesFor: #importProject!operations!public! !
!StsManager categoriesFor: #importProjectNewFormatFrom:!operations!private! !
!StsManager categoriesFor: #importProjectOldFormatFrom:!operations!private! !
!StsManager categoriesFor: #incrementOne:!private! !
!StsManager categoriesFor: #install!public! !
!StsManager categoriesFor: #isConnected!private!testing! !
!StsManager categoriesFor: #markClassAsChanged:!event handlers!private! !
!StsManager categoriesFor: #markPackageAsChanged:!event handlers!private! !
!StsManager categoriesFor: #methodDictionariesKey!db root key definitions!private! !
!StsManager categoriesFor: #notifyImageSameAsPackageEdition:!public! !
!StsManager categoriesFor: #objectArtsPackageNames!public! !
!StsManager categoriesFor: #onAboutToSave:!event handlers!private! !
!StsManager categoriesFor: #onClassRepackaged:from:to:!event handlers!private! !
!StsManager categoriesFor: #onGlobalRepackaged:from:to:!event handlers!private! !
!StsManager categoriesFor: #onLoadedPackagesChanged!private! !
!StsManager categoriesFor: #onMethodRepackaged:from:to:!event handlers!private! !
!StsManager categoriesFor: #onPackageChanged:!event handlers!private! !
!StsManager categoriesFor: #onResourceRepackaged:from:to:!event handlers!private! !
!StsManager categoriesFor: #onSystemClassAdded:!event handlers!private! !
!StsManager categoriesFor: #onSystemClassUpdated:!event handlers!private! !
!StsManager categoriesFor: #onSystemGlobalRemoved:!event handlers!private! !
!StsManager categoriesFor: #onSystemGlobalRenamed:from:!event handlers!private! !
!StsManager categoriesFor: #onSystemMethodCompiled:!event handlers!private! !
!StsManager categoriesFor: #onSystemMethodRemoved:!event handlers!private! !
!StsManager categoriesFor: #onSystemMethodUpdated:!event handlers!private! !
!StsManager categoriesFor: #packageNames:usingMethodEdition:!public!searching! !
!StsManager categoriesFor: #packagesKey!db root key definitions!private! !
!StsManager categoriesFor: #projectEditionFileTypes!operations!private! !
!StsManager categoriesFor: #projectExportHeaderString!operations!private! !
!StsManager categoriesFor: #projectsKey!db root key definitions!private! !
!StsManager categoriesFor: #purgePackage:!operations!public! !
!StsManager categoriesFor: #purgePackageEdition:!operations!public! !
!StsManager categoriesFor: #purgeProject:!operations!public! !
!StsManager categoriesFor: #purgeProjectEdition:!operations!public! !
!StsManager categoriesFor: #purgeUnusedClassEditions!operations!public! !
!StsManager categoriesFor: #refactoryPackageNames!public! !
!StsManager categoriesFor: #registerEventHandlers!event handlers!private! !
!StsManager categoriesFor: #remoteLoginData!public! !
!StsManager categoriesFor: #removeLoadedPackageIdentifiersForEdition:!operations!private! !
!StsManager categoriesFor: #removePackageNamed:fromProjectEdition:!operations!public! !
!StsManager categoriesFor: #removeStoredChangeSets:!public!to be merged list! !
!StsManager categoriesFor: #renamePackage:to:!operations!public! !
!StsManager categoriesFor: #renamePackageVersion:newVersionDescriptor:!operations!public! !
!StsManager categoriesFor: #renameProject:to:!operations!public! !
!StsManager categoriesFor: #renameProjectVersion:newVersionDescriptor:!operations!public! !
!StsManager categoriesFor: #repositoryPath!public! !
!StsManager categoriesFor: #resourcesKey!db root key definitions!private! !
!StsManager categoriesFor: #salvageLastPurgedPackage!operations!public! !
!StsManager categoriesFor: #salvageLastPurgedPackageEditionFor:!operations!public! !
!StsManager categoriesFor: #salvageLastPurgedProject!operations!public! !
!StsManager categoriesFor: #salvageLastPurgedProjectEditionFor:!operations!public! !
!StsManager categoriesFor: #setChangeSetBlessingLevelFor:newBlessing:!public!to be merged list! !
!StsManager categoriesFor: #setCurrentDeveloper:!accessing!public! !
!StsManager categoriesFor: #setLoadedClassIdentifiersFor:to:!operations!private! !
!StsManager categoriesFor: #setLoadedPackageIdentifiersFor:to:!operations!private! !
!StsManager categoriesFor: #setPackageBlessingLevelFor:newBlessing:!public! !
!StsManager categoriesFor: #setProjectBlessingLevelFor:newBlessing:!public! !
!StsManager categoriesFor: #setProjectCommentFor:newComment:!public! !
!StsManager categoriesFor: #setProjectVersionCommentFor:newComment:!public! !
!StsManager categoriesFor: #setRemoteServerUrl:!public! !
!StsManager categoriesFor: #shutdown!public! !
!StsManager categoriesFor: #startUpOn:!public! !
!StsManager categoriesFor: #stsPackageNames!public! !
!StsManager categoriesFor: #toFilenameString:!operations!private! !
!StsManager categoriesFor: #unregisterEventHandlers!event handlers!private! !
!StsManager categoriesFor: #versionPackage:!public! !
!StsManager categoriesFor: #versionProjectEdition:!*/changed!public! !

!StsManager class methodsFor!

current
	current isNil ifTrue: [current := self new].
	^current!

defaultRepositoryPath
	| path |
	path := SessionManager current imageBase.
	"take the backslash away"
	^path copyFrom: 1 to: path size - 1!

extendedClassNames
	^#(#ClassBrowserAbstract #MethodBrowser #Debugger #PackageBrowserShell)!

initialize
	self registerCommandQueryHandlers!

install
	StsManager current install!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application."

	^false!

registerCommandQueryHandlers
	self extendedClassNames 
		do: [:each | Smalltalk at: each ifPresent: [:class | class addCommandQueryHandler: #queryStsCommand:]]!

shutdown
	self current shutdown.
	current := nil!

startUp
	self startUpOn: self defaultRepositoryPath!

startUpOn: aString 
	self current startUpOn: aString!

uninitialize
	self unregisterCommandQueryHandlers!

unregisterCommandQueryHandlers
	self extendedClassNames 
		do: [:each | Smalltalk at: each ifPresent: [:class | class removeCommandQueryHandler: #queryStsCommand:]]! !
!StsManager class categoriesFor: #current!public! !
!StsManager class categoriesFor: #defaultRepositoryPath!public! !
!StsManager class categoriesFor: #extendedClassNames!constants!private! !
!StsManager class categoriesFor: #initialize!development!initializing!public! !
!StsManager class categoriesFor: #install!public! !
!StsManager class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!StsManager class categoriesFor: #registerCommandQueryHandlers!helpers!private! !
!StsManager class categoriesFor: #shutdown!public! !
!StsManager class categoriesFor: #startUp!public! !
!StsManager class categoriesFor: #startUpOn:!public! !
!StsManager class categoriesFor: #uninitialize!initializing!private! !
!StsManager class categoriesFor: #unregisterCommandQueryHandlers!helpers!private! !

