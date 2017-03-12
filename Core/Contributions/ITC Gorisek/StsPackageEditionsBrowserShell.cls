"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsPackageEditionsBrowserShell
	instanceVariableNames: 'packagesPresenter editionsPresenter classesPresenter methodsPresenter commentPresenter versionCommentPresenter sourcePresenter resourcesPresenter versionInfoPresenter scriptsPresenter globalsPresenter inspectorPresenter prerequisitesPresenter packageCards'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsPackageEditionsBrowserShell guid: (GUID fromString: '{914f381f-11d6-11d4-b091-000000000000}')!
StsPackageEditionsBrowserShell comment: ''!
!StsPackageEditionsBrowserShell categoriesForClass!Unclassified! !
!StsPackageEditionsBrowserShell methodsFor!

clearSource
	sourcePresenter text: ''!

createComponents
	super createComponents.
	packagesPresenter := self 
				add: ListPresenter new
				name: 'packageNames'
				helpId: 10979.
	packagesPresenter model searchPolicy: SearchPolicy equality.
	editionsPresenter := self 
				add: ListPresenter new
				name: 'packageEditions'
				helpId: 10980.
	classesPresenter := (self add: ListPresenter new name: 'classes') beSorted.
	methodsPresenter := self add: ListPresenter new name: 'methods'.
	methodsPresenter beSorted: self methodSortBlock.
	versionInfoPresenter := self add: TextPresenter new name: 'versionInformation'.
	globalsPresenter := (self add: ListPresenter new name: 'globals') beSorted.
	resourcesPresenter := self add: ListPresenter new name: 'resources'.
	scriptsPresenter := self add: ListPresenter new name: 'scripts'.
	prerequisitesPresenter := (self add: ListPresenter new name: 'prerequisites') beSorted.
	sourcePresenter := self add: SmalltalkWorkspace new name: 'source'.
	commentPresenter := self add: SmalltalkWorkspace new name: 'comment'.
	versionCommentPresenter := self add: SmalltalkWorkspace new name: 'versionComment'.
	inspectorPresenter := self add: PublishedAspectInspector new name: 'inspector'!

createSchematicWiring
	super createSchematicWiring.
	packagesPresenter 
		when: #selectionChanged
		send: #onPackageSelected
		to: self.
	editionsPresenter 
		when: #selectionChanged
		send: #onPackageEditionSelected
		to: self.
	classesPresenter
		when: #selectionChanged
			send: #onClassSelected
			to: self;
		when: #actionPerformed
			send: #menuBrowseClassEditions
			to: self.
	methodsPresenter 
		when: #selectionChanged
		send: #onMethodSelected
		to: self.
	scriptsPresenter 
		when: #selectionChanged
		send: #onScriptSelected
		to: self.
	globalsPresenter 
		when: #selectionChanged
		send: #onGlobalSelected
		to: self.
	resourcesPresenter 
		when: #selectionChanged
		send: #onResourceSelected
		to: self.
	prerequisitesPresenter 
		when: #selectionChanged
		send: #onPrerequisiteSelected
		to: self.

	"Hang off system package events"
	(self packageManager)
		when: #packageChanged:
			send: #onPackageChanged:
			to: self;
		when: #loadedChanged
			send: #onLoadedPackagesChanged
			to: self!

defaultHelpId
	^10896!

fileOutChangesForSmalltalkX: packageEdition on: stream 
	packageEdition basicExportAsSmalltalkXChangeSetOn: stream packageName: packageEdition name!

fileOutChangesForSqueak: packageEdition on: stream 
	packageEdition basicExportAsSqueakChangeSetOn: stream packageName: packageEdition name!

fileOutChangesForVW: packageEdition on: stream 
	| writer |
	stream nextPutAll: '<?xml version="1.0"?>

'.
	writer := StsXmlWriter on: stream.
	packageEdition basicExportAsVWChangeSetOn: writer parcelName: packageEdition name!

menuBrowseClass
	self selectedLoadedClassOrNil browse!

menuBrowseClassEditions
	classesPresenter selectionOrNil first browseEdition!

menuBrowseMethod
	self selectedLoadedMethodOrNil browse!

menuBrowseMethodEditions
	methodsPresenter selectionOrNil first browseEdition!

menuBrowsePackage
	self selectedLoadedPackageOrNil browse!

menuComparePackageEditions
	self sourceControl browseChangesBetween: editionsPresenter selectionOrNil first
		and: editionsPresenter selectionOrNil last!

menuCompareWith
	| anotherEdition |
	(anotherEdition := StsPackageEditionPrompter 
				chooseWithDefault: editionsPresenter selectionOrNil first name) notNil 
		ifTrue: 
			[self sourceControl browseChangesBetween: editionsPresenter selectionOrNil first and: anotherEdition]!

menuCompareWithImage
	self sourceControl comparePackage: self selectedLoadedPackageOrNil
		with: self selectedSinglePackageEditionOrNil.

	"The comparison may prompt to mark the edition as loaded so force a refresh here"
	editionsPresenter model refresh: self selectedSinglePackageEditionOrNil!

menuExportPackageEdition
	self sourceControl exportPackageEdition: self packageEdition!

menuFileOutAsSmalltalkXChangeSet
	| filename stream fileStream packageEdition |
	packageEdition := self packageEdition.
	filename := (FileSaveDialog new)
				caption: 'File Out as SmalltalkX Changes Set';
				fileTypes: #(#('SmalltalkX Change Set (*.st)' '*.st'));
				value: packageEdition name , '.st';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			self fileOutChangesForSmalltalkX: packageEdition on: stream.
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuFileOutAsSqueakChangeSet
	| filename stream fileStream packageEdition |
	packageEdition := self packageEdition.
	filename := (FileSaveDialog new)
				caption: 'File Out as Squeak Changes Set';
				fileTypes: #(#('Squeak Change Set (*.cs)' '*.cs'));
				value: packageEdition name , '.cs';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			self fileOutChangesForSqueak: packageEdition on: stream.
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuFileOutAsVwChangeSet
	| filename stream fileStream packageEdition |
	packageEdition := self packageEdition.
	filename := (FileSaveDialog new)
				caption: 'File Out as VW Changes Set';
				fileTypes: #(#('VW Changes Set (*.cha)' '*.cha'));
				value: packageEdition name , '.cha';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			self fileOutChangesForVW: packageEdition on: stream.
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuImportPackageFromFile
	| packageName selectionIndex |
	Cursor wait showWhile: [packageName := self sourceControl importPackage].
	packageName isNil 
		ifFalse: 
			[self refresh.
			selectionIndex := packagesPresenter list findFirst: [:each | each = packageName].
			packagesPresenter selectionByIndex: selectionIndex ifAbsent: []]!

