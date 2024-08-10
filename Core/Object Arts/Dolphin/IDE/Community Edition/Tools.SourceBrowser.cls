"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.SourceBrowser'
	instanceVariableNames: 'listPresenter changedOnly refreshBlock packagesFilter statusModel'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.SourceBrowser guid: (Core.GUID fromString: '{87b4c6c4-026e-11d3-9fd7-00a0cc3e4a32}')!

Tools.SourceBrowser comment: 'SourceBrowser is a <SmalltalkToolShell> that implements a Source Management interface onto the various <sourceObject>s in the development system. SourceBrowser''s view of the system is somewhat different to the other tools in that operates on classes, packages, views, etc, as files. It allows these objects to externalized (filed out) and placed in a change control system. Source objects can be saved individually or en-masse and their change flags can be toggled on or off.

SourceBrowsers are typically opened either from the main development system window, which opens the browser on all source objects in the system, or from the package browser in order to operate on the source objects in a package.

Instance Variables:
	listPresenter		<ListPresenter> displaying a list of <exportableSource> objects.
	changedOnly		<BooleanPresenter> indicating whether the browser is displaying only changed objects.
	refreshBlock		<monadicValuable> that can be evaluated to refresh the browser display.

'!

!Tools.SourceBrowser categoriesForClass!MVP-Presenters! !

!Tools.SourceBrowser methodsFor!

allSourceObjects
	"Answer a <collection> of the selected source objects"
	
	^listPresenter list!

browseChangedMethods
	"Browse the changed methods in the selected classes"

	<commandQuery: #hasChangedClassesSelected>
	self model browseChangedMethodsOfClasses: self selectedSourceClasses!

browseIt
	"Context sensitive Browse-It command."

	<commandQuery: #queryBrowseSourceObject:>
	self browseSourceObject!

browseSourceObject
	"Browse the first of selected source object."

	<commandQuery: #queryBrowseSourceObject:>
	self selectedSourceObjects single browse!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	listPresenter := self add: ListPresenter new name: 'list'.
	"Most items in the list preserve identity after a refresh, but ResourceIdentifiers do not."
	listPresenter model searchPolicy: SearchPolicy equality.
	changedOnly := self add: BooleanPresenter new name: 'changedOnly'.
	changedOnly value: true.
	statusModel := ValueHolder new!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	changedOnly model
		when: #valueChanged
		send: #refresh
		to: self.
	listPresenter
		when: #actionPerformed
		send: #browseIt
		to: self.
	Smalltalk
		when: #classRemoved:
			send: #onClassRemoved:
			to: self;
		when: #variableRemoved:
			send: #onVariableRemoved:
			to: self.
	Package manager
		when: #loadedChanged
		send: #onLoadedPackagesChanged
		to: self!

fileOut: sourceObjects
	"Private - Save (file out) all the selected source objects which are saveable.
	Answer a <collection> of all those which could not be saved."

	| progress |
	sourceObjects size < 100 ifTrue: [^self fileOut: sourceObjects progressModel: [:v | ]].
	progress := ProgressDialog create.
	progress text: 'Filing out <1p> source objects' << sourceObjects size.
	progress operation: [:p | self fileOut: sourceObjects progressModel: p].
	^progress showModal!

fileOut: sourceObjects progressModel: aMonadicValuable
	| saved count |
	count := sourceObjects size.
	saved := Set new.
	
	[sourceObjects inject: 1
		into: 
			[:i :each |
			aMonadicValuable value: i * 100 / count.
			each canFileOut
				ifTrue: 
					[each fileOut.
					saved add: each].
			i + 1]]
			on: Package unsaveableSignal
			do: [:ex | UI.MessageBox errorMsg: ex messageText]
			on: OperationAborted
			do: [:ex | ].
	^sourceObjects difference: saved!

fileSave
	"Save (file out) all the selected source objects which are saveable
	in response to the menu bar File/Save command."

	<commandQuery: #hasWriteableSourceObjectsSelected>
	| notSaved |
	statusModel value: nil.
	notSaved := self fileOut: self selectedSourceObjects.
	self refresh.
	notSaved isEmpty ifTrue: [^self].
	"Come here if some files are read only"
	listPresenter selections: notSaved.
	statusModel value: (Warning
				messageText: 'A number of the selected items could not be filed out. Ensure that all the selected items are writeable and try again.')!

