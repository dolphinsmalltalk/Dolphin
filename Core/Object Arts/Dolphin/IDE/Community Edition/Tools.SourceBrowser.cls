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
	statusModel value: (Warning
				messageText: 'A number of the selected items could not be filed out. Ensure that all the selected items are writeable and try again.')!

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
!Tools.SourceBrowser categoriesForMethods!
allSourceObjects!accessing!public! !
browseChangedMethods!commands!public! !
browseIt!commands!public! !
browseSourceObject!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
fileOut:!commands!private! !
fileSave!commands!public! !
fileSaveAll!commands!public! !
onClassRemoved:!event handling!private! !
onLoadedPackagesChanged!event handling!private! !
onVariableRemoved:!event handling!private! !
onViewOpened!event handling!private! !
queryCommand:!commands!private! !
refresh!commands!operations!public! !
refreshBlock:!accessing!private! !
selectedSourceClasses!accessing!public! !
selectedSourceFiles!accessing!public! !
selectedSourceObjects!accessing!public! !
selectedWriteableSourceObjects!accessing!private! !
setPackagesFilter:!initializing!private! !
toggleChanged!commands!public! !
toggleWriteable!commands!public! !
updateCaption!public!updating! !
updateSelected!private!updating! !
viewChangedOnly!commands!operations!public! !
viewRefresh!commands!operations!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 1 528 nil nil nil 519 nil nil nil 528 917510 #{Graphics.Color} #default 8 1815075056 170 192 34 6 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 866 71 59 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 35 0 0 0 29 0 0 0] 8 #() 866 193 193 nil 27 8 'imageTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 #{UI.Toolbar} #resource_Search_tools nil 770 34 1 818 #createAt:extent: 34 2 866 711 1 866 445 59 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 99 1 0 0 0 0 0 0 65 2 0 0 29 0 0 0] 960 976 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 #{UI.Toolbar} #resource_Smalltalk_tools nil 770 34 1 818 #createAt:extent: 34 2 866 71 1 866 641 59 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 0 0 0 0 99 1 0 0 29 0 0 0] 960 976 nil 27 8 'smalltalkTools' nil nil nil 170 192 960 138 144 960 nil nil 1 nil 866 41 41 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1609 59 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 36 3 0 0 29 0 0 0] 34 4 672 1232 1008 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1140853580 131137 1680 nil nil nil 519 nil nil nil 1680 608 8 1815075056 170 192 960 nil nil nil 170 192 34 10 49789 1311814 1 #{UI.ToolbarIconButton} 1680 1 1377606 4 #{UI.CommandDescription} #viewChangedOnly 8 'Show Changed Only' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'Changed.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil 49789 49785 1810 1680 1 1842 #fileSave 8 'Save Selected Sources' 1 1 1890 nil true 1922 8 'FileSave.ico' 1984 65541 nil 49785 49791 1810 1680 1 1842 #viewRefresh 8 'Refresh' 1 1 1890 nil true 1922 8 'Refresh.ico' 1984 65541 nil 49791 49787 1810 1680 1 1842 #fileSaveAll 8 'Save All Sources' 1 1 1890 nil true 1922 8 'FileSaveAll.ico' 1984 65541 nil 49787 49783 1810 1680 1 1842 #fileFileIn 8 'File In…' 1 1 1890 nil true 1922 8 'FileIn.ico' 1984 65541 nil 49783 34 6 2304 2016 2208 1245766 1 #{UI.ToolbarSeparator} 1680 1 1824 2112 nil nil 1 nil nil nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 1155 1 866 287 59 1680 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 2 0 0 0 0 0 0 208 2 0 0 29 0 0 0] 8 #() 976 nil 29 976 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140853004 1 2592 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 866 193 193 nil 2592 nil 8 1814628368 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 2592 nil 786950 #{Core.Message} #displayString 8 #() 2834 #iconImageIndex 960 nil 8 'status' nil nil nil 34 1 2816 1311814 1 #{UI.StatusBarNullItem} 8705 1 2592 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 699 866 1609 45 2592 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 93 1 0 0 36 3 0 0 115 1 0 0] 8 #() 976 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 3104 nil nil nil 7 nil nil nil 3104 1376774 #{UI.ProportionalLayout} 170 176 960 true 170 192 34 2 410 #{UI.ListView} 34 45 nil 3104 34 2 8 1140920393 1 3248 787270 2 #{UI.ListModel} 138 144 960 nil 1769478 #{Kernel.IdentitySearchPolicy} 608 nil 7 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 2097153 1842 #fileSave 8 '&Save' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 3442 1 1842 #checkOut 8 'Check &Out' 1 1 nil nil nil 3442 1 1842 #checkIn 8 'Check &In' 1 1 nil nil nil 3506 4097 3442 1 1842 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3442 1 1842 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 3506 4097 3442 1 1842 #browseIt 8 '&Browse <1d>' 1 1 1890 nil true 1922 8 'ClassBrowserShell.ico' 1984 65541 nil nil nil 3442 1 1842 #browseChangedMethods 8 'Browse Changed &Methods' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3248 nil 8 1815049392 2834 #displayString 960 2880 1639750 1 #{Graphics.IconImageManager} nil nil nil 866 65 65 nil nil 138 144 34 6 1117254 5 #{UI.ListViewColumn} 8 'Source Object' 401 #left 3936 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] #displayString 4096 7 513 nil nil nil 3248 2880 1 nil nil 4034 8 'Type' 301 #left 3936 2834 #<= 8 #() 818 #typeOfObject: 8 #(nil) #{Tools.SourceBrowser} nil 3248 nil 1 nil nil 4034 8 'Changed' 141 #left 4082 0 nil 4114 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''yes'']]' 8 #[30 105 17 119 29 106 60 106] 8 'yes' 4320 7 257 nil 4082 0 nil 4114 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4416 7 513 nil 2834 #isChanged 8 #() nil 3248 4082 0 nil 4114 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [True icon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1049094 #{Core.Association} #True #{Core.True} #icon #imageIndex 4528 7 257 nil 1 nil nil 4034 8 'Writeable' 141 #left 4082 0 nil 4114 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifFalse: [''no'']]' 8 #[30 105 17 220 2 29 106 60 106] 8 'no' 4672 7 257 nil 4082 0 nil 4114 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4768 7 513 nil 2834 #canFileOut 8 #() nil 3248 4082 0 nil 4114 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifFalse: [False icon imageIndex]]' 8 #[32 105 17 220 4 45 159 160 106 60 106] 4610 #False #{Core.False} #icon #imageIndex 4880 7 257 nil 1 nil nil 4034 8 'Package' 401 #left 2834 #name 8 #() 4082 0 nil 4114 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 5040 7 513 nil 2834 #owningPackage 5024 nil 3248 nil 1 nil nil 4034 8 'Source file' 801 #left 3936 2834 #<= 4240 2834 #fileOutName 8 #() nil 3248 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 1609 641 3248 818 #contextMenu: 34 1 3408 3248 818 #text: 34 1 8 'Source Object' 3248 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 36 3 0 0 64 1 0 0] 8 #() 976 nil 35 8 'list' nil 770 34 1 818 #createAt:extent: 34 2 866 1 59 866 1609 641 3104 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 29 0 0 0 36 3 0 0 93 1 0 0] 34 1 3248 976 nil 27 170 192 34 2 528 8 'toolbar' nil 658246 4 #{UI.MenuBar} nil true 34 6 3394 nil true 34 11 3442 1 1842 #fileOpen 8 '&File In…' 9375 1 nil nil nil 3506 4097 3442 2097153 1842 #fileSave 8 '&Save' 9383 1 1890 nil true 1922 8 'FileSave.ico' 1984 65541 nil nil nil 3442 1 1842 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 3442 1 1842 #fileSaveAll 8 'Save A&ll' 1 1 1890 nil true 1922 8 'FileSaveAll.ico' 1984 65541 nil nil nil 3506 4097 3442 1 1842 #checkOut 8 'Check &Out' 1 1 nil nil nil 3442 1 1842 #checkIn 8 'Check &In' 1 1 nil nil nil 3506 4097 3442 1 1842 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3442 1 1842 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 49809 nil nil 3394 nil true 34 2 3442 1 1842 #browseSourceObject 8 '<1d>' 9349 1 nil nil nil 3442 1 1842 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 49815 nil nil 3394 nil true 34 3 3442 1 1842 #viewChangedOnly 8 '&Changed Only' 1 1 nil nil nil 3506 4097 3442 2097153 1842 #viewRefresh 8 '&Refresh' 1257 1 1890 nil true 1922 8 'Refresh.ico' 1984 65541 nil nil nil 8 '&View' nil 134217729 nil nil 49821 nil nil 3394 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 49823 nil nil 3394 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 49825 nil nil 3394 nil true 34 15 3442 1 1842 #helpContents 8 '&Contents' 1025 1 1890 nil true 2425862 #{Graphics.ImageFromResourceInitializer} 49 983302 #{OS.ShellLibrary} 65541 nil nil nil 3442 1 1842 #help 8 'On this &Tool' 1249 1 nil nil nil 3442 1 1842 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3506 4097 3442 1 1842 #learnSmalltalk 8 'Learn Smalltalk' 1 1 1378630 2 #{Graphics.TextTileIcon} $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 3506 4097 3442 1 1842 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3442 1 1842 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3442 1 1842 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3506 4097 3442 1 1842 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1890 nil true 1922 8 '!!APPLICATION' 1984 65541 nil nil nil 3442 1 1842 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3442 1 1842 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3506 4097 3442 1 1842 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7058 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 49849 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 2 818 #createAt:extent: 34 2 866 12287 21 866 1641 861 416 818 #text: 34 1 8 'Source Manager' 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 51 27 0 0 184 1 0 0] 34 3 528 3104 2592 976 nil 27)!

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