menuLoadClassEdition
	classesPresenter selectionOrNil do: [:eachClassEdition | eachClassEdition load]!

menuLoadMethodEdition
	| edition |
	edition := methodsPresenter selectionOrNil first.
	StsManager current ignoreCompilerWhile: [edition methodClass compile: edition source].
	methodsPresenter view refreshContents.
	methodsPresenter selection: (Array with: edition)!

menuLoadPackageEdition
	self packageEdition load!

menuPurgeUnusedClassEditions
	self sourceControl purgeUnusedClassEditions!

menuRenamePackage
	| newName oldName newNames |
	(oldName := packagesPresenter selectionOrNil) isNil ifTrue: [^self].
	(newName := Prompter 
				on: oldName
				prompt: 'Enter new package name'
				caption: 'Renaming package') isNil 
		ifTrue: [^self].
	(self sourceControl renamePackage: oldName to: newName) 
		ifTrue: 
			[newNames := self sourceControl getAllPackageNames.
			newName := newNames detect: [:each | each = newName].
			packagesPresenter
				list: newNames;
				selection: newName]!

menuRenameVersion
	| newVersionName |
	
	[newVersionName := Prompter 
				on: self packageEdition versionDescriptor
				prompt: 'Enter new version descriptor:'
				caption: 'Rename package version'.
	newVersionName isNil ifTrue: [^self].
	newVersionName isEmpty] 
			whileTrue: [MessageBox errorMsg: 'Version name can not be empty'].
	newVersionName = self packageEdition versionDescriptor 
		ifFalse: 
			[self sourceControl renamePackageVersion: self packageEdition newVersionDescriptor: newVersionName.
			self refreshPackageEditions]!

menuResourceBrowse
	| edition |
	edition := resourcesPresenter selectionOrNil.
	Smalltalk developmentSystem openViewComposerEmpty openOn: edition!

menuVersionPackage
	"Create a new version dor the selected package in the repository"

	self selectedLoadedPackageOrNil ifNotNil: [:package | self sourceControl versionPackage: package].
	self onPackageSelected!

methodSortBlock
	"Private - Answer a default sort block to use when the receiver is sorted"

	^[:x :y | x selector <= y selector]!

onCardChanged
	| cardName |
	versionInfoPresenter value: nil.
	cardName := packageCards currentCard name.
	cardName = 'classes' ifTrue: [^self onClassSelected].
	cardName = 'methods' ifTrue: [^self onMethodSelected].
	cardName = 'scripts' ifTrue: [^self onScriptSelected].
	cardName = 'globals' ifTrue: [^self onGlobalSelected]!

onClassSelected
	| classes |
	(classes := classesPresenter selectionOrNil) notEmpty 
		ifTrue: 
			[sourcePresenter
				text: classes first definition;
				ensureVisible.
			versionInfoPresenter value: classes first]
		ifFalse: 
			[self clearSource.
			versionInfoPresenter value: nil]!

onDeferredStartup
	self refresh!

onGlobalSelected
	| globalName |
	(globalName := globalsPresenter selectionOrNil) notNil 
		ifTrue: 
			[sourcePresenter
				text: (self packageEdition globals at: globalName) printString;
				ensureVisible]
		ifFalse: [self clearSource]!

onLoadedPackagesChanged
	"Private - The loaded packages have changed so refresh our packages and editions panes"

	packagesPresenter view invalidate.
	editionsPresenter view invalidate!

onMethodSelected
	| methods |
	(methods := methodsPresenter selectionOrNil) notEmpty 
		ifTrue: 
			[sourcePresenter
				text: methods first source;
				ensureVisible.
			versionInfoPresenter value: methods first]
		ifFalse: 
			[self clearSource.
			versionInfoPresenter value: nil]!

onPackageChanged: aPackage 
	"Private - The specified <Package> has moved from changed to not-changed state, or vice
	versa. Repaint the packages pane to ensure that any change markers are added/removed."

	packagesPresenter model refresh: aPackage name ifAbsent: [].
	aPackage == self selectedLoadedPackageOrNil ifTrue: [self refreshPackageEditions]!

onPackageEditionSelected
	| edition |
	(edition := self packageEdition) notNil 
		ifTrue: 
			[classesPresenter list: edition classes.
			methodsPresenter list: edition methods.
			resourcesPresenter list: edition resources.
			commentPresenter text: edition comment.
			versionCommentPresenter text: edition versionComment.
			scriptsPresenter list: #(#preinstall #postinstall #preuninstall #postuninstall).
			globalsPresenter list: edition globalNames.
			prerequisitesPresenter list: edition prerequisiteNames]
		ifFalse: 
			[classesPresenter clear.
			methodsPresenter clear.
			resourcesPresenter clear.
			commentPresenter text: ''.
			scriptsPresenter clear.
			globalsPresenter clear.
			prerequisitesPresenter clear.
			self clearSource].
	inspectorPresenter model: edition.
	versionInfoPresenter value: nil.
	self onScriptSelected!

onPackageSelected
	self
		refreshPackageEditions;
		onScriptSelected.
	self clearSource!

onPrerequisiteSelected
	sourcePresenter clear!

onResourceSelected
	self clearSource!

onScriptSelected
	| script |
	(script := scriptsPresenter selectionOrNil) notNil 
		ifTrue: 
			[sourcePresenter
				text: (self packageEdition script: script);
				ensureVisible.
			versionInfoPresenter value: nil]
		ifFalse: 
			[self clearSource.
			versionInfoPresenter value: nil]!

onStartup
	SessionManager current inputState queueDeferredAction: [self onDeferredStartup]!

onViewOpened
	super onViewOpened.
	(packageCards := self view viewNamed: 'packageCards') 
		when: #currentCardChanged
		send: #onCardChanged
		to: self.
	self refresh!

packageEdition
	^self selectedSinglePackageEditionOrNil!

purgePackage
	(MessageBox 
		confirm: 'Warning: if you continue the package and all its editions 
will be permamently removed from the repository.

Are you sure you want to continue?'
		caption: 'Purging package ' , packagesPresenter selection) 
			ifTrue: 
				[self sourceControl purgePackage: packagesPresenter selection.
				self refresh]!