fileSaveAll
	"Attempt to save all the displayed source objects in response to the 
	menubar/toolbar File/Save All command."

	<commandQuery: #hasSourceObjects>
	| notSaved |
	notSaved := self fileOut: self allSourceObjects.
	self refresh.
	(notSaved isNil or: [notSaved notEmpty])
		ifTrue: 
			["Come here if some files are read only"
			MessageBox
				warning: 'A number of the items could not be filed out. 
Ensure that all the items are writeable and try again.'
				caption: 'Operation incomplete']!

hasChangedClassesSelected
	^self selectedChangedClasses notEmpty!

hasSingleSelection
	^self selectedSourceObjects size = 1!

hasSourceObjects
	^listPresenter list notEmpty!

hasWriteableSourceObjectsSelected
	^self selectedWriteableSourceObjects notEmpty!

onClassRemoved: aClass
	"Private - React to aClass being removed from the Smalltalk system."

	listPresenter model remove: aClass ifAbsent: nil!

onLoadedPackagesChanged
	"Private - React to the set of installed packages being changed."

	| uninstalled |
	uninstalled := (listPresenter model select: [:e | e isKindOf: Package])
				difference: Package manager packages.
	listPresenter model removeAll: uninstalled.
!

onVariableRemoved: aVariableBinding
	"Private - React to globalName being removed from the Dolphin system."

	listPresenter model remove: aVariableBinding ifAbsent: nil!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| statusItem |
	super onViewOpened.
	statusItem := self view viewNamed: 'status' ifNone: nil.
	statusItem notNil ifTrue: [statusItem model: statusModel]!

queryBrowseSourceObject: aCommandQuery
	| selected |
	selected := self selectedSourceObjects.
	selected size == 1
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: selected single].
	^true!

queryToggleChanged: aCommandQuery
	| changed selected |
	selected := self selectedSourceObjects.
	changed := false.
	aCommandQuery
		isEnabled: (selected notEmpty and: 
					[changed := selected first isChanged.
					selected allSatisfy: [:each | each isChanged == changed]]).
	aCommandQuery isChecked: changed!

queryToggleWriteable: aCommandQuery
	| writeable selected |
	selected := self selectedSourceObjects.
	writeable := false.
	aCommandQuery
		isEnabled: (selected notEmpty and: 
					[writeable := selected first canFileOut.
					selected allSatisfy: [:each | each canFileOut == writeable]]).
	aCommandQuery isChecked: writeable!

queryViewChangedOnly: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: changedOnly value!

refresh
	"Refresh the contents of the receiver"

	| contents |
	contents := refreshBlock value.
	changedOnly value ifTrue: [
		contents := contents select: [:each | each isChanged]].

	"After refresh initial sorting is by display string of source object."
	listPresenter list: (contents asSortedCollection: [:a :b | a displayString < b displayString]).

	self updateCaption!

refreshBlock: aBlock
	"Private - Set the block that describes which source objects the receiver is displaying"

	refreshBlock := aBlock.
	self refresh!

selectedChangedClasses
	"Private - Answer a collection of the selected source classes that are dirty."

	^self selectedSourceClasses select: [:each | each isChanged]!

selectedChangedSourceObjects
	"Private - Answer a collection of the selected source classes that are dirty."

	^self selectedSourceObjects select: [:each | each isChanged]!

selectedSourceClasses
	"Answer a collection of the selected source classes"
	
	^self selectedSourceObjects select: [:each | each isKindOf: Class]!

selectedSourceFiles
	"Answer a collection of the filenames of the selected objects"
	
	^self selectedSourceObjects collect: [:each | each fileOutName].!

selectedSourceObjects
	"Answer a collection of the selected source objects"
	
	^listPresenter selections!

selectedWriteableSourceObjects
	"Private - Answer a <collection> of the selected source objects which are currently writeable."
	
	^listPresenter selections select: [:each | each canFileOut]!

