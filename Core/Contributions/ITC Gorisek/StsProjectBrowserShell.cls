"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsProjectBrowserShell
	instanceVariableNames: 'projectsPresenter projectEditionsPresenter packageEditionsPresenter commentPresenter versionCommentPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsProjectBrowserShell guid: (GUID fromString: '{10d6a001-af19-11d4-b232-000000000000}')!
StsProjectBrowserShell comment: ''!
!StsProjectBrowserShell categoriesForClass!Unclassified! !
!StsProjectBrowserShell methodsFor!

addPackageEdition
	| tmp |
	self 
		addPackageEdition: ((tmp := packageEditionsPresenter selection) isEmpty ifFalse: [tmp first name])!

addPackageEdition: packageNameOrNil 
	| index packageEdition |
	(packageEdition := StsPackageEditionPrompter chooseWithDefault: packageNameOrNil) notNil 
		ifTrue: 
			[self sourceControl addPackageEdition: packageEdition
				toProjectEdition: self selectedSingleProjectEditionOrNil.
			self refreshProjectEditionsList.
			index := packageEditionsPresenter list indexOf: packageEdition odbResolve.
			packageEditionsPresenter selectionByIndex: (Array with: index)]!

browsePackageEditions
	self sourceControl browsePackageEditions: packageEditionsPresenter selection first name!

compareLoadedPackagesWithEditions: packageEditions 
	| changes loadedPackage allChanges |
	allChanges := OrderedCollection new.
	packageEditions do: 
			[:eachPackageEdition | 
			changes := OrderedCollection new.
			loadedPackage := Package manager packageNamed: eachPackageEdition name ifNone: [].
			loadedPackage isNil 
				ifTrue: 
					[changes addFirst: ((StsChangeNode new)
								elementDescription: 'contained package ' , eachPackageEdition name;
								description: 'package not loaded in the image';
								leftEdition: eachPackageEdition;
								owningPackage: nil;
								yourself)]
				ifFalse: 
					[Cursor wait showWhile: [eachPackageEdition compareWithLoadedPackage: loadedPackage on: changes].
					changes do: [:each | each owningPackage isNil ifTrue: [each owningPackage: loadedPackage]]].
			allChanges addAll: changes].
	allChanges isEmpty 
		ifTrue: 
			[MessageBox notify: 'No changes were found between loaded packages and editions in repository.']
		ifFalse: 
			[(StsComparisonBrowser create)
				setChanges: allChanges;
				caption: 'Changes Browser - Loaded packages vs Versions in the repository';
				showShell]!

comparePackageEditionWith
	| anotherEdition selectedEdition |
	(selectedEdition := self selectedSinglePackageEditionOrNil) isNil 
		ifFalse: 
			[(anotherEdition := StsPackageEditionPrompter chooseWithDefault: selectedEdition name) notNil 
				ifTrue: [self sourceControl browseChangesBetween: anotherEdition and: selectedEdition]]!

comparePackageEditionWithImage
	self sourceControl comparePackage: self selectedLoadedPackageOrNil
		with: self selectedSinglePackageEditionOrNil.

	"The comparison may prompt to mark the edition as loaded so force a refresh here"
	packageEditionsPresenter model refresh: self selectedSinglePackageEditionOrNil!

comparePackageEditionWithLoadedPackage
	| selectedEdition loadedPackage allChanges changes |
	self selectedPackageEditions isEmpty ifTrue: [^self].
	(selectedEdition := self selectedSinglePackageEditionOrNil) isNil 
		ifFalse: 
			[loadedPackage := Package manager packageNamed: selectedEdition name ifNone: [].
			^(PackagePrompter 
				showModalOn: loadedPackage asValue
				caption: 'Select default package...'
				default: nil) 
					ifNotNil: [:selectedPackage | self sourceControl comparePackage: selectedPackage with: selectedEdition]].
	allChanges := OrderedCollection new.
	packageEditionsPresenter selection do: 
			[:eachPackageEdition | 
			changes := OrderedCollection new.
			(loadedPackage := Package manager packageNamed: eachPackageEdition name ifNone: []) isNil 
				ifTrue: 
					[changes addFirst: ((StsChangeNode new)
								elementDescription: 'contained package ' , eachPackageEdition name;
								description: 'package not loaded in the image';
								leftEdition: eachPackageEdition;
								owningPackage: nil;
								yourself)]
				ifFalse: 
					[Cursor wait showWhile: [eachPackageEdition compareWithLoadedPackage: loadedPackage on: changes].
					changes do: [:each | each owningPackage isNil ifTrue: [each owningPackage: loadedPackage]]].
			allChanges addAll: changes].
	allChanges isEmpty 
		ifTrue: 
			[MessageBox notify: 'No changes were found between loaded packages and editions in repository.']
		ifFalse: 
			[(StsComparisonBrowser create)
				setChanges: allChanges;
				caption: 'Changes Browser - Loaded packages vs Versions in the repository';
				showShell]!

compareProjectEdition: pe1 with: pe2 
	| packageEdition1 packageEdition2 changes progressDialog defaultCaption transaction todoList size position projectEdition1 projectEdition2 |
	transaction := self sourceControl databaseConnection newLongReadOnlyTransaction.
	projectEdition1 := transaction objectAt: pe1 odbGetOID.
	projectEdition2 := transaction objectAt: pe2 odbGetOID.
	changes := OrderedCollection new.
	defaultCaption := projectEdition1 name , ': Version ' , projectEdition1 versionDescriptor 
				, ' vs Version ' , projectEdition2 versionDescriptor.
	position := 0.
	progressDialog := ProgressDialog operation: 
					[:progressValue | 
					
					[todoList := projectEdition2 packageEditions copy asOrderedCollection.
					size := todoList size min: projectEdition1 packageEditions size.
					projectEdition1 packageEditions do: 
							[:eachPackageEdition1 | 
							progressDialog caption: 'Comparing ' , defaultCaption.
							packageEdition2 := todoList detect: [:each | each name = eachPackageEdition1 name] ifNone: [].
							packageEdition2 isNil 
								ifTrue: 
									["add change here to indicate that project edition 2 does not have package named: eachPackageEdition1 name"
									changes addFirst: ((StsChangeNode new)
												elementDescription: 'contained package ' , eachPackageEdition1 name;
												description: 'package added';
												leftEdition: eachPackageEdition1;
												owningPackage: (self sourceControl getChangeNodeOwningPackageFor: eachPackageEdition1);
												yourself)]
								ifFalse: 
									[todoList remove: packageEdition2.
									position := position + 1.
									progressValue value: position / size * 100.
									(eachPackageEdition1 isIdenticalTo: packageEdition2) 
										ifFalse: 
											[Cursor wait showWhile: 
													[| owningPackage t2 |
													t2 := self sourceControl databaseConnection newLongReadOnlyTransaction.
													packageEdition1 := t2 objectAt: eachPackageEdition1 odbGetOID.
													packageEdition2 := t2 objectAt: packageEdition2 odbGetOID.
													progressDialog 
														caption: 'Comparing package ' , packageEdition1 name , ': Version ' 
																, packageEdition1 versionDescriptor , ' vs Version ' 
																, packageEdition2 versionDescriptor.
													changes add: ((StsChangeNode new)
																elementDescription: 'contained package ' , packageEdition1 name;
																description: 'different package version';
																leftEdition: packageEdition1;
																rightEdition: packageEdition2;
																yourself).
													packageEdition1 compareWith: packageEdition2 on: changes.
													owningPackage := self sourceControl getChangeNodeOwningPackageFor: packageEdition1.
													changes do: [:each | each owningPackage isNil ifTrue: [each owningPackage: owningPackage]]]]]].
					todoList do: 
							[:eachPackageEdition | 
							"add changes here to indicate that project edition 1 does not have package remaining editions"
							changes addFirst: ((StsChangeNode new)
										elementDescription: 'contained package ' , eachPackageEdition name;
										description: 'package removed';
										rightEdition: eachPackageEdition;
										owningPackage: (self sourceControl getChangeNodeOwningPackageFor: eachPackageEdition);
										yourself)]] 
							ifCurtailed: [progressDialog view close]].
	progressDialog
		caption: 'Comparing ' , defaultCaption;
		showModal.
	changes isEmpty 
		ifFalse: 
			[(StsComparisonBrowser create)
				setChanges: changes;
				caption: 'Changes Browser - ' , defaultCaption;
				showShell]
		ifTrue: [MessageBox notify: 'There were no changes between these two project editions']!

compareProjectEditions
	self sourceControl checkIfConnected ifFalse: [^nil].
	self compareProjectEdition: (projectEditionsPresenter selectionOrNil at: 1)
		with: (projectEditionsPresenter selectionOrNil at: 2)!

compareProjectEditionWithImage
	self compareLoadedPackagesWithEditions: self selectedSingleProjectEditionOrNil packageEditions!

