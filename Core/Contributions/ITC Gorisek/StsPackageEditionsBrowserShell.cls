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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140851500 131137 544 nil 466 496 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 156 196 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 nil 544 466 496 8 4294902285 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 1 1 706 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 706 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 63 1 706 991 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 170 192 1088 8 #() 170 176 1088 nil 1 nil 706 33 31 706 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 1249 51 544 962 #updateSizePosted 1088 544 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 34 2 800 1136 1104 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 1664 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil 626 nil true 658 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 156 196 71 1 0 0 204 53 71 1 6 0 20 59 0 0 0 0 255 0 5 86 119 1] 720 nil 1664 nil 8 4294906851 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1664 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'versionInformation' 34 1 1872 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1664 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 799 706 1249 45 1664 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 8 #() 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2144 nil 466 496 nil 7 nil nil nil 2144 1180166 ##(Smalltalk.ProportionalLayout) 170 176 1088 true 170 192 1088 nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 51 706 1249 749 2144 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2144 34 2 8 1140850688 131073 2448 nil 466 496 nil 7 nil nil nil 2448 2226 170 176 34 4 410 ##(Smalltalk.ListView) 34 30 nil 2448 34 2 8 1140920397 1 2576 590662 2 ##(Smalltalk.ListModel) 138 144 1088 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 nil 23 265030 4 ##(Smalltalk.Menu) nil true 34 11 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #menuImportPackageFromFile 8 '&Import Package to Repository...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2786 1 2818 #menuBrowsePackage 8 '&Browse Package' 1 1 nil nil nil 2786 1 2818 #menuVersionPackage 8 '&Version Package...' 1 1 nil nil nil 2786 1 2818 #menuRenamePackage 8 '&Rename Package...' 1 1 nil nil nil 2866 4097 2786 1 2818 #showPackageHistory 8 'Show Edition &History' 1 1 nil nil nil 2866 4097 2786 1 2818 #purgePackage 8 '&Purge Package from Repository...' 1 1 nil nil nil 2786 1 2818 #menuPurgeUnusedClassEditions 8 'Purge &All Unused Class Editions...' 1 1 nil nil nil 2786 1 2818 #salvagePackage 8 'Salva&ge Last Purged' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2576 nil 8 4294902479 459270 ##(Smalltalk.Message) #asString 8 #() nil 1904 nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 45 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 3440 7 257 nil 3426 0 nil 3458 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 3568 7 513 nil 3426 0 nil 3458 3 1 3296 8 'doIt' 8 '[:x | StsPackageEditionsBrowserShell isLoadedAndChangedPackage: x]' 8 #[31 105 29 17 177 106] ##(Smalltalk.StsPackageEditionsBrowserShell) #isLoadedAndChangedPackage: 3648 7 257 nil nil 2576 3426 0 nil 3458 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 721414 ##(Smalltalk.Association) #Package ##(Smalltalk.Package) #changedIcon 3810 #Icon ##(Smalltalk.Icon) #blank #imageIndex 3728 7 257 nil 1 nil nil 3378 8 'Packages in Repository' 277 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 2576 3426 0 nil 3458 4 1 3424 8 'doIt' 8 '[:x | (StsPackageEditionsBrowserShell iconForPackageName: x) imageIndex]' 8 #[32 105 29 17 177 160 106] ##(Smalltalk.StsPackageEditionsBrowserShell) #iconForPackageName: #imageIndex 3888 7 257 nil 3 nil nil #report 1088 nil 133221 nil 8 #(nil) 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 329 369 2576 962 #contextMenu: 34 1 2752 2576 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 0 0 0 184 0 0 0] 8 #() 1104 nil 27 524806 ##(Smalltalk.Fraction) 621 1167 410 ##(Smalltalk.MultipleSelectionListView) 34 30 nil 2448 34 2 8 1140953161 1 4208 2642 138 144 1088 nil 2704 466 496 nil 7 2738 nil true 34 15 2786 1 2818 #menuLoadPackageEdition 8 'Load &Edition' 1 1 nil nil nil 2866 4097 2786 1 2818 #menuComparePackageEditions 8 '&Compare Editions' 1 1 nil nil nil 2786 1 2818 #menuCompareWithImage 8 'Compare with &Image' 1 1 nil nil nil 2786 1 2818 #menuCompareWith 8 'Compare &with...' 1 1 nil nil nil 2866 4097 2786 1 2818 #showPackageHistory 8 'Show Edition &History' 1 1 nil nil nil 2866 4097 2786 1 2818 #menuExportPackageEdition 8 'E&xport Edition...' 1 1 nil nil nil 2738 nil true 34 3 2786 1 2818 #menuFileOutAsVwChangeSet 8 'VisualWorks Change Set' 1 1 nil nil nil 2786 1 2818 #menuFileOutAsSqueakChangeSet 8 'Squeak Change Set' 1 1 nil nil nil 2786 1 2818 #menuFileOutAsSmalltalkXChangeSet 8 'Smalltalk/X Change Set' 1 1 nil nil nil 8 'File Out As ...' nil 1 nil nil nil nil nil 2866 4097 2786 1 2818 #menuRenameVersion 8 '&Rename Version...' 1 1 nil nil nil 2866 4097 2786 1 2818 #purgePackageEdition 8 '&Purge Edition from Repository...' 1 1 nil nil nil 2786 1 2818 #salvagePackageEdition 8 'Sal&vage Last Purged' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4208 nil 8 4294902479 ##(Smalltalk.BasicListAbstract) nil 1904 nil nil nil nil nil nil 138 144 34 5 3378 8 '' 45 #left 3426 0 nil 3458 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 5152 7 257 nil 3426 0 nil 3458 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 5264 7 513 nil 3426 0 nil 3458 2 1 3424 8 'doIt' 8 '[:x | x isLoadedAndChangedAfterLoad ]' 8 #[30 105 226 0 106] #isLoadedAndChangedAfterLoad 5344 7 257 nil nil 4208 3426 0 nil 3458 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 3810 #Package ##(Smalltalk.Package) #changedIcon 3810 #Icon ##(Smalltalk.Icon) #blank #imageIndex 5424 7 257 nil 1 nil nil 3378 8 'Package Editions' 337 #left 3298 #displayVersionDescriptor 8 #() nil nil nil 4208 ##(Smalltalk.IconicListAbstract) 1 nil nil 3378 8 'Timestamp' 601 #left 3426 0 459302 ##(Smalltalk.Context) 1 1 nil nil 3458 2 9 3296 8 'doIt' 34 2 8 '[:edition | edition timestamp printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #timestamp #printString 17 257 3298 #timestamp 8 #() nil nil nil 4208 nil 1 nil nil 3378 8 'Developer' 267 #left 3298 #developer 5808 nil nil nil 4208 nil 1 nil nil 3378 8 'Blessing' 201 #left 3298 #displayString 8 #() 3298 #<= 5920 3298 #blessingString 5920 nil 4208 nil 1 nil nil #report 1088 nil 131173 nil 34 4 nil nil 706 1 1 nil 898 138 144 34 2 962 #createAt:extent: 34 2 706 339 1 706 911 369 4208 962 #contextMenu: 34 1 4320 4208 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 169 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 8 #() 1104 nil 27 4178 1713 1167 false 170 192 34 4 2576 8 'packageNames' 4208 8 'packageEditions' nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 1249 369 2448 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 34 3 2576 410 ##(Smalltalk.Splitter) 34 12 nil 2448 34 2 8 1140850688 1 6432 nil 466 496 nil 519 nil nil nil 6432 898 138 144 34 1 962 #createAt:extent: 34 2 706 329 1 706 11 369 6432 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 0 0 0 0 169 0 0 0 184 0 0 0] 8 #() 1104 nil 27 4208 1104 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 2144 34 2 8 1140850688 1 6672 nil 466 496 nil 519 nil nil nil 6672 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 369 706 1249 11 6672 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 184 0 0 0 112 2 0 0 189 0 0 0] 8 #() 1104 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2144 34 2 8 1140850688 131073 6912 nil 466 496 nil 7 nil nil nil 6912 2226 170 176 34 4 410 ##(Smalltalk.CardContainer) 34 16 nil 6912 34 2 8 1140850688 393217 7040 nil 466 496 nil 7 nil nil nil 7040 655878 ##(Smalltalk.CardLayout) 138 144 34 3 3810 8 'Comment' 410 ##(Smalltalk.ScintillaView) 34 50 nil 7040 34 2 8 1176572228 1 7216 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 196934 1 ##(Smalltalk.RGB) 30932991 nil 5 2738 nil true 34 12 2786 1 2818 #accept 8 '&Accept' 1 1 nil nil nil 2866 4097 2738 nil true 34 8 2786 1 2818 #undo 8 '&Undo' 1 1 nil nil nil 2866 4097 2786 1 2818 #cutSelection 8 'Cu&t' 1 1 nil nil nil 2786 1 2818 #copySelection 8 '&Copy' 1 1 nil nil nil 2786 1 2818 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 2786 1 2818 #clearSelection 8 'De&lete' 1 1 nil nil nil 2866 4097 2786 1 2818 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2786 1 2818 #clear 8 'Clea&r' 1 1 nil nil nil 2866 4097 2786 1 2818 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2786 1 2818 #displayIt 8 '&Display It' 1 1 nil nil nil 2786 1 2818 #evaluateIt 8 'E&valuate It' 1 1 nil nil nil 2786 1 2818 #inspectIt 8 '&Inspect It' 1 1 7954 nil true 8000 8 'BasicInspector.ico' 8048 nil nil 2786 1 2818 #debugIt 8 'Deb&ug It' 1 1 7954 nil true 8000 8 'Debugger.ico' 8048 nil nil 2866 4097 2738 nil true 34 2 2786 2097153 2818 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 2786 1 2818 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 7216 7346 8454145 8 4294907129 852486 ##(Smalltalk.NullConverter) nil nil 11 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 8610 77 786694 ##(Smalltalk.IndexedColor) 33554457 8658 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 8624 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 7216 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1088 nil 170 176 1088 9215 nil nil nil nil 8658 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 8576 nil nil nil nil 1 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 7216 33423361 3 false #Warning nil nil nil nil nil nil #Error 8946 17 7216 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 8610 1029 nil 7346 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 8610 1027 7346 60239 7346 31326207 1 nil nil nil nil #Warning nil nil nil #Error 8610 1031 7346 335 7346 31317503 1 nil nil nil nil #Error nil nil nil nil 898 138 144 34 8 962 #createAt:extent: 34 2 706 9 55 706 561 305 7216 962 #contextMenu: 34 1 7376 7216 962 #modificationEventMask: 8 #(4607) 7216 962 #caretPeriod: 8 #(530) 7216 962 #wordWrap: 8 #(true) 7216 962 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 7216 1 3 nil nil 5 nil 9442 3 7216 1 nil nil 67108863 5 nil 9442 5 7216 1 nil nil nil 5 nil 7216 962 #maxCompletionListHeight: 8 #(9) 7216 962 #sciSetCodePage: 8 #(65001) 7216 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 8 #() 1104 nil 29 3810 8 'Version Comment' 410 ##(Smalltalk.ScintillaView) 34 50 nil 7040 34 2 8 1176572228 1 9648 7282 nil false 7328 nil 7346 30932991 nil 7 2738 nil true 34 12 2786 1 2818 #accept 7440 1 1 nil nil nil 2866 4097 2738 nil true 34 8 2786 1 2818 #undo 7536 1 1 nil nil nil 2866 4097 2786 1 2818 #cutSelection 7600 1 1 nil nil nil 2786 1 2818 #copySelection 7648 1 1 nil nil nil 2786 1 2818 #pasteClipboard 7696 1 1 nil nil nil 2786 1 2818 #clearSelection 7744 1 1 nil nil nil 2866 4097 2786 1 2818 #selectAll 7808 1 1 nil nil nil 7824 nil 134217729 nil nil nil nil nil 2786 1 2818 #clear 7872 1 1 nil nil nil 2866 4097 2786 1 2818 #browseIt 7936 1 1 7954 nil true 8000 8016 8048 nil nil 2786 1 2818 #displayIt 8112 1 1 nil nil nil 2786 1 2818 #evaluateIt 8160 1 1 nil nil nil 2786 1 2818 #inspectIt 8208 1 1 7954 nil true 8000 8240 8048 nil nil 2786 1 2818 #debugIt 8288 1 1 7954 nil true 8000 8320 8048 nil nil 2866 4097 2738 nil true 34 2 2786 2097153 2818 #browseDefinitions 8416 1 1 nil nil nil 2786 1 2818 #browseReferences 8464 1 1 nil nil nil 8480 nil 134217729 nil nil nil nil nil 8496 nil 134217729 nil nil nil nil nil nil nil 9648 7346 8454145 8 4294907129 8546 nil nil 11 nil 170 192 34 4 #normal 8610 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 8610 77 8672 8688 1 nil nil nil nil #callTip nil nil nil 34 40 10528 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 8722 #normal 170 192 34 2 #default 8786 1 nil nil nil 9648 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1088 nil 170 176 1088 9215 nil nil nil nil 8848 nil nil 65 nil nil nil 8864 3 170 192 34 2 #container 10496 nil nil nil nil 1 nil 170 192 34 4 #Warning 8946 19 9648 33423361 3 false #Warning nil nil nil nil nil nil #Error 8946 17 9648 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 8610 1029 nil 7346 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 8610 1027 7346 60239 7346 31326207 1 nil nil nil nil #Warning nil nil nil #Error 8610 1031 7346 335 7346 31317503 1 nil nil nil nil #Error nil nil nil nil 898 138 144 34 8 962 #createAt:extent: 34 2 706 9 55 706 561 305 9648 962 #contextMenu: 34 1 9744 9648 962 #modificationEventMask: 8 #(4607) 9648 962 #caretPeriod: 8 #(530) 9648 962 #wordWrap: 8 #(true) 9648 962 #margins: 34 1 34 3 9442 1 9648 1 3 nil nil 5 nil 9442 3 9648 1 nil nil 67108863 5 nil 9442 5 9648 1 nil nil nil 5 nil 9648 962 #maxCompletionListHeight: 8 #(9) 9648 962 #sciSetCodePage: 8 #(65001) 9648 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 8 #() 1104 nil 29 3810 8 'Source' 410 ##(Smalltalk.ScintillaView) 34 50 nil 7040 34 2 8 1411453252 1 11408 7282 nil false 7328 nil nil nil 21 nil nil nil 11408 nil 8 4294907129 8546 nil nil 11 nil 170 192 34 4 #normal 8610 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 8610 77 8672 8688 1 nil nil nil nil #callTip nil nil nil 34 40 11552 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 1088 170 192 34 2 #default 8786 1 nil nil nil 11408 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1088 nil 170 176 1088 9215 nil nil nil nil 8848 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 11520 nil nil nil nil 3 nil 170 192 34 6 #Notification 8946 17 11408 33554437 11 false #Notification nil nil nil nil nil nil #Warning 8946 19 11408 33554465 3 false #Warning nil nil nil nil nil nil #Error 8946 21 11408 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 8610 1029 nil 7346 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 8610 1027 7346 60239 7346 31326207 1 nil nil nil nil #Warning nil nil nil #Error 8610 1031 7346 335 7346 31317503 1 nil nil nil nil #Error nil nil nil nil 898 138 144 34 9 962 #createAt:extent: 34 2 706 9 55 706 561 305 11408 962 #modificationEventMask: 8 #(4607) 11408 962 #hoverTime: 8 #(500) 11408 962 #caretPeriod: 8 #(530) 11408 962 #wordWrap: 8 #(true) 11408 962 #margins: 34 1 34 3 9442 1 11408 1 3 nil nil 5 nil 9442 3 11408 1 nil nil 67108863 5 nil 9442 5 11408 1 nil nil nil 5 nil 11408 962 #tabWidth: 8 #(4) 11408 962 #maxCompletionListHeight: 8 #(9) 11408 962 #sciSetCodePage: 8 #(65001) 11408 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 8 #() 1104 nil 29 9648 170 192 34 6 7216 8 'comment' 11408 8 'source' 9648 8 'versionComment' nil 410 ##(Smalltalk.TabView) 34 23 nil 7040 34 2 8 1140916736 1 12656 2642 138 144 34 3 11392 7200 9632 nil 2704 1730 31 nil 1 nil nil nil 12656 nil 8 4294907861 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 nil nil nil nil nil #noIcons 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 581 371 12656 962 #basicSelectionsByIndex: 34 1 8 #(3) 12656 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 12656 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 185 0 0 0] 8 #() 1104 nil 27 898 138 144 34 1 962 #createAt:extent: 34 2 706 669 1 706 581 371 7040 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 78 1 0 0 0 0 0 0 112 2 0 0 185 0 0 0] 34 4 11408 7216 9648 12656 1104 nil 27 4178 1093 1167 410 ##(Smalltalk.CardContainer) 34 16 nil 6912 34 2 8 1140850688 131073 13216 nil 466 496 nil 7 nil nil nil 13216 7122 138 144 34 7 3810 8 'Globals' 410 ##(Smalltalk.ListView) 34 30 nil 13216 34 2 8 1140936781 1025 13376 2642 138 144 1088 nil 2704 466 496 nil 13 nil nil nil 13376 nil 8 4294902479 ##(Smalltalk.BasicListAbstract) 3426 0 5650 1 1 nil nil 3458 4 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:symbol | (Smalltalk at: symbol ifAbsent: [nil]) icon imageIndex]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 19 0 17 230 32 45 228 32 252 0 0 1 1 2 0 60 106 191 160 161 106 100 105] 3810 #Smalltalk ##(Smalltalk) #at:ifAbsent: #icon #imageIndex 17 257 nil 1904 nil nil nil nil nil nil 138 144 34 1 3378 8 '' 751 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 13376 nil 1 nil nil #report 1088 nil 133217 nil 8 #(nil) 898 138 144 34 1 962 #createAt:extent: 34 2 706 9 101 706 643 263 13376 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 nil 27 3810 8 'Resources' 410 ##(Smalltalk.ListView) 34 30 nil 13216 34 2 8 1140920397 1025 13936 2642 138 144 1088 nil 2704 466 496 nil 13 2738 nil true 34 1 2786 1 2818 #menuResourceBrowse 8 'Browse View' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 13936 nil 8 4294902479 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 nil nil nil nil nil nil 138 144 34 2 3378 8 'Owning class' 451 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3298 #className 8 #() nil 13936 3376 1 nil nil 3378 8 'Resource name' 185 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3298 #name 8 #() nil 13936 3376 3 nil nil #report 1088 nil 131169 nil 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 706 9 101 706 643 263 13936 962 #contextMenu: 34 1 14048 13936 962 #text: 34 1 8 'Owning class' 13936 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 nil 27 3810 8 'Scripts' 410 ##(Smalltalk.ListBox) 34 17 nil 13216 34 2 8 1144062209 1025 14608 2642 138 144 1088 nil 2704 466 496 nil 5 nil nil nil 14608 nil 8 4294904911 ##(Smalltalk.BasicListAbstract) 1088 false 898 138 144 34 2 962 #createAt:extent: 34 2 706 9 101 706 643 263 14608 962 #horizontalExtent: 8 #(0) 14608 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 nil 27 3810 8 'Inspector' 410 ##(Smalltalk.ContainerView) 34 15 nil 13216 34 2 8 1140850688 131073 14960 nil 466 496 nil 7 nil nil nil 14960 2226 138 ##(Smalltalk.Dictionary) 34 2 3810 410 ##(Smalltalk.TreeView) 34 27 nil 14960 34 2 8 1140916771 1025 15104 590918 3 ##(Smalltalk.TreeModel) nil 2704 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1088 466 496 nil 7 nil nil nil 15104 nil 8 4294908199 ##(Smalltalk.BasicListAbstract) 3426 0 5650 1 1 nil nil 3458 2 9 106 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 34 2 8 '[:x | 	x value icon imageIndex ]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 1 0 1 1 9 0 17 230 32 228 32 142 158 159 106 100 105] #icon #imageIndex 17 257 ##(Smalltalk.IconicListAbstract) 1904 nil nil nil nil nil 170 176 1088 17 #smallIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1088 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 317 263 15104 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 158 0 0 0 131 0 0 0] 8 #() 1104 nil 27 3 3810 410 ##(Smalltalk.Splitter) 34 12 nil 14960 34 2 8 1140850688 1 15680 nil 466 496 nil 519 nil nil nil 15680 898 138 144 34 1 962 #createAt:extent: 34 2 706 317 1 706 11 263 15680 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 158 0 0 0 0 0 0 0 163 0 0 0 131 0 0 0] 8 #() 1104 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.CardContainer) 34 16 nil 14960 34 2 8 1140850688 131073 15952 nil 466 496 nil 23 nil nil nil 15952 7122 138 144 1088 nil 170 192 1088 nil 410 ##(Smalltalk.TabView) 34 23 nil 15952 34 2 8 1140916736 1 16080 2642 138 144 1088 nil 2704 1730 31 nil 1 nil nil nil 16080 nil 8 4294907861 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 nil nil nil nil nil #noIcons 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 317 263 16080 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 16080 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 158 0 0 0 131 0 0 0] 8 #() 1104 nil 27 898 138 144 34 1 962 #createAt:extent: 34 2 706 327 1 706 317 263 15952 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 0 0 0 0 65 1 0 0 131 0 0 0] 34 1 16080 1104 nil 27 8 'display' 15104 8 'aspects' nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 9 101 706 643 263 14960 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 34 3 15104 15680 15952 1104 nil 27 3810 8 'Classes' 410 ##(Smalltalk.MultipleSelectionListView) 34 30 nil 13216 34 2 8 1140936779 1 16784 2642 138 144 1088 nil 2704 466 496 nil 13 2738 nil true 34 4 2786 1 2818 #menuLoadClassEdition 8 '&Load Edition' 1 1 nil nil nil 2786 1 2818 #menuBrowseClassEditions 8 'Browse &Editions' 1 1 nil nil nil 2866 4097 2786 1 2818 #menuBrowseClass 8 'Browse Class' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 16784 nil 8 4294902479 3298 #name 8 #() ##(Smalltalk.IconicListAbstract) 1904 nil nil nil nil nil nil 138 144 34 1 3378 8 '' 601 #left 3298 #name 8 #() ##(Smalltalk.SortedCollection) nil nil 16784 nil 1 nil nil #list 1088 nil 133217 nil 8 #(nil) 898 138 144 34 2 962 #createAt:extent: 34 2 706 9 101 706 643 263 16784 962 #contextMenu: 34 1 16896 16784 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 nil 27 3810 8 'Prerequisites' 410 ##(Smalltalk.ListBox) 34 17 nil 13216 34 2 8 1144062209 1025 17488 2642 138 144 1088 nil 2704 466 496 nil 5 nil nil nil 17488 nil 8 4294904911 ##(Smalltalk.BasicListAbstract) 1088 false 898 138 144 34 2 962 #createAt:extent: 34 2 706 9 101 706 643 263 17488 962 #horizontalExtent: 8 #(0) 17488 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 nil 27 3810 8 'Loose Methods' 410 ##(Smalltalk.MultipleSelectionListView) 34 30 nil 13216 34 2 8 1140920393 1025 17840 2642 138 144 1088 nil 2704 466 496 nil 13 2738 nil true 34 4 2786 1 2818 #menuLoadMethodEdition 8 '&Load Edition' 1 1 nil nil nil 2786 1 2818 #menuBrowseMethodEditions 8 '&Browse Editions' 1 1 nil nil nil 2866 4097 2786 1 2818 #menuBrowseMethod 8 'Browse Method' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 17840 nil 8 4294902479 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 nil nil nil nil nil nil 138 144 34 2 3378 8 'Selector' 501 #left 3298 #selector 8 #() 3426 0 5650 2 1 nil nil nil 3458 1 13 106 8 'Dolphin' 8 'SortedCollection' 8 'doIt' 34 2 8 '[:a :b | a selector < b selector]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 2 0 1 1 14 0 17 18 230 33 230 32 228 32 158 228 33 158 128 106 100 105] #selector 17 513 nil nil nil 17840 ##(Smalltalk.IconicListAbstract) 1 nil nil 3378 8 'Class' 135 #left ##(Smalltalk.BasicListAbstract) 3426 0 5650 2 1 nil nil nil 3458 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | a name asString > b name asString]' 34 1 138 ##(Smalltalk.PoolDictionary) 1088 8 #[252 2 0 1 1 16 0 17 18 230 33 230 32 228 32 158 159 228 33 158 159 129 106 100 105] #name #asString 17 513 nil 3298 #methodClassOrProxy 8 #() nil 17840 ##(Smalltalk.IconicListAbstract) 3 nil nil #report 1088 nil 131173 nil 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 706 9 101 706 643 263 17840 962 #contextMenu: 34 1 17952 17840 962 #text: 34 1 8 'Selector' 17840 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 8 #() 1104 nil 27 14960 170 192 34 14 13376 8 'globals' 17488 8 'prerequisites' 13936 8 'resources' 14608 8 'scripts' 14960 8 'inspector' 16784 8 'classes' 17840 8 'methods' nil 410 ##(Smalltalk.TabView) 34 23 nil 13216 34 2 8 1140916736 1 19072 2642 138 144 34 7 16768 17824 13360 13920 14592 14944 17472 nil 2704 1730 31 nil 1 nil nil nil 19072 nil 8 4294907861 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1904 nil nil nil nil nil #noIcons 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 659 371 19072 962 #basicSelectionsByIndex: 34 1 8 #(6) 19072 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 19072 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 73 1 0 0 185 0 0 0] 8 #() 1104 nil 27 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 659 371 13216 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 73 1 0 0 185 0 0 0] 34 8 16784 17840 13376 13936 14608 14960 17488 19072 1104 nil 27 4178 1241 1167 false 170 192 34 2 13216 8 'packageCards' nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 379 706 1249 371 6912 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 189 0 0 0 112 2 0 0 118 1 0 0] 34 3 13216 410 ##(Smalltalk.Splitter) 34 12 nil 6912 34 2 8 1140850688 1 19840 nil 466 496 nil 519 nil nil nil 19840 898 138 144 34 1 962 #createAt:extent: 34 2 706 659 1 706 11 371 19840 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 73 1 0 0 0 0 0 0 78 1 0 0 185 0 0 0] 8 #() 1104 nil 27 7040 1104 nil 27 1104 nil 27 170 192 34 2 544 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 2738 nil true 34 9 2786 1 2818 #fileNew 8 '&New' 8349 1 nil nil nil 2786 1 2818 #fileOpen 8 '&Open...' 8351 1 nil nil nil 2786 1 2818 #fileFileIn 8 '&File In...' 1 1 nil nil nil 2866 4097 2786 1 2818 #saveImage 8 'Sa&ve Image' 1 1 nil nil nil 2786 1 2818 #saveImageAs 8 'Save Image As...' 1 1 nil nil nil 2786 1 2818 #compressChanges 8 '&Compress Changes' 1 1 nil nil nil 2866 4097 2786 1 2818 #smalltalkExit 8 'E&xit Dolphin' 1 1 nil nil nil 8 '&File' nil 1 nil nil 44105 nil nil 2738 nil true 34 11 2786 1 2818 #undo 8 '&Undo' 8373 1 nil nil nil 2866 4097 2786 1 2818 #cutSelection 8 'Cu&t' 8369 1 nil nil nil 2786 1 2818 #copySelection 8 '&Copy' 8327 1 nil nil nil 2786 1 2818 #pasteClipboard 8 '&Paste' 8365 1 nil nil nil 2786 1 2818 #clearSelection 8 '&Delete' 1 1 nil nil nil 2786 1 2818 #selectAll 8 'Select &All' 1 1 nil nil nil 2866 4097 2786 1 2818 #find 8 '&Find...' 8333 1 nil nil nil 2786 1 2818 #findNext 8 'Find &Next' 229 1 nil nil nil 2786 1 2818 #findReplace 8 '&Replace...' 8337 1 nil nil nil 8 '&Edit' nil 1 nil nil 44125 nil nil 2738 nil true 34 7 2786 1 2818 #browseIt 8 '&Browse It' 8325 1 nil nil nil 2786 1 2818 #displayIt 8 '&Display It' 8329 1 nil nil nil 2786 1 2818 #evaluateIt 8 '&Evaluate It' 8331 1 nil nil nil 2786 1 2818 #inspectIt 8 '&Inspect It' 8339 1 nil nil nil 2786 1 2818 #fileItIn 8 '&File It In' 1 1 nil nil nil 2866 4097 2786 1 2818 #accept 8 '&Accept' 8359 1 nil nil nil 8 '&Workspace' nil 1 nil nil 44139 nil nil 2738 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 44141 nil nil 2738 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 44143 nil nil 2738 nil true 34 15 2786 1 2818 #helpContents 8 '&Contents' 1025 1 7954 nil true 8000 49 786694 ##(Smalltalk.ShellLibrary) nil nil 2786 1 2818 #help 8 'On this &Tool' 1249 1 nil nil nil 2786 1 2818 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2866 4097 2786 1 2818 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 2866 4097 2786 1 2818 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2786 1 2818 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2786 1 2818 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2866 4097 2786 1 2818 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 2786 1 2818 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2786 1 2818 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2866 4097 2786 1 2818 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7954 nil true 8000 8 '!!APPLICATION' 8048 nil nil 8 '&Help' nil 134217729 nil nil 44167 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 706 3839 21 706 1281 961 416 962 #text: 34 1 8 'Package Editions Browser' 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 34 3 544 2144 1664 1104 nil 27 )!

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