setPackagesFilter: aPackageCollection
	"Private - Set the collection packages whose owned source objects the receiver is displaying."

	(packagesFilter := aPackageCollection) isNil 
		ifTrue: [self refreshBlock: [self model packageManager allSourceObjects]]
		ifFalse: 
			[self refreshBlock: 
					[packagesFilter inject: OrderedCollection new
						into: 
							[:all :package | 
							all addAll: package allSourceObjects.
							all]]].
	self updateCaption!

toggleChanged
	"Toggle the changed flag associated with all the selected objects"

	<commandQuery: #queryToggleChanged:>
	self selectedSourceObjects do: [:each | each isChanged: each isChanged not].
	self updateSelected!

toggleWriteable
	"Toogle the writeable state associated with all the selected objects"

	<commandQuery: #queryToggleWriteable:>
	self selectedSourceFiles do: 
			[:each |
			| state |
			state := File isWriteable: each.
			File isWriteable: each set: state not].
	self updateSelected!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed."

	| strm |
	strm := String writeStream.
	strm
		display: self class;
		nextPutAll: ' on '.
	packagesFilter notNil 
		ifTrue: [strm display: 'Selected Package']
		ifFalse: [strm display: 'All'].
	strm space.
	changedOnly value ifTrue: [strm nextPutAll: 'Changed '].
	strm nextPutAll: 'Sources'.
	self caption: strm contents!

updateSelected
	"Private - Update the selected entries in the receiver's view"

	listPresenter selectionsByIndex do: [:index | listPresenter model refreshAtIndex: index]!

viewChangedOnly
	"Toggle whether all, or only changed, source objects are displayed
	in the receiver and refresn."

	<commandQuery: #queryViewChangedOnly:>
	changedOnly value: changedOnly value not.
	self refresh!

viewRefresh
	"Refresh the contents of the receiver in response to the menu bar View/Refresh
	command."

	self refresh
! !

!Tools.SourceBrowser categoriesForMethods!
allSourceObjects!accessing!public! !
browseChangedMethods!commands-actions!public! !
browseIt!commands-actions!public! !
browseSourceObject!commands-actions!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
fileOut:!commands-actions!private! !
fileOut:progressModel:!commands-actions!private! !
fileSave!commands-actions!public! !
fileSaveAll!commands-actions!public! !
hasChangedClassesSelected!commands-queries!private! !
hasSingleSelection!commands-queries!private! !
hasSourceObjects!commands-queries!private! !
hasWriteableSourceObjectsSelected!commands-queries!private! !
onClassRemoved:!event handling!private! !
onLoadedPackagesChanged!event handling!private! !
onVariableRemoved:!event handling!private! !
onViewOpened!event handling!private! !
queryBrowseSourceObject:!commands-queries!private! !
queryToggleChanged:!commands-queries!private! !
queryToggleWriteable:!commands-queries!private! !
queryViewChangedOnly:!commands-queries!private! !
refresh!commands-actions!operations!public! !
refreshBlock:!accessing!private! !
selectedChangedClasses!accessing!private! !
selectedChangedSourceObjects!accessing!private! !
selectedSourceClasses!accessing!public! !
selectedSourceFiles!accessing!public! !
selectedSourceObjects!accessing!public! !
selectedWriteableSourceObjects!accessing!private! !
setPackagesFilter:!initializing!private! !
toggleChanged!commands-actions!public! !
toggleWriteable!commands-actions!public! !
updateCaption!public!updating! !
updateSelected!private!updating! !
viewChangedOnly!commands-actions!operations!public! !
viewRefresh!commands-actions!operations!public! !
!

!Tools.SourceBrowser class methodsFor!

defaultOptionFlags
	^##(ReuseIfOpenMask | CanUseIdeaSpaceMask)!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Source Browser'!