purgePackageEdition
	| progressDialog coll edition |
	coll := editionsPresenter selection copy.
	(MessageBox 
		confirm: 'Warning: if you continue the selected package edition(s)
will be removed from the repository.

Are you sure you want to continue?'
		caption: (coll size > 1 
				ifTrue: ['Purging package editions']
				ifFalse: ['Purging package edition ' , coll first versionDescriptor])) 
			ifTrue: 
				[progressDialog := ProgressDialog operation: 
								[:progress | 
								1 to: coll size
									do: 
										[:i | 
										edition := coll at: i.
										progressDialog
											caption: 'Purging package edition ' , edition displayString;
											value: 100.0 * i / coll size.
										self sourceControl purgePackageEdition: edition].
								self refreshPackageEditions].
				progressDialog
					allowCancel: true;
					caption: 'Please wait';
					showModal]!

queryCommand: query 
	| selector |
	selector := query commandSymbol.
	selector == #menuPurgeUnusedClassEditions 
		ifTrue: 
			[query isEnabled: true.
			^true].
	(#(#menuBrowsePackage #menuVersionPackage) includes: selector) 
		ifTrue: 
			[query isEnabled: self selectedLoadedPackageOrNil notNil.
			^true].
	(#(#menuCompareWithImage) includes: selector) 
		ifTrue: 
			[query isEnabled: (self selectedLoadedPackageOrNil notNil 
						and: [self selectedSinglePackageEditionOrNil notNil]).
			^true].
	(#(#menuRenamePackage #purgePackage #salvagePackageEdition) includes: selector) 
		ifTrue: 
			[query isEnabled: packagesPresenter selectionOrNil notNil.
			^true].
	selector == #menuLoadMethodEdition 
		ifTrue: 
			[query isEnabled: (methodsPresenter selectionOrNil notEmpty 
						and: [methodsPresenter selectionOrNil first methodClass notNil]).
			^true].
	selector == #menuBrowseMethodEditions 
		ifTrue: 
			[query isEnabled: methodsPresenter selectionOrNil notEmpty.
			^true].
	selector == #menuLoadClassEdition 
		ifTrue: 
			[query isEnabled: classesPresenter selectionOrNil notEmpty.
			^true].
	selector == #menuBrowseClassEditions 
		ifTrue: 
			[query isEnabled: classesPresenter selectionOrNil size = 1.
			^true].
	selector == #menuBrowseClass 
		ifTrue: 
			[query isEnabled: self selectedLoadedClassOrNil notNil.
			^true].
	selector == #menuBrowseMethod 
		ifTrue: 
			[query isEnabled: self selectedLoadedMethodOrNil notNil.
			^true].
	selector == #menuComparePackageEditions 
		ifTrue: 
			[query isEnabled: editionsPresenter selectionOrNil size = 2.
			^true].
	(#(#menuLoadPackageEdition #menuExportPackageEdition #menuCompareWith #showPackageHistory #menuRenameVersion #menuFileOutAsVwChangeSet #menuFileOutAsSmalltalkXChangeSet #menuFileOutAsSqueakChangeSet #purgePackageEdition) 
		includes: selector) 
			ifTrue: 
				[query isEnabled: self selectedSinglePackageEditionOrNil notNil.
				^true].
	^super queryCommand: query!

refresh
	packagesPresenter list: self sourceControl getAllPackageNames!

refreshPackageEditions
	| packageName editions |
	versionInfoPresenter value: nil.
	(packageName := packagesPresenter selectionOrNil) isNil 
		ifTrue: 
			[self caption: 'Package Editions Browser'.
			editionsPresenter clear.
			self onPackageEditionSelected]
		ifFalse: 
			[self caption: 'Package Editions Browser - ' , packageName.
			Cursor wait showWhile: 
					[editions := self sourceControl getPackageEditionsFor: packageName.
					editionsPresenter list: editions.
					editions notEmpty ifTrue: [editionsPresenter selection: (Array with: editions first)]]]!

salvagePackage
	self sourceControl salvageLastPurgedPackage ifTrue: [self refresh]!

salvagePackageEdition
	(self sourceControl salvageLastPurgedPackageEditionFor: packagesPresenter selection) 
		ifTrue: [self refreshPackageEditions]!

selectedLoadedClassOrNil
	"Answer the the loaded class with the same name as the class edition selected in the classes
	pane or nil if there is none"

	^self selectedSingleClassEditionOrNil 
		ifNotNil: [:classEdition | self class environment at: classEdition className ifAbsent: []]!

selectedLoadedMethodOrNil
	"Answer the the loaded method with the same signature as the method edition selected in the
	method pane or nil if there is none"

	^self selectedSingleMethodEditionOrNil 
		ifNotNil: [:methodEdition | methodEdition methodClass compiledMethodAt: methodEdition selector ifAbsent: []]!

selectedLoadedPackageOrNil
	"Answer the package selected in the packages pane if it is loaded in the image, or nil otherwise"

	^Package manager packageNamed: self selectedPackageName ifNone: []!

selectedPackageName
	"Answer the name of the package selected in the packages pane"

	^packagesPresenter selectionOrNil!

selectedSingleClassEditionOrNil
	"Answer the single class edition selected in the classes pane"

	^classesPresenter selection size = 1 ifTrue: [classesPresenter selection first]!

selectedSingleMethodEditionOrNil
	"Answer the single method edition selected in the method pane"

	^methodsPresenter selection size = 1 ifTrue: [methodsPresenter selection first]!

selectedSinglePackageEditionOrNil
	"Answer the single class edition selected in the classes pane"

	^editionsPresenter selection size = 1 ifTrue: [editionsPresenter selection first]!

setPackageName: aString 
	packagesPresenter list do: [:each | each = aString ifTrue: [^packagesPresenter selection: each]]!

showPackageHistory
	(StsVersionTreeDiagram create)
		setEditions: editionsPresenter list selectedEdition: self selectedSinglePackageEditionOrNil;
		showShell! !
!StsPackageEditionsBrowserShell categoriesFor: #clearSource!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #createComponents!private! !
!StsPackageEditionsBrowserShell categoriesFor: #createSchematicWiring!private! !
!StsPackageEditionsBrowserShell categoriesFor: #defaultHelpId!public! !
!StsPackageEditionsBrowserShell categoriesFor: #fileOutChangesForSmalltalkX:on:!private! !
!StsPackageEditionsBrowserShell categoriesFor: #fileOutChangesForSqueak:on:!private! !
!StsPackageEditionsBrowserShell categoriesFor: #fileOutChangesForVW:on:!private! !
!StsPackageEditionsBrowserShell categoriesFor: #menuBrowseClass!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuBrowseClassEditions!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuBrowseMethod!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuBrowseMethodEditions!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuBrowsePackage!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuComparePackageEditions!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuCompareWith!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuCompareWithImage!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuExportPackageEdition!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuFileOutAsSmalltalkXChangeSet!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuFileOutAsSqueakChangeSet!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuFileOutAsVwChangeSet!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuImportPackageFromFile!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuLoadClassEdition!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuLoadMethodEdition!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuLoadPackageEdition!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuPurgeUnusedClassEditions!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuRenamePackage!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuRenameVersion!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuResourceBrowse!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #menuVersionPackage!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #methodSortBlock!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onCardChanged!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onClassSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onDeferredStartup!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onGlobalSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onLoadedPackagesChanged!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onMethodSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onPackageChanged:!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onPackageEditionSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onPackageSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onPrerequisiteSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onResourceSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onScriptSelected!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onStartup!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #onViewOpened!event handling!private! !
!StsPackageEditionsBrowserShell categoriesFor: #packageEdition!private! !
!StsPackageEditionsBrowserShell categoriesFor: #purgePackage!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #purgePackageEdition!commands!public! !
!StsPackageEditionsBrowserShell categoriesFor: #queryCommand:!private! !
!StsPackageEditionsBrowserShell categoriesFor: #refresh!private! !
!StsPackageEditionsBrowserShell categoriesFor: #refreshPackageEditions!private! !
!StsPackageEditionsBrowserShell categoriesFor: #salvagePackage!private! !
!StsPackageEditionsBrowserShell categoriesFor: #salvagePackageEdition!private! !
!StsPackageEditionsBrowserShell categoriesFor: #selectedLoadedClassOrNil!accessing!public! !
!StsPackageEditionsBrowserShell categoriesFor: #selectedLoadedMethodOrNil!accessing!public! !
!StsPackageEditionsBrowserShell categoriesFor: #selectedLoadedPackageOrNil!accessing!public! !
!StsPackageEditionsBrowserShell categoriesFor: #selectedPackageName!accessing!public! !
!StsPackageEditionsBrowserShell categoriesFor: #selectedSingleClassEditionOrNil!accessing!public! !
!StsPackageEditionsBrowserShell categoriesFor: #selectedSingleMethodEditionOrNil!accessing!public! !
!StsPackageEditionsBrowserShell categoriesFor: #selectedSinglePackageEditionOrNil!accessing!public! !
!StsPackageEditionsBrowserShell categoriesFor: #setPackageName:!public! !
!StsPackageEditionsBrowserShell categoriesFor: #showPackageHistory!public! !

!StsPackageEditionsBrowserShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Package Editions Browser'!

icon
	^StsPackageEdition icon!

iconForPackageName: aStringName 
	^(Package manager packageNamed: aStringName ifNone: [^StsPackageEdition icon]) class icon!

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

isLoadedAndChangedPackage: aStringName 
	^(Package manager packageNamed: aStringName ifNone: [^false]) isChanged!

onStartup
	"Private - Ensure all the receiver's subinstances are in their clean state on startup
	rather than attempting to use an old safe array hanging around from the sesssion 
	when the image was saved."

	self primAllSubinstances do: [:i | i onStartup]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 0 416 34 2 8 1140851500 131137 544 0 466 496 0 519 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 156 196 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 0 544 466 496 8 4294906655 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 0 544 34 2 8 1140850688 131073 800 0 0 0 7 0 0 0 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 1 1 706 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 706 193 193 0 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 0 544 34 2 8 1140850688 131073 1136 0 0 0 7 0 0 0 1136 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 63 1 706 991 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1088 1104 0 27 8 'smalltalkTools' 170 192 1088 8 #() 170 176 1088 0 1 0 706 33 31 706 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 1249 51 544 962 #updateSizePosted 1088 544 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 34 2 800 1136 1104 0 27 410 ##(Smalltalk.StatusBar) 34 18 0 416 34 2 8 1140850956 1 1664 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 626 0 true 658 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 156 196 71 1 0 0 204 53 71 1 6 0 20 59 0 0 0 0 255 0 5 86 119 1] 720 0 1664 0 8 4294903691 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1664 0 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'versionInformation' 34 1 1872 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1664 0 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 799 706 1249 45 1664 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 8 #() 1104 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 2144 0 466 496 0 7 0 0 0 2144 1180166 ##(Smalltalk.ProportionalLayout) 170 176 1088 true 170 192 1088 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 51 706 1249 749 2144 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 0 2144 34 2 8 1140850688 131073 2448 0 466 496 0 7 0 0 0 2448 2226 170 176 34 4 410 ##(Smalltalk.MultipleSelectionListView) 34 30 0 2448 34 2 8 1140953161 1 2576 590662 2 ##(Smalltalk.ListModel) 138 144 1088 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #menuLoadPackageEdition 8 'Load &Edition' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2786 1 2818 #menuComparePackageEditions 8 '&Compare Editions' 1 1 0 0 0 2786 1 2818 #menuCompareWithImage 8 'Compare with &Image' 1 1 0 0 0 2786 1 2818 #menuCompareWith 8 'Compare &with...' 1 1 0 0 0 2866 4097 2786 1 2818 #showPackageHistory 8 'Show Edition &History' 1 1 0 0 0 2866 4097 2786 1 2818 #menuExportPackageEdition 8 'E&xport Edition...' 1 1 0 0 0 2738 0 true 34 3 2786 1 2818 #menuFileOutAsVwChangeSet 8 'VisualWorks Change Set' 1 1 0 0 0 2786 1 2818 #menuFileOutAsSqueakChangeSet 8 'Squeak Change Set' 1 1 0 0 0 2786 1 2818 #menuFileOutAsSmalltalkXChangeSet 8 'Smalltalk/X Change Set' 1 1 0 0 0 8 'File Out As ...' 0 1 0 0 0 0 0 2866 4097 2786 1 2818 #menuRenameVersion 8 '&Rename Version...' 1 1 0 0 0 2866 4097 2786 1 2818 #purgePackageEdition 8 '&Purge Edition from Repository...' 1 1 0 0 0 2786 1 2818 #salvagePackageEdition 8 'Sal&vage Last Purged' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2576 0 8 4294905883 ##(Smalltalk.BasicListAbstract) 0 1904 0 0 0 0 0 0 138 144 34 5 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 45 #left 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 3664 7 257 0 3650 0 0 3682 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 3792 7 513 0 3650 0 0 3682 2 1 3648 8 'doIt' 8 '[:x | x isLoadedAndChangedAfterLoad ]' 8 #[30 105 226 0 106] #isLoadedAndChangedAfterLoad 3872 7 257 0 0 2576 3650 0 0 3682 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 721414 ##(Smalltalk.Association) #Package ##(Smalltalk.Package) #changedIcon 4034 #Icon ##(Smalltalk.Icon) #blank #imageIndex 3952 7 257 0 1 0 0 3602 8 'Package Editions' 337 #left 459270 ##(Smalltalk.Message) #displayVersionDescriptor 8 #() 0 0 0 2576 ##(Smalltalk.IconicListAbstract) 1 0 0 3602 8 'Timestamp' 601 #left 3650 0 459302 ##(Smalltalk.Context) 1 1 0 0 3682 2 9 4112 8 'doIt' 34 2 8 '[:edition | edition timestamp printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #timestamp #printString 17 257 4114 #timestamp 8 #() 0 0 0 2576 0 1 0 0 3602 8 'Developer' 267 #left 4114 #developer 4368 0 0 0 2576 0 1 0 0 3602 8 'Blessing' 201 #left 4114 #displayString 8 #() 4114 #<= 4480 4114 #blessingString 4480 0 2576 0 1 0 0 #report 1088 0 131173 0 8 #(nil) 898 138 144 34 2 962 #createAt:extent: 34 2 706 339 1 706 911 369 2576 962 #contextMenu: 34 1 2752 2576 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 169 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 8 #() 1104 0 27 524806 ##(Smalltalk.Fraction) 1713 1167 410 ##(Smalltalk.ListView) 34 30 0 2448 34 2 8 1140920397 1 4768 2642 138 144 1088 0 2704 466 496 0 23 2738 0 true 34 11 2786 1 2818 #menuImportPackageFromFile 8 '&Import Package to Repository...' 1 1 0 0 0 2866 4097 2786 1 2818 #menuBrowsePackage 8 '&Browse Package' 1 1 0 0 0 2786 1 2818 #menuVersionPackage 8 '&Version Package...' 1 1 0 0 0 2786 1 2818 #menuRenamePackage 8 '&Rename Package...' 1 1 0 0 0 2866 4097 2786 1 2818 #showPackageHistory 8 'Show Edition &History' 1 1 0 0 0 2866 4097 2786 1 2818 #purgePackage 8 '&Purge Package from Repository...' 1 1 0 0 0 2786 1 2818 #menuPurgeUnusedClassEditions 8 'Purge &All Unused Class Editions...' 1 1 0 0 0 2786 1 2818 #salvagePackage 8 'Salva&ge Last Purged' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4768 0 8 4294905883 4114 #asString 8 #() 0 1904 0 0 0 0 0 0 138 144 34 2 3602 8 '' 45 #left 3650 0 0 3682 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 5472 7 257 0 3650 0 0 3682 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 5584 7 513 0 3650 0 0 3682 3 1 4112 8 'doIt' 8 '[:x | StsPackageEditionsBrowserShell isLoadedAndChangedPackage: x]' 8 #[31 105 29 17 177 106] ##(Smalltalk.StsPackageEditionsBrowserShell) #isLoadedAndChangedPackage: 5664 7 257 0 0 4768 3650 0 0 3682 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 4034 #Package ##(Smalltalk.Package) #changedIcon 4034 #Icon ##(Smalltalk.Icon) #blank #imageIndex 5744 7 257 0 1 0 0 3602 8 'Packages in Repository' 277 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 0 0 4768 3650 0 0 3682 4 1 3648 8 'doIt' 8 '[:x | (StsPackageEditionsBrowserShell iconForPackageName: x) imageIndex]' 8 #[32 105 29 17 177 160 106] ##(Smalltalk.StsPackageEditionsBrowserShell) #iconForPackageName: #imageIndex 5888 7 257 0 3 0 0 #report 1088 0 133221 0 8 #(nil) 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 329 369 4768 962 #contextMenu: 34 1 4880 4768 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 0 0 0 184 0 0 0] 8 #() 1104 0 27 4738 621 1167 false 170 192 34 4 2576 8 'packageEditions' 4768 8 'packageNames' 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 1249 369 2448 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 34 3 4768 410 ##(Smalltalk.Splitter) 34 12 0 2448 34 2 8 1140850688 1 6416 0 466 496 0 519 0 0 0 6416 898 138 144 34 1 962 #createAt:extent: 34 2 706 329 1 706 11 369 6416 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 0 0 0 0 169 0 0 0 184 0 0 0] 8 #() 1104 0 27 2576 1104 0 27 410 ##(Smalltalk.Splitter) 34 12 0 2144 34 2 8 1140850688 1 6656 0 466 496 0 519 0 0 0 6656 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 369 706 1249 11 6656 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 184 0 0 0 112 2 0 0 189 0 0 0] 8 #() 1104 0 27 410 ##(Smalltalk.ContainerView) 34 15 0 2144 34 2 8 1140850688 131073 6896 0 466 496 0 7 0 0 0 6896 2226 170 176 34 4 410 ##(Smalltalk.CardContainer) 34 16 0 6896 34 2 8 1140850688 393217 7024 0 466 496 0 7 0 0 0 7024 655878 ##(Smalltalk.CardLayout) 138 144 34 3 4034 8 'Comment' 410 ##(Smalltalk.ScintillaView) 34 50 0 7024 34 2 8 1176572228 1 7200 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 196934 1 ##(Smalltalk.RGB) 30932991 0 7 2738 0 true 34 12 2786 1 2818 #accept 8 '&Accept' 1 1 0 0 0 2866 4097 2738 0 true 34 8 2786 1 2818 #undo 8 '&Undo' 1 1 0 0 0 2866 4097 2786 1 2818 #cutSelection 8 'Cu&t' 1 1 0 0 0 2786 1 2818 #copySelection 8 '&Copy' 1 1 0 0 0 2786 1 2818 #pasteClipboard 8 '&Paste' 1 1 0 0 0 2786 1 2818 #clearSelection 8 'De&lete' 1 1 0 0 0 2866 4097 2786 1 2818 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 2786 1 2818 #clear 8 'Clea&r' 1 1 0 0 0 2866 4097 2786 1 2818 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 2786 1 2818 #displayIt 8 '&Display It' 1 1 0 0 0 2786 1 2818 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 2786 1 2818 #inspectIt 8 '&Inspect It' 1 1 7938 0 true 7984 8 'BasicInspector.ico' 8032 0 0 2786 1 2818 #debugIt 8 'Deb&ug It' 1 1 7938 0 true 7984 8 'Debugger.ico' 8032 0 0 2866 4097 2738 0 true 34 2 2786 2097153 2818 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 2786 1 2818 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 7200 7330 8454145 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 11 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 8594 77 786694 ##(Smalltalk.IndexedColor) 33554457 8642 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 8608 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 7200 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1088 0 170 176 1088 9215 0 0 0 0 8642 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 8560 0 0 0 0 1 0 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 7200 33423361 3 false #Warning 0 0 0 0 0 0 #Error 8930 17 7200 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 8594 1029 0 7330 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 8594 1027 7330 60239 7330 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 8594 1031 7330 335 7330 31317503 1 0 0 0 0 #Error 0 0 0 0 898 138 144 34 6 962 #createAt:extent: 34 2 706 9 55 706 561 305 7200 962 #contextMenu: 34 1 7360 7200 962 #modificationEventMask: 8 #(4607) 7200 962 #caretPeriod: 8 #(530) 7200 962 #wordWrap: 8 #(true) 7200 962 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 7200 1 3 0 0 5 0 9426 3 7200 1 0 0 67108863 5 0 9426 5 7200 1 0 0 0 5 0 7200 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 8 #() 1104 0 29 4034 8 'Version Comment' 410 ##(Smalltalk.ScintillaView) 34 50 0 7024 34 2 8 1176572228 1 9568 7266 0 false 7312 0 7330 30932991 0 5 2738 0 true 34 12 2786 1 2818 #accept 7424 1 1 0 0 0 2866 4097 2738 0 true 34 8 2786 1 2818 #undo 7520 1 1 0 0 0 2866 4097 2786 1 2818 #cutSelection 7584 1 1 0 0 0 2786 1 2818 #copySelection 7632 1 1 0 0 0 2786 1 2818 #pasteClipboard 7680 1 1 0 0 0 2786 1 2818 #clearSelection 7728 1 1 0 0 0 2866 4097 2786 1 2818 #selectAll 7792 1 1 0 0 0 7808 0 134217729 0 0 0 0 0 2786 1 2818 #clear 7856 1 1 0 0 0 2866 4097 2786 1 2818 #browseIt 7920 1 1 7938 0 true 7984 8000 8032 0 0 2786 1 2818 #displayIt 8096 1 1 0 0 0 2786 1 2818 #evaluateIt 8144 1 1 0 0 0 2786 1 2818 #inspectIt 8192 1 1 7938 0 true 7984 8224 8032 0 0 2786 1 2818 #debugIt 8272 1 1 7938 0 true 7984 8304 8032 0 0 2866 4097 2738 0 true 34 2 2786 2097153 2818 #browseDefinitions 8400 1 1 0 0 0 2786 1 2818 #browseReferences 8448 1 1 0 0 0 8464 0 134217729 0 0 0 0 0 8480 0 134217729 0 0 0 0 0 0 0 9568 7330 8454145 8 4294906539 8530 0 0 11 0 170 192 34 4 #normal 8594 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 8594 77 8656 8672 1 0 0 0 0 #callTip 0 0 0 34 40 10448 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8706 #normal 170 192 34 2 #default 8770 1 0 0 0 9568 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1088 0 170 176 1088 9215 0 0 0 0 8832 0 0 65 0 0 0 8848 3 170 192 34 2 #container 10416 0 0 0 0 1 0 170 192 34 4 #Warning 8930 19 9568 33423361 3 false #Warning 0 0 0 0 0 0 #Error 8930 17 9568 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 8594 1029 0 7330 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 8594 1027 7330 60239 7330 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 8594 1031 7330 335 7330 31317503 1 0 0 0 0 #Error 0 0 0 0 898 138 144 34 6 962 #createAt:extent: 34 2 706 9 55 706 561 305 9568 962 #contextMenu: 34 1 9664 9568 962 #modificationEventMask: 8 #(4607) 9568 962 #caretPeriod: 8 #(530) 9568 962 #wordWrap: 8 #(true) 9568 962 #margins: 34 1 34 3 9426 1 9568 1 3 0 0 5 0 9426 3 9568 1 0 0 67108863 5 0 9426 5 9568 1 0 0 0 5 0 9568 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 8 #() 1104 0 29 4034 8 'Source' 410 ##(Smalltalk.ScintillaView) 34 50 0 7024 34 2 8 1411453252 1 11264 7266 0 false 7312 0 0 0 21 0 0 0 11264 0 8 4294906539 8530 0 0 11 0 170 192 34 4 #normal 8594 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 8594 77 8656 8672 1 0 0 0 0 #callTip 0 0 0 34 40 11408 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 0 0 false 138 144 1088 170 192 34 2 #default 8770 1 0 0 0 11264 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1088 0 170 176 1088 9215 0 0 0 0 8832 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 11376 0 0 0 0 3 0 170 192 34 6 #Notification 8930 17 11264 33554437 11 false #Notification 0 0 0 0 0 0 #Warning 8930 19 11264 33554465 3 false #Warning 0 0 0 0 0 0 #Error 8930 21 11264 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 8594 1029 0 7330 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 8594 1027 7330 60239 7330 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 8594 1031 7330 335 7330 31317503 1 0 0 0 0 #Error 0 0 0 0 898 138 144 34 7 962 #createAt:extent: 34 2 706 9 55 706 561 305 11264 962 #modificationEventMask: 8 #(4607) 11264 962 #hoverTime: 8 #(500) 11264 962 #caretPeriod: 8 #(530) 11264 962 #wordWrap: 8 #(true) 11264 962 #margins: 34 1 34 3 9426 1 11264 1 3 0 0 5 0 9426 3 11264 1 0 0 67108863 5 0 9426 5 11264 1 0 0 0 5 0 11264 962 #tabWidth: 8 #(4) 11264 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 8 #() 1104 0 29 7200 170 192 34 6 7200 8 'comment' 9568 8 'versionComment' 11264 8 'source' 0 410 ##(Smalltalk.TabView) 34 23 0 7024 34 2 8 1140916736 1 12448 2642 138 144 34 3 11248 7184 9552 0 2704 1730 31 0 1 0 0 0 12448 0 8 4294903993 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 #noIcons 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 581 371 12448 962 #basicSelectionsByIndex: 34 1 8 #(2) 12448 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 12448 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 185 0 0 0] 8 #() 1104 0 27 898 138 144 34 1 962 #createAt:extent: 34 2 706 669 1 706 581 371 7024 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 78 1 0 0 0 0 0 0 112 2 0 0 185 0 0 0] 34 4 11264 7200 9568 12448 1104 0 27 4738 1093 1167 410 ##(Smalltalk.CardContainer) 34 16 0 6896 34 2 8 1140850688 131073 13008 0 466 496 0 7 0 0 0 13008 7106 138 144 34 7 4034 8 'Globals' 410 ##(Smalltalk.ListView) 34 30 0 13008 34 2 8 1140936781 1025 13168 2642 138 144 1088 0 2704 466 496 0 13 0 0 0 13168 0 8 4294905883 ##(Smalltalk.BasicListAbstract) 3650 0 4210 1 1 0 0 3682 4 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:symbol | (Smalltalk at: symbol ifAbsent: [nil]) icon imageIndex]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 19 0 17 230 32 45 228 32 252 0 0 1 1 2 0 60 106 191 160 161 106 100 105] 4034 #Smalltalk ##(Smalltalk) #at:ifAbsent: #icon #imageIndex 17 257 0 1904 0 0 0 0 0 0 138 144 34 1 3602 8 '' 751 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 0 0 13168 0 1 0 0 #report 1088 0 133217 0 8 #(nil) 898 138 144 34 1 962 #createAt:extent: 34 2 706 9 101 706 643 263 13168 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 0 27 4034 8 'Resources' 410 ##(Smalltalk.ListView) 34 30 0 13008 34 2 8 1140920397 1025 13728 2642 138 144 1088 0 2704 466 496 0 13 2738 0 true 34 1 2786 1 2818 #menuResourceBrowse 8 'Browse View' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 13728 0 8 4294905883 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 0 138 144 34 2 3602 8 'Owning class' 451 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 4114 #className 8 #() 0 13728 3600 1 0 0 3602 8 'Resource name' 185 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 4114 #name 8 #() 0 13728 3600 3 0 0 #report 1088 0 131169 0 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 706 9 101 706 643 263 13728 962 #contextMenu: 34 1 13840 13728 962 #text: 34 1 8 'Owning class' 13728 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 0 27 4034 8 'Scripts' 410 ##(Smalltalk.ListBox) 34 17 0 13008 34 2 8 1144062209 1025 14400 2642 138 144 1088 0 2704 466 496 0 5 0 0 0 14400 0 8 4294904045 ##(Smalltalk.BasicListAbstract) 1088 false 898 138 144 34 2 962 #createAt:extent: 34 2 706 9 101 706 643 263 14400 962 #horizontalExtent: 8 #(0) 14400 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 0 27 4034 8 'Inspector' 410 ##(Smalltalk.ContainerView) 34 15 0 13008 34 2 8 1140850688 131073 14752 0 466 496 0 5 0 0 0 14752 2226 138 ##(Smalltalk.Dictionary) 34 2 4034 410 ##(Smalltalk.TreeView) 34 27 0 14752 34 2 8 1140916771 1025 14896 590918 3 ##(Smalltalk.TreeModel) 0 2704 525062 ##(Smalltalk.TreeNode) 0 0 0 170 192 1088 466 496 0 5 0 0 0 14896 0 8 4294904023 ##(Smalltalk.BasicListAbstract) 3650 0 4210 1 1 0 0 3682 2 9 106 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 34 2 8 '[:x | 	x value icon imageIndex ]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 9 0 17 230 32 228 32 142 158 159 106 100 105] #icon #imageIndex 17 257 ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 170 176 1088 17 #smallIcons 1 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 493 181 14896 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 246 0 0 0 90 0 0 0] 8 #() 1104 0 27 3 4034 410 ##(Smalltalk.Splitter) 34 12 0 14752 34 2 8 1140850688 1 15456 0 466 496 0 517 0 0 0 15456 898 138 144 34 1 962 #createAt:extent: 34 2 706 493 1 706 7 181 15456 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 246 0 0 0 0 0 0 0 249 0 0 0 90 0 0 0] 8 #() 1104 0 27 1 false 170 192 34 4 14896 8 'aspects' 410 ##(Smalltalk.CardContainer) 34 16 0 14752 34 2 8 1140850688 131073 15744 0 466 496 0 21 0 0 0 15744 7106 138 144 1088 0 170 192 1088 0 410 ##(Smalltalk.TabView) 34 23 0 15744 34 2 8 1140916736 1 15872 2642 138 144 1088 0 2704 1730 31 0 1 0 0 0 15872 0 8 4294903993 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 #noIcons 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 493 181 15872 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 15872 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 246 0 0 0 90 0 0 0] 8 #() 1104 0 27 898 138 144 34 1 962 #createAt:extent: 34 2 706 499 1 706 493 181 15744 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 249 0 0 0 0 0 0 0 239 1 0 0 90 0 0 0] 34 1 15872 1104 0 27 8 'display' 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 9 101 706 643 263 14752 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 34 3 14896 15456 15744 1104 0 27 4034 8 'Classes' 410 ##(Smalltalk.MultipleSelectionListView) 34 30 0 13008 34 2 8 1140936779 1 16560 2642 138 144 1088 0 2704 466 496 0 15 2738 0 true 34 4 2786 1 2818 #menuLoadClassEdition 8 '&Load Edition' 1 1 0 0 0 2786 1 2818 #menuBrowseClassEditions 8 'Browse &Editions' 1 1 0 0 0 2866 4097 2786 1 2818 #menuBrowseClass 8 'Browse Class' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 16560 0 8 4294905883 4114 #name 8 #() ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 0 138 144 34 1 3602 8 '' 601 #left 4114 #name 8 #() ##(Smalltalk.SortedCollection) 0 0 16560 0 1 0 0 #list 1088 0 133217 0 8 #(nil) 898 138 144 34 2 962 #createAt:extent: 34 2 706 9 101 706 643 263 16560 962 #contextMenu: 34 1 16672 16560 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 0 27 4034 8 'Prerequisites' 410 ##(Smalltalk.ListBox) 34 17 0 13008 34 2 8 1144062209 1025 17264 2642 138 144 1088 0 2704 466 496 0 5 0 0 0 17264 0 8 4294904045 ##(Smalltalk.BasicListAbstract) 1088 false 898 138 144 34 2 962 #createAt:extent: 34 2 706 9 101 706 643 263 17264 962 #horizontalExtent: 8 #(0) 17264 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 0 27 4034 8 'Loose Methods' 410 ##(Smalltalk.MultipleSelectionListView) 34 30 0 13008 34 2 8 1140920393 1025 17616 2642 138 144 1088 0 2704 466 496 0 13 2738 0 true 34 4 2786 1 2818 #menuLoadMethodEdition 8 '&Load Edition' 1 1 0 0 0 2786 1 2818 #menuBrowseMethodEditions 8 '&Browse Editions' 1 1 0 0 0 2866 4097 2786 1 2818 #menuBrowseMethod 8 'Browse Method' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 17616 0 8 4294905883 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 0 138 144 34 2 3602 8 'Selector' 501 #left 4114 #selector 8 #() 3650 0 4210 2 1 0 0 0 3682 1 13 106 8 'Dolphin' 8 'SortedCollection' 8 'doIt' 34 2 8 '[:a :b | a selector < b selector]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 2 0 1 1 14 0 17 18 230 33 230 32 228 32 158 228 33 158 128 106 100 105] #selector 17 513 0 0 0 17616 ##(Smalltalk.IconicListAbstract) 1 0 0 3602 8 'Class' 135 #left ##(Smalltalk.BasicListAbstract) 3650 0 4210 2 1 0 0 0 3682 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | a name asString > b name asString]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 2 0 1 1 16 0 17 18 230 33 230 32 228 32 158 159 228 33 158 159 129 106 100 105] #name #asString 17 513 0 4114 #methodClassOrProxy 8 #() 0 17616 ##(Smalltalk.IconicListAbstract) 3 0 0 #report 1088 0 131173 0 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 706 9 101 706 643 263 17616 962 #contextMenu: 34 1 17728 17616 962 #text: 34 1 8 'Selector' 17616 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 0 27 16560 170 192 34 14 17616 8 'methods' 13728 8 'resources' 16560 8 'classes' 14752 8 'inspector' 14400 8 'scripts' 13168 8 'globals' 17264 8 'prerequisites' 0 410 ##(Smalltalk.TabView) 34 23 0 13008 34 2 8 1140916736 1 18848 2642 138 144 34 7 16544 17600 13152 13712 14384 14736 17248 0 2704 1730 31 0 1 0 0 0 18848 0 8 4294903993 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 0 0 0 0 0 #noIcons 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 659 371 18848 962 #basicSelectionsByIndex: 34 1 8 #(1) 18848 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 18848 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 73 1 0 0 185 0 0 0] 8 #() 1104 0 27 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 659 371 13008 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 73 1 0 0 185 0 0 0] 34 8 16560 17616 13168 13728 14400 14752 17264 18848 1104 0 27 4738 1241 1167 false 170 192 34 2 13008 8 'packageCards' 0 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 379 706 1249 371 6896 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 189 0 0 0 112 2 0 0 118 1 0 0] 34 3 13008 410 ##(Smalltalk.Splitter) 34 12 0 6896 34 2 8 1140850688 1 19616 0 466 496 0 519 0 0 0 19616 898 138 144 34 1 962 #createAt:extent: 34 2 706 659 1 706 11 371 19616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 73 1 0 0 0 0 0 0 78 1 0 0 185 0 0 0] 8 #() 1104 0 27 7024 1104 0 27 1104 0 27 170 192 34 2 544 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 6 2738 0 true 34 9 2786 1 2818 #fileNew 8 '&New' 8349 1 0 0 0 2786 1 2818 #fileOpen 8 '&Open...' 8351 1 0 0 0 2786 1 2818 #fileFileIn 8 '&File In...' 1 1 0 0 0 2866 4097 2786 1 2818 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 2786 1 2818 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 2786 1 2818 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 2866 4097 2786 1 2818 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 8 '&File' 0 1 0 0 40173 0 0 2738 0 true 34 11 2786 1 2818 #undo 8 '&Undo' 8373 1 0 0 0 2866 4097 2786 1 2818 #cutSelection 8 'Cu&t' 8369 1 0 0 0 2786 1 2818 #copySelection 8 '&Copy' 8327 1 0 0 0 2786 1 2818 #pasteClipboard 8 '&Paste' 8365 1 0 0 0 2786 1 2818 #clearSelection 8 '&Delete' 1 1 0 0 0 2786 1 2818 #selectAll 8 'Select &All' 1 1 0 0 0 2866 4097 2786 1 2818 #find 8 '&Find...' 8333 1 0 0 0 2786 1 2818 #findNext 8 'Find &Next' 229 1 0 0 0 2786 1 2818 #findReplace 8 '&Replace...' 8337 1 0 0 0 8 '&Edit' 0 1 0 0 40193 0 0 2738 0 true 34 7 2786 1 2818 #browseIt 8 '&Browse It' 8325 1 0 0 0 2786 1 2818 #displayIt 8 '&Display It' 8329 1 0 0 0 2786 1 2818 #evaluateIt 8 '&Evaluate It' 8331 1 0 0 0 2786 1 2818 #inspectIt 8 '&Inspect It' 8339 1 0 0 0 2786 1 2818 #fileItIn 8 '&File It In' 1 1 0 0 0 2866 4097 2786 1 2818 #accept 8 '&Accept' 8359 1 0 0 0 8 '&Workspace' 0 1 0 0 40207 0 0 2738 0 true 8 #() 8 '&Tools' #toolsMenu 1 0 0 40209 0 0 2738 0 true 8 #() 8 'Wi&ndow' #windowMenu 134217729 0 0 40211 0 0 2738 0 true 34 15 2786 1 2818 #helpContents 8 '&Contents' 1025 1 7938 0 true 7984 49 786694 ##(Smalltalk.ShellLibrary) 0 0 2786 1 2818 #help 8 'On this &Tool' 1249 1 0 0 0 2786 1 2818 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2866 4097 2786 1 2818 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 2866 4097 2786 1 2818 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2786 1 2818 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2786 1 2818 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2866 4097 2786 1 2818 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2786 1 2818 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2786 1 2818 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2866 4097 2786 1 2818 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7938 0 true 7984 8 '!!APPLICATION' 8032 0 0 8 '&Help' 0 134217729 0 0 40235 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 898 138 144 34 3 962 #createAt:extent: 34 2 706 3839 21 706 1281 961 416 962 #text: 34 1 8 'Package Editions Browser' 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 34 3 544 2144 1664 1104 0 27 )!

show
	StsManager current isConnected ifFalse: [StsManager install].
	StsManager current isConnected ifFalse: [^self].
	super show!

toolsFolderHelpId
	^10607!

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
!StsPackageEditionsBrowserShell class categoriesFor: #displayOn:!public! !
!StsPackageEditionsBrowserShell class categoriesFor: #icon!public! !
!StsPackageEditionsBrowserShell class categoriesFor: #iconForPackageName:!helpers!private! !
!StsPackageEditionsBrowserShell class categoriesFor: #initialize!initializing!private! !
!StsPackageEditionsBrowserShell class categoriesFor: #isLoadedAndChangedPackage:!helpers!private! !
!StsPackageEditionsBrowserShell class categoriesFor: #onStartup!event handling!private! !
!StsPackageEditionsBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!StsPackageEditionsBrowserShell class categoriesFor: #show!public! !
!StsPackageEditionsBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!StsPackageEditionsBrowserShell class categoriesFor: #uninitialize!initializing!must strip!private! !

