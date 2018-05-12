"Filed out from Dolphin Smalltalk 7"!

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
!SourceBrowser categoriesForClass!Development!MVP-Presenters! !
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
!SourceBrowser categoriesFor: #allSourceObjects!accessing!public! !
!SourceBrowser categoriesFor: #browseChangedMethods!commands!public! !
!SourceBrowser categoriesFor: #browseIt!commands!public! !
!SourceBrowser categoriesFor: #browseSourceObject!commands!public! !
!SourceBrowser categoriesFor: #createComponents!initializing!public! !
!SourceBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!SourceBrowser categoriesFor: #fileOut:!commands!private! !
!SourceBrowser categoriesFor: #fileSave!commands!public! !
!SourceBrowser categoriesFor: #fileSaveAll!commands!public! !
!SourceBrowser categoriesFor: #onClassRemoved:!event handling!private! !
!SourceBrowser categoriesFor: #onGlobalRemoved:!event handling!private! !
!SourceBrowser categoriesFor: #onLoadedPackagesChanged!event handling!private! !
!SourceBrowser categoriesFor: #onViewOpened!event handling!private! !
!SourceBrowser categoriesFor: #queryCommand:!commands!private! !
!SourceBrowser categoriesFor: #refresh!commands!operations!public! !
!SourceBrowser categoriesFor: #refreshBlock:!accessing!private! !
!SourceBrowser categoriesFor: #selectedSourceClasses!accessing!public! !
!SourceBrowser categoriesFor: #selectedSourceFiles!accessing!public! !
!SourceBrowser categoriesFor: #selectedSourceObjects!accessing!public! !
!SourceBrowser categoriesFor: #selectedWriteableSourceObjects!accessing!private! !
!SourceBrowser categoriesFor: #setPackagesFilter:!initializing!private! !
!SourceBrowser categoriesFor: #toggleChanged!commands!public! !
!SourceBrowser categoriesFor: #toggleWriteable!commands!public! !
!SourceBrowser categoriesFor: #updateCaption!public!updating! !
!SourceBrowser categoriesFor: #updateSelected!private!updating! !
!SourceBrowser categoriesFor: #viewChangedOnly!commands!operations!public! !
!SourceBrowser categoriesFor: #viewRefresh!commands!operations!public! !

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

	^SourceManager icon!

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

	| aspects |
	aspects := super publishedAspects.
	aspects add: (Aspect boolean: #reuseIfOpen).
	aspects add: (Aspect boolean: #canUseIdeaSpace).
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 1 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 1 1 770 63 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'imageTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Smalltalk_tools 0 1026 202 208 98 1 1090 1120 98 2 770 63 1 770 991 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1232 1248 0 27 8 'smalltalkTools' 234 256 1232 202 208 1232 234 240 1232 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 1169 101 560 1090 8 #updateSizePosted 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 98 3 864 1280 410 576 98 25 0 560 98 2 8 1140853580 131137 1856 0 642 672 0 519 0 0 0 1856 642 672 8 4294903529 234 256 1232 234 256 98 10 18001 853766 ##(Smalltalk.ToolbarButton) 18001 0 1856 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #fileFileIn 8 'File In...' 1 1 0 395334 3 ##(Smalltalk.Bitmap) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 71 770 1857 33 25 18003 2018 18003 0 1856 1 2050 8 #fileSave 8 'Save Selected Sources' 1 1 0 2114 0 16 2160 8 'FileBar.bmp' 2208 0 7 770 161 33 5 18005 2018 18005 0 1856 1 2050 8 #fileSaveAll 8 'Save All Sources' 1 1 0 2320 7 18007 2018 18007 0 1856 1 2050 8 #viewChangedOnly 8 'Show Changed Only' 1 1 0 2128 83 18009 2018 18009 0 1856 1 2050 8 #viewRefresh 8 'Refresh' 1 1 0 2128 109 98 6 2032 2256 2368 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 1856 3 0 1 2432 2496 234 240 98 4 2128 1 2320 117 0 1 0 770 33 33 770 45 45 0 0 1026 202 208 98 2 1090 1120 98 2 770 1 51 770 247 51 1856 1090 1792 1232 1856 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 98 0 1248 0 27 1248 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140853004 1 2848 0 642 672 0 7 0 690 0 16 722 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 770 193 193 0 2848 0 8 4294905391 234 256 98 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2848 0 459270 ##(Smalltalk.Message) 8 #displayString 98 0 3056 1049926 1 ##(Smalltalk.IconImageManager) 8 'status' 98 1 3072 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2848 0 0 1026 202 208 98 1 1090 1120 98 2 770 1 639 770 1169 45 2848 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 63 1 0 0 72 2 0 0 85 1 0 0] 98 0 1248 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3408 0 642 8 4278190080 0 7 0 0 0 3408 1180166 ##(Smalltalk.ProportionalLayout) 234 240 1232 16 234 256 98 2 410 8 ##(Smalltalk.ListView) 98 30 0 3408 98 2 8 1140920393 1 3600 590662 2 ##(Smalltalk.ListModel) 202 208 1232 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 642 672 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 2050 2288 8 '&Save' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3826 1 2050 8 #checkOut 8 'Check &Out' 1 1 0 0 0 3826 1 2050 8 #checkIn 8 'Check &In' 1 1 0 0 0 3890 4097 3826 1 2050 8 #toggleChanged 8 '&Changed' 1 1 0 0 0 3826 1 2050 8 #toggleWriteable 8 '&Writeable' 1 1 0 0 0 3890 4097 3826 1 2050 8 #browseIt 8 '&Browse <1d>' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 2160 8 'ClassBrowserShell.ico' 2208 0 0 3826 1 2050 8 #browseChangedMethods 8 'Browse Changed &Methods' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3600 0 8 4294909021 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 3168 0 0 0 770 65 65 0 0 202 208 98 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Source Object' 401 8 #left 4416 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] 3120 4576 7 513 0 0 0 3600 4432 1 0 0 4498 8 'Type' 301 4544 4416 3090 8 #<= 98 0 1090 8 #typeOfObject: 98 1 0 8 ##(Smalltalk.SourceBrowser) 0 3600 0 1 0 0 4498 8 'Changed' 141 4544 4562 0 0 4594 2 1 4624 8 'doIt' 8 '[:x | x ifTrue: [''yes'']]' 8 #[30 105 17 119 29 106 60 106] 8 'yes' 4864 7 257 0 4562 0 0 4594 3 1 4624 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 4960 7 513 0 3090 8 #isChanged 98 0 0 3600 4562 0 0 4594 4 1 4624 8 'doIt' 8 '[:x | x ifTrue: [True icon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association) 8 #True 8 ##(Smalltalk.True) 8 #icon 8 #imageIndex 5120 7 257 0 1 0 0 4498 8 'Writeable' 141 4544 4562 0 0 4594 2 1 4624 8 'doIt' 8 '[:x | x ifFalse: [''no'']]' 8 #[30 105 17 220 2 29 106 60 106] 8 'no' 5328 7 257 0 4562 0 0 4594 3 1 4624 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 5040 5056 5424 7 513 0 3090 8 #canFileOut 98 0 0 3600 4562 0 0 4594 4 1 4624 8 'doIt' 8 '[:x | x ifFalse: [False icon imageIndex]]' 8 #[32 105 17 220 4 45 159 160 106 60 106] 5202 8 #False 8 ##(Smalltalk.False) 5264 5280 5552 7 257 0 1 0 0 4498 8 'Package' 401 4544 3090 8 #name 98 0 4562 0 0 4594 2 1 4624 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] 5728 5760 7 513 0 3090 8 #owningPackage 5744 0 3600 0 1 0 0 4498 8 'Source file' 801 4544 4416 3090 4736 4752 3090 8 #fileOutName 98 0 0 3600 4496 1 0 0 8 #report 1232 0 131169 0 98 1 0 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 1169 539 3600 1090 8 #contextMenu: 98 1 3792 3600 1090 8 #text: 98 1 8 'Source Object' 3600 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 13 1 0 0] 98 0 1248 0 27 8 'list' 0 1026 202 208 98 1 1090 1120 98 2 770 1 101 770 1169 539 3408 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 63 1 0 0] 98 1 3600 1248 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 3778 0 16 98 11 3826 1 2050 8 #fileOpen 8 '&File In...' 9375 1 0 0 0 3890 4097 3826 2097153 2050 2288 8 '&Save' 9383 1 0 0 0 3826 1 2050 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 3826 1 2050 2400 8 'Save A&ll' 1 1 0 0 0 3890 4097 3826 1 2050 3952 8 'Check &Out' 1 1 0 0 0 3826 1 2050 4016 8 'Check &In' 1 1 0 0 0 3890 4097 3826 1 2050 4096 8 '&Changed' 1 1 0 0 0 3826 1 2050 4160 8 '&Writeable' 1 1 0 0 0 8 '&File' 0 134217729 0 0 18069 0 0 3778 0 16 98 2 3826 1 2050 8 #browseSourceObject 8 '<1d>' 9349 1 0 0 0 3826 1 2050 4352 8 'Changed &Methods' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 18075 0 0 3778 0 16 98 3 3826 1 2050 2464 8 '&Changed Only' 1 1 0 0 0 3890 4097 3826 2097153 2050 2528 8 '&Refresh' 1257 1 0 0 0 8 '&View' 0 134217729 0 0 18081 0 0 3778 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 18083 0 0 3778 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 18085 0 0 3778 0 16 98 15 3826 1 2050 8 #helpContents 8 '&Contents' 1025 1 4274 0 16 2160 49 786694 ##(Smalltalk.ShellLibrary) 0 0 3826 1 2050 8 #help 8 'On this &Tool' 1249 1 0 0 0 3826 1 2050 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3890 4097 3826 1 2050 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 3890 4097 3826 1 2050 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3826 1 2050 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3826 1 2050 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3890 4097 3826 1 2050 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3826 1 2050 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3826 1 2050 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3890 4097 3826 1 2050 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4274 0 16 2160 8 '!!APPLICATION' 2208 0 0 8 '&Help' 0 134217729 0 0 18109 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 202 208 98 3 1090 1120 98 2 770 3839 21 770 1201 801 416 1090 6176 98 1 8 'Source Manager' 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 3 560 3408 2848 1248 0 27 )!

show
	"Answer an instance of the receiver showing all the sources in the system"

	^self forSourcesOfPackages: nil!

toolsFolderHelpId
	^10605!

typeOfObject: aSourceObject
	"Private - Answers a descriptive string that identifies the type of aSourceObject"

	^(aSourceObject isKindOf: Class)
		ifTrue: [ 'a Class']
		ifFalse: [ aSourceObject basicPrintString ]!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.

	self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!SourceBrowser class categoriesFor: #displayOn:!displaying!public! !
!SourceBrowser class categoriesFor: #forSourcesOfPackages:!instance creation!public! !
!SourceBrowser class categoriesFor: #icon!constants!public! !
!SourceBrowser class categoriesFor: #initialize!initializing!private! !
!SourceBrowser class categoriesFor: #publishedAspects!development!public! !
!SourceBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!SourceBrowser class categoriesFor: #show!instance creation!public! !
!SourceBrowser class categoriesFor: #toolsFolderHelpId!public! !
!SourceBrowser class categoriesFor: #typeOfObject:!helpers!private! !
!SourceBrowser class categoriesFor: #uninitialize!class hierarchy-removing!private! !