forSourcesOfPackages: aPackageCollection 
	"Answer an instance of the receiver showing all the sources in aPackage"

	^(super show)
		setPackagesFilter: aPackageCollection;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver. Register the tools folder icon with SmalltalkSystem.

		self initialize.
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 1 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 35 0 0 0 29 0 0 0] 193 336 8 '' 304 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[99 1 0 0 0 0 0 0 63 2 0 0 29 0 0 0] 193 688 8 '' 656 3 592 610 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[35 0 0 0 0 0 0 0 99 1 0 0 29 0 0 0] 193 928 8 '' 896 3 592 610 193 193 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 1437 #mediumSmallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 36 3 0 0 29 0 0 0] 193 192 8 '' 160 3 50 4 304 896 656 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140853580 131137 1344 nil nil nil 517 nil nil nil 1344 240 nil 258 #{Core.IdentityDictionary} 592 nil nil nil nil 50 6 1606 2 #{UI.ToolbarIconButton} 1344 1 1350 4 #{UI.CommandDescription} #fileFileIn 8 'File In…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FileIn.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil 1442 1344 1 1474 #fileSave 8 'Save Selected Sources' 1 1 1522 nil true 1554 8 'FileSave.ico' 1616 65541 nil nil nil nil 1442 1344 1 1474 #fileSaveAll 8 'Save All Sources' 1 1 1522 nil true 1554 8 'FileSaveAll.ico' 1616 65541 nil nil nil nil 582 1 #{UI.ToolbarSeparator} 1344 1 1442 1344 1 1474 #viewChangedOnly 8 'Show Changed Only' 1 1 1522 nil true 1554 8 'Changed.ico' 1616 65541 nil nil nil nil 1442 1344 1 1474 #viewRefresh 8 'Refresh' 1 1 1522 nil true 1554 8 'Refresh.ico' 1616 65541 nil nil nil nil nil nil 9 1 nil nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[63 2 0 0 0 0 0 0 206 2 0 0 29 0 0 0] 193 1376 8 '' 1344 3 8 #() 610 193 193 nil 31 610 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140853004 1 2240 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2240 nil nil 258 #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 2240 nil 518 #{Core.Message} #displayString 8 #() 2450 #iconImageIndex 8 #() nil 8 'status' nil nil nil 50 1 2432 1094 1 #{UI.StatusBarNullItem} 8705 1 2240 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 93 1 0 0 36 3 0 0 115 1 0 0] 193 2272 8 '' 2240 3 8 #() 610 193 193 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2752 nil nil nil 5 nil nil nil 2752 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 258 #{Core.IdentityDictionary} 50 2 18 #{UI.ListView} 50 45 nil 2752 50 2 8 1140920393 1 2912 838 2 #{UI.ListModel} 1138 0 nil 6 #{Kernel.IdentitySearchPolicy} 240 nil 5 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 2097153 1474 #fileSave 8 '&Save' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3106 1 1474 #checkOut 8 'Check &Out' 1 1 nil nil nil 3106 1 1474 #checkIn 8 'Check &In' 1 1 nil nil nil 3170 4097 3106 1 1474 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3106 1 1474 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 3170 4097 3106 1 1474 #browseIt 8 '&Browse <d:Source Object>' 1 1 1522 nil true 1554 8 'ClassBrowserShell.ico' 1616 65541 nil nil nil 3106 1 1474 #browseChangedMethods 8 'Browse Changed &Methods' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2912 nil nil 2450 #displayString 2512 2496 1350 1 #{Graphics.IconImageManager} nil nil nil 610 65 65 nil nil 1138 6 3142 5 #{UI.ListViewColumn} 8 'Source Object' 401 #left 3584 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] #displayString 3728 7 513 nil nil nil 2912 2496 1 nil nil 3666 8 'Type' 301 #left 3584 2450 #<= 8 #() 450 #typeOfObject: 8 #(nil) #{Tools.SourceBrowser} nil 2912 nil 1 nil nil 3666 8 'Changed' 141 #left 3714 0 nil 3746 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''yes'']]' 8 #[30 105 17 119 29 106 60 106] 8 'yes' 3952 7 257 nil 3714 0 nil 3746 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4048 7 513 nil 2450 #isChanged 8 #() nil 2912 3714 0 nil 3746 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [True icon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 518 #{Core.Association} #True #{Core.True} #icon #imageIndex 4160 7 257 nil 1 nil nil 3666 8 'Writeable' 141 #left 3714 0 nil 3746 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifFalse: [''no'']]' 8 #[30 105 17 220 2 29 106 60 106] 8 'no' 4304 7 257 nil 3714 0 nil 3746 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4400 7 513 nil 2450 #canFileOut 8 #() nil 2912 3714 0 nil 3746 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifFalse: [False icon imageIndex]]' 8 #[32 105 17 220 4 45 159 160 106 60 106] 4242 #False #{Core.False} #icon #imageIndex 4512 7 257 nil 1 nil nil 3666 8 'Package' 401 #left 2450 #name 8 #() 3714 0 nil 3746 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 4672 7 513 nil 2450 #owningPackage 4656 nil 2912 nil 1 nil nil 3666 8 'Source file' 801 #left 3584 2450 #<= 3872 2450 #fileOutName 8 #() nil 2912 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 2912 nil nil nil nil nil nil nil nil nil 402 50 2 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 36 3 0 0 64 1 0 0] 193 2944 8 'Source Object' 2912 450 #contextMenu: 50 1 3072 2912 3 8 #() 610 193 193 nil 35 8 'list' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 29 0 0 0 36 3 0 0 93 1 0 0] 193 2784 8 '' 2752 3 50 1 2912 610 193 193 nil 27 258 #{Core.IdentityDictionary} 50 2 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 3058 nil true 50 11 3106 1 1474 #fileOpen 8 '&File In…' 9375 1 nil nil nil 3170 4097 3106 2097153 1474 #fileSave 8 '&Save' 9383 1 1522 nil true 1554 8 'FileSave.ico' 1616 65541 nil nil nil 3106 1 1474 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 3106 1 1474 #fileSaveAll 8 'Save A&ll' 1 1 1522 nil true 1554 8 'FileSaveAll.ico' 1616 65541 nil nil nil 3170 4097 3106 1 1474 #checkOut 8 'Check &Out' 1 1 nil nil nil 3106 1 1474 #checkIn 8 'Check &In' 1 1 nil nil nil 3170 4097 3106 1 1474 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3106 1 1474 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 3058 nil true 50 2 3106 1 1474 #browseSourceObject 8 '<d:Source Object>' 9349 1 nil nil nil 3106 1 1474 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 3058 nil true 50 3 3106 1 1474 #viewChangedOnly 8 '&Changed Only' 1 1 nil nil nil 3170 4097 3106 2097153 1474 #viewRefresh 8 '&Refresh' 1257 1 1522 nil true 1554 8 'Refresh.ico' 1616 65541 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 3058 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 3058 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 3058 nil true 50 15 3106 1 1474 #helpContents 8 '&Contents' 1025 1 1522 nil true 1030 #{Graphics.ImageFromResourceInitializer} 49 262 #{OS.ShellLibrary} 65541 nil nil nil 3106 1 1474 #help 8 'On this &Tool' 1249 1 nil nil nil 3106 1 1474 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3170 4097 3106 1 1474 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 3170 4097 3106 1 1474 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3106 1 1474 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3106 1 1474 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3170 4097 3106 1 1474 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1522 nil true 1554 8 '!!APPLICATION' 1616 65541 nil nil nil 3106 1 1474 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3106 1 1474 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3170 4097 3106 1 1474 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6706 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil nil nil 193 402 50 1 450 #createWindow: 50 1 498 518 #{Graphics.Rectangle} 610 7679 21 610 9319 881 193 80 8 'Source Manager' 32 1 50 3 160 2752 2240 610 193 193 nil 27)!

show
	"Answer an instance of the receiver showing all the sources in the system"

	^self forSourcesOfPackages: nil!

toolsFolderHelpId
	^10605!

typeOfObject: aSourceObject
	"Private - Answers a descriptive string that identifies the type of aSourceObject"

	^(aSourceObject isKindOf: Class)
		ifTrue: [ 'a Class']
		ifFalse: [ aSourceObject basicPrintString ]! !

!Tools.SourceBrowser class categoriesForMethods!
defaultOptionFlags!constants!options!private! !
displayOn:!displaying!public! !
forSourcesOfPackages:!instance creation!public! !
icon!constants!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
show!instance creation!public! !
toolsFolderHelpId!public! !
typeOfObject:!helpers!private! !
!

