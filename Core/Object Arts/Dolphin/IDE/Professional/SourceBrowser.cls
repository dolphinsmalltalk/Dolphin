"Filed out from Dolphin Smalltalk X6"!

SmalltalkToolShell subclass: #SourceBrowser
	instanceVariableNames: 'listPresenter changedOnly refreshBlock packagesFilter statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SourceBrowser guid: (GUID fromString: '{87B4C6C4-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	listPresenter selectionsByIndex do: [:index |
		listPresenter model updateAtIndex: index ]!

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

	Smalltalk developmentSystem
		addAdditionalToolsFolderIcon: self toolsFolderIcon;
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4294967295 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 1 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 482 656 8 4294905093 234 256 98 4 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 848 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 63 1 754 991 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'smalltalkTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1264 0 930 31 0 7 0 0 0 1264 962 576 8 #resource_Image_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 63 51 1264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1216 1232 0 27 8 'imageTools' 234 256 1216 202 208 1216 234 240 1216 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 1010 202 208 98 2 1074 1104 98 2 754 1 1 754 1185 101 560 1074 8 #updateSize 1216 560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 50 0 0 0] 98 3 1264 848 410 576 98 25 0 560 98 2 8 1140853580 131137 1840 0 482 656 0 519 0 0 0 1840 482 656 8 4294905093 234 256 1216 234 256 98 10 36835 853766 ##(Smalltalk.ToolbarButton)  36835 0 1840 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #fileFileIn 8 'File In...' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.ImageRelativeFileLocator)  8 #current 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 71 754 1857 33 25 36837 2002 36837 0 1840 1 2034 8 #fileSave 8 'Save Selected Sources' 1 1 0 2098 0 16 2144 8 'FileBar.bmp' 2224 0 7 754 161 33 5 36839 2002 36839 0 1840 1 2034 8 #fileSaveAll 8 'Save All Sources' 1 1 0 2336 7 36841 2002 36841 0 1840 1 2034 8 #viewChangedOnly 8 'Show Changed Only' 1 1 0 2112 83 36843 2002 36843 0 1840 1 2034 8 #viewRefresh 8 'Refresh' 1 1 0 2112 109 98 6 2016 2272 2384 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 1840 3 0 1 2448 2512 234 240 98 4 2112 1 2336 117 0 1 0 754 33 33 754 45 45 0 0 1010 202 208 98 2 1074 1104 98 2 754 1 51 754 247 51 1840 1074 1776 1216 1840 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 98 0 1232 0 27 1232 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140853004 1 2864 0 482 656 0 7 0 674 0 16 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 754 193 193 0 2864 0 8 4294905053 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 2864 0 459270 ##(Smalltalk.Message)  8 #displayString 98 0 3072 2138 8 ##(Smalltalk.IconImageManager)  2176 8 'status' 98 1 3088 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 2864 0 0 1010 202 208 98 1 1074 1104 98 2 754 1 649 754 1185 45 2864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 68 1 0 0 80 2 0 0 90 1 0 0] 98 0 1232 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 3424 0 482 8 4278190080 0 7 0 0 0 3424 1180166 ##(Smalltalk.ProportionalLayout)  234 240 1216 16 234 256 98 2 410 8 ##(Smalltalk.ListView)  98 30 0 3424 98 2 8 1140920393 1 3616 590662 2 ##(Smalltalk.ListModel)  202 208 1216 0 2138 8 ##(Smalltalk.SearchPolicy)  8 #identity 482 656 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 2034 2304 8 '&Save' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3858 1 2034 8 #checkOut 8 'Check &Out' 1 1 0 0 0 3858 1 2034 8 #checkIn 8 'Check &In' 1 1 0 0 0 3922 4097 3858 1 2034 8 #toggleChanged 8 '&Changed' 1 1 0 0 0 3858 1 2034 8 #toggleWriteable 8 '&Writeable' 1 1 0 0 0 3922 4097 3858 1 2034 8 #browseIt 8 '&Browse <1d>' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 2144 8 'ClassBrowserShell.ico' 2224 0 0 3858 1 2034 8 #browseChangedMethods 8 'Browse Changed &Methods' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3616 0 8 4294904983 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  3168 0 0 0 754 65 65 0 0 202 208 98 6 920646 5 ##(Smalltalk.ListViewColumn)  8 'Source Object' 401 8 #left 4448 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] 3136 4608 7 513 0 0 0 3616 4464 1 0 0 4530 8 'Type' 301 4576 4448 3106 8 #<= 98 0 1074 8 #typeOfObject: 98 1 0 8 ##(Smalltalk.SourceBrowser)  0 3616 0 1 0 0 4530 8 'Changed' 141 4576 4594 0 0 4626 2 1 4656 8 'doIt' 8 '[:x | x ifTrue: [''yes'']]' 8 #[30 105 17 119 29 106 60 106] 8 'yes' 4896 7 257 0 4594 0 0 4626 3 1 4656 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 4992 7 513 0 3106 8 #isChanged 98 0 0 3616 4594 0 0 4626 4 1 4656 8 'doIt' 8 '[:x | x ifTrue: [True icon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association)  8 #True 8 ##(Smalltalk.True)  8 #icon 8 #imageIndex 5152 7 257 0 1 0 0 4530 8 'Writeable' 141 4576 4594 0 0 4626 2 1 4656 8 'doIt' 8 '[:x | x ifFalse: [''no'']]' 8 #[30 105 17 220 2 29 106 60 106] 8 'no' 5360 7 257 0 4594 0 0 4626 3 1 4656 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 5072 5088 5456 7 513 0 3106 8 #canFileOut 98 0 0 3616 4594 0 0 4626 4 1 4656 8 'doIt' 8 '[:x | x ifFalse: [False icon imageIndex]]' 8 #[32 105 17 220 4 45 159 160 106 60 106] 5234 8 #False 8 ##(Smalltalk.False)  5296 5312 5584 7 257 0 1 0 0 4530 8 'Package' 401 4576 3106 8 #name 98 0 4594 0 0 4626 2 1 4656 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] 5760 5792 7 513 0 3106 8 #owningPackage 5776 0 3616 0 1 0 0 4530 8 'Source file' 801 4576 4448 3106 4768 4784 3106 8 #fileOutName 98 0 0 3616 4528 1 0 0 8 #report 1216 0 131169 0 0 1010 202 208 98 3 1074 1104 98 2 754 1 1 754 1185 549 3616 1074 8 #contextMenu: 98 1 3824 3616 1074 8 #text: 98 1 8 'Source Object' 3616 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 18 1 0 0] 98 0 1232 0 27 8 'list' 0 1010 202 208 98 1 1074 1104 98 2 754 1 101 754 1185 549 3424 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 80 2 0 0 68 1 0 0] 98 1 3616 1232 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 6 3810 0 16 98 11 3858 1 2034 8 #fileOpen 8 '&File In...' 8351 1 0 0 0 3922 4097 3858 2097153 2034 2304 8 '&Save' 8359 1 0 0 0 3858 1 2034 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 3858 1 2034 2416 8 'Save A&ll' 1 1 0 0 0 3922 4097 3858 1 2034 3984 8 'Check &Out' 1 1 0 0 0 3858 1 2034 4048 8 'Check &In' 1 1 0 0 0 3922 4097 3858 1 2034 4128 8 '&Changed' 1 1 0 0 0 3858 1 2034 4192 8 '&Writeable' 1 1 0 0 0 8 '&File' 0 134217729 0 0 36755 0 0 3810 0 16 98 2 3858 1 2034 8 #browseSourceObject 8 '<1d>' 8325 1 0 0 0 3858 1 2034 4384 8 'Changed &Methods' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 36761 0 0 3810 0 16 98 3 3858 1 2034 2480 8 '&Changed Only' 1 1 0 0 0 3922 4097 3858 2097153 2034 2544 8 '&Refresh' 233 1 0 0 0 8 '&View' 0 134217729 0 0 36767 0 0 3810 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 36769 0 0 3810 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 36771 0 0 3810 0 16 98 19 3858 1 2034 8 #helpContents 8 '&Contents' 1025 1 4306 0 16 2144 49 2138 8 ##(Smalltalk.ShellLibrary)  8 #default 0 0 3858 1 2034 8 #help 8 'On this &Tool' 1249 1 0 0 0 3858 1 2034 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3922 4097 3858 1 2034 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 3922 4097 3858 1 2034 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3858 1 2034 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3858 1 2034 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3810 0 16 98 4 3858 1 2034 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 4306 0 16 2144 8 'TipOfTheDay.ico' 2224 0 0 3858 1 2034 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 4306 0 16 2144 8 'TipOfTheDay.ico' 2224 0 0 3922 4097 3858 1 2034 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 3922 4097 3858 1 2034 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3858 1 2034 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3858 1 2034 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3858 1 2034 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 3922 4097 3858 1 2034 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 4306 0 16 2144 8 'LiveUpdate.ico' 2224 0 0 3922 4097 3858 1 2034 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4306 0 16 2144 8 '!!APPLICATION' 2224 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 9 5234 8351 6608 5234 8359 6688 5234 8325 7120 5234 233 7344 5234 9441 2034 7584 8 '&Contents' 9441 1 4306 0 16 2144 49 7632 5234 1249 2034 7712 8 'On this &Tool' 1249 1 0 5234 5345 2034 7776 8 'What''s This?' 5345 1 0 5234 17633 2034 8160 8 '&Next Tip of the Day' 17633 1 4306 0 16 2144 8 'TipOfTheDay.ico' 2224 5234 21729 2034 8256 8 '&Previous Tip of the Day' 21729 1 4306 0 16 2144 8 'TipOfTheDay.ico' 2224 0 1 0 0 0 0 1 0 0 1010 202 208 98 3 1074 1104 98 2 754 6399 21 754 1201 801 416 1074 6192 98 1 8 'Source Manager' 416 1074 8 #menuBar: 98 1 6528 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 215 14 0 0 154 1 0 0] 98 3 560 3424 2864 1232 0 27 )!

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

