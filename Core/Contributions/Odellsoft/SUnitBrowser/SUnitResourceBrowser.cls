"Filed out from Dolphin Smalltalk 7"!

SUnitAbsBrowser subclass: #SUnitResourceBrowser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitResourceBrowser guid: (GUID fromString: '{ee3accb0-4f35-4387-82fe-150498fd8b82}')!
SUnitResourceBrowser comment: ''!
!SUnitResourceBrowser categoriesForClass!Unclassified! !
!SUnitResourceBrowser methodsFor!

browserName

	^'SUnit Resource Browser'
!

browseTestCases

	SUnitBrowser show!

callbackStartedTestResource: aTestResource

	self 
		refreshList; 
		setDetailState!

callbackStoppedTestResource: anTestResource 

	self 
		refreshList; 
		setDetailState!

createSchematicWiring

	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.

	self listPresenter
		when: #actionPerformed
		send: #sbBrowseHierarchy
		to: self!

model: anSUnitResourceBrowserModel
	"Set the model of the receiver to be anObject"

	super model: anSUnitResourceBrowserModel.
	anSUnitResourceBrowserModel browser: self.

	self listModel: (ListModel on: self wrapAllTestResourcesFromModel).
	listPresenter model: self listModel.

	self setResultDisplay!

queryCommand: aCommandQuery
	"Enters details about a potential command for the receiver into aCommandQuery"

	super queryCommand: aCommandQuery.

	(aCommandQuery command = #startAll)
		 ifTrue: [^aCommandQuery isEnabled: self model canStartAll].

	(aCommandQuery command = #stopAll)
		 ifTrue: [^aCommandQuery isEnabled: self model canStopAll].

	(aCommandQuery command = #startSelected)
		 ifTrue: [^aCommandQuery isEnabled: self model canStart].

	(aCommandQuery command = #stopSelected)
		 ifTrue: [^aCommandQuery isEnabled: self model canStop].

	(aCommandQuery command = #showStatusPaneBackgroundColors)
		 ifTrue: [aCommandQuery isChecked: self model showStatusBackgroundColors]!

resetListFromModel

	self listModel 
		removeAll; 
		addAll: self wrapAllTestResourcesFromModel


!

sbBrowseHierarchy

	| currentClass |

	self model selectedItem canBrowse 
		ifFalse: [^self].

	currentClass := self model selectedItem class.

	currentClass browse!

setLabelState
!

setModelWithSelectedItems

	self model selectItems: (self listPresenter selections asOrderedCollection collect: [:each | each testResource])
!

startAll

	self model startAll!

startSelected

	self model startSelected!

stopAll

	self model stopAll!

stopSelected

	self model stopSelected!

wrapAllTestResourcesFromModel

	^self model listItems collect: [:each | SUnitTestResourceWrapper newOn: each model: self model].
! !
!SUnitResourceBrowser categoriesFor: #browserName!commands!private! !
!SUnitResourceBrowser categoriesFor: #browseTestCases!commands!private! !
!SUnitResourceBrowser categoriesFor: #callbackStartedTestResource:!model callbacks!private! !
!SUnitResourceBrowser categoriesFor: #callbackStoppedTestResource:!model callbacks!private! !
!SUnitResourceBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!SUnitResourceBrowser categoriesFor: #model:!accessing!public! !
!SUnitResourceBrowser categoriesFor: #queryCommand:!commands!private! !
!SUnitResourceBrowser categoriesFor: #resetListFromModel!model callbacks!private! !
!SUnitResourceBrowser categoriesFor: #sbBrowseHierarchy!commands!private! !
!SUnitResourceBrowser categoriesFor: #setLabelState!model callbacks!private! !
!SUnitResourceBrowser categoriesFor: #setModelWithSelectedItems!event handling!private! !
!SUnitResourceBrowser categoriesFor: #startAll!commands!private! !
!SUnitResourceBrowser categoriesFor: #startSelected!commands!private! !
!SUnitResourceBrowser categoriesFor: #stopAll!commands!private! !
!SUnitResourceBrowser categoriesFor: #stopSelected!commands!private! !
!SUnitResourceBrowser categoriesFor: #wrapAllTestResourcesFromModel!model callbacks!private! !

!SUnitResourceBrowser class methodsFor!

defaultModel

	^self defaultModelClass
		newForUI: nil
		builder: TestResource!

defaultModelClass

	^SUnitResourceBrowserModel!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'SUnit Resource Browser'!

initialize
	"
	self initialize
	"

	self initializeToolClass: self!

openOnTestResource: aTestResource 
	| model |
	model := SUnitResourceBrowserModel newForUI: nil builder: aTestResource.
	(self show)
		model: model;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.ReferenceView) 98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 1180166 ##(Smalltalk.ResourceIdentifier) 8 ##(Smalltalk.SUnitToolbar) 8 #resource_Resource_browser_toolbar 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 1 834 2369 61 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 30 0 0 0] 98 0 834 193 193 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 960 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 960 0 8 4294905391 234 256 98 4 853766 ##(Smalltalk.StatusBarItem) 1 51 960 0 8 ##(Smalltalk.BasicListAbstract) 0 1049926 1 ##(Smalltalk.IconImageManager) 8 'showAll' 1122 1 -1 960 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:wrapper | wrapper text]' 8 #[30 105 17 158 106] 8 #text 1248 7 257 0 8 ##(Smalltalk.IconicListAbstract) 1184 8 'status' 98 1 1216 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 960 0 0 706 202 208 98 1 770 800 98 2 834 1 1497 834 2369 39 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 236 2 0 0 160 4 0 0 255 2 0 0] 98 0 944 0 27 0 0 410 8 ##(Smalltalk.ListView) 98 30 0 416 98 2 8 1140920393 1 1616 590662 2 ##(Smalltalk.ListModel) 202 208 928 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 196934 1 ##(Smalltalk.RGB) 33554431 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 16 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #runAll 8 'Run &All' 1 1 0 0 0 1858 1 1890 8 #runSelected 8 '&Run Selected' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1858 1 1890 8 #debug 8 '&Debug' 1 1 0 0 0 1858 1 1890 8 #step 8 '&Step' 1 1 0 0 0 2018 4097 1858 1 1890 8 #inspectSelected 8 '&Inspect' 1 1 0 0 0 2018 4097 1858 1 1890 8 #delete 8 'Delete' 1 1 0 0 0 2018 4097 1858 1 1890 8 #reset 8 'Reset' 1 1 0 0 0 2018 4097 1858 1 1890 8 #sbBrowseHierarchy 8 'Browse &Hierarchy' 1 1 0 0 0 1858 1 1890 8 #browseTestCases 8 'Browse Tests' 1 1 0 0 0 2018 4097 1858 1 1890 8 #useDisplayNames 8 'Use Display Names' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1616 0 8 4294909021 1152 1376 1184 0 0 0 834 65 65 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Resource' 2103 8 #left 1152 8 ##(Smalltalk.SortedCollection) 1234 0 0 1266 2 1 1296 8 'doIt' 8 '[:resource | resource name]' 8 #[30 105 17 158 106] 8 #name 2800 7 257 0 0 1616 1234 0 0 1266 1 83886081 1296 8 'doIt' 8 '[:x|nil]' 8 #[29 105 60 106] 2896 7 257 0 3 0 0 2722 8 'Status' 259 2768 1152 2784 1234 0 0 1266 2 1 1296 8 'doIt' 8 '[:resource | resource status]' 8 #[30 105 17 158 106] 8 #status 3008 7 257 0 0 1616 0 1 0 0 8 #report 928 0 133217 0 98 1 0 706 202 208 98 3 770 800 98 2 834 1 61 834 2369 1437 1616 770 8 #contextMenu: 98 1 1824 1616 770 8 #text: 98 1 8 'Resource' 1616 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 30 0 0 0 160 4 0 0 236 2 0 0] 98 0 944 0 27 234 256 98 4 560 8 'toolbar' 1616 8 'list' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 1810 0 16 98 1 1858 1 1890 8 #exit 8 '&Exit' 1 1 0 0 0 8 '&File' 0 1 0 0 49071 0 0 1810 0 16 98 2 1858 1 1890 2464 8 'Browse &Hierarchy' 1 1 0 0 0 1858 1 1890 2528 8 'Browse &Tests' 1 1 0 0 0 8 '&Browse' 0 1 0 0 49077 0 0 1810 0 16 98 9 1858 1 1890 8 #startAll 8 'Start &All' 1 1 0 0 0 1858 1 1890 8 #startSelected 8 '&Start Selected' 1 1 0 0 0 2018 4097 1858 1 1890 8 #stopAll 8 'S&top All' 1 1 0 0 0 1858 1 1890 8 #stopSelected 8 'Stop Selected' 1 1 0 0 0 2018 4097 1858 1 1890 2304 8 'Delete' 1 1 0 0 0 2018 4097 1858 1 1890 2384 8 'Reset' 1 1 0 0 0 8 'T&est' 0 1 0 0 49091 0 0 1810 0 16 98 1 1858 1 1890 2608 8 'Use Display Names' 1 1 0 0 0 8 'Configuration' 0 1 0 0 49095 0 0 1810 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 49097 0 0 1810 0 16 98 15 1858 1 1890 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 1858 1 1890 8 #help 8 'On this &Tool' 1249 1 0 0 0 1858 1 1890 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2018 4097 1858 1 1890 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 2018 4097 1858 1 1890 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 1858 1 1890 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 1858 1 1890 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2018 4097 1858 1 1890 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 1858 1 1890 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 1858 1 1890 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2018 4097 1858 1 1890 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4482 0 16 4528 8 '!!APPLICATION' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 8 '&Help' 0 134217729 0 0 49121 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 706 202 208 98 3 770 800 98 2 834 3839 21 834 2401 1653 416 770 3312 98 1 8 'SUnit Resource Browser' 416 770 8 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 47 12 0 0 68 3 0 0] 98 3 560 1616 960 944 0 27 )!

toolsFolderHelpId
	^10612!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
	Un-register the system tools folder icon for the receiver.
	Note: This method is in the 'must strip' category so that it is removed in the early
	stages of image stripping. It is not required during stripping, because the system
	folders are cleared down anyway, and it may generate an error if required parts
	of the development system have already been removed.

	self uninitialize
	"

	self uninitializeToolClass: self! !
!SUnitResourceBrowser class categoriesFor: #defaultModel!accessing!private! !
!SUnitResourceBrowser class categoriesFor: #defaultModelClass!accessing!private! !
!SUnitResourceBrowser class categoriesFor: #displayOn:!displaying!public! !
!SUnitResourceBrowser class categoriesFor: #initialize!initializing!must strip!private! !
!SUnitResourceBrowser class categoriesFor: #openOnTestResource:!instance creation!public! !
!SUnitResourceBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!SUnitResourceBrowser class categoriesFor: #toolsFolderHelpId!public! !
!SUnitResourceBrowser class categoriesFor: #uninitialize!initializing!must strip!private! !

