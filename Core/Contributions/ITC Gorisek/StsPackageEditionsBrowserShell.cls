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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851500 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 156 196 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 0 560 482 512 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 63 1 738 991 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 738 193 193 0 27 8 'smalltalkTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Image_tools 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 63 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1168 1184 0 27 8 'imageTools' 234 256 1168 98 0 234 240 1168 0 1 0 738 33 31 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1249 51 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 98 2 1216 832 1184 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 1776 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 156 196 71 1 0 0 204 53 71 1 6 0 20 59 0 0 0 0 255 0 5 86 119 1] 752 0 1776 0 8 4294905391 234 256 98 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1776 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'versionInformation' 98 1 2000 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1776 0 0 962 202 208 98 1 1026 1056 98 2 738 1 799 738 1249 45 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 98 0 1184 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 2304 0 482 512 0 7 0 0 0 2304 1180166 ##(Smalltalk.ProportionalLayout) 234 240 1168 16 234 256 1168 0 962 202 208 98 1 1026 1056 98 2 738 1 51 738 1249 749 2304 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 98 3 410 2320 98 15 0 2304 98 2 8 1140850688 131073 2624 0 482 512 0 7 0 0 0 2624 2402 234 240 98 4 410 8 ##(Smalltalk.MultipleSelectionListView) 98 30 0 2624 98 2 8 1140953161 1 2752 590662 2 ##(Smalltalk.ListModel) 202 208 1168 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 512 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #menuLoadPackageEdition 8 'Load &Edition' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2978 1 3010 8 #menuComparePackageEditions 8 '&Compare Editions' 1 1 0 0 0 2978 1 3010 8 #menuCompareWithImage 8 'Compare with &Image' 1 1 0 0 0 2978 1 3010 8 #menuCompareWith 8 'Compare &with...' 1 1 0 0 0 3074 4097 2978 1 3010 8 #showPackageHistory 8 'Show Edition &History' 1 1 0 0 0 3074 4097 2978 1 3010 8 #menuExportPackageEdition 8 'E&xport Edition...' 1 1 0 0 0 2930 0 16 98 3 2978 1 3010 8 #menuFileOutAsVwChangeSet 8 'VisualWorks Change Set' 1 1 0 0 0 2978 1 3010 8 #menuFileOutAsSqueakChangeSet 8 'Squeak Change Set' 1 1 0 0 0 2978 1 3010 8 #menuFileOutAsSmalltalkXChangeSet 8 'Smalltalk/X Change Set' 1 1 0 0 0 8 'File Out As ...' 0 1 0 0 0 0 0 3074 4097 2978 1 3010 8 #menuRenameVersion 8 '&Rename Version...' 1 1 0 0 0 3074 4097 2978 1 3010 8 #purgePackageEdition 8 '&Purge Edition from Repository...' 1 1 0 0 0 2978 1 3010 8 #salvagePackageEdition 8 'Sal&vage Last Purged' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2752 0 8 4294909021 2016 0 2064 0 0 0 0 0 0 202 208 98 5 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 45 8 #left 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 3 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 4064 7 257 0 4050 0 0 4082 3 1 4112 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 4208 7 513 0 4050 0 0 4082 2 1 4048 8 'doIt' 8 '[:x | x isLoadedAndChangedAfterLoad ]' 8 #[30 105 226 0 106] 8 #isLoadedAndChangedAfterLoad 4320 7 257 0 0 2752 4050 0 0 4082 6 1 4112 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 721414 ##(Smalltalk.Association) 8 #Package 8 ##(Smalltalk.Package) 8 #changedIcon 4498 8 #Icon 8 ##(Smalltalk.Icon) 8 #blank 8 #imageIndex 4416 7 257 0 1 0 0 3986 8 'Package Editions' 337 4032 459270 ##(Smalltalk.Message) 8 #displayVersionDescriptor 98 0 0 0 0 2752 2032 1 0 0 3986 8 'Timestamp' 601 4032 4050 0 459302 ##(Smalltalk.Context) 1 1 0 0 4082 2 9 4688 8 'doIt' 98 2 8 '[:edition | edition timestamp printString]' 98 1 202 8 ##(Smalltalk.PoolDictionary) 1168 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 8 #timestamp 8 #printString 17 257 4690 4960 98 0 0 0 0 2752 0 1 0 0 3986 8 'Developer' 267 4032 4690 8 #developer 5008 0 0 0 2752 0 1 0 0 3986 8 'Blessing' 201 4032 4690 8 #displayString 98 0 4690 8 #<= 5152 4690 8 #blessingString 5152 0 2752 0 1 0 0 8 #report 1168 0 131173 0 98 1 0 962 202 208 98 2 1026 1056 98 2 738 339 1 738 911 369 2752 1026 8 #contextMenu: 98 1 2944 2752 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 169 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 98 0 1184 0 27 524806 ##(Smalltalk.Fraction) 1713 1167 410 8 ##(Smalltalk.ListView) 98 30 0 2624 98 2 8 1140920397 1 5504 2834 202 208 1168 0 2896 482 512 0 23 2930 0 16 98 11 2978 1 3010 8 #menuImportPackageFromFile 8 '&Import Package to Repository...' 1 1 0 0 0 3074 4097 2978 1 3010 8 #menuBrowsePackage 8 '&Browse Package' 1 1 0 0 0 2978 1 3010 8 #menuVersionPackage 8 '&Version Package...' 1 1 0 0 0 2978 1 3010 8 #menuRenamePackage 8 '&Rename Package...' 1 1 0 0 0 3074 4097 2978 1 3010 3344 8 'Show Edition &History' 1 1 0 0 0 3074 4097 2978 1 3010 8 #purgePackage 8 '&Purge Package from Repository...' 1 1 0 0 0 2978 1 3010 8 #menuPurgeUnusedClassEditions 8 'Purge &All Unused Class Editions...' 1 1 0 0 0 2978 1 3010 8 #salvagePackage 8 'Salva&ge Last Purged' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 5504 0 8 4294909021 4690 8 #asString 98 0 0 2064 0 0 0 0 0 0 202 208 98 2 3986 8 '' 45 4032 4050 0 0 4082 3 1 4112 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 6352 7 257 0 4050 0 0 4082 3 1 4112 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] 4288 4304 6464 7 513 0 4050 0 0 4082 3 1 4688 8 'doIt' 8 '[:x | StsPackageEditionsBrowserShell isLoadedAndChangedPackage: x]' 8 #[31 105 29 17 177 106] 8 ##(Smalltalk.StsPackageEditionsBrowserShell) 8 #isLoadedAndChangedPackage: 6544 7 257 0 0 5504 4050 0 0 4082 6 1 4112 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 4498 4528 4544 4560 4498 4592 4608 4624 4640 6656 7 257 0 1 0 0 3986 8 'Packages in Repository' 277 4032 2016 8 ##(Smalltalk.SortedCollection) 0 0 5504 4050 0 0 4082 4 1 4048 8 'doIt' 8 '[:x | (StsPackageEditionsBrowserShell iconForPackageName: x) imageIndex]' 8 #[32 105 29 17 177 160 106] 6624 8 #iconForPackageName: 4640 6816 7 257 0 3 0 0 5232 1168 0 133221 0 98 1 0 962 202 208 98 2 1026 1056 98 2 738 1 1 738 329 369 5504 1026 5392 98 1 5632 5504 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 0 0 0 184 0 0 0] 98 0 1184 0 27 5474 621 1167 32 234 256 98 4 2752 8 'packageEditions' 5504 8 'packageNames' 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 1249 369 2624 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 98 3 5504 410 8 ##(Smalltalk.Splitter) 98 12 0 2624 98 2 8 1140850688 1 7360 0 482 512 0 519 0 0 0 7360 962 202 208 98 1 1026 1056 98 2 738 329 1 738 11 369 7360 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 0 0 0 0 169 0 0 0 184 0 0 0] 98 0 1184 0 27 2752 1184 0 27 410 7376 98 12 0 2304 98 2 8 1140850688 1 7616 0 482 512 0 519 0 0 0 7616 962 202 208 98 1 1026 1056 98 2 738 1 369 738 1249 11 7616 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 184 0 0 0 112 2 0 0 189 0 0 0] 98 0 1184 0 27 410 2320 98 15 0 2304 98 2 8 1140850688 131073 7856 0 482 512 0 7 0 0 0 7856 2402 234 240 98 4 410 8 ##(Smalltalk.CardContainer) 98 16 0 7856 98 2 8 1140850688 393217 7984 0 482 512 0 7 0 0 0 7984 655878 ##(Smalltalk.CardLayout) 202 208 98 3 4498 8 'Comment' 410 8 ##(Smalltalk.ScintillaView) 98 50 0 7984 98 2 8 1176572228 1 8176 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 196934 1 ##(Smalltalk.RGB) 30932991 0 7 2930 0 16 98 12 2978 1 3010 8 #accept 8 '&Accept' 1 1 0 0 0 3074 4097 2930 0 16 98 8 2978 1 3010 8 #undo 8 '&Undo' 1 1 0 0 0 3074 4097 2978 1 3010 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 2978 1 3010 8 #copySelection 8 '&Copy' 1 1 0 0 0 2978 1 3010 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 2978 1 3010 8 #clearSelection 8 'De&lete' 1 1 0 0 0 3074 4097 2978 1 3010 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 2978 1 3010 8 #clear 8 'Clea&r' 1 1 0 0 0 3074 4097 2978 1 3010 8 #browseIt 8 'Bro&wse It' 1 1 4610 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 2978 1 3010 8 #displayIt 8 '&Display It' 1 1 0 0 0 2978 1 3010 8 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 2978 1 3010 8 #inspectIt 8 '&Inspect It' 1 1 4610 0 16 9104 8 'BasicInspector.ico' 9152 0 0 2978 1 3010 8 #debugIt 8 'Deb&ug It' 1 1 4610 0 16 9104 8 'Debugger.ico' 9152 0 0 3074 4097 2930 0 16 98 2 2978 2097153 3010 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 2978 1 3010 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 8176 8322 8454145 8 4294905031 852486 ##(Smalltalk.NullConverter) 0 0 11 0 234 256 98 4 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 9808 0 0 0 8 #callTip 9826 77 786694 ##(Smalltalk.IndexedColor) 33554457 9890 33554471 1 0 0 0 0 9856 0 0 0 98 40 9840 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) 9808 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 8176 8 #circle 0 0 0 0 0 0 202 208 1168 0 63 9215 0 0 0 0 9890 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 9776 0 0 0 0 1 0 234 256 98 4 8 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 8176 33423361 3 32 10208 0 0 0 0 0 0 8 #Error 10226 17 8176 33554459 3 32 10256 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 9826 1029 0 8322 31185883 1 0 0 0 0 10320 0 0 0 10256 9826 1031 8322 335 8322 31317503 1 0 0 0 0 10256 0 0 0 10208 9826 1027 8322 60239 8322 31326207 1 0 0 0 0 10208 0 0 0 0 962 202 208 98 11 1026 1056 98 2 738 9 55 738 561 305 8176 1026 5392 98 1 8352 8176 1026 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 8176 1026 8 #isTextModified: 98 1 32 8176 1026 8 #modificationEventMask: 98 1 9215 8176 1026 8 #secondaryCaretForecolor: 98 1 8322 16711423 8176 1026 8 #caretPeriod: 98 1 1061 8176 1026 8 #wordWrap: 98 1 16 8176 1026 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 8176 1 3 32 1 5 11010 3 8176 1 1 32 67108863 5 11010 5 8176 1 1 32 1 5 8176 1026 8 #tabIndents: 98 1 16 8176 1026 8 #areAdditionalCaretsVisible: 98 1 16 8176 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 98 0 1184 0 29 4498 8 'Version Comment' 410 8192 98 50 0 7984 98 2 8 1176572228 1 11248 8258 0 32 8304 0 8322 30932991 0 5 2930 0 16 98 12 2978 1 3010 8416 8432 1 1 0 0 0 3074 4097 2930 0 16 98 8 2978 1 3010 8528 8544 1 1 0 0 0 3074 4097 2978 1 3010 8608 8624 1 1 0 0 0 2978 1 3010 8672 8688 1 1 0 0 0 2978 1 3010 8736 8752 1 1 0 0 0 2978 1 3010 8800 8816 1 1 0 0 0 3074 4097 2978 1 3010 8880 8896 1 1 0 0 0 8912 0 134217729 0 0 0 0 0 2978 1 3010 8960 8976 1 1 0 0 0 3074 4097 2978 1 3010 9040 9056 1 1 4610 0 16 9104 9120 9152 0 0 2978 1 3010 9216 9232 1 1 0 0 0 2978 1 3010 9280 9296 1 1 0 0 0 2978 1 3010 9344 9360 1 1 4610 0 16 9104 9392 9152 0 0 2978 1 3010 9440 9456 1 1 4610 0 16 9104 9488 9152 0 0 3074 4097 2930 0 16 98 2 2978 2097153 3010 9584 9600 1 1 0 0 0 2978 1 3010 9648 9664 1 1 0 0 0 9680 0 134217729 0 0 0 0 0 9696 0 134217729 0 0 0 0 0 0 0 11248 8322 8454145 8 4294905031 9746 0 0 11 0 234 256 98 4 9808 9826 1 0 0 1 0 0 0 0 9808 0 0 0 9856 9826 77 9904 9920 1 0 0 0 0 9856 0 0 0 98 40 12128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9954 9808 234 256 98 2 10016 10034 1 0 0 0 11248 10064 0 0 0 0 0 0 202 208 1168 0 63 9215 0 0 0 0 10096 0 0 65 0 0 0 10112 3 234 256 98 2 10160 12096 0 0 0 0 1 0 234 256 98 4 10208 10226 19 11248 33423361 3 32 10208 0 0 0 0 0 0 10256 10226 17 11248 33554459 3 32 10256 0 0 0 0 0 0 0 0 234 256 98 6 10320 9826 1029 0 8322 31185883 1 0 0 0 0 10320 0 0 0 10256 9826 1031 8322 335 8322 31317503 1 0 0 0 0 10256 0 0 0 10208 9826 1027 8322 60239 8322 31326207 1 0 0 0 0 10208 0 0 0 0 962 202 208 98 11 1026 1056 98 2 738 9 55 738 561 305 11248 1026 5392 98 1 11344 11248 1026 10624 98 1 10658 3 1 3 11248 1026 10704 98 1 32 11248 1026 10752 98 1 9215 11248 1026 10800 98 1 8322 16711423 11248 1026 10864 98 1 1061 11248 1026 10912 98 1 16 11248 1026 10960 98 1 98 3 11010 1 11248 1 3 32 1 5 11010 3 11248 1 1 32 67108863 5 11010 5 11248 1 1 32 1 5 11248 1026 11088 98 1 16 11248 1026 11136 98 1 16 11248 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 98 0 1184 0 29 4498 8 'Source' 410 8192 98 50 0 7984 98 2 8 1411453252 1 13120 8258 0 32 8304 0 0 0 21 0 0 0 13120 0 8 4294905031 9746 0 0 11 0 234 256 98 4 9808 9826 1 0 0 1 0 0 0 0 9808 0 0 0 9856 9826 77 9904 9920 1 0 0 0 0 9856 0 0 0 98 40 13264 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 0 0 32 202 208 1168 234 256 98 2 10016 10034 1 0 0 0 13120 10064 0 0 0 0 0 0 202 208 1168 0 63 9215 0 0 0 0 10096 0 0 65 0 0 234 256 98 6 8 #specialCharacter 8 '()[]<>' 8 #literalBytes 8 '[]' 8 #literalArray 8 '()' 8 '' 3 234 256 98 2 10160 13232 0 0 0 0 3 0 234 256 98 6 10320 10226 17 13120 33554437 11 32 10320 0 0 0 0 0 0 10256 10226 21 13120 33554459 3 32 10256 0 0 0 0 0 0 10208 10226 19 13120 33554465 3 32 10208 0 0 0 0 0 0 0 0 234 256 98 6 10320 9826 1029 0 8322 31185883 1 0 0 0 0 10320 0 0 0 10256 9826 1031 8322 335 8322 31317503 1 0 0 0 0 10256 0 0 0 10208 9826 1027 8322 60239 8322 31326207 1 0 0 0 0 10208 0 0 0 0 962 202 208 98 12 1026 1056 98 2 738 9 55 738 561 305 13120 1026 10624 98 1 10658 3 1 3 13120 1026 10704 98 1 32 13120 1026 10752 98 1 9215 13120 1026 8 #hoverTime: 98 1 1001 13120 1026 10800 98 1 8322 16711423 13120 1026 10864 98 1 1061 13120 1026 10912 98 1 16 13120 1026 10960 98 1 98 3 11010 1 13120 1 3 32 1 5 11010 3 13120 1 1 32 67108863 5 11010 5 13120 1 1 32 1 5 13120 1026 11088 98 1 16 13120 1026 8 #tabWidth: 98 1 9 13120 1026 11136 98 1 16 13120 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 28 1 0 0 179 0 0 0] 98 0 1184 0 29 8176 234 256 98 6 11248 8 'versionComment' 8176 8 'comment' 13120 8 'source' 0 410 8 ##(Smalltalk.TabView) 98 23 0 7984 98 2 8 1140916736 1 14560 2834 202 208 98 3 13104 8160 11232 0 2896 1858 31 0 1 0 0 0 14560 0 8 4294903943 2016 2032 2064 0 0 0 0 0 8 #noIcons 962 202 208 98 3 1026 1056 98 2 738 1 1 738 581 371 14560 1026 8 #basicSelectionsByIndex: 98 1 98 1 5 14560 1026 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 14560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 185 0 0 0] 98 0 1184 0 27 962 202 208 98 1 1026 1056 98 2 738 669 1 738 581 371 7984 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 78 1 0 0 0 0 0 0 112 2 0 0 185 0 0 0] 98 4 13120 8176 11248 14560 1184 0 27 5474 1093 1167 410 8000 98 16 0 7856 98 2 8 1140850688 131073 15184 0 482 512 0 7 0 0 0 15184 8082 202 208 98 7 4498 8 'Globals' 410 5520 98 30 0 15184 98 2 8 1140936781 1025 15344 2834 202 208 1168 0 2896 482 512 0 13 0 0 0 15344 0 8 4294909021 2016 4050 0 4802 1 1 0 0 4082 4 9 4112 8 'doIt' 98 2 8 '[:symbol | (Smalltalk at: symbol ifAbsent: [nil]) icon imageIndex]' 98 1 202 4928 1168 8 #[252 1 0 1 1 19 0 17 230 32 45 228 32 252 0 0 1 1 2 0 60 106 191 160 161 106 100 105] 4498 8 #Smalltalk 48 8 #at:ifAbsent: 8 #icon 4640 17 257 0 2064 0 0 0 0 0 0 202 208 98 1 3986 8 '' 751 4032 2016 6800 0 0 15344 0 1 0 0 5232 1168 0 133217 0 98 1 0 962 202 208 98 1 1026 1056 98 2 738 9 101 738 643 263 15344 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 98 0 1184 0 27 4498 8 'Resources' 410 5520 98 30 0 15184 98 2 8 1140920397 1025 15952 2834 202 208 1168 0 2896 482 512 0 13 2930 0 16 98 1 2978 1 3010 8 #menuResourceBrowse 8 'Browse View' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 15952 0 8 4294909021 2016 2032 2064 0 0 0 0 0 0 202 208 98 2 3986 8 'Owning class' 451 4032 2016 6800 4690 8 #className 98 0 0 15952 3984 1 0 0 3986 8 'Resource name' 185 4032 2016 6800 4690 8 #name 98 0 0 15952 3984 3 0 0 5232 1168 0 131169 0 98 1 0 962 202 208 98 3 1026 1056 98 2 738 9 101 738 643 263 15952 1026 5392 98 1 16064 15952 1026 8 #text: 98 1 8 'Owning class' 15952 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 98 0 1184 0 27 4498 8 'Scripts' 410 8 ##(Smalltalk.ListBox) 98 17 0 15184 98 2 8 1144062209 1025 16688 2834 202 208 1168 0 2896 482 512 0 5 0 0 0 16688 0 8 4294903909 2016 1168 32 962 202 208 98 2 1026 1056 98 2 738 9 101 738 643 263 16688 1026 8 #horizontalExtent: 98 1 1 16688 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 98 0 1184 0 27 4498 8 'Inspector' 410 2320 98 15 0 15184 98 2 8 1140850688 131073 17072 0 482 512 0 5 0 0 0 17072 2402 202 8 ##(Smalltalk.Dictionary) 98 2 4498 410 7376 98 12 0 17072 98 2 8 1140850688 1 17232 0 482 512 0 517 0 0 0 17232 962 202 208 98 1 1026 1056 98 2 738 493 1 738 7 181 17232 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 246 0 0 0 0 0 0 0 249 0 0 0 90 0 0 0] 98 0 1184 0 27 1 4498 410 8 ##(Smalltalk.TreeView) 98 27 0 17072 98 2 8 1140916771 1025 17488 590918 3 ##(Smalltalk.TreeModel) 0 2896 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 1168 482 512 0 5 0 0 0 17488 0 8 4294904491 2016 4050 0 4802 1 1 0 0 4082 2 9 170 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 98 2 8 '[:x | 	x value icon imageIndex ]' 98 1 202 4928 1168 8 #[252 1 0 1 1 9 0 17 230 32 228 32 142 158 159 106 100 105] 15664 4640 17 257 2032 2064 0 0 0 0 0 234 240 1168 17 8 #smallIcons 1 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 493 181 17488 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 246 0 0 0 90 0 0 0] 98 0 1184 0 27 3 32 234 256 98 4 410 8000 98 16 0 17072 98 2 8 1140850688 131073 18096 0 482 512 0 21 0 0 0 18096 8082 202 208 1168 0 234 256 1168 0 410 14576 98 23 0 18096 98 2 8 1140916736 1 18224 2834 202 208 1168 0 2896 1858 31 0 1 0 0 0 18224 0 8 4294903943 2016 2032 2064 0 0 0 0 0 14720 962 202 208 98 2 1026 1056 98 2 738 1 1 738 493 181 18224 1026 14928 98 2 -1 1 18224 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 246 0 0 0 90 0 0 0] 98 0 1184 0 27 962 202 208 98 1 1026 1056 98 2 738 499 1 738 493 181 18096 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 249 0 0 0 0 0 0 0 239 1 0 0 90 0 0 0] 98 1 18224 1184 0 27 8 'display' 17488 8 'aspects' 0 962 202 208 98 1 1026 1056 98 2 738 9 101 738 643 263 17072 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 98 3 17488 17232 18096 1184 0 27 4498 8 'Classes' 410 2768 98 30 0 15184 98 2 8 1140936779 1 18928 2834 202 208 1168 0 2896 482 512 0 15 2930 0 16 98 4 2978 1 3010 8 #menuLoadClassEdition 8 '&Load Edition' 1 1 0 0 0 2978 1 3010 8 #menuBrowseClassEditions 8 'Browse &Editions' 1 1 0 0 0 3074 4097 2978 1 3010 8 #menuBrowseClass 8 'Browse Class' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 18928 0 8 4294909021 4690 16352 98 0 2032 2064 0 0 0 0 0 0 202 208 98 1 3986 8 '' 601 4032 4690 16352 98 0 6800 0 0 18928 0 1 0 0 8 #list 1168 0 133217 0 98 1 0 962 202 208 98 2 1026 1056 98 2 738 9 101 738 643 263 18928 1026 5392 98 1 19040 18928 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 98 0 1184 0 27 4498 8 'Prerequisites' 410 16704 98 17 0 15184 98 2 8 1144062209 1025 19696 2834 202 208 1168 0 2896 482 512 0 5 0 0 0 19696 0 8 4294903909 2016 1168 32 962 202 208 98 2 1026 1056 98 2 738 9 101 738 643 263 19696 1026 16960 98 1 1 19696 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 98 0 1184 0 27 4498 8 'Loose Methods' 410 2768 98 30 0 15184 98 2 8 1140920393 1025 20048 2834 202 208 1168 0 2896 482 512 0 13 2930 0 16 98 4 2978 1 3010 8 #menuLoadMethodEdition 8 '&Load Edition' 1 1 0 0 0 2978 1 3010 8 #menuBrowseMethodEditions 8 '&Browse Editions' 1 1 0 0 0 3074 4097 2978 1 3010 8 #menuBrowseMethod 8 'Browse Method' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 20048 0 8 4294909021 2016 2032 2064 0 0 0 0 0 0 202 208 98 2 3986 8 'Selector' 501 4032 4690 8 #selector 98 0 4050 0 4802 2 1 0 0 0 4082 1 13 170 8 'Dolphin' 8 'SortedCollection' 8 'doIt' 98 2 8 '[:a :b | a selector < b selector]' 98 1 202 4928 1168 8 #[252 2 0 1 1 14 0 17 18 230 33 230 32 228 32 158 228 33 158 128 106 100 105] 20512 17 513 0 0 0 20048 2032 1 0 0 3986 8 'Class' 135 4032 2016 4050 0 4802 2 1 0 0 0 4082 2 13 4112 8 'doIt' 98 2 8 '[:a :b | a name asString > b name asString]' 98 1 202 4928 1168 8 #[252 2 0 1 1 16 0 17 18 230 33 230 32 228 32 158 159 228 33 158 159 129 106 100 105] 16352 6256 17 513 0 4690 8 #methodClassOrProxy 98 0 0 20048 2032 3 0 0 5232 1168 0 131173 0 98 1 0 962 202 208 98 3 1026 1056 98 2 738 9 101 738 643 263 20048 1026 5392 98 1 20160 20048 1026 16560 98 1 8 'Selector' 20048 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 69 1 0 0 181 0 0 0] 98 0 1184 0 27 18928 234 256 98 14 17072 8 'inspector' 16688 8 'scripts' 19696 8 'prerequisites' 15344 8 'globals' 18928 8 'classes' 15952 8 'resources' 20048 8 'methods' 0 410 14576 98 23 0 15184 98 2 8 1140916736 1 21360 2834 202 208 98 7 18912 20032 15328 15936 16672 17056 19680 0 2896 1858 31 0 1 0 0 0 21360 0 8 4294903943 2016 2032 2064 0 0 0 0 0 14720 962 202 208 98 3 1026 1056 98 2 738 1 1 738 659 371 21360 1026 14864 98 1 98 1 3 21360 1026 14928 98 2 -1 1 21360 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 73 1 0 0 185 0 0 0] 98 0 1184 0 27 962 202 208 98 1 1026 1056 98 2 738 1 1 738 659 371 15184 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 73 1 0 0 185 0 0 0] 98 8 18928 20048 15344 15952 16688 17072 19696 21360 1184 0 27 5474 1241 1167 32 234 256 98 2 15184 8 'packageCards' 0 962 202 208 98 1 1026 1056 98 2 738 1 379 738 1249 371 7856 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 189 0 0 0 112 2 0 0 118 1 0 0] 98 3 15184 410 7376 98 12 0 7856 98 2 8 1140850688 1 22128 0 482 512 0 519 0 0 0 22128 962 202 208 98 1 1026 1056 98 2 738 659 1 738 11 371 22128 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 73 1 0 0 0 0 0 0 78 1 0 0 185 0 0 0] 98 0 1184 0 27 7984 1184 0 27 1184 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 2930 0 16 98 9 2978 1 3010 8 #fileNew 8 '&New' 8349 1 0 0 0 2978 1 3010 8 #fileOpen 8 '&Open...' 8351 1 0 0 0 2978 1 3010 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 3074 4097 2978 1 3010 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 2978 1 3010 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 2978 1 3010 8 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 3074 4097 2978 1 3010 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 8 '&File' 0 1 0 0 43473 0 0 2930 0 16 98 11 2978 1 3010 8528 8 '&Undo' 8373 1 0 0 0 3074 4097 2978 1 3010 8608 8 'Cu&t' 8369 1 0 0 0 2978 1 3010 8672 8 '&Copy' 8327 1 0 0 0 2978 1 3010 8736 8 '&Paste' 8365 1 0 0 0 2978 1 3010 8800 8 '&Delete' 1 1 0 0 0 2978 1 3010 8880 8 'Select &All' 1 1 0 0 0 3074 4097 2978 1 3010 8 #find 8 '&Find...' 8333 1 0 0 0 2978 1 3010 8 #findNext 8 'Find &Next' 229 1 0 0 0 2978 1 3010 8 #findReplace 8 '&Replace...' 8337 1 0 0 0 8 '&Edit' 0 1 0 0 43493 0 0 2930 0 16 98 7 2978 1 3010 9040 8 '&Browse It' 8325 1 0 0 0 2978 1 3010 9216 8 '&Display It' 8329 1 0 0 0 2978 1 3010 9280 8 '&Evaluate It' 8331 1 0 0 0 2978 1 3010 9344 8 '&Inspect It' 8339 1 0 0 0 2978 1 3010 8 #fileItIn 8 '&File It In' 1 1 0 0 0 3074 4097 2978 1 3010 8416 8 '&Accept' 8359 1 0 0 0 8 '&Workspace' 0 1 0 0 43507 0 0 2930 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 43509 0 0 2930 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 43511 0 0 2930 0 16 98 15 2978 1 3010 8 #helpContents 8 '&Contents' 1025 1 4610 0 16 9104 49 786694 ##(Smalltalk.ShellLibrary) 0 0 2978 1 3010 8 #help 8 'On this &Tool' 1249 1 0 0 0 2978 1 3010 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3074 4097 2978 1 3010 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 3074 4097 2978 1 3010 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2978 1 3010 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2978 1 3010 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3074 4097 2978 1 3010 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2978 1 3010 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2978 1 3010 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3074 4097 2978 1 3010 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4610 0 16 9104 8 '!!APPLICATION' 9152 0 0 8 '&Help' 0 134217729 0 0 43535 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 738 3839 21 738 1281 961 416 1026 16560 98 1 8 'Package Editions Browser' 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 98 3 560 2304 1776 1184 0 27 )!

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

