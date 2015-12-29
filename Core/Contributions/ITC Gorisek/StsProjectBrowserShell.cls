"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsProjectBrowserShell
	instanceVariableNames: 'projectsPresenter projectEditionsPresenter packageEditionsPresenter commentPresenter versionCommentPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsProjectBrowserShell guid: (GUID fromString: '{10D6A001-AF19-11D4-B232-000000000000}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851500 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 482 512 8 4294902647 234 256 98 4 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 738 63 1 738 991 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 738 193 193 0 27 8 'smalltalkTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Image_tools 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 63 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1168 1184 0 27 8 'imageTools' 234 256 1168 98 0 234 240 1168 0 1 0 738 33 31 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1939 51 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 201 3 0 0 25 0 0 0] 98 2 1216 832 1184 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 1776 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 752 0 1776 0 8 4294902455 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 1776 0 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  8 'versionInformation' 98 1 2000 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 1776 0 0 962 202 208 98 1 1026 1056 98 2 738 1 991 738 1939 43 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 239 1 0 0 201 3 0 0 4 2 0 0] 98 0 1184 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 2304 0 482 512 0 7 0 0 0 2304 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 2304 98 2 8 1140920397 1025 2464 590662 2 ##(Smalltalk.ListModel)  202 208 1168 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 8 4278190080 0 23 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #refreshProjectsList 8 'Update list' 1 1 0 0 0 2706 1 2738 8 #newProject 8 '&New Project...' 1 1 0 0 0 2706 1 2738 8 #menuImportProjectFromStpFile 8 '&Import from STP/STX file...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 2706 1 2738 8 #renameProject 8 '&Rename Project...' 1 1 0 0 0 2930 4097 2706 1 2738 8 #purgeProject 8 '&Purge Project from Repository...' 1 1 0 0 0 2706 1 2738 8 #salvageProject 8 'Salvage Last Purged' 1 1 0 0 0 2930 4097 2706 1 2738 8 #createNewProjectEdition 8 '&Create New Edition' 1 1 0 0 0 2706 1 2738 8 #versionOpenProjectEdition 8 '&Version New Edition' 1 1 0 0 0 2706 1 2738 8 #showProjectHistory 8 'Show Edition &History' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2464 0 8 4294902537 459270 ##(Smalltalk.Message)  8 #asString 98 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  4 1 3472 8 'doIt' 8 '[:x | StsProjectEdition projectIcon imageIndex]' 8 #[32 105 29 159 160 106] 8 ##(Smalltalk.StsProjectEdition)  8 #projectIcon 8 #imageIndex 3488 7 257 0 2064 0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Projects in Repository' 475 8 #left 3410 8 #displayString 98 0 3410 8 #<= 3760 0 0 2464 0 3 0 0 8 #report 1168 0 2145 0 98 1 0 962 202 208 98 3 1026 1056 98 2 738 1 1 738 483 941 2464 1026 8 #contextMenu: 98 1 2672 2464 1026 8 #text: 98 1 8 'Projects in Repository' 2464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 241 0 0 0 214 1 0 0] 98 0 1184 0 27 852486 ##(Smalltalk.ScaledDecimal)  524806 ##(Smalltalk.Fraction)  3 5 3 410 2320 98 15 0 2304 98 2 8 1140850688 131073 4176 0 482 512 0 7 0 0 0 4176 2402 234 240 1168 16 234 256 98 2 410 8 ##(Smalltalk.MultipleSelectionListView)  98 30 0 4176 98 2 8 1140953161 1025 4320 2546 202 208 1168 0 2608 482 512 0 7 2658 0 16 98 26 2706 1 2738 2768 8 'Update list' 1 1 0 0 0 2930 4097 2706 1 2738 3280 8 '&Version New Edition...' 1 1 0 0 0 2706 1 2738 3216 8 'Create &New Edition' 1 1 0 0 0 2706 1 2738 8 #menuCopyProjectEditionTo 8 'Copy Edition to Another Project ...' 1 1 0 0 0 2706 1 2738 8 #loadProjectEdition 8 'Load &Edition' 1 1 0 0 0 2706 1 2738 8 #compareProjectEditions 8 '&Compare Editions' 1 1 0 0 0 2706 1 2738 8 #compareProjectEditionWithImage 8 'Compare with Image' 1 1 0 0 0 2706 1 2738 8 #compareProjectEditionWithPreviousVersion 8 'Compare with Previous Edition' 1 1 0 0 0 2930 4097 2706 1 2738 8 #menuExportProject 8 'E&xport to File ...' 1 1 0 0 0 2706 1 2738 8 #menuExportProjectToURL 8 'Export to Repository Server ...' 1 1 0 0 0 2706 1 2738 8 #menuImportProject 8 '&Import from File ...' 1 1 0 0 0 2706 1 2738 8 #menuImportProjectFromURL 8 'Import from Repository Server ...' 1 1 0 0 0 2930 4097 2706 1 2738 3344 8 'Show Project History' 1 1 0 0 0 2930 4097 2706 1 2738 8 #menuRenameVersion 8 '&Rename Edition...' 1 1 0 0 0 2706 1 2738 8 #purgeProjectEdition 8 '&Purge Edition from Repository...' 1 1 0 0 0 2706 1 2738 8 #salvageProjectEdition 8 '&Salvage Last Purged' 1 1 0 0 0 2930 4097 2706 1 2738 8 #menuChangeProjectBlessingLevel 8 'Change blessing level ...' 1 1 0 0 0 2706 1 2738 8 #menuChangeProjectComment 8 'Change Project Comment ...' 1 1 0 0 0 2706 1 2738 8 #menuChangeProjectVersionComment 8 'Change Project Version Comment ...' 1 1 0 0 0 2930 4097 2706 1 2738 8 #menuSortPackagesByPrerequisites 8 'Sort Packages by Prerequisites' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4320 0 8 4294902537 2016 2032 2064 0 0 0 0 0 0 202 208 98 4 3666 8 'Project Editions' 337 3712 3410 8 #versionDescriptor 98 0 0 0 0 4320 0 1 0 0 3666 8 'Timestamp' 501 3712 3474 0 459302 ##(Smalltalk.Context)  1 1 0 0 3506 2 9 3408 8 'doIt' 98 2 8 '[:edition | edition timestamp printString]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  1168 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 8 #timestamp 8 #printString 17 257 3410 6144 5920 0 0 0 4320 0 1 0 0 3666 8 'Developer' 403 3712 3410 8 #developer 5920 0 0 0 4320 0 3 0 0 3666 8 'Blessing' 201 3712 3410 3744 98 0 3410 3792 6304 3410 8 #blessingString 6304 0 4320 0 1 0 0 3808 1168 0 131169 0 98 1 0 962 202 208 98 3 1026 1056 98 2 738 1 1 738 1447 465 4320 1026 3968 98 1 4448 4320 1026 4016 98 1 8 'Project Editions' 4320 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 211 2 0 0 232 0 0 0] 98 0 1184 0 27 8 'projectEditions' 0 962 202 208 98 1 1026 1056 98 2 738 493 1 738 1447 941 4176 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 246 0 0 0 0 0 0 0 201 3 0 0 214 1 0 0] 98 3 4320 410 8 ##(Smalltalk.Splitter)  98 12 0 4176 98 2 8 1140850688 1 6800 0 482 512 0 519 0 0 0 6800 962 202 208 98 1 1026 1056 98 2 738 1 465 738 1447 11 6800 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 232 0 0 0 211 2 0 0 237 0 0 0] 98 0 1184 0 27 410 2320 98 15 0 4176 98 2 8 1140850688 131073 7056 0 0 0 7 0 0 0 7056 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.CardContainer)  98 16 0 7056 98 2 8 1140850688 393217 7184 0 482 8 4278190080 0 7 0 0 0 7184 655878 ##(Smalltalk.CardLayout)  202 208 98 3 721414 ##(Smalltalk.Association)  8 'Project Comment' 410 8 ##(Smalltalk.ScintillaView)  98 50 0 7184 98 2 8 1176572228 1 7408 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 196934 1 ##(Smalltalk.RGB)  30932991 0 5 2658 0 16 98 12 2706 1 2738 8 #accept 8 '&Accept' 1 1 0 0 0 2930 4097 2658 0 16 98 8 2706 1 2738 8 #undo 8 '&Undo' 1 1 0 0 0 2930 4097 2706 1 2738 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 2706 1 2738 8 #copySelection 8 '&Copy' 1 1 0 0 0 2706 1 2738 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 2706 1 2738 8 #clearSelection 8 'De&lete' 1 1 0 0 0 2930 4097 2706 1 2738 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 2706 1 2738 8 #clear 8 'Clea&r' 1 1 0 0 0 2930 4097 2706 1 2738 8 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr7.dll' 0 0 0 2706 1 2738 8 #displayIt 8 '&Display It' 1 1 0 0 0 2706 1 2738 8 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 2706 1 2738 8 #inspectIt 8 '&Inspect It' 1 1 8306 0 16 8352 8 'BasicInspector.ico' 8400 0 0 2706 1 2738 8 #debugIt 8 'Deb&ug It' 1 1 8306 0 16 8352 8 'Debugger.ico' 8400 0 0 2930 4097 2658 0 16 98 2 2706 2097153 2738 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 2706 1 2738 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 7408 7554 8454145 8 4294902597 852486 ##(Smalltalk.NullConverter)  0 0 11 0 234 256 98 4 8 #callTip 1182726 ##(Smalltalk.ScintillaTextStyle)  77 786694 ##(Smalltalk.IndexedColor)  33554457 9106 33554471 1 0 0 0 0 9056 0 0 0 8 #normal 9074 1 0 0 1 0 0 0 0 9152 0 0 0 98 40 9168 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler)  9152 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 9106 33554433 9136 7408 8 #circle 202 208 1168 0 63 9215 0 0 0 0 9106 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 9024 0 0 0 0 1 0 234 256 98 4 8 #Warning 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  19 7408 33423361 3 32 9472 0 8 #Error 9490 17 7408 33554459 3 32 9520 0 0 0 234 256 98 6 8 #Notification 9074 1029 0 7554 31185883 1 0 0 0 0 9584 0 0 0 9520 9074 1031 7554 335 7554 31317503 1 0 0 0 0 9520 0 0 0 9472 9074 1027 7554 60239 7554 31326207 1 0 0 0 0 9472 0 0 0 0 962 202 208 98 12 1026 1056 98 2 738 9 55 738 1425 351 7408 1026 3968 98 1 7584 7408 1026 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 7408 1026 8 #isTextModified: 98 1 32 7408 1026 8 #modificationEventMask: 98 1 9215 7408 1026 8 #secondaryCaretForecolor: 98 1 7554 16711423 7408 1026 8 #caretPeriod: 98 1 1061 7408 1026 8 #wordWrap: 98 1 16 7408 1026 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin)  1 7408 1 3 32 1 5 10274 3 7408 1 1 32 67108863 5 10274 5 7408 1 1 32 1 5 7408 1026 8 #indentationGuides: 98 1 0 7408 1026 8 #tabIndents: 98 1 16 7408 1026 8 #areAdditionalCaretsVisible: 98 1 16 7408 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 204 2 0 0 202 0 0 0] 98 0 1184 0 29 7362 8 'Project Version Comment' 410 7424 98 50 0 7184 98 2 8 1176572228 1 10560 7490 0 32 7536 0 7554 30932991 0 5 2658 0 16 98 12 2706 1 2738 7648 7664 1 1 0 0 0 2930 4097 2658 0 16 98 8 2706 1 2738 7760 7776 1 1 0 0 0 2930 4097 2706 1 2738 7840 7856 1 1 0 0 0 2706 1 2738 7904 7920 1 1 0 0 0 2706 1 2738 7968 7984 1 1 0 0 0 2706 1 2738 8032 8048 1 1 0 0 0 2930 4097 2706 1 2738 8112 8128 1 1 0 0 0 8144 0 134217729 0 0 0 0 0 2706 1 2738 8192 8208 1 1 0 0 0 2930 4097 2706 1 2738 8272 8288 1 1 8306 0 16 8352 8368 8400 0 0 2706 1 2738 8464 8480 1 1 0 0 0 2706 1 2738 8528 8544 1 1 0 0 0 2706 1 2738 8592 8608 1 1 8306 0 16 8352 8640 8400 0 0 2706 1 2738 8688 8704 1 1 8306 0 16 8352 8736 8400 0 0 2930 4097 2658 0 16 98 2 2706 2097153 2738 8832 8848 1 1 0 0 0 2706 1 2738 8896 8912 1 1 0 0 0 8928 0 134217729 0 0 0 0 0 8944 0 134217729 0 0 0 0 0 0 0 10560 7554 8454145 8 4294902597 8994 0 0 11 0 234 256 98 4 9056 9074 77 9120 9136 1 0 0 0 0 9056 0 0 0 9152 9074 1 0 0 1 0 0 0 0 9152 0 0 0 98 40 11456 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9202 9152 234 256 98 2 9264 9282 1 1 9312 9136 10560 9328 202 208 1168 0 63 9215 0 0 0 0 9360 0 0 65 0 0 0 9376 3 234 256 98 2 9424 11408 0 0 0 0 1 0 234 256 98 4 9472 9490 19 10560 33423361 3 32 9472 0 9520 9490 17 10560 33554459 3 32 9520 0 0 0 234 256 98 6 9584 9074 1029 0 7554 31185883 1 0 0 0 0 9584 0 0 0 9520 9074 1031 7554 335 7554 31317503 1 0 0 0 0 9520 0 0 0 9472 9074 1027 7554 60239 7554 31326207 1 0 0 0 0 9472 0 0 0 0 962 202 208 98 12 1026 1056 98 2 738 9 55 738 1425 351 10560 1026 3968 98 1 10656 10560 1026 9888 98 1 9922 3 1 3 10560 1026 9968 98 1 32 10560 1026 10016 98 1 9215 10560 1026 10064 98 1 7554 16711423 10560 1026 10128 98 1 1061 10560 1026 10176 98 1 16 10560 1026 10224 98 1 98 3 10274 1 10560 1 3 32 1 5 10274 3 10560 1 1 32 67108863 5 10274 5 10560 1 1 32 1 5 10560 1026 10352 98 1 0 10560 1026 10400 98 1 16 10560 1026 10448 98 1 16 10560 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 204 2 0 0 202 0 0 0] 98 0 1184 0 29 7362 8 'Packages in Load Order' 410 4336 98 30 0 7184 98 2 8 1140953153 1025 12464 2546 202 208 1168 0 2608 482 512 0 7 2658 0 16 98 22 2706 1 2738 8 #addPackageEdition 8 '&Add/Replace Edition with...' 1 1 0 0 0 2706 1 2738 8 #replaceWithLoadedEdition 8 'Re&place with loaded Edition' 1 1 0 0 0 2706 1 2738 8 #menuVersionAndReplaceWithLoaded 8 '&Version Package(s) and replace with loaded Edition...' 1 1 0 0 0 2930 4097 2706 1 2738 8 #removePackageEdition 8 '&Remove Package Edition' 1 1 0 0 0 2930 4097 2706 1 2738 8 #loadPackageEdition 8 '&Load Edition' 1 1 0 0 0 2706 1 2738 8 #browsePackageEditions 8 '&Browse Editions' 1 1 0 0 0 2706 1 2738 8 #comparePackageEditionWithLoadedPackage 8 'Compare with loaded package' 1 1 0 0 0 2706 1 2738 8 #comparePackageEditionWith 8 'Compare &with...' 1 1 0 0 0 2930 4097 2706 1 2738 8 #menuPackageEditionShowVersionHistory 8 'Show Package Edition History' 1 1 0 0 0 2930 4097 2706 1 2738 8 #menuImportPackage 8 'Import Package to Repository and Add...' 1 1 0 0 0 2706 1 2738 8 #menuExportPackageEdition 8 'E&xport Package Edition...' 1 1 0 0 0 2658 0 16 98 4 2706 1 2738 8 #menuFileOutPackagesAsSmalltalkXChangeSet 8 'Smalltalk/X Change Set' 1 1 0 0 0 2706 1 2738 8 #menuFileOutPackagesAsSqueakChangeSet 8 'Squeak Change Set' 1 1 0 0 0 2706 1 2738 8 #menuFileOutPackagesAsVASTAppFileOut 8 'VAST App File Out' 1 1 0 0 0 2706 1 2738 8 #menuFileOutPackagesAsVWChangeSet 8 'VisualWorks Change Set' 1 1 0 0 0 8 'File Out As' 0 1 0 0 0 0 0 2658 0 16 98 6 2706 1 2738 8 #menuViewChangesFromToday 8 'Today' 1 1 0 0 0 2706 1 2738 8 #menuViewChangesFromYesterday 8 'Yesterday' 1 1 0 0 0 2930 4097 2706 1 2738 8 #menuViewChangesFromWeek 8 'Week' 1 1 0 0 0 2706 1 2738 8 #menuViewChangesFromMonth 8 'Month' 1 1 0 0 0 2706 1 2738 8 #menuViewChangesFromYear 8 'Year' 1 1 0 0 0 8 'View Changes from...' 0 134217729 0 0 0 0 0 2930 4097 2706 1 2738 8 #menuChangePackageBlessingLevel 8 'Change blessing level ...' 1 1 0 0 0 2930 4097 2658 0 16 98 0 8 'Add Prerequisite Package' 8 #addPrerequisitesMenu 134217729 0 0 0 0 0 2706 1 2738 8 #comparePackageEditionWithImage 8 'Compare with lmage' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 12464 0 8 4294902537 2016 0 2064 0 0 0 738 65 65 0 0 202 208 98 6 3666 8 '' 45 3712 0 0 0 0 12464 3474 0 0 3506 4 1 3472 8 'doIt' 8 '[:x | (StsProjectBrowserShell statusIconForPackageEdition: x) imageIndex]' 8 #[32 105 29 17 177 160 106] 8 ##(Smalltalk.StsProjectBrowserShell)  8 #statusIconForPackageEdition: 3616 14400 7 257 0 1 0 0 3666 8 'Package Name' 301 3712 3474 0 5986 1 1 0 0 3506 1 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:each | each displayName ]' 98 1 202 6112 1168 8 #[252 1 0 1 1 7 0 17 230 32 228 32 158 106 100 105] 8 #displayName 17 257 0 0 0 0 12464 2032 1 0 0 3666 8 'Edition' 241 3712 3410 5904 98 0 0 0 0 12464 0 1 0 0 3666 8 'Timestamp' 361 3712 3474 0 5986 1 1 0 0 3506 2 9 3408 8 'doIt' 98 2 8 '[:edition | edition timestamp printString]' 98 1 202 6112 1168 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 6144 6160 17 257 3410 6144 14768 0 0 0 12464 0 1 0 0 3666 8 'Developer' 273 3712 3410 6240 14768 0 0 0 12464 0 3 0 0 3666 8 'Blessing' 201 3712 3410 3744 98 0 3410 3792 15072 3410 6352 15072 0 12464 0 1 0 0 3808 1168 0 131173 0 98 1 0 962 202 208 98 2 1026 1056 98 2 738 9 55 738 1425 351 12464 1026 3968 98 1 12576 12464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 204 2 0 0 202 0 0 0] 98 0 1184 0 27 12464 234 256 98 6 7408 8 'comment' 12464 8 'packageEditions' 10560 8 'versionComment' 0 410 8 ##(Smalltalk.TabView)  98 23 0 7184 98 2 8 1140916736 1 15408 2546 202 208 98 3 12448 7392 10544 0 2608 1858 31 0 1 0 0 0 15408 0 8 4294902189 2016 2032 2064 0 0 0 0 0 8 #noIcons 962 202 208 98 3 1026 1056 98 2 738 1 1 738 1445 417 15408 1026 8 #basicSelectionsByIndex: 98 1 98 1 3 15408 1026 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 15408 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 210 2 0 0 208 0 0 0] 98 0 1184 0 27 962 202 208 98 1 1026 1056 98 2 738 1 51 738 1445 417 7184 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 210 2 0 0 233 0 0 0] 98 4 12464 7408 10560 15408 1184 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 16050 8 #fixedParentRight -1 16050 8 #fixedParentTop 51 16050 8 #fixedParentBottom 1 410 2320 98 15 0 7056 98 2 8 1140850688 131073 16192 0 0 0 7 0 0 0 16192 7122 234 240 98 4 410 8 ##(Smalltalk.StaticText)  98 16 0 16192 98 2 8 1140850945 65 16304 0 0 0 7 0 0 0 16304 0 8 4294902681 8994 0 0 0 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1145 49 16304 1026 4016 98 1 8 'Contained Package Editions in their load order' 16304 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 60 2 0 0 24 0 0 0] 98 0 1184 0 27 16018 16064 1 16050 8 #fixedPreviousLeft -3 16128 1 16160 1 410 576 98 25 0 16192 98 2 8 1409288972 131137 16672 0 482 8 4278190080 0 519 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 0 16672 482 16752 8 4294902647 234 256 1168 234 256 98 12 23497 853766 ##(Smalltalk.ToolbarButton)  23497 0 16672 1 2738 8 #moveLastPackageEdition 8 'Move Last' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 8352 8 'ListBar.bmp' 8400 0 7 738 161 33 7 23487 16914 23487 0 16672 1 2738 12640 8 'Add' 1 1 0 17008 9 23489 16914 23489 0 16672 1 2738 12848 8 'Remove' 1 1 0 16994 0 16 8352 8 'EditBar.bmp' 8400 0 7 738 193 33 11 23491 16914 23491 0 16672 1 2738 8 #moveFirstPackageEdition 8 'Move First' 1 1 0 17008 5 23493 16914 23493 0 16672 1 2738 8 #moveUpPackageEdition 8 'Move Up' 1 1 0 17008 1 23495 16914 23495 0 16672 1 2738 8 #moveDownPackageEdition 8 'Move Down' 1 1 0 17008 3 98 7 17056 17104 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 16672 3 0 1 17200 17264 17328 16928 234 240 98 4 17008 1 17152 11 0 1 0 738 33 33 738 45 45 0 0 962 202 208 98 2 1026 1056 98 2 738 1149 1 738 1407 49 16672 1026 1712 1168 16672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 62 2 0 0 0 0 0 0 253 4 0 0 24 0 0 0] 98 0 1184 0 27 16018 16096 -1755 16096 -349 16128 1 16160 1 234 256 1168 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 2905 49 16192 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 5 0 0 24 0 0 0] 98 2 16672 16304 1184 0 27 16018 16064 1 16096 1459 16128 1 16050 8 #fixedViewTop 49 234 256 1168 0 962 202 208 98 1 1026 1056 98 2 738 1 475 738 1447 467 7056 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 237 0 0 0 211 2 0 0 214 1 0 0] 98 2 16192 7184 1184 0 27 1184 0 27 4114 4146 7 5 3 32 234 256 98 2 2464 8 'projects' 0 962 202 208 98 1 1026 1056 98 2 738 1 51 738 1939 941 2304 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 201 3 0 0 239 1 0 0] 98 3 2464 410 6816 98 12 0 2304 98 2 8 1140850688 1 18336 0 482 512 0 519 0 0 0 18336 962 202 208 98 1 1026 1056 98 2 738 483 1 738 11 941 18336 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 0 0 0 0 246 0 0 0 214 1 0 0] 98 0 1184 0 27 4176 1184 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 6 2658 0 16 98 9 2706 1 2738 8 #fileNew 8 '&New' 8349 1 0 0 0 2706 1 2738 8 #fileOpen 8 '&Open...' 8351 1 0 0 0 2706 1 2738 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 2930 4097 2706 1 2738 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 2706 1 2738 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 2706 1 2738 8 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 2930 4097 2706 1 2738 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 8 '&File' 0 1 0 0 23569 0 0 2658 0 16 98 11 2706 1 2738 7760 8 '&Undo' 8373 1 0 0 0 2930 4097 2706 1 2738 7840 8 'Cu&t' 8369 1 0 0 0 2706 1 2738 7904 8 '&Copy' 8327 1 0 0 0 2706 1 2738 7968 8 '&Paste' 8365 1 0 0 0 2706 1 2738 8032 8 '&Delete' 1 1 0 0 0 2706 1 2738 8112 8 'Select &All' 1 1 0 0 0 2930 4097 2706 1 2738 8 #find 8 '&Find...' 8333 1 0 0 0 2706 1 2738 8 #findNext 8 'Find &Next' 229 1 0 0 0 2706 1 2738 8 #findReplace 8 '&Replace...' 8337 1 0 0 0 8 '&Edit' 0 1 0 0 23589 0 0 2658 0 16 98 7 2706 1 2738 8272 8 '&Browse It' 8325 1 0 0 0 2706 1 2738 8464 8 '&Display It' 8329 1 0 0 0 2706 1 2738 8528 8 '&Evaluate It' 8331 1 0 0 0 2706 1 2738 8592 8 '&Inspect It' 8339 1 0 0 0 2706 1 2738 8 #fileItIn 8 '&File It In' 1 1 0 0 0 2930 4097 2706 1 2738 7648 8 '&Accept' 8359 1 0 0 0 8 '&Workspace' 0 1 0 0 23603 0 0 2658 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 23605 0 0 2658 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 23607 0 0 2658 0 16 98 16 2706 1 2738 8 #helpContents 8 '&Contents' 1025 1 8306 0 16 8352 49 786694 ##(Smalltalk.ShellLibrary)  0 0 2706 1 2738 8 #help 8 'On this &Tool' 1249 1 0 0 0 2706 1 2738 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2930 4097 2706 1 2738 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 2930 4097 2706 1 2738 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2706 1 2738 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2706 1 2738 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2658 0 16 98 4 2706 2097153 2738 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 8306 0 16 8352 8 'TipOfTheDay.ico' 8400 0 0 2706 1 2738 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 8306 0 16 8352 8 'TipOfTheDay.ico' 8400 0 0 2930 4097 2706 1 2738 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 23629 0 0 2930 4097 2706 1 2738 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2706 1 2738 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2706 1 2738 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2930 4097 2706 1 2738 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 8306 0 16 8352 8 '!!APPLICATION' 8400 0 0 8 '&Help' 0 134217729 0 0 23639 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 738 4999 21 738 1971 1151 416 1026 4016 98 1 8 'Project Editions Browser' 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 9 0 0 10 0 0 0 156 13 0 0 73 2 0 0] 98 3 560 2304 1776 1184 0 27 )!

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

