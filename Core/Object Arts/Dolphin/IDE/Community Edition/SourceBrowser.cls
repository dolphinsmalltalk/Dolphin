"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #SourceBrowser
	instanceVariableNames: 'listPresenter changedOnly refreshBlock packagesFilter statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SourceBrowser guid: (GUID fromString: '{87b4c6c4-026e-11d3-9fd7-00a0cc3e4a32}')!

SourceBrowser comment: 'SourceBrowser is a <SmalltalkToolShell> that implements a Source Management interface onto the various <sourceObject>s in the development system. SourceBrowser''s view of the system is somewhat different to the other tools in that operates on classes, packages, views, etc, as files. It allows these objects to externalized (filed out) and placed in a change control system. Source objects can be saved individually or en-masse and their change flags can be toggled on or off.

SourceBrowsers are typically opened either from the main development system window, which opens the browser on all source objects in the system, or from the package browser in order to operate on the source objects in a package.

Instance Variables:
	listPresenter		<ListPresenter> displaying a list of <exportableSource> objects.
	changedOnly		<BooleanPresenter> indicating whether the browser is displaying only changed objects.
	refreshBlock		<monadicValuable> that can be evaluated to refresh the browser display.

'!

!SourceBrowser categoriesForClass!MVP-Presenters! !

!SourceBrowser methodsFor!

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
	(self class environment)
		when: #classRemoved:
			send: #onClassRemoved:
			to: self;
		when: #globalRemoved:
			send: #onGlobalRemoved:
			to: self.
	Package manager 
		when: #loadedChanged
		send: #onLoadedPackagesChanged
		to: self!

fileOut: sourceObjects
	"Private - Save (file out) all the selected source objects which are saveable.
	Answer a <collection> of all those which could not be saved."

	| notSaved |
	notSaved := OrderedCollection new.
	sourceObjects do: [:each | 
		each canFileOut 
			ifTrue: [each fileOut]
			ifFalse: [notSaved add: each]].
	^notSaved!

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

onGlobalRemoved: anAssociation
	"Private - React to globalName being removed from the Dolphin system."

	listPresenter model remove: anAssociation ifAbsent: []!

onLoadedPackagesChanged
	"Private - React to the set of installed packages being changed."

	| uninstalled |
	uninstalled := (listPresenter model select: [:e | e isKindOf: Package])
				difference: Package manager packages.
	listPresenter model removeAll: uninstalled.
!

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
				text: (fmt 
							expandMacrosWith: (enable ifTrue: [selected first] ifFalse: ['Source Object']));
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

!SourceBrowser categoriesForMethods!
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
onGlobalRemoved:!event handling!private! !
onLoadedPackagesChanged!event handling!private! !
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

