"Filed out from Dolphin Smalltalk X6"!

SmalltalkToolShell subclass: #SelectorBrowser
	instanceVariableNames: 'selectorsPresenter searchEnvironment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SelectorBrowser guid: (GUID fromString: '{944D70B6-5CE9-4D2D-9E54-9B6481B3B035}')!
SelectorBrowser comment: 'SelectorBrowser is a <SmalltalkToolShell> that displays a list of method selectors, and which can be used as a launch off point for browsing definitions and references of/to these.

Instance Variables:
	selectorsPresenter		<ListPresenter> displaying the list of selectors.'!
!SelectorBrowser categoriesForClass!Development! !
!SelectorBrowser methodsFor!

browseDefinitions
	"Context-sensitive 'Browse Definitions' command."

	self systemModel browseDefinitionsOfSelector: self selector
		in: self searchEnvironment!

browseReferences
	"Context-sensitive 'Browse References' command. In this case browse refs. to the 
	current selector."

	self systemModel browseReferencesToLiteral: self selector in: self searchEnvironment!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	selectorsPresenter := self add: ListPresenter new name: 'list'!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery> argument."

	| command hasSelection |
	command := aCommandQuery commandSymbol.
	hasSelection := selectorsPresenter hasSelection.
	(#(#browseDefinitions #browseReferences) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: hasSelection.
			^true].
	(self canRefactor and: [self queryRefactoringCommand: aCommandQuery]) ifTrue: [^true].
	^super queryCommand: aCommandQuery!

searchEnvironment
	^searchEnvironment ifNil: [self systemModel systemEnvironment]!

searchEnvironment: aBrowserEnvironment 
	"Set the <BrowserEnvironment> used as the context for searches such as those for references
	to a selector.. By default this will be 'Smalltalk', which includes the whole system, so all
	searches will be global."

	searchEnvironment := aBrowserEnvironment!

selector
	^selectorsPresenter selectionOrNil!

selectors
	^selectorsPresenter list!

selectors: aCollectionOfSelectors 
	selectorsPresenter list: aCollectionOfSelectors! !
!SelectorBrowser categoriesFor: #browseDefinitions!commands!public! !
!SelectorBrowser categoriesFor: #browseReferences!commands!public! !
!SelectorBrowser categoriesFor: #createComponents!initializing!public! !
!SelectorBrowser categoriesFor: #queryCommand:!commands!private! !
!SelectorBrowser categoriesFor: #searchEnvironment!commands!public! !
!SelectorBrowser categoriesFor: #searchEnvironment:!accessing!public! !
!SelectorBrowser categoriesFor: #selector!Accessing!public! !
!SelectorBrowser categoriesFor: #selectors!accessing!public! !
!SelectorBrowser categoriesFor: #selectors:!accessing!public! !

!SelectorBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef)  8 4278190080 328198 ##(Point)  601 801 517 0 0 0 416 788230 ##(BorderLayout)  1 1 0 0 0 0 410 8 ##(ListView)  98 30 0 416 98 2 8 1140969549 1 592 590662 2 ##(ListModel)  202 208 98 0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 482 512 0 5 265030 4 ##(Menu)  0 16 98 4 818 0 16 98 6 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #renameMethod 8 'Re&name...' 1 1 0 0 0 898 1 930 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 983366 1 ##(DividerMenuItem)  4097 898 1 930 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 818 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 0 0 0 818 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 0 0 0 0 0 1058 4097 898 1 930 8 #browseDefinitions 8 'Defi&nitions' 1 1 0 0 0 898 1 930 8 #browseReferences 8 '&References' 1 1 0 0 0 8 '&Selector' 0 134217729 0 0 0 0 0 0 0 592 0 8 4294902987 8 ##(BasicListAbstract)  8 ##(IconicListAbstract)  746 8 ##(IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 1 920646 5 ##(ListViewColumn)  8 'Selectors' 577 8 #left 1488 8 ##(SortedCollection)  0 0 592 0 3 0 0 8 #report 720 0 131073 0 0 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 530 1 1 530 585 733 592 1762 8 #contextMenu: 98 1 832 592 1762 8 #text: 98 1 8 'Selectors' 592 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 36 1 0 0 110 1 0 0] 98 0 530 193 193 0 27 234 256 98 2 592 8 'list' 0 461638 4 ##(MenuBar)  0 16 98 6 818 0 16 98 4 898 1 930 8 #fileNew 8 '&New' 9373 1 0 0 0 898 1 930 8 #fileOpen 8 '&Open...' 9375 1 0 0 0 1058 4097 898 1 930 8 #exit 8 '&Close' 17639 1 0 0 0 8 '&File' 0 134217729 0 0 36617 0 0 818 0 16 98 2 898 1 930 1360 8 'Defi&nitions...' 1271 1 0 0 0 898 1 930 1424 8 '&References...' 5367 1 0 0 0 8 '&Browse' 0 134217729 0 0 36623 0 0 818 0 16 98 6 818 0 16 98 3 898 1 930 960 8 'All...' 1 1 0 0 0 898 1 930 8 #renameMethodInHierarchy 8 'In &Hierarchy...' 1 1 0 0 0 898 1 930 8 #renameMethodInPackage 8 'In &Package...' 1 1 0 0 0 8 'Re&name' 0 134217729 0 0 36631 0 0 1058 4097 898 1 930 1120 8 'Add &Parameter...' 1 1 0 0 0 818 0 16 98 0 8 'Remo&ve Parameter' 1200 134217729 0 0 36635 0 0 818 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 36637 0 0 818 0 16 98 0 8 '&Inline Parameter' 1264 134217729 0 0 36639 0 0 8 'Refactorin&gs' 1296 134217729 0 0 36641 0 0 818 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 36643 0 0 818 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 36645 0 0 818 0 16 98 7 898 1 930 8 #help 8 '&Help on this tool' 1249 1 263494 3 ##(Icon)  0 16 746 8 ##(ImageRelativeFileLocator)  1552 49 746 8 ##(ShellLibrary)  8 #default 0 0 1058 4097 898 1 930 8 #guidedTour 8 '&Guided tour' 1 1 0 0 0 898 1 930 8 #educationCenter 8 '&Education centre' 1 1 0 0 0 898 1 930 8 #tipOfTheDay 8 '&Tip of the Day' 1 1 3266 0 16 3296 8 'TipOfTheDay.ico' 2032142 ##(STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1058 4097 898 1 930 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3266 0 16 3296 8 '!!APPLICATION' 3632 0 0 8 '&Help' 0 134217729 0 0 36657 0 0 8 '' 0 134217729 0 0 0 0 0 0 1049350 ##(AcceleratorTable)  0 16 98 6 721414 ##(Association)  9373 2192 3858 9375 2256 3858 17639 2336 3858 1271 2448 3858 5367 2496 3858 1249 3216 0 1 0 0 0 0 1 0 0 1698 202 208 98 2 1762 1792 98 2 530 397 523 530 601 801 416 1762 8 #menuBar: 98 1 2112 416 1970 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 198 0 0 0 5 1 0 0 242 1 0 0 149 2 0 0] 98 1 592 2032 0 27 )! !
!SelectorBrowser class categoriesFor: #resource_Default_view!public!resources-views! !