compareProjectEditionWithPreviousVersion
	| pe |
	self sourceControl checkIfConnected ifFalse: [^nil].
	pe := self selectedSingleProjectEditionOrNil.
	pe previousEdition isNil 
		ifFalse: [self compareProjectEdition: pe with: pe previousEdition]
		ifTrue: [MessageBox notify: 'Project has no previous edition data.']!

createComponents
	super createComponents.
	projectsPresenter := self 
				add: ListPresenter new
				name: 'projects'
				helpId: 10982.
	projectsPresenter model searchPolicy: SearchPolicy equality.
	projectEditionsPresenter := self 
				add: ListPresenter new
				name: 'projectEditions'
				helpId: 10983.
	packageEditionsPresenter := self 
				add: ListPresenter new
				name: 'packageEditions'
				helpId: 10984.
	packageEditionsPresenter model searchPolicy: SearchPolicy equality.
	commentPresenter := self add: TextPresenter new name: 'comment'.
	versionCommentPresenter := self add: TextPresenter new name: 'versionComment'!

createNewProjectEdition
	self createNewProjectEditionBranchedFrom: self selectedSingleProjectEditionOrNil!

createNewProjectEditionBranchedFrom: aProjectEdition 
	self sourceControl createNewProjectEditionFrom: aProjectEdition in: aProjectEdition name.
	self refreshProjectEditionsList.
	projectEditionsPresenter selectionByIndex: #(1)!

createSchematicWiring
	super createSchematicWiring.
	projectsPresenter 
		when: #selectionChanged
		send: #onProjectSelected
		to: self.
	projectEditionsPresenter 
		when: #selectionChanged
		send: #onProjectEditionSelected
		to: self.
	packageEditionsPresenter 
		when: #actionPerformed
		send: #browsePackageEditions
		to: self!

defaultHelpId
	^10897!

firstLevelPrerequisiteNamesFor: packageEditions in: aProjectEdition 
	| prereqs |
	prereqs := Set new.
	packageEditions do: [:eachPackageEdition | prereqs addAll: eachPackageEdition prerequisiteNames].
	^prereqs!

hasOpenProjectEditionSelected
	| selectedProjectEdition |
	selectedProjectEdition := self selectedSingleProjectEditionOrNil.
	^selectedProjectEdition notNil and: [selectedProjectEdition isOpenEdition]!

iconForPackageName: packageName 
	| edition |
	edition := self sourceControl getLatestPackageEditionFor: packageName.
	edition isNil 
		ifTrue: 
			[| package |
			package := self sourceControl packageNamed: packageName.
			^package icon].
	^edition isBaseImagePackage ifTrue: [Package dolphinPackageIcon] ifFalse: [StsPackageEdition icon]!

isBasePackageName: aPackageName 
	"Answer true if aPackageName is the name of a base system package"

	"First see if a versioned package of this name exists and use the lastest edition of this to judge"

	| package packageEditions |
	packageEditions := self sourceControl getPackageEditionsFor: aPackageName.
	packageEditions notEmpty ifTrue: [^packageEditions first isBaseImagePackage].

	"Otherwise check the image"
	package := Package manager packageNamed: aPackageName ifNone: [].
	^package notNil and: [package isBaseImagePackage]!

loadPackageEdition
	packageEditionsPresenter selection do: [:eachEdition | eachEdition load]!

loadProjectEdition
	projectEditionsPresenter selectionOrNil first load.
	self refreshProjectEditionsList!

menuChangePackageBlessingLevel
	| selectedItem newBlessing |
	(selectedItem := self selectedSinglePackageEditionOrNil) isNil ifTrue: [^nil].
	(newBlessing := ChoicePrompter 
				on: (selectedItem blessing ifNil: [''])
				choices: StsEdition possibleBlessingLevels
				caption: 'Select package blessing level') isNil 
		ifTrue: [^nil].
	selectedItem blessing == newBlessing ifTrue: [^nil].
	self sourceControl setPackageBlessingLevelFor: selectedItem newBlessing: newBlessing.
	self refreshProjectEditionsList!

menuChangeProjectBlessingLevel
	| selectedItem newBlessing |
	(selectedItem := self selectedSingleProjectEditionOrNil) isNil ifTrue: [^nil].
	(newBlessing := ChoicePrompter 
				on: (selectedItem blessing ifNil: [''])
				choices: StsEdition possibleBlessingLevels
				caption: 'Select project blessing level') isNil 
		ifTrue: [^nil].
	selectedItem blessing == newBlessing ifTrue: [^nil].
	self sourceControl setProjectBlessingLevelFor: selectedItem newBlessing: newBlessing.
	self refreshProjectEditionsList!

menuChangeProjectComment
	| selectedItem newComment |
	self hasOpenProjectEditionSelected ifFalse: [^nil].
	(selectedItem := self selectedSingleProjectEditionOrNil) isNil ifTrue: [^nil].
	(newComment := StsMultilinePrompter 
				on: selectedItem comment asValue
				prompt: 'Enter project edition comment:'
				caption: 'Adding project edition comment') isNil 
		ifTrue: [^nil].
	selectedItem comment = newComment ifTrue: [^nil].
	self sourceControl setProjectCommentFor: selectedItem newComment: newComment.
	self refreshProjectEditionsList!

menuChangeProjectVersionComment
	| selectedItem newComment |
	(selectedItem := self selectedSingleProjectEditionOrNil) isNil ifTrue: [^nil].
	(newComment := StsMultilinePrompter 
				on: selectedItem versionComment asValue
				prompt: 'Enter project edition version comment:'
				caption: 'Adding project edition version comment') isNil 
		ifTrue: [^nil].
	selectedItem comment = newComment ifTrue: [^nil].
	self sourceControl setProjectVersionCommentFor: selectedItem newComment: newComment.
	self refreshProjectEditionsList!

menuCopyProjectEditionTo
	| allProjects selectedProjectName selectedProjectEdition |
	selectedProjectEdition := projectEditionsPresenter selection first.
	allProjects := self sourceControl getAllProjectNames.
	(selectedProjectName := ChoicePrompter 
				choices: (Array with: '<create new project>' asSymbol) , allProjects
				caption: 'Select destination project') isNil 
		ifTrue: [^nil].
	selectedProjectName class == Symbol 
		ifTrue: 
			["create new project first"
			((selectedProjectName := Prompter 
						on: ''
						prompt: 'Enter new project name:'
						caption: 'Copy project edition to new project') isNil 
				or: [selectedProjectName isEmpty]) ifTrue: [^nil].
			self sourceControl createNewProjectNamed: selectedProjectName createInitialOpenEdition: false].

	"same as create new edition, only creates it in another project"
	self sourceControl createNewProjectEditionFrom: selectedProjectEdition in: selectedProjectName.
	self refreshProjectEditionsList!

menuExportPackageEdition
	| selection |
	(selection := self selectedPackageEditions) size = 1 
		ifTrue: [self sourceControl exportPackageEdition: selection first]
		ifFalse: [selection isEmpty ifFalse: [self sourceControl exportPackageEditions: selection]]!

menuExportProject
	| selection |
	selection := projectEditionsPresenter selectionOrNil first.
	self sourceControl exportProjectEdition: selection!

menuFileOutPackagesAsSmalltalkXChangeSet
	| filename stream fileStream packageEdition |
	packageEdition := packageEditionsPresenter selection first.
	filename := (FileSaveDialog new)
				caption: 'File Out as SmalltalkX Changes Set';
				fileTypes: #(#('SmalltalkX Change Set (*.st)' '*.st'));
				value: packageEdition name , '.st';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			packageEditionsPresenter selection 
				do: [:eachEdition | eachEdition basicExportAsSmalltalkXChangeSetOn: stream packageName: eachEdition name].
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuFileOutPackagesAsSqueakChangeSet
	| filename stream fileStream packageEdition |
	packageEdition := packageEditionsPresenter selection first.
	filename := (FileSaveDialog new)
				caption: 'File Out as Squeak Changes Set';
				fileTypes: #(#('Squeak Change Set (*.cs)' '*.cs'));
				value: packageEdition name , '.cs';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			packageEditionsPresenter selection 
				do: [:eachEdition | eachEdition basicExportAsSqueakChangeSetOn: stream packageName: eachEdition name].
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuFileOutPackagesAsVASTAppFileOut
	"TODO not implemented yet."

	"| filename stream fileStream packageEdition |
	packageEdition := packageEditionsPresenter selection first.
	filename := (FileSaveDialog new)
				caption: 'File Out as VAST App File Out';
				fileTypes: #(#('VAST App File Out (*.app)' '*.app'));
				value: packageEdition name , '.app';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			packageEditionsPresenter selection 
				do: [:eachEdition | eachEdition basicExportAsVASTAppFileOutOn: stream packageName: eachEdition name].
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]"

	!

menuFileOutPackagesAsVWChangeSet
	!

menuImportPackage
	Cursor wait showWhile: [StsManager current importPackage]!

menuImportProject
	Cursor wait showWhile: [StsManager current importProject].
	self
		refreshProjectsList;
		refreshProjectEditionsList!

