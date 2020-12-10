"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.SourceBrowser'
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

	self model browseChangedMethodsOfClasses: self selectedSourceClasses!

browseIt
	"Context sensitive Browse-It command."

	self browseSourceObject!

browseSourceObject
	"Browse the first of selected source object."

	self selectedSourceObjects first browse!

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

	| saved |
	saved := Set new.
	
	[sourceObjects do: 
			[:each |
			each canFileOut
				ifTrue: 
					[each fileOut.
					saved add: each]]]
			on: OperationAborted
			do: [:ex | ].
	^sourceObjects difference: saved!

fileSave
	"Save (file out) all the selected source objects which are saveable
	in response to the menu bar File/Save command."

	| notSaved |
	statusModel value: nil.
	notSaved := self fileOut: self selectedSourceObjects.
	self refresh.
	notSaved isEmpty ifTrue: [^self].
	"Come here if some files are read only"
	listPresenter selections: notSaved.
	statusModel value: ((Warning new)
				messageText: 'A number of the selected items could not be filed out. Ensure that all the selected items are writeable and try again.';
				yourself)!

fileSaveAll
	"Attempt to save all the displayed source objects in response to the 
	menubar/toolbar File/Save All command."

	| notSaved |
	notSaved := self fileOut: self allSourceObjects.

	self refresh.
	notSaved notEmpty ifTrue: [
		"Come here if some files are read only"
		MessageBox 
			warning: 'A number of the items could not be filed out. 
Ensure that all the items are writeable and try again.' 
			caption: 'Operation incomplete']
!

onClassRemoved: aClass
	"Private - React to aClass being removed from the Smalltalk system."

	listPresenter model remove: aClass ifAbsent: []!

onLoadedPackagesChanged
	"Private - React to the set of installed packages being changed."

	| uninstalled |
	uninstalled := (listPresenter model select: [:e | e isKindOf: Package])
				difference: Package manager packages.
	listPresenter model removeAll: uninstalled.
!