!SourceBrowser class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Source Browser'!

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

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 1 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1795812352 170 192 34 6 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Search_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[99 1 0 0 0 0 0 0 63 2 0 0 29 0 0 0] 193 704 8 '' 672 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[35 0 0 0 0 0 0 0 99 1 0 0 29 0 0 0] 193 1072 8 '' 1040 3 976 994 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1296 nil nil nil 7 nil nil nil 1296 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 35 0 0 0 29 0 0 0] 193 1328 8 '' 1296 3 976 994 193 193 nil 27 8 'imageTools' nil nil nil 170 192 976 138 144 976 nil nil 9 1437 #mediumSmallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 36 3 0 0 29 0 0 0] 193 560 8 '' 528 3 34 4 1296 1040 672 410 ##(Smalltalk.Toolbar) 34 28 nil 528 34 2 8 1140853580 131137 1776 nil nil nil 519 nil nil nil 1776 608 8 1795812352 170 192 976 nil nil nil 170 192 34 10 13033 1115718 2 ##(Smalltalk.ToolbarIconButton) 1776 1 1180998 4 ##(Smalltalk.CommandDescription) #viewChangedOnly 8 'Show Changed Only' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Changed.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 13033 nil nil 13029 1906 1776 1 1938 #fileSave 8 'Save Selected Sources' 1 1 1986 nil true 2032 8 'FileSave.ico' 2080 13029 nil nil 13035 1906 1776 1 1938 #viewRefresh 8 'Refresh' 1 1 1986 nil true 2032 8 'Refresh.ico' 2080 13035 nil nil 13031 1906 1776 1 1938 #fileSaveAll 8 'Save All Sources' 1 1 1986 nil true 2032 8 'FileSaveAll.ico' 2080 13031 nil nil 13027 1906 1776 1 1938 #fileFileIn 8 'File In...' 1 1 1986 nil true 2032 8 'FileIn.ico' 2080 13027 nil nil 34 6 2352 2112 2272 1049158 1 ##(Smalltalk.ToolbarSeparator) 1776 1 1920 2192 nil nil 9 1 nil nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[63 2 0 0 0 0 0 0 206 2 0 0 29 0 0 0] 193 1808 8 '' 1776 3 8 #() 994 193 193 nil 31 994 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140853004 1 2672 nil nil nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2672 nil 8 1795505344 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2672 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2864 nil 8 'status' nil nil nil 34 1 2880 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2672 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 93 1 0 0 36 3 0 0 115 1 0 0] 193 2704 8 '' 2672 3 8 #() 994 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3184 nil nil nil 7 nil nil nil 3184 1180166 ##(Smalltalk.ProportionalLayout) 170 176 976 true 170 192 34 2 410 ##(Smalltalk.ListView) 34 45 nil 3184 34 2 8 1140920393 1 3328 590662 2 ##(Smalltalk.ListModel) 138 144 976 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 608 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1938 #fileSave 8 '&Save' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3522 1 1938 #checkOut 8 'Check &Out' 1 1 nil nil nil 3522 1 1938 #checkIn 8 'Check &In' 1 1 nil nil nil 3586 4097 3522 1 1938 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3522 1 1938 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 3586 4097 3522 1 1938 #browseIt 8 '&Browse <1d>' 1 1 1986 nil true 2032 8 'ClassBrowserShell.ico' 2080 nil nil 3522 1 1938 #browseChangedMethods 8 'Browse Changed &Methods' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3328 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 994 65 65 nil nil 138 144 34 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Source Object' 401 #left ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] #displayString 4144 7 513 nil nil nil 3328 ##(Smalltalk.IconicListAbstract) 1 nil nil 4082 8 'Type' 301 #left ##(Smalltalk.BasicListAbstract) 2898 #<= 8 #() 834 #typeOfObject: 8 #(nil) ##(Smalltalk.SourceBrowser) nil 3328 nil 1 nil nil 4082 8 'Changed' 141 #left 4130 0 nil 4162 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''yes'']]' 8 #[30 105 17 119 29 106 60 106] 8 'yes' 4368 7 257 nil 4130 0 nil 4162 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4464 7 513 nil 2898 #isChanged 8 #() nil 3328 4130 0 nil 4162 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [True icon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association) #True ##(Smalltalk.True) #icon #imageIndex 4576 7 257 nil 1 nil nil 4082 8 'Writeable' 141 #left 4130 0 nil 4162 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifFalse: [''no'']]' 8 #[30 105 17 220 2 29 106 60 106] 8 'no' 4720 7 257 nil 4130 0 nil 4162 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 4816 7 513 nil 2898 #canFileOut 8 #() nil 3328 4130 0 nil 4162 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifFalse: [False icon imageIndex]]' 8 #[32 105 17 220 4 45 159 160 106 60 106] 4658 #False ##(Smalltalk.False) #icon #imageIndex 4928 7 257 nil 1 nil nil 4082 8 'Package' 401 #left 2898 #name 8 #() 4130 0 nil 4162 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 5088 7 513 nil 2898 #owningPackage 5072 nil 3328 nil 1 nil nil 4082 8 'Source file' 801 #left ##(Smalltalk.BasicListAbstract) 2898 #<= 4288 2898 #fileOutName 8 #() nil 3328 4080 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 36 3 0 0 64 1 0 0] 193 3360 8 'Source Object' 3328 834 #contextMenu: 34 1 3488 3328 3 8 #() 994 193 193 nil 35 8 'list' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 29 0 0 0 36 3 0 0 93 1 0 0] 193 3216 8 '' 3184 3 34 1 3328 994 193 193 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 3474 nil true 34 11 3522 1 1938 #fileOpen 8 '&File In...' 9375 1 nil nil nil 3586 4097 3522 2097153 1938 #fileSave 8 '&Save' 9383 1 1986 nil true 2032 8 'FileSave.ico' 2080 nil nil 3522 1 1938 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 3522 1 1938 #fileSaveAll 8 'Save A&ll' 1 1 1986 nil true 2032 8 'FileSaveAll.ico' 2080 nil nil 3586 4097 3522 1 1938 #checkOut 8 'Check &Out' 1 1 nil nil nil 3522 1 1938 #checkIn 8 'Check &In' 1 1 nil nil nil 3586 4097 3522 1 1938 #toggleChanged 8 '&Changed' 1 1 nil nil nil 3522 1 1938 #toggleWriteable 8 '&Writeable' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 13053 nil nil 3474 nil true 34 2 3522 1 1938 #browseSourceObject 8 '<1d>' 9349 1 nil nil nil 3522 1 1938 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 13059 nil nil 3474 nil true 34 3 3522 1 1938 #viewChangedOnly 8 '&Changed Only' 1 1 nil nil nil 3586 4097 3522 2097153 1938 #viewRefresh 8 '&Refresh' 1257 1 1986 nil true 2032 8 'Refresh.ico' 2080 nil nil 8 '&View' nil 134217729 nil nil 13065 nil nil 3474 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 13067 nil nil 3474 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 13069 nil nil 3474 nil true 34 15 3522 1 1938 #helpContents 8 '&Contents' 1025 1 1986 nil true 2032 8 'Help.ico' 2080 nil nil 3522 1 1938 #help 8 'On this &Tool' 1249 1 nil nil nil 3522 1 1938 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3586 4097 3522 1 1938 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $🎓 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 3586 4097 3522 1 1938 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3522 1 1938 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3522 1 1938 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3586 4097 3522 1 1938 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1986 nil true 2032 8 '!!APPLICATION' 2080 nil nil 3522 1 1938 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3522 1 1938 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3586 4097 3522 1 1938 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7026 $🐬 nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 13093 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 770 138 144 34 1 834 #createWindow: 34 1 882 590342 ##(Smalltalk.Rectangle) 994 6143 21 994 7783 881 193 448 8 'Source Manager' 416 1 34 3 528 3184 2672 994 193 193 nil 27 )!

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

!SourceBrowser class categoriesForMethods!
displayOn:!displaying!public! !
forSourcesOfPackages:!instance creation!public! !
icon!constants!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
show!instance creation!public! !
toolsFolderHelpId!public! !
typeOfObject:!helpers!private! !
!