menuImportProjectFromStpFile
	Cursor wait showWhile: [StsManager current importProject].
	self
		refreshProjectsList;
		refreshProjectEditionsList!

menuPackageEditionShowVersionHistory
	| allEditions selectedEdition |
	self selectedSinglePackageEditionOrNil isNil 
		ifFalse: 
			[allEditions := self sourceControl 
						getPackageEditionsFor: self selectedSinglePackageEditionOrNil name.
			selectedEdition := allEditions 
						detect: [:each | each identifiers = self selectedSinglePackageEditionOrNil identifiers]
						ifNone: [].
			(StsVersionTreeDiagram create)
				showShell;
				setEditions: allEditions selectedEdition: selectedEdition]!

menuRenameVersion
	| newVersionName projectEdition |
	projectEdition := projectEditionsPresenter selectionOrNil first.
	
	[newVersionName := Prompter 
				on: projectEdition versionDescriptor
				prompt: 'Enter new version descriptor:'
				caption: 'Rename project version'.
	newVersionName isNil ifTrue: [^self].
	newVersionName isEmpty] 
			whileTrue: [MessageBox errorMsg: 'Version name can not be empty'].
	newVersionName = projectEdition versionDescriptor 
		ifFalse: 
			[self sourceControl renameProjectVersion: projectEdition newVersionDescriptor: newVersionName.
			self refreshProjectEditionsList]!

menuSortPackagesByPrerequisites
	| projectEdition containedEditions counter edition |
	self hasOpenProjectEditionSelected ifFalse: [^self].
	projectEdition := self selectedSingleProjectEditionOrNil.
	containedEditions := projectEdition packageEditions.
	counter := 0.
	(projectEdition allPrerequisitePackageNamesIncludingBase: true) do: 
			[:eachName | 
			(edition := containedEditions detect: [:each | each name = eachName] ifNone: []) notNil 
				ifTrue: 
					[self sourceControl 
						addPackageEdition: edition
						beforeIndex: (counter := counter + 1)
						onProjectEdition: projectEdition]].
	self refreshProjectEditionsList!

menuVersionAndReplaceWithLoaded
	| packagesToVersion package loadedPackageEdition importInformation |
	packagesToVersion := OrderedCollection new.
	packageEditionsPresenter selection do: 
			[:eachPackageEdition | 
			(package := Package manager packageNamed: eachPackageEdition name ifNone: []) isNil 
				ifTrue: 
					[MessageBox notify: 'Can not version selected packages.

Package "' , eachPackageEdition name 
								, '" is not present in the image'.
					^self].
			((self sourceControl getPackageEditionsFor: eachPackageEdition name) 
				detect: [:each | each isLoadedAndNotChanged]
				ifNone: []) isNil 
				ifTrue: [packagesToVersion add: package]].
	packagesToVersion isEmpty 
		ifFalse: 
			[(importInformation := packagesToVersion size == 1 
						ifTrue: 
							[(StsImportInformationDialog createOn: (StsImportInformationModel package: packagesToVersion first))
								caption: 'Versioning package ' , packagesToVersion first name;
								showModal]
						ifFalse: 
							[(StsImportInformationDialog 
								createOn: (StsImportInformationModel projectForPackages: self selectedSingleProjectEditionOrNil))
								caption: 'About to version selected packages';
								showModal]) 
					isNil ifTrue: [^self].
			packagesToVersion do: 
					[:eachPackage | 
					self sourceControl 
						basicVersionPackage: eachPackage
						versionDescriptor: importInformation version
						developer: importInformation developer
						previousEdition: (packagesToVersion size == 1 
								ifTrue: [importInformation previousEdition]
								ifFalse: 
									[(self sourceControl getPackageEditionsFor: eachPackage name) 
										detect: [:each | each isLoadedOrChangedAfterLoad]
										ifNone: []])
						blessing: importInformation blessing
						comment: importInformation comment asString
						versionComment: importInformation versionComment asString
						checkExisting: false
						silentBool: false]].
	packageEditionsPresenter selection do: 
			[:eachPackageEdition | 
			loadedPackageEdition := (self sourceControl getPackageEditionsFor: eachPackageEdition name) 
						detect: [:each | each isLoadedAndNotChanged]
						ifNone: [].
			loadedPackageEdition isNil 
				ifFalse: 
					[self sourceControl addPackageEdition: loadedPackageEdition
						toProjectEdition: projectEditionsPresenter selection first]].
	self refreshProjectEditionsList!

menuViewChangesFrom: fromDate until: toDate 
	| allClasses packageEdition allMethodEditions changes |
	packageEdition := self selectedSinglePackageEditionOrNil.
	allClasses := Set new.
	packageEdition classes do: [:eachClassEdition | allClasses add: eachClassEdition name asSymbol].
	(Package manager packageNamed: packageEdition name ifNone: []) 
		ifNotNil: [:package | package classes do: [:eachClassEdition | allClasses add: eachClassEdition name asSymbol]].
	allMethodEditions := OrderedCollection new.
	allClasses asSortedCollection do: 
			[:each | 
			allMethodEditions addAll: (self sourceControl 
						getAllMethodEditionsFor: each
						from: fromDate
						until: toDate)].
	changes := allMethodEditions collect: 
					[:each | 
					(StsChangedMethodNode new)
						description: 'new or changed method';
						leftEdition: each;
						rightEdition: (each methodClass isNil 
									ifFalse: 
										[(each methodClass compiledMethodAt: each selector ifAbsent: []) 
											ifNotNil: 
												[:compiledMethod | 
												self sourceControl getMethodEditionFor: compiledMethod
													in: self sourceControl databaseConnection newLongReadOnlyTransaction]])].
	(StsComparisonBrowser create)
		setChanges: changes;
		caption: 'Changes Browser - New or Changed Methods from ' 
					, (fromDate isNil ifTrue: [''] ifFalse: [fromDate displayString]) 
						, (toDate isNil ifTrue: [''] ifFalse: [' until ' , toDate displayString]);
		showShell!

menuViewChangesFromMonth
	self menuViewChangesFrom: (Date today subtractMonths: 1) until: nil!

menuViewChangesFromToday
	self menuViewChangesFrom: Date today until: nil!

menuViewChangesFromWeek
	self menuViewChangesFrom: (Date today subtractDays: 7) until: nil!

menuViewChangesFromYear
	self menuViewChangesFrom: (Date today subtractMonths: 12) until: nil!

menuViewChangesFromYesterday
	self menuViewChangesFrom: Date yesterday until: Date yesterday!

missingFirstLevelPrerequisiteNamesFor: packageEditions in: aProjectEdition 
	"Private - Answer those prerequisite package names that are not currently part of aProjectEdition"

	| prereqs |
	prereqs := self firstLevelPrerequisiteNamesFor: packageEditions in: aProjectEdition.
	aProjectEdition packageEditions do: [:each | prereqs remove: each name ifAbsent: []].
	^prereqs!

moveDownPackageEdition
	| selectedProjectEdition index selectedPackageEdition newPosition |
	(selectedPackageEdition := self selectedSinglePackageEditionOrNil) isNil ifTrue: [^self].
	selectedProjectEdition := self selectedSingleProjectEditionOrNil.
	(index := packageEditionsPresenter selectionByIndex first) 
		< selectedProjectEdition packageEditions size 
			ifTrue: 
				[self sourceControl 
					addPackageEdition: selectedPackageEdition
					beforeIndex: (newPosition := index + 1)
					onProjectEdition: selectedProjectEdition.
				self refreshProjectEditionsList.
				packageEditionsPresenter selectionByIndex: (Array with: newPosition)]!

moveFirstPackageEdition
	| selectedPackageEdition |
	(selectedPackageEdition := self selectedSinglePackageEditionOrNil) isNil ifTrue: [^self].
	packageEditionsPresenter selectionByIndex first > 1 
		ifTrue: 
			[self sourceControl 
				addPackageEdition: selectedPackageEdition
				beforeIndex: 1
				onProjectEdition: self selectedSingleProjectEditionOrNil.
			self refreshProjectEditionsList.
			packageEditionsPresenter selectionByIndex: (Array with: 1)]!

moveLastPackageEdition
	| selectedProjectEdition selectedPackage newPosition |
	(selectedPackage := self selectedSinglePackageEditionOrNil) isNil ifTrue: [^self].
	selectedProjectEdition := self selectedSingleProjectEditionOrNil.
	packageEditionsPresenter selectionByIndex first 
		< (newPosition := selectedProjectEdition packageEditions size) 
			ifTrue: 
				[self sourceControl 
					addPackageEdition: selectedPackage
					beforeIndex: newPosition
					onProjectEdition: selectedProjectEdition.
				self refreshProjectEditionsList.
				packageEditionsPresenter selectionByIndex: (Array with: newPosition)]!