onVariableRemoved: aVariableBinding
	"Private - React to globalName being removed from the Dolphin system."

	listPresenter model remove: aVariableBinding ifAbsent: []!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| statusItem |
	super onViewOpened.
	statusItem := self view viewNamed: 'status' ifNone: [].
	statusItem notNil ifTrue: [statusItem model: statusModel]!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| command |
	command := query commandSymbol.
	(#(#checkOut #checkIn) identityIncludes: command)
		ifTrue: 
			[query isEnabled: ((self respondsTo: command) and: [listPresenter hasSelection]).
			^true].
	#fileSaveAll == command
		ifTrue: 
			[query isEnabled: listPresenter list notEmpty.
			^true].
	#fileSaveAs == command
		ifTrue: 
			[query isEnabled: ((self respondsTo: #fileSaveAs) and: [self selectedSourceObjects size == 1]).
			^true].
	(#(#browseIt #browseSourceObject) identityIncludes: command)
		ifTrue: 
			[| selected enable fmt |
			selected := self selectedSourceObjects.
			enable := selected size == 1.
			fmt := query commandDescription menuText.
			query
				text: (fmt expandMacrosWithArguments: {enable ifTrue: [selected first] ifFalse: ['Source Object']}
							locale: Locale smalltalk);
				isEnabled: enable.
			^true].
	#fileSave == command
		ifTrue: 
			[query isEnabled: self selectedWriteableSourceObjects notEmpty.
			^true].
	#toggleWriteable == command
		ifTrue: 
			[| selected writeable |
			selected := self selectedSourceObjects.
			writeable := false.
			query
				isEnabled: (selected notEmpty and: 
							[writeable := selected first canFileOut.
							selected allSatisfy: [:each | each canFileOut == writeable]]).
			query isChecked: writeable.
			^true].
	#toggleChanged == command
		ifTrue: 
			[| selected changed |
			selected := self selectedSourceObjects.
			changed := false.
			query
				isEnabled: (selected notEmpty and: 
							[changed := selected first isChanged.
							selected allSatisfy: [:each | each isChanged == changed]]).
			query isChecked: changed.
			^true].
	#viewChangedOnly == command
		ifTrue: 
			[query
				isEnabled: true;
				isChecked: changedOnly value.
			^true].
	#browseChangedMethods == command
		ifTrue: 
			[query isEnabled: (self selectedSourceClasses select: [:c | c isChanged]) notEmpty.
			^true].
	^super queryCommand: query!

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

	self selectedSourceObjects do: [:each | each isChanged: each isChanged not ].
	self updateSelected
!

toggleWriteable
	"Toogle the writeable state associated with all the selected objects"

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

	changedOnly value: changedOnly value not.
	self refresh!

viewRefresh
	"Refresh the contents of the receiver in response to the menu bar View/Refresh
	command."

	self refresh
! !
!Tools.SourceBrowser categoriesFor: #allSourceObjects!accessing!public! !
!Tools.SourceBrowser categoriesFor: #browseChangedMethods!commands!public! !
!Tools.SourceBrowser categoriesFor: #browseIt!commands!public! !
!Tools.SourceBrowser categoriesFor: #browseSourceObject!commands!public! !
!Tools.SourceBrowser categoriesFor: #createComponents!initializing!public! !
!Tools.SourceBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.SourceBrowser categoriesFor: #fileOut:!commands!private! !
!Tools.SourceBrowser categoriesFor: #fileSave!commands!public! !
!Tools.SourceBrowser categoriesFor: #fileSaveAll!commands!public! !
!Tools.SourceBrowser categoriesFor: #onClassRemoved:!event handling!private! !
!Tools.SourceBrowser categoriesFor: #onLoadedPackagesChanged!event handling!private! !
!Tools.SourceBrowser categoriesFor: #onVariableRemoved:!event handling!private! !
!Tools.SourceBrowser categoriesFor: #onViewOpened!event handling!private! !
!Tools.SourceBrowser categoriesFor: #queryCommand:!commands!private! !
!Tools.SourceBrowser categoriesFor: #refresh!commands!operations!public! !
!Tools.SourceBrowser categoriesFor: #refreshBlock:!accessing!private! !
!Tools.SourceBrowser categoriesFor: #selectedSourceClasses!accessing!public! !
!Tools.SourceBrowser categoriesFor: #selectedSourceFiles!accessing!public! !
!Tools.SourceBrowser categoriesFor: #selectedSourceObjects!accessing!public! !
!Tools.SourceBrowser categoriesFor: #selectedWriteableSourceObjects!accessing!private! !
!Tools.SourceBrowser categoriesFor: #setPackagesFilter:!initializing!private! !
!Tools.SourceBrowser categoriesFor: #toggleChanged!commands!public! !
!Tools.SourceBrowser categoriesFor: #toggleWriteable!commands!public! !
!Tools.SourceBrowser categoriesFor: #updateCaption!public!updating! !
!Tools.SourceBrowser categoriesFor: #updateSelected!private!updating! !
!Tools.SourceBrowser categoriesFor: #viewChangedOnly!commands!operations!public! !
!Tools.SourceBrowser categoriesFor: #viewRefresh!commands!operations!public! !

!Tools.SourceBrowser class methodsFor!

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

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true.!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		removeKey: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 1 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 6 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Search_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 711 1 882 445 59 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 99 1 0 0 0 0 0 0 65 2 0 0 29 0 0 0] 8 #() 882 193 193 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 71 1 882 641 59 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 0 0 0 0 99 1 0 0 29 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(UI.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 71 59 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 35 0 0 0 29 0 0 0] 976 992 nil 27 8 'imageTools' 170 192 976 138 144 976 nil nil 1 nil 882 41 41 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1609 59 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 36 3 0 0 29 0 0 0] 34 4 1264 1024 672 410 ##(UI.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 1744 nil nil nil 519 nil nil nil 1744 608 8 1801306032 170 192 976 170 192 34 10 51549 1311814 1 ##(UI.ToolbarIconButton) 1744 1 1377606 4 ##(UI.CommandDescription) #viewChangedOnly 8 'Show Changed Only' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'Changed.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 51549 51545 1874 1744 1 1906 #fileSave 8 'Save Selected Sources' 1 1 1954 nil true 2000 8 'FileSave.ico' 2048 51545 51551 1874 1744 1 1906 #viewRefresh 8 'Refresh' 1 1 1954 nil true 2000 8 'Refresh.ico' 2048 51551 51547 1874 1744 1 1906 #fileSaveAll 8 'Save All Sources' 1 1 1954 nil true 2000 8 'FileSaveAll.ico' 2048 51547 51543 1874 1744 1 1906 #fileFileIn 8 'File In...' 1 1 1954 nil true 2000 8 'FileIn.ico' 2048 51543 34 6 2320 2080 2240 1245766 1 ##(UI.ToolbarSeparator) 1744 1 1888 2160 nil nil 1 nil nil nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1155 1 882 287 59 1744 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 2 0 0 0 0 0 0 208 2 0 0 29 0 0 0] 8 #() 992 nil 27 992 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2608 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 882 193 193 nil 2608 nil 8 1801004784 170 192 34 2 1050374 ##(UI.StatusBarItem) 1 -1 2608 nil 786950 ##(Core.Message) #displayString 8 #() 2816 nil 8 'status' 34 1 2832 1311750 ##(UI.StatusBarNullItem) 513 1 2608 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 699 882 1609 45 2608 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 93 1 0 0 36 3 0 0 115 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3120 nil nil nil 7 nil nil nil 3120 1376774 ##(UI.ProportionalLayout) 170 176 976 true 170 192 34 2 410 ##(UI.ListView) 34 45 nil 3120 34 2 8 1140920393 1 3264 787270 2 ##(UI.ListModel) 138 144 976 nil 1769478 ##(Kernel.IdentitySearchPolicy) 608 nil 7 461638 4 ##(UI.Menu) nil true 34 10 1180742 2 ##(UI.CommandMenuItem) 2097153 1906 #fileSave 8 '&Save' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3458 1 1906 #checkOut 8 'Check &Out' 1 1 nil nil nil 3458 1 1906 #checkIn 8 'Check &In' 1 1 nil nil nil 3522 4097 3458 1 1906 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3458 1 1906 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 3522 4097 3458 1 1906 #browseIt 8 '&Browse <1d>' 1 1 1954 nil true 2000 8 'ClassBrowserShell.ico' 2048 nil nil 3458 1 1906 #browseChangedMethods 8 'Browse Changed &Methods' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3264 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil 882 65 65 nil nil 138 144 34 6 1117254 5 ##(UI.ListViewColumn) 8 'Source Object' 401 #left ##(UI.BasicListAbstract) 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] #displayString 4080 7 513 nil nil nil 3264 ##(UI.IconicListAbstract) 1 nil nil 4018 8 'Type' 301 #left ##(UI.BasicListAbstract) 2850 #<= 8 #() 834 #typeOfObject: 8 #(nil) ##(Tools.SourceBrowser) nil 3264 nil 1 nil nil 4018 8 'Changed' 141 #left 4066 0 nil 4098 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''yes'']]' 8 #[30 105 17 119 29 106 60 106] 8 'yes' 4304 7 257 nil 4066 0 nil 4098 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4400 7 513 nil 2850 #isChanged 8 #() nil 3264 4066 0 nil 4098 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [True icon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1049094 ##(Core.Association) #True ##(Core.True) #icon #imageIndex 4512 7 257 nil 1 nil nil 4018 8 'Writeable' 141 #left 4066 0 nil 4098 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifFalse: [''no'']]' 8 #[30 105 17 220 2 29 106 60 106] 8 'no' 4656 7 257 nil 4066 0 nil 4098 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4752 7 513 nil 2850 #canFileOut 8 #() nil 3264 4066 0 nil 4098 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifFalse: [False icon imageIndex]]' 8 #[32 105 17 220 4 45 159 160 106 60 106] 4594 #False ##(Core.False) #icon #imageIndex 4864 7 257 nil 1 nil nil 4018 8 'Package' 401 #left 2850 #name 8 #() 4066 0 nil 4098 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 5024 7 513 nil 2850 #owningPackage 5008 nil 3264 nil 1 nil nil 4018 8 'Source file' 801 #left ##(UI.BasicListAbstract) 2850 #<= 4224 2850 #fileOutName 8 #() nil 3264 4016 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 1609 641 3264 834 #contextMenu: 34 1 3424 3264 834 #text: 34 1 8 'Source Object' 3264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 36 3 0 0 64 1 0 0] 8 #() 992 nil 35 8 'list' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 59 882 1609 641 3120 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 29 0 0 0 36 3 0 0 93 1 0 0] 34 1 3264 992 nil 27 170 192 34 2 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 6 3410 nil true 34 11 3458 1 1906 #fileOpen 8 '&File In...' 9375 1 nil nil nil 3522 4097 3458 2097153 1906 #fileSave 8 '&Save' 9383 1 1954 nil true 2000 8 'FileSave.ico' 2048 nil nil 3458 1 1906 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 3458 1 1906 #fileSaveAll 8 'Save A&ll' 1 1 1954 nil true 2000 8 'FileSaveAll.ico' 2048 nil nil 3522 4097 3458 1 1906 #checkOut 8 'Check &Out' 1 1 nil nil nil 3458 1 1906 #checkIn 8 'Check &In' 1 1 nil nil nil 3522 4097 3458 1 1906 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3458 1 1906 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 51569 nil nil 3410 nil true 34 2 3458 1 1906 #browseSourceObject 8 '<1d>' 9349 1 nil nil nil 3458 1 1906 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 51575 nil nil 3410 nil true 34 3 3458 1 1906 #viewChangedOnly 8 '&Changed Only' 1 1 nil nil nil 3522 4097 3458 2097153 1906 #viewRefresh 8 '&Refresh' 1257 1 1954 nil true 2000 8 'Refresh.ico' 2048 nil nil 8 '&View' nil 134217729 nil nil 51581 nil nil 3410 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 51583 nil nil 3410 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 51585 nil nil 3410 nil true 34 15 3458 1 1906 #helpContents 8 '&Contents' 1025 1 1954 nil true 2000 49 983302 ##(OS.ShellLibrary) nil nil 3458 1 1906 #help 8 'On this &Tool' 1249 1 nil nil nil 3458 1 1906 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3522 4097 3458 1 1906 #learnSmalltalk 8 'Learn Smalltalk' 1 1 1378630 1 ##(Graphics.TextTileIcon) $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 3522 4097 3458 1 1906 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3458 1 1906 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3458 1 1906 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3522 4097 3458 1 1906 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1954 nil true 2000 8 '!!APPLICATION' 2048 nil nil 3458 1 1906 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3458 1 1906 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3522 4097 3458 1 1906 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6994 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 51609 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 1641 861 416 834 #text: 34 1 8 'Source Manager' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 51 15 0 0 184 1 0 0] 34 3 528 3120 2608 992 nil 27 )!

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
!Tools.SourceBrowser class categoriesFor: #displayOn:!displaying!public! !
!Tools.SourceBrowser class categoriesFor: #forSourcesOfPackages:!instance creation!public! !
!Tools.SourceBrowser class categoriesFor: #icon!constants!public! !
!Tools.SourceBrowser class categoriesFor: #initialize!initializing!private! !
!Tools.SourceBrowser class categoriesFor: #publishedAspects!public! !
!Tools.SourceBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.SourceBrowser class categoriesFor: #show!instance creation!public! !
!Tools.SourceBrowser class categoriesFor: #toolsFolderHelpId!public! !
!Tools.SourceBrowser class categoriesFor: #typeOfObject:!helpers!private! !

