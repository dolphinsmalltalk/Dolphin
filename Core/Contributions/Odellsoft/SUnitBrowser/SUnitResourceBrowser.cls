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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 544 nil nil nil 7 nil nil nil 544 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_SUnitBrowser_Resource_browser_toolbar nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 754 2369 51 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 8 #() 754 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 880 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 880 nil 8 1914952576 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 880 nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:wrapper | wrapper text]' 8 #[30 105 17 158 106] #text 1072 7 257 nil ##(Smalltalk.IconicListAbstract) nil 8 'status' 1026 1 51 880 nil ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) 8 'showAll' 34 1 1040 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 880 nil nil 642 138 144 34 1 706 #createAt:extent: 34 2 754 1 1497 754 2369 39 880 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 236 2 0 0 160 4 0 0 255 2 0 0] 8 #() 864 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140920393 1 1456 590662 2 ##(Smalltalk.ListModel) 138 144 848 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 196934 1 ##(Smalltalk.RGB) 33554431 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 16 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #runAll 8 'Run &All' 1 1 nil nil nil 1682 1 1714 #runSelected 8 '&Run Selected' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1682 1 1714 #debug 8 '&Debug' 1 1 nil nil nil 1682 1 1714 #step 8 '&Step' 1 1 nil nil nil 1810 4097 1682 1 1714 #inspectSelected 8 '&Inspect' 1 1 nil nil nil 1810 4097 1682 1 1714 #delete 8 'Delete' 1 1 nil nil nil 1810 4097 1682 1 1714 #reset 8 'Reset' 1 1 nil nil nil 1810 4097 1682 1 1714 #sbBrowseHierarchy 8 'Browse &Hierarchy' 1 1 nil nil nil 1682 1 1714 #browseTestCases 8 'Browse Tests' 1 1 nil nil nil 1810 4097 1682 1 1714 #useDisplayNames 8 'Use Display Names' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1456 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1216 nil nil nil 754 65 65 nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Resource' 2103 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 1058 0 nil 1090 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:resource | resource name]' 8 #[30 105 17 158 106] #name 2432 7 257 nil nil 1456 1058 0 nil 1090 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x|nil]' 8 #[29 105 60 106] 2512 7 257 nil 3 nil nil 2386 8 'Status' 259 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 1058 0 nil 1090 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:resource | resource status]' 8 #[30 105 17 158 106] #status 2624 7 257 nil nil 1456 nil 1 nil nil #report 848 nil 133217 nil 8 #(nil) 642 138 144 34 3 706 #createAt:extent: 34 2 754 1 51 754 2369 1447 1456 706 #contextMenu: 34 1 1648 1456 706 #text: 34 1 8 'Resource' 1456 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 236 2 0 0] 8 #() 864 nil 27 170 192 34 4 1456 8 'list' 544 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 1634 nil true 34 1 1682 1 1714 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 1 nil nil 31511 nil nil 1634 nil true 34 2 1682 1 1714 #sbBrowseHierarchy 8 'Browse &Hierarchy' 1 1 nil nil nil 1682 1 1714 #browseTestCases 8 'Browse &Tests' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil 31517 nil nil 1634 nil true 34 9 1682 1 1714 #startAll 8 'Start &All' 1 1 nil nil nil 1682 1 1714 #startSelected 8 '&Start Selected' 1 1 nil nil nil 1810 4097 1682 1 1714 #stopAll 8 'S&top All' 1 1 nil nil nil 1682 1 1714 #stopSelected 8 'Stop Selected' 1 1 nil nil nil 1810 4097 1682 1 1714 #delete 8 'Delete' 1 1 nil nil nil 1810 4097 1682 1 1714 #reset 8 'Reset' 1 1 nil nil nil 8 'T&est' nil 1 nil nil 31531 nil nil 1634 nil true 34 1 1682 1 1714 #useDisplayNames 8 'Use Display Names' 1 1 nil nil nil 8 'Configuration' nil 1 nil nil 31535 nil nil 1634 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 31537 nil nil 1634 nil true 34 15 1682 1 1714 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) nil nil 1682 1 1714 #help 8 'On this &Tool' 1249 1 nil nil nil 1682 1 1714 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 1810 4097 1682 1 1714 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 1810 4097 1682 1 1714 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 1682 1 1714 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 1682 1 1714 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 1810 4097 1682 1 1714 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 1682 1 1714 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 1682 1 1714 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 1810 4097 1682 1 1714 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3922 nil true 3968 8 '!!APPLICATION' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 8 '&Help' nil 134217729 nil nil 31561 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 642 138 144 34 3 706 #createAt:extent: 34 2 754 3839 21 754 2401 1653 416 706 #text: 34 1 8 'SUnit Resource Browser' 416 706 #updateMenuBar 848 416 802 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 47 12 0 0 68 3 0 0] 34 3 544 1456 880 864 nil 27 )!

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