moveUpPackageEdition
	| index selectedPackageEdition newPosition |
	(selectedPackageEdition := self selectedSinglePackageEditionOrNil) isNil ifTrue: [^self].
	(index := packageEditionsPresenter selectionByIndex first) > 1 
		ifTrue: 
			[self sourceControl 
				addPackageEdition: selectedPackageEdition
				beforeIndex: (newPosition := index - 1)
				onProjectEdition: self selectedSingleProjectEditionOrNil.
			self refreshProjectEditionsList.
			packageEditionsPresenter selectionByIndex: (Array with: newPosition)]!

newProject
	| newProjectName |
	((newProjectName := Prompter 
				on: ''
				prompt: 'Enter new project name:'
				caption: 'New project') notNil 
		and: [newProjectName notEmpty]) 
			ifTrue: 
				[| newProject |
				newProject := self sourceControl createNewProjectNamed: newProjectName
							createInitialOpenEdition: true.
				self refreshProjectsList.
				projectsPresenter selection: newProject name]!

onAboutToDisplayMenu: addPrerequisitesMenu 
	"Private - The system is about to display the <Menu>, popup, this is our chance
	to fiddle with it and display the recent files list if appropriate."

	| suggestedPackageNamesForSelections suggestedPackageNamesForProject |
	super onAboutToDisplayMenu: addPrerequisitesMenu.
	addPrerequisitesMenu name == #addPrerequisitesMenu ifFalse: [^self].
	addPrerequisitesMenu clear.
	suggestedPackageNamesForSelections := self 
				suggestedPackageNamesToAddForEditions: self selectedPackageEditions.
	suggestedPackageNamesForProject := self 
				suggestedPackageNamesToAddForEditions: self selectedSingleProjectEditionOrNil packageEditions.
	suggestedPackageNamesForProject removeAll: suggestedPackageNamesForSelections.
	(suggestedPackageNamesForSelections isEmpty and: [suggestedPackageNamesForProject isEmpty]) 
		ifTrue: [^addPrerequisitesMenu addCommand: #dummy description: 'None'].
	suggestedPackageNamesForSelections notEmpty 
		ifTrue: 
			[addPrerequisitesMenu addCommand: #dummy description: 'For selected package'.
			suggestedPackageNamesForSelections asSortedCollection do: 
					[:each | 
					addPrerequisitesMenu 
						addCommand: (Message selector: #addPackageEdition: argument: each)
						description: each
						image: (self iconForPackageName: each)]].
	suggestedPackageNamesForProject notEmpty 
		ifTrue: 
			[addPrerequisitesMenu
				addSeparator;
				addCommand: #dummy description: 'For all project packages'.
			suggestedPackageNamesForProject asSortedCollection do: 
					[:each | 
					addPrerequisitesMenu 
						addCommand: (Message selector: #addPackageEdition: argument: each)
						description: each
						image: (self iconForPackageName: each)]]!

onDeferredStartup
	self refreshProjectsList!

onProjectEditionSelected
	| selection |
	(selection := projectEditionsPresenter selection) notEmpty 
		ifTrue: 
			[packageEditionsPresenter list: (selection := selection first) packageEditions.
			commentPresenter value: selection comment.
			versionCommentPresenter value: selection versionComment]
		ifFalse: 
			[packageEditionsPresenter clear.
			commentPresenter clear.
			versionCommentPresenter clear]!

onProjectSelected
	self refreshProjectEditionsList.
	projectsPresenter selectionOrNil notNil 
		ifTrue: [projectEditionsPresenter selection: (projectEditionsPresenter list copyFrom: 1 to: 1)]!

onStartup
	SessionManager current inputState queueDeferredAction: [self onDeferredStartup]!

onViewOpened
	super onViewOpened.
	self refreshProjectsList!

purgeProject
	(MessageBox 
		confirm: 'Warning: if you continue the project and all its editions 
will be permamently removed from the repository.

Are you sure you want to continue?'
		caption: 'Purging project ' , projectsPresenter selection) 
			ifTrue: 
				[self sourceControl purgeProject: projectsPresenter selection.
				self refreshProjectsList]!

purgeProjectEdition
	(MessageBox 
		confirm: 'Warning: if you continue the selected project edition
will be permamently removed from the repository.

Are you sure you want to continue?'
		caption: 'Purging project edition ' , projectEditionsPresenter selection first versionDescriptor) 
			ifTrue: 
				[self sourceControl purgeProjectEdition: projectEditionsPresenter selection first.
				self refreshProjectEditionsList]!

queryCommand: query 
	| selector |
	selector := query commandSymbol.
	(#(#purgeProject #salvageProjectEdition) includes: selector) 
		ifTrue: 
			[query isEnabled: self selectedProjectNameOrNil notNil.
			^true].
	selector == #compareProjectEditions 
		ifTrue: 
			[query isEnabled: self selectedProjectEditions size = 2.
			^true].
	selector == #compareProjectEditionWithPreviousVersion 
		ifTrue: 
			[query isEnabled: (self selectedSingleProjectEditionOrNil notNil 
						and: [self selectedSingleProjectEditionOrNil previousEdition notNil]).
			^true].
	(#(#loadProjectEdition #compareProjectEditionWithImage #showProjectHistory #purgeProjectEdition #menuCopyProjectEditionTo #menuChangeProjectBlessingLevel #menuChangeProjectVersionComment) 
		includes: selector) 
			ifTrue: 
				[query isEnabled: self selectedSingleProjectEditionOrNil notNil.
				^true].
	(#(#createNewProjectEdition #menuRenameVersion #menuExportProject #menuExportProjectToURL) 
		includes: selector) 
			ifTrue: 
				[query isEnabled: (self selectedSingleProjectEditionOrNil notNil 
							and: [self hasOpenProjectEditionSelected not]).
				^true].
	(#(#addPackageEdition #versionOpenProjectEdition #addPrerequisitesMenu #menuImportPackage #menuChangeProjectComment #menuSortPackagesByPrerequisites) 
		includes: selector) 
			ifTrue: 
				[query isEnabled: self hasOpenProjectEditionSelected.
				^true].
	#removePackageEdition == selector 
		ifTrue: 
			[query isEnabled: (self hasOpenProjectEditionSelected and: [self selectedPackageEditions notEmpty]).
			^true].
	(#(#moveFirstPackageEdition #moveUpPackageEdition #moveDownPackageEdition #moveLastPackageEdition) 
		includes: selector) 
			ifTrue: 
				[query 
					isEnabled: (self selectedSinglePackageEditionOrNil notNil and: [self hasOpenProjectEditionSelected]).
				^true].
	#replaceWithLoadedEdition == selector 
		ifTrue: 
			[query isEnabled: (self selectedPackageEditions notEmpty and: [self hasOpenProjectEditionSelected]).
			^true].
	#menuVersionAndReplaceWithLoaded == selector 
		ifTrue: 
			[query 
				isEnabled: (self hasOpenProjectEditionSelected and: 
							[packageEditionsPresenter selection notEmpty and: 
									[(packageEditionsPresenter selection allSatisfy: [:each | each isLoadedAndNotChanged]) not 
										and: [packageEditionsPresenter selection allSatisfy: [:each | each isSameNamedPackageLoaded]]]]).
			^true].
	(#(#comparePackageEditionWith #browsePackageEditions #menuPackageEditionShowVersionHistory #menuViewChangesFromToday #menuViewChangesFromYesterday #menuViewChangesFromWeek #menuViewChangesFromMonth #menuViewChangesFromYear #menuChangePackageBlessingLevel) 
		includes: selector) 
			ifTrue: 
				[query isEnabled: self selectedSinglePackageEditionOrNil notNil.
				^true].
	(#(#loadPackageEdition #menuExportPackageEdition #menuFileOutPackagesAsSmalltalkXChangeSet #menuFileOutPackagesAsSqueakChangeSet #menuFileOutPackagesAsVWChangeSet #comparePackageEditionWithLoadedPackage) 
		includes: selector) 
			ifTrue: 
				[query isEnabled: self selectedPackageEditions notEmpty.
				^true].
	#comparePackageEditionWithImage == selector 
		ifTrue: 
			[query isEnabled: (self selectedSinglePackageEditionOrNil 
						ifNotNil: [:packageEdition | packageEdition isSameNamedPackageLoaded]
						ifNil: [false]).
			^true].
	^super queryCommand: query!

refreshProjectEditionsList
	| selection |
	projectsPresenter selectionOrNil isNil 
		ifTrue: 
			[projectEditionsPresenter clear.
			commentPresenter clear.
			versionCommentPresenter clear]
		ifFalse: 
			[selection := projectEditionsPresenter selection collect: [:each | each versionIdString].
			projectEditionsPresenter 
				list: (self sourceControl getProjectEditionsFor: projectsPresenter selectionOrNil).
			projectEditionsPresenter selection: (selection := projectEditionsPresenter list 
								select: [:each | selection includes: each versionIdString]).
			selection isEmpty 
				ifTrue: 
					[commentPresenter clear.
					versionCommentPresenter clear]
				ifFalse: 
					[selection := selection first.
					commentPresenter value: selection comment.
					versionCommentPresenter value: selection versionComment]]!

refreshProjectsList
	| selectedProject projects |
	selectedProject := projectsPresenter selectionOrNil.
	projectsPresenter list: (projects := self sourceControl getAllProjectNames).
	selectedProject notNil 
		ifTrue: 
			[projectsPresenter selection: (projects detect: [:each | each = selectedProject] ifNone: [^self])]!

removePackageEdition
	packageEditionsPresenter selection do: 
			[:eachEdition | 
			self sourceControl removePackageNamed: eachEdition name
				fromProjectEdition: projectEditionsPresenter selection first].
	self refreshProjectEditionsList!

renameProject
	| newName oldName newNames |
	(oldName := projectsPresenter selectionOrNil) isNil ifTrue: [^self].
	(newName := Prompter 
				on: oldName
				prompt: 'Enter new project name'
				caption: 'Renaming project') isNil 
		ifTrue: [^self].
	(self sourceControl renameProject: oldName to: newName) 
		ifTrue: 
			[newNames := self sourceControl getAllProjectNames.
			newName := newNames detect: [:each | each = newName].
			projectsPresenter
				list: newNames;
				selection: newName]!

replaceWithLoadedEdition
	| loadedPackageEdition |
	packageEditionsPresenter selection do: 
			[:eachPackageEdition | 
			loadedPackageEdition := (self sourceControl getPackageEditionsFor: eachPackageEdition name) 
						detect: [:each | each isLoaded]
						ifNone: [].
			loadedPackageEdition isNil 
				ifFalse: 
					[self sourceControl addPackageEdition: loadedPackageEdition
						toProjectEdition: projectEditionsPresenter selection first]].
	self refreshProjectEditionsList!

salvageProject
	self sourceControl salvageLastPurgedProject ifTrue: [self refreshProjectsList]!

salvageProjectEdition
	(self sourceControl salvageLastPurgedProjectEditionFor: projectsPresenter selection) 
		ifTrue: [self refreshProjectEditionsList]!

selectedLoadedPackageOrNil
	"Private - Answer the package selected in the packages pane if it is loaded in the image, or nil otherwise"

	^Package manager packageNamed: self selectedSinglePackageEditionOrNil name ifNone: []!

selectedPackageEditions
	^packageEditionsPresenter selection!

selectedProjectEditions
	^projectEditionsPresenter selection!

selectedProjectNameOrNil
	^projectsPresenter selectionOrNil!

selectedSinglePackageEditionOrNil
	^packageEditionsPresenter selection size = 1 ifTrue: [packageEditionsPresenter selection first]!

selectedSingleProjectEditionOrNil
	^projectEditionsPresenter selection size = 1 ifTrue: [projectEditionsPresenter selection first]!

showProjectHistory
	(StsVersionTreeDiagram create)
		showShell;
		setEditions: projectEditionsPresenter list selectedEdition: self selectedSingleProjectEditionOrNil!

suggestedPackageNamesToAddForEditions: packageEditionsToSuggest 
	"Private - Answer a collection of package names that could be added to the currently
	selected project edition. This is derived by taking the missing first level prerequisites
	for all the selected packages in the project and then ignoring the ones that are already
	present or that are base image packages."

	| selectedProjectEdition |
	selectedProjectEdition := self selectedSingleProjectEditionOrNil.
	selectedProjectEdition ifNil: [^Array new].
	^(self missingFirstLevelPrerequisiteNamesFor: packageEditionsToSuggest in: selectedProjectEdition) 
		reject: [:eachName | self isBasePackageName: eachName]!

versionOpenProjectEdition
	self sourceControl versionProjectEdition: self selectedSingleProjectEditionOrNil.
	self refreshProjectEditionsList! !
!StsProjectBrowserShell categoriesFor: #addPackageEdition!commands!public! !
!StsProjectBrowserShell categoriesFor: #addPackageEdition:!operations!private! !
!StsProjectBrowserShell categoriesFor: #browsePackageEditions!commands!private! !
!StsProjectBrowserShell categoriesFor: #compareLoadedPackagesWithEditions:!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #comparePackageEditionWith!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #comparePackageEditionWithImage!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #comparePackageEditionWithLoadedPackage!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #compareProjectEdition:with:!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #compareProjectEditions!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #compareProjectEditionWithImage!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #compareProjectEditionWithPreviousVersion!comparing!operations!private! !
!StsProjectBrowserShell categoriesFor: #createComponents!initializing!private! !
!StsProjectBrowserShell categoriesFor: #createNewProjectEdition!commands!private! !
!StsProjectBrowserShell categoriesFor: #createNewProjectEditionBranchedFrom:!operations!private! !
!StsProjectBrowserShell categoriesFor: #createSchematicWiring!initializing!private! !
!StsProjectBrowserShell categoriesFor: #defaultHelpId!constants!public! !
!StsProjectBrowserShell categoriesFor: #firstLevelPrerequisiteNamesFor:in:!helpers!private! !
!StsProjectBrowserShell categoriesFor: #hasOpenProjectEditionSelected!private! !
!StsProjectBrowserShell categoriesFor: #iconForPackageName:!helpers!private! !
!StsProjectBrowserShell categoriesFor: #isBasePackageName:!private!testing! !
!StsProjectBrowserShell categoriesFor: #loadPackageEdition!commands!public! !
!StsProjectBrowserShell categoriesFor: #loadProjectEdition!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuChangePackageBlessingLevel!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuChangeProjectBlessingLevel!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuChangeProjectComment!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuChangeProjectVersionComment!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuCopyProjectEditionTo!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuExportPackageEdition!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuExportProject!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuFileOutPackagesAsSmalltalkXChangeSet!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuFileOutPackagesAsSqueakChangeSet!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuFileOutPackagesAsVASTAppFileOut!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuFileOutPackagesAsVWChangeSet!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuImportPackage!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuImportProject!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuImportProjectFromStpFile!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuPackageEditionShowVersionHistory!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuRenameVersion!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuSortPackagesByPrerequisites!comparing!operations!public! !
!StsProjectBrowserShell categoriesFor: #menuVersionAndReplaceWithLoaded!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuViewChangesFrom:until:!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuViewChangesFromMonth!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuViewChangesFromToday!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuViewChangesFromWeek!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuViewChangesFromYear!commands!public! !
!StsProjectBrowserShell categoriesFor: #menuViewChangesFromYesterday!commands!public! !
!StsProjectBrowserShell categoriesFor: #missingFirstLevelPrerequisiteNamesFor:in:!helpers!private! !
!StsProjectBrowserShell categoriesFor: #moveDownPackageEdition!commands!private! !
!StsProjectBrowserShell categoriesFor: #moveFirstPackageEdition!commands!private! !
!StsProjectBrowserShell categoriesFor: #moveLastPackageEdition!commands!private! !
!StsProjectBrowserShell categoriesFor: #moveUpPackageEdition!commands!private! !
!StsProjectBrowserShell categoriesFor: #newProject!commands!public! !
!StsProjectBrowserShell categoriesFor: #onAboutToDisplayMenu:!event handling!private! !
!StsProjectBrowserShell categoriesFor: #onDeferredStartup!event handling!private! !
!StsProjectBrowserShell categoriesFor: #onProjectEditionSelected!event handling!private! !
!StsProjectBrowserShell categoriesFor: #onProjectSelected!event handling!private! !
!StsProjectBrowserShell categoriesFor: #onStartup!event handling!private! !
!StsProjectBrowserShell categoriesFor: #onViewOpened!event handling!private! !
!StsProjectBrowserShell categoriesFor: #purgeProject!private! !
!StsProjectBrowserShell categoriesFor: #purgeProjectEdition!private! !
!StsProjectBrowserShell categoriesFor: #queryCommand:!private! !
!StsProjectBrowserShell categoriesFor: #refreshProjectEditionsList!private! !
!StsProjectBrowserShell categoriesFor: #refreshProjectsList!private! !
!StsProjectBrowserShell categoriesFor: #removePackageEdition!commands!public! !
!StsProjectBrowserShell categoriesFor: #renameProject!commands!public! !
!StsProjectBrowserShell categoriesFor: #replaceWithLoadedEdition!commands!public! !
!StsProjectBrowserShell categoriesFor: #salvageProject!commands!public! !
!StsProjectBrowserShell categoriesFor: #salvageProjectEdition!commands!public! !
!StsProjectBrowserShell categoriesFor: #selectedLoadedPackageOrNil!accessing!private! !
!StsProjectBrowserShell categoriesFor: #selectedPackageEditions!accessing!private! !
!StsProjectBrowserShell categoriesFor: #selectedProjectEditions!accessing!private! !
!StsProjectBrowserShell categoriesFor: #selectedProjectNameOrNil!private! !
!StsProjectBrowserShell categoriesFor: #selectedSinglePackageEditionOrNil!accessing!private! !
!StsProjectBrowserShell categoriesFor: #selectedSingleProjectEditionOrNil!accessing!private! !
!StsProjectBrowserShell categoriesFor: #showProjectHistory!accessing!public! !
!StsProjectBrowserShell categoriesFor: #suggestedPackageNamesToAddForEditions:!private! !
!StsProjectBrowserShell categoriesFor: #versionOpenProjectEdition!private! !

!StsProjectBrowserShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Project Editions Browser'!

icon
	^StsProjectEdition icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon to: Smalltalk developmentSystem sourceTrackingToolsFolder;
		registerTool: self.
	self reuseIfOpen: true.
	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

onStartup
	self primAllSubinstances do: [:i | i onStartup]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 0 416 34 2 8 1140851500 131137 544 0 466 496 0 519 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 544 466 496 8 4294906655 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 0 544 34 2 8 1140850688 131073 800 0 0 0 7 0 0 0 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 1 1 706 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 706 193 193 0 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 0 544 34 2 8 1140850688 131073 1136 0 0 0 7 0 0 0 1136 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 63 1 706 991 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1088 1104 0 27 8 'smalltalkTools' 170 192 1088 8 #() 170 176 1088 0 1 0 706 33 31 706 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 1939 51 544 962 #updateSizePosted 1088 544 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 201 3 0 0 25 0 0 0] 34 2 800 1136 1104 0 27 410 ##(Smalltalk.StatusBar) 34 18 0 416 34 2 8 1140850956 1 1664 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 626 0 true 658 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 720 0 1664 0 8 4294903691 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1664 0 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'versionInformation' 34 1 1872 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1664 0 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 991 706 1939 43 1664 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 239 1 0 0 201 3 0 0 4 2 0 0] 8 #() 1104 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 2144 0 466 496 0 7 0 0 0 2144 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 0 2144 34 2 8 1140850688 131073 2288 0 466 496 0 7 0 0 0 2288 2226 170 176 1088 true 170 192 34 2 410 ##(Smalltalk.MultipleSelectionListView) 34 30 0 2288 34 2 8 1140953161 1025 2432 590662 2 ##(Smalltalk.ListModel) 138 144 1088 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 26 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #refreshProjectsList 8 'Update list' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2642 1 2674 #versionOpenProjectEdition 8 '&Version New Edition...' 1 1 0 0 0 2642 1 2674 #createNewProjectEdition 8 'Create &New Edition' 1 1 0 0 0 2642 1 2674 #menuCopyProjectEditionTo 8 'Copy Edition to Another Project ...' 1 1 0 0 0 2642 1 2674 #loadProjectEdition 8 'Load &Edition' 1 1 0 0 0 2642 1 2674 #compareProjectEditions 8 '&Compare Editions' 1 1 0 0 0 2642 1 2674 #compareProjectEditionWithImage 8 'Compare with Image' 1 1 0 0 0 2642 1 2674 #compareProjectEditionWithPreviousVersion 8 'Compare with Previous Edition' 1 1 0 0 0 2722 4097 2642 1 2674 #menuExportProject 8 'E&xport to File ...' 1 1 0 0 0 2642 1 2674 #menuExportProjectToURL 8 'Export to Repository Server ...' 1 1 0 0 0 2642 1 2674 #menuImportProject 8 '&Import from File ...' 1 1 0 0 0 2642 1 2674 #menuImportProjectFromURL 8 'Import from Repository Server ...' 1 1 0 0 0 2722 4097 2642 1 2674 #showProjectHistory 8 'Show Project History' 1 1 0 0 0 2722 4097 2642 1 2674 #menuRenameVersion 8 '&Rename Edition...' 1 1 0 0 0 2642 1 2674 #purgeProjectEdition 8 '&Purge Edition from Repository...' 1 1 0 0 0 2642 1 2674 #salvageProjectEdition 8 '&Salvage Last Purged' 1 1 0 0 0 2722 4097 2642 1 2674 #menuChangeProjectBlessingLevel 8 'Change blessing level ...' 1 1 0 0 0 2642 1 2674 #menuChangeProjectComment 8 'Change Project Comment ...' 1 1 0 0 0 2642 1 2674 #menuChangeProjectVersionComment 8 'Change Project Version Comment ...' 1 1 0 0 0 2722 4097 2642 1 2674 #menuSortPackagesByPrerequisites 8 'Sort Packages by Prerequisites' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2432 0 8 4294905883 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 0 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Project Editions' 337 #left 459270 ##(Smalltalk.Message) #versionDescriptor 8 #() 0 0 0 2432 0 1 0 0 3810 8 'Timestamp' 501 #left 787814 3 ##(Smalltalk.BlockClosure) 0 459302 ##(Smalltalk.Context) 1 1 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 9 3856 8 'doIt' 34 2 8 '[:edition | edition timestamp printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #timestamp #printString 17 257 3858 #timestamp 3888 0 0 0 2432 0 1 0 0 3810 8 'Developer' 403 #left 3858 #developer 3888 0 0 0 2432 0 3 0 0 3810 8 'Blessing' 201 #left 3858 #displayString 8 #() 3858 #<= 4240 3858 #blessingString 4240 0 2432 0 1 0 0 #report 1088 0 131169 0 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 1447 465 2432 962 #contextMenu: 34 1 2608 2432 962 #text: 34 1 8 'Project Editions' 2432 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 211 2 0 0 232 0 0 0] 8 #() 1104 0 27 8 'projectEditions' 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 493 1 706 1447 941 2288 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 246 0 0 0 0 0 0 0 201 3 0 0 214 1 0 0] 34 3 2432 410 ##(Smalltalk.Splitter) 34 12 0 2288 34 2 8 1140850688 1 4720 0 466 496 0 519 0 0 0 4720 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 465 706 1447 11 4720 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 232 0 0 0 211 2 0 0 237 0 0 0] 8 #() 1104 0 27 410 ##(Smalltalk.ContainerView) 34 15 0 2288 34 2 8 1140850688 131073 4960 0 0 0 7 0 0 0 4960 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.CardContainer) 34 16 0 4960 34 2 8 1140850688 393217 5088 0 466 8 4278190080 0 7 0 0 0 5088 655878 ##(Smalltalk.CardLayout) 138 144 34 3 721414 ##(Smalltalk.Association) 8 'Project Comment' 410 ##(Smalltalk.ScintillaView) 34 50 0 5088 34 2 8 1176572228 1 5296 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 196934 1 ##(Smalltalk.RGB) 30932991 0 5 2594 0 true 34 12 2642 1 2674 #accept 8 '&Accept' 1 1 0 0 0 2722 4097 2594 0 true 34 8 2642 1 2674 #undo 8 '&Undo' 1 1 0 0 0 2722 4097 2642 1 2674 #cutSelection 8 'Cu&t' 1 1 0 0 0 2642 1 2674 #copySelection 8 '&Copy' 1 1 0 0 0 2642 1 2674 #pasteClipboard 8 '&Paste' 1 1 0 0 0 2642 1 2674 #clearSelection 8 'De&lete' 1 1 0 0 0 2722 4097 2642 1 2674 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 2642 1 2674 #clear 8 'Clea&r' 1 1 0 0 0 2722 4097 2642 1 2674 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 2642 1 2674 #displayIt 8 '&Display It' 1 1 0 0 0 2642 1 2674 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 2642 1 2674 #inspectIt 8 '&Inspect It' 1 1 6034 0 true 6080 8 'BasicInspector.ico' 6128 0 0 2642 1 2674 #debugIt 8 'Deb&ug It' 1 1 6034 0 true 6080 8 'Debugger.ico' 6128 0 0 2722 4097 2594 0 true 34 2 2642 2097153 2674 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 2642 1 2674 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 5296 5426 8454145 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 11 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 6690 77 786694 ##(Smalltalk.IndexedColor) 33554457 6738 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 6704 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 5296 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1088 0 170 176 1088 9215 0 0 0 0 6738 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 6656 0 0 0 0 1 0 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 5296 33423361 3 false #Warning 0 0 0 0 0 0 #Error 7026 17 5296 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 6690 1029 0 5426 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 6690 1027 5426 60239 5426 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 6690 1031 5426 335 5426 31317503 1 0 0 0 0 #Error 0 0 0 0 898 138 144 34 6 962 #createAt:extent: 34 2 706 9 55 706 1425 351 5296 962 #contextMenu: 34 1 5456 5296 962 #modificationEventMask: 8 #(4607) 5296 962 #caretPeriod: 8 #(530) 5296 962 #wordWrap: 8 #(true) 5296 962 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5296 1 3 0 0 5 0 7522 3 5296 1 0 0 67108863 5 0 7522 5 5296 1 0 0 0 5 0 5296 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 204 2 0 0 202 0 0 0] 8 #() 1104 0 29 5250 8 'Project Version Comment' 410 ##(Smalltalk.ScintillaView) 34 50 0 5088 34 2 8 1176572228 1 7664 5362 0 false 5408 0 5426 30932991 0 5 2594 0 true 34 12 2642 1 2674 #accept 5520 1 1 0 0 0 2722 4097 2594 0 true 34 8 2642 1 2674 #undo 5616 1 1 0 0 0 2722 4097 2642 1 2674 #cutSelection 5680 1 1 0 0 0 2642 1 2674 #copySelection 5728 1 1 0 0 0 2642 1 2674 #pasteClipboard 5776 1 1 0 0 0 2642 1 2674 #clearSelection 5824 1 1 0 0 0 2722 4097 2642 1 2674 #selectAll 5888 1 1 0 0 0 5904 0 134217729 0 0 0 0 0 2642 1 2674 #clear 5952 1 1 0 0 0 2722 4097 2642 1 2674 #browseIt 6016 1 1 6034 0 true 6080 6096 6128 0 0 2642 1 2674 #displayIt 6192 1 1 0 0 0 2642 1 2674 #evaluateIt 6240 1 1 0 0 0 2642 1 2674 #inspectIt 6288 1 1 6034 0 true 6080 6320 6128 0 0 2642 1 2674 #debugIt 6368 1 1 6034 0 true 6080 6400 6128 0 0 2722 4097 2594 0 true 34 2 2642 2097153 2674 #browseDefinitions 6496 1 1 0 0 0 2642 1 2674 #browseReferences 6544 1 1 0 0 0 6560 0 134217729 0 0 0 0 0 6576 0 134217729 0 0 0 0 0 0 0 7664 5426 8454145 8 4294906539 6626 0 0 11 0 170 192 34 4 #normal 6690 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 6690 77 6752 6768 1 0 0 0 0 #callTip 0 0 0 34 40 8544 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6802 #normal 170 192 34 2 #default 6866 1 0 0 0 7664 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1088 0 170 176 1088 9215 0 0 0 0 6928 0 0 65 0 0 0 6944 3 170 192 34 2 #container 8512 0 0 0 0 1 0 170 192 34 4 #Warning 7026 19 7664 33423361 3 false #Warning 0 0 0 0 0 0 #Error 7026 17 7664 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 6690 1029 0 5426 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 6690 1027 5426 60239 5426 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 6690 1031 5426 335 5426 31317503 1 0 0 0 0 #Error 0 0 0 0 898 138 144 34 6 962 #createAt:extent: 34 2 706 9 55 706 1425 351 7664 962 #contextMenu: 34 1 7760 7664 962 #modificationEventMask: 8 #(4607) 7664 962 #caretPeriod: 8 #(530) 7664 962 #wordWrap: 8 #(true) 7664 962 #margins: 34 1 34 3 7522 1 7664 1 3 0 0 5 0 7522 3 7664 1 0 0 67108863 5 0 7522 5 7664 1 0 0 0 5 0 7664 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 204 2 0 0 202 0 0 0] 8 #() 1104 0 29 5250 8 'Packages in Load Order' 410 ##(Smalltalk.MultipleSelectionListView) 34 30 0 5088 34 2 8 1140953153 1025 9360 2498 138 144 1088 0 2560 466 496 0 7 2594 0 true 34 22 2642 1 2674 #addPackageEdition 8 '&Add/Replace Edition with...' 1 1 0 0 0 2642 1 2674 #replaceWithLoadedEdition 8 'Re&place with loaded Edition' 1 1 0 0 0 2642 1 2674 #menuVersionAndReplaceWithLoaded 8 '&Version Package(s) and replace with loaded Edition...' 1 1 0 0 0 2722 4097 2642 1 2674 #removePackageEdition 8 '&Remove Package Edition' 1 1 0 0 0 2722 4097 2642 1 2674 #loadPackageEdition 8 '&Load Edition' 1 1 0 0 0 2642 1 2674 #browsePackageEditions 8 '&Browse Editions' 1 1 0 0 0 2642 1 2674 #comparePackageEditionWithLoadedPackage 8 'Compare with loaded package' 1 1 0 0 0 2642 1 2674 #comparePackageEditionWith 8 'Compare &with...' 1 1 0 0 0 2722 4097 2642 1 2674 #menuPackageEditionShowVersionHistory 8 'Show Package Edition History' 1 1 0 0 0 2722 4097 2642 1 2674 #menuImportPackage 8 'Import Package to Repository and Add...' 1 1 0 0 0 2642 1 2674 #menuExportPackageEdition 8 'E&xport Package Edition...' 1 1 0 0 0 2594 0 true 34 4 2642 1 2674 #menuFileOutPackagesAsSmalltalkXChangeSet 8 'Smalltalk/X Change Set' 1 1 0 0 0 2642 1 2674 #menuFileOutPackagesAsSqueakChangeSet 8 'Squeak Change Set' 1 1 0 0 0 2642 1 2674 #menuFileOutPackagesAsVASTAppFileOut 8 'VAST App File Out' 1 1 0 0 0 2642 1 2674 #menuFileOutPackagesAsVWChangeSet 8 'VisualWorks Change Set' 1 1 0 0 0 8 'File Out As' 0 1 0 0 0 0 0 2594 0 true 34 6 2642 1 2674 #menuViewChangesFromToday 8 'Today' 1 1 0 0 0 2642 1 2674 #menuViewChangesFromYesterday 8 'Yesterday' 1 1 0 0 0 2722 4097 2642 1 2674 #menuViewChangesFromWeek 8 'Week' 1 1 0 0 0 2642 1 2674 #menuViewChangesFromMonth 8 'Month' 1 1 0 0 0 2642 1 2674 #menuViewChangesFromYear 8 'Year' 1 1 0 0 0 8 'View Changes from...' 0 134217729 0 0 0 0 0 2722 4097 2642 1 2674 #menuChangePackageBlessingLevel 8 'Change blessing level ...' 1 1 0 0 0 2722 4097 2594 0 true 8 #() 8 'Add Prerequisite Package' #addPrerequisitesMenu 134217729 0 0 0 0 0 2642 1 2674 #comparePackageEditionWithImage 8 'Compare with lmage' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 9360 0 8 4294905883 ##(Smalltalk.BasicListAbstract) 0 1904 0 0 0 706 65 65 0 0 138 144 34 6 3810 8 '' 45 #left 0 0 0 0 9360 3938 0 0 4002 4 1 3936 8 'doIt' 8 '[:x | (StsProjectBrowserShell statusIconForPackageEdition: x) imageIndex]' 8 #[32 105 29 17 177 160 106] ##(Smalltalk.StsProjectBrowserShell) #statusIconForPackageEdition: #imageIndex 10928 7 257 0 1 0 0 3810 8 'Package Name' 301 #left 3938 0 3970 1 1 0 0 4002 1 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:each | each displayName ]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 7 0 17 230 32 228 32 158 106 100 105] #displayName 17 257 0 0 0 0 9360 ##(Smalltalk.IconicListAbstract) 1 0 0 3810 8 'Edition' 241 #left 3858 #versionDescriptor 8 #() 0 0 0 9360 0 1 0 0 3810 8 'Timestamp' 361 #left 3938 0 3970 1 1 0 0 4002 2 9 3856 8 'doIt' 34 2 8 '[:edition | edition timestamp printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #timestamp #printString 17 257 3858 #timestamp 11232 0 0 0 9360 0 1 0 0 3810 8 'Developer' 273 #left 3858 #developer 11232 0 0 0 9360 0 3 0 0 3810 8 'Blessing' 201 #left 3858 #displayString 8 #() 3858 #<= 11536 3858 #blessingString 11536 0 9360 0 1 0 0 #report 1088 0 131173 0 8 #(nil) 898 138 144 34 2 962 #createAt:extent: 34 2 706 9 55 706 1425 351 9360 962 #contextMenu: 34 1 9472 9360 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 204 2 0 0 202 0 0 0] 8 #() 1104 0 27 9360 170 192 34 6 5296 8 'comment' 7664 8 'versionComment' 9360 8 'packageEditions' 0 410 ##(Smalltalk.TabView) 34 23 0 5088 34 2 8 1140916736 1 11872 2498 138 144 34 3 9344 5280 7648 0 2560 1730 31 0 1 0 0 0 11872 0 8 4294903993 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 #noIcons 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 1445 417 11872 962 #basicSelectionsByIndex: 34 1 8 #(1) 11872 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11872 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 210 2 0 0 208 0 0 0] 8 #() 1104 0 27 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 51 706 1445 417 5088 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 210 2 0 0 233 0 0 0] 34 4 9360 5296 7664 11872 1104 0 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 12450 #fixedParentRight -1 12450 #fixedParentTop 51 12450 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 0 4960 34 2 8 1140850688 131073 12528 0 0 0 7 0 0 0 12528 5026 170 176 34 4 410 ##(Smalltalk.Toolbar) 34 25 0 12528 34 2 8 1409288972 131137 12640 0 466 8 4278190080 0 519 0 626 0 true 658 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 706 193 193 0 12640 466 12720 8 4294906655 170 192 1088 170 192 34 12 40371 853766 ##(Smalltalk.ToolbarButton) 40371 0 12640 1 2674 #addPackageEdition 8 'Add' 1 1 0 395334 3 ##(Smalltalk.Bitmap) 0 true 6080 8 'ListBar.bmp' 6128 0 7 706 161 33 9 40373 12882 40373 0 12640 1 2674 #removePackageEdition 8 'Remove' 1 1 0 12946 0 true 6080 8 'EditBar.bmp' 6128 0 7 706 193 33 11 40375 12882 40375 0 12640 1 2674 #moveFirstPackageEdition 8 'Move First' 1 1 0 12960 5 40377 12882 40377 0 12640 1 2674 #moveUpPackageEdition 8 'Move Up' 1 1 0 12960 1 40379 12882 40379 0 12640 1 2674 #moveDownPackageEdition 8 'Move Down' 1 1 0 12960 3 40381 12882 40381 0 12640 1 2674 #moveLastPackageEdition 8 'Move Last' 1 1 0 12960 7 34 7 12896 13008 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 12640 3 0 1 13104 13152 13200 13248 170 176 34 4 13056 11 12960 1 0 1 0 706 33 33 706 45 45 0 0 898 138 144 34 2 962 #createAt:extent: 34 2 706 1149 1 706 1407 49 12640 962 #updateSizePosted 1088 12640 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 62 2 0 0 0 0 0 0 253 4 0 0 24 0 0 0] 8 #() 1104 0 27 12418 12480 -1755 12480 -349 12496 1 12512 1 410 ##(Smalltalk.StaticText) 34 16 0 12528 34 2 8 1140850945 65 13600 0 0 0 7 0 0 0 13600 0 8 4294903859 6626 0 0 0 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 1145 49 13600 962 #text: 34 1 8 'Contained Package Editions in their load order' 13600 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 60 2 0 0 24 0 0 0] 8 #() 1104 0 27 12418 12464 1 12450 #fixedPreviousLeft -3 12496 1 12512 1 170 192 1088 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 2905 49 12528 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 5 0 0 24 0 0 0] 34 2 12640 13600 1104 0 27 12418 12464 1 12480 1459 12496 1 12450 #fixedViewTop 49 170 192 1088 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 475 706 1447 467 4960 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 237 0 0 0 211 2 0 0 214 1 0 0] 34 2 12528 5088 1104 0 27 1104 0 27 852486 ##(Smalltalk.ScaledDecimal) 524806 ##(Smalltalk.Fraction) 7 5 3 410 ##(Smalltalk.ListView) 34 30 0 2144 34 2 8 1140920397 1025 14384 2498 138 144 1088 0 2560 466 8 4278190080 0 23 2594 0 true 34 12 2642 1 2674 #refreshProjectsList 8 'Update list' 1 1 0 0 0 2642 1 2674 #newProject 8 '&New Project...' 1 1 0 0 0 2642 1 2674 #menuImportProjectFromStpFile 8 '&Import from STP/STX file...' 1 1 0 0 0 2722 4097 2642 1 2674 #renameProject 8 '&Rename Project...' 1 1 0 0 0 2722 4097 2642 1 2674 #purgeProject 8 '&Purge Project from Repository...' 1 1 0 0 0 2642 1 2674 #salvageProject 8 'Salvage Last Purged' 1 1 0 0 0 2722 4097 2642 1 2674 #createNewProjectEdition 8 '&Create New Edition' 1 1 0 0 0 2642 1 2674 #versionOpenProjectEdition 8 '&Version New Edition' 1 1 0 0 0 2642 1 2674 #showProjectHistory 8 'Show Edition &History' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 14384 0 8 4294905883 3858 #asString 8 #() 3938 0 0 4002 4 1 3936 8 'doIt' 8 '[:x | StsProjectEdition projectIcon imageIndex]' 8 #[32 105 29 159 160 106] ##(Smalltalk.StsProjectEdition) #projectIcon #imageIndex 15088 7 257 0 1904 0 0 0 0 0 0 138 144 34 1 3810 8 'Projects in Repository' 475 #left 3858 #displayString 8 #() 3858 #<= 15248 0 0 14384 0 3 0 0 #report 1088 0 2145 0 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 483 941 14384 962 #contextMenu: 34 1 14512 14384 962 #text: 34 1 8 'Projects in Repository' 14384 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 241 0 0 0 214 1 0 0] 8 #() 1104 0 27 14322 14354 3 5 3 false 170 192 34 2 14384 8 'projects' 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 51 706 1939 941 2144 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 201 3 0 0 239 1 0 0] 34 3 14384 410 ##(Smalltalk.Splitter) 34 12 0 2144 34 2 8 1140850688 1 15776 0 466 496 0 519 0 0 0 15776 898 138 144 34 1 962 #createAt:extent: 34 2 706 483 1 706 11 941 15776 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 0 0 0 0 246 0 0 0 214 1 0 0] 8 #() 1104 0 27 2288 1104 0 27 170 192 34 2 544 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 6 2594 0 true 34 9 2642 1 2674 #fileNew 8 '&New' 8349 1 0 0 0 2642 1 2674 #fileOpen 8 '&Open...' 8351 1 0 0 0 2642 1 2674 #fileFileIn 8 '&File In...' 1 1 0 0 0 2722 4097 2642 1 2674 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 2642 1 2674 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 2642 1 2674 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 2722 4097 2642 1 2674 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 8 '&File' 0 1 0 0 40279 0 0 2594 0 true 34 11 2642 1 2674 #undo 8 '&Undo' 8373 1 0 0 0 2722 4097 2642 1 2674 #cutSelection 8 'Cu&t' 8369 1 0 0 0 2642 1 2674 #copySelection 8 '&Copy' 8327 1 0 0 0 2642 1 2674 #pasteClipboard 8 '&Paste' 8365 1 0 0 0 2642 1 2674 #clearSelection 8 '&Delete' 1 1 0 0 0 2642 1 2674 #selectAll 8 'Select &All' 1 1 0 0 0 2722 4097 2642 1 2674 #find 8 '&Find...' 8333 1 0 0 0 2642 1 2674 #findNext 8 'Find &Next' 229 1 0 0 0 2642 1 2674 #findReplace 8 '&Replace...' 8337 1 0 0 0 8 '&Edit' 0 1 0 0 40299 0 0 2594 0 true 34 7 2642 1 2674 #browseIt 8 '&Browse It' 8325 1 0 0 0 2642 1 2674 #displayIt 8 '&Display It' 8329 1 0 0 0 2642 1 2674 #evaluateIt 8 '&Evaluate It' 8331 1 0 0 0 2642 1 2674 #inspectIt 8 '&Inspect It' 8339 1 0 0 0 2642 1 2674 #fileItIn 8 '&File It In' 1 1 0 0 0 2722 4097 2642 1 2674 #accept 8 '&Accept' 8359 1 0 0 0 8 '&Workspace' 0 1 0 0 40313 0 0 2594 0 true 8 #() 8 '&Tools' #toolsMenu 1 0 0 40315 0 0 2594 0 true 8 #() 8 'Wi&ndow' #windowMenu 134217729 0 0 40317 0 0 2594 0 true 34 15 2642 1 2674 #helpContents 8 '&Contents' 1025 1 6034 0 true 6080 49 786694 ##(Smalltalk.ShellLibrary) 0 0 2642 1 2674 #help 8 'On this &Tool' 1249 1 0 0 0 2642 1 2674 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2722 4097 2642 1 2674 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 2722 4097 2642 1 2674 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2642 1 2674 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2642 1 2674 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2722 4097 2642 1 2674 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2642 1 2674 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2642 1 2674 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2722 4097 2642 1 2674 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6034 0 true 6080 8 '!!APPLICATION' 6128 0 0 8 '&Help' 0 134217729 0 0 40341 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 898 138 144 34 3 962 #createAt:extent: 34 2 706 3839 21 706 1971 1151 416 962 #text: 34 1 8 'Project Editions Browser' 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 88 11 0 0 73 2 0 0] 34 3 544 2144 1664 1104 0 27 )!

show
	StsManager current isConnected ifFalse: [StsManager install].
	StsManager current isConnected ifFalse: [^self].
	super show!

statusIconForPackageEdition: aPackageEdition 
	^aPackageEdition statusIcon!

toolsFolderHelpId
	^10606!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	Note: As in all Development classes, this method must be stripped to prevent
	it generating an error when this class is removed."

	(Smalltalk developmentSystem)
		removeSystemFolderIcon: self toolsFolderIcon;
		unregisterTool: self.
	SessionManager current removeEventsTriggeredFor: self! !
!StsProjectBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!StsProjectBrowserShell class categoriesFor: #icon!public! !
!StsProjectBrowserShell class categoriesFor: #initialize!initializing!private! !
!StsProjectBrowserShell class categoriesFor: #onStartup!event handling!private! !
!StsProjectBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!StsProjectBrowserShell class categoriesFor: #show!public! !
!StsProjectBrowserShell class categoriesFor: #statusIconForPackageEdition:!helpers!private! !
!StsProjectBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!StsProjectBrowserShell class categoriesFor: #uninitialize!initializing!must strip!private! !

