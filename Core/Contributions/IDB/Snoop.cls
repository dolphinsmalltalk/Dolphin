"Filed out from Dolphin Smalltalk X6"!

IdbToolShell subclass: #Snoop
	instanceVariableNames: 'snoopedShell viewTree presenterTree viewList presenterList status isHidden'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Snoop guid: (GUID fromString: '{425D0EA0-542E-11D3-998B-D5CA2C3C1D61}')!
Snoop comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!Snoop categoriesForClass!IDB Goodies! !
!Snoop methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
Snoop
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

closeSnoopee
	"If there is a shell being snooped then close it down as well"

	snoopedShell isNil 
		ifFalse: 
			[snoopedShell removeEventsTriggeredFor: self view.
			snoopedShell topShell hasView ifTrue: [snoopedShell topShell view close].
			snoopedShell := nil]!

collapse
	"Collapse one level of the tree starting at the selected node"

	| tree |
	tree := self currentTreePresenter.
	tree hasSelection ifTrue: [tree collapse: tree selection]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	viewTree := self add: TreePresenter new name: 'viewTree'.
	viewList := self add: ListPresenter new name: 'viewList'.
	presenterTree := self add: TreePresenter new name: 'presenterTree'.
	presenterList := self add: ListPresenter new name: 'presenterList'.
	status := self add: TextPresenter new name: 'status'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	viewTree 
		when: #selectionChanged
		send: #onTreeSelectionChanged
		to: self.
	viewList 
		when: #actionPerformed
		send: #onListActionPerformed
		to: self.
	presenterTree 
		when: #selectionChanged
		send: #onTreeSelectionChanged
		to: self.
	presenterList 
		when: #actionPerformed
		send: #onListActionPerformed
		to: self.
	(self view viewNamed: 'cards') layoutManager 
		when: #currentCardChanged
		send: #onTreeSelectionChanged
		to: self!

currentListPresenter
	"Answer the current list presenter ('view' or 'presenter')"

	^self isViewTab ifTrue: [viewList] ifFalse: [presenterList]!

currentTreePresenter
	"Answer the current tree presenter ('view' or 'presenter')"

	^self isViewTab ifTrue: [viewTree] ifFalse: [presenterTree]!

expand
	"Expand one level of the tree starting at the selected node"

	| tree |
	tree := self currentTreePresenter.
	tree hasSelection ifTrue: [tree expand: tree selection]!

hideSnoopee
	snoopedShell topShell hide.
	isHidden := true.
	self updateStatus!

inspectItem
	"Same as double clicking an item"

	self onListActionPerformed!

isViewTab
	"Answer true if the view tab is selected. If it's not the view it must be the presenter"

	^(self view viewNamed: 'cards') currentCard name = 'view'!

onListActionPerformed
	"A list item was double clicked so simply open a standard inspector on it"

	| list |
	list := self currentListPresenter.
	list hasSelection ifTrue: [list selection value inspect]!

onTreeSelectionChanged
	"The tree selection has changed so update the items list"

	| tree list |
	tree := self currentTreePresenter.
	list := self currentListPresenter.
	tree hasSelection 
		ifTrue: [list list: tree selection snoopAspects]
		ifFalse: [list list: OrderedCollection new].
	list view layout!

onViewClosed
	super onViewClosed.
	self closeSnoopee!

queryCommand: aCommandQuery 
	| command |
	super queryCommand: aCommandQuery.
	command := aCommandQuery command.
	(#(#report #collapse #expand #refreshTree) includes: command) 
		ifTrue: [aCommandQuery isEnabled: snoopedShell notNil].
	command == #hideSnoopee 
		ifTrue: [aCommandQuery isEnabled: (snoopedShell notNil and: [isHidden not])].
	command == #showSnoopee ifTrue: [aCommandQuery isEnabled: (snoopedShell notNil and: [isHidden])].
	(#(#inspectItem #refreshItem) includes: command) 
		ifTrue: [aCommandQuery isEnabled: viewList hasSelection | presenterList hasSelection]!

refreshItem
	"Force a refresh the items currently selected in the tree"

	| list selectionIndex |
	list := self currentListPresenter.
	selectionIndex := list selectionByIndex.
	self onTreeSelectionChanged.
	list selectionByIndex: selectionIndex!

refreshTree
	"Set the tree presenters model for the first time or after it has changed. Expand and
	select the 	top level when the tree is displayed as will only have a small number of 
	nodes and it also looks better.
	It would be nice to be able to reselect the currently selected item here but ... to do
	this the parent block (see SnoopHierarchy) needs to work but ... a number of items
	that we put in the tree don't know who their parent (or even top view) is !! (menus 
	for example) and finding out would not be an easy task. Seems easier to ignore it"

	viewTree model: (self treeModelFor: snoopedShell view).
	viewTree
		expand: snoopedShell view;
		selection: snoopedShell view.
	presenterTree model: (self treeModelFor: snoopedShell).
	presenterTree
		expand: snoopedShell;
		selection: snoopedShell.
	self updateStatus!

report
	"Opens up a SmalltalkWorkspaceDocument containing the same information
	as the tree but in a text form that can be saved or printed"

	| stream report |
	stream := String writeStream.
	self 
		report: snoopedShell view
		on: stream
		indent: 0.
	report := SmalltalkWorkspaceDocument show.
	report caption: 'Snoop Report on ' , snoopedShell printString.
	report workspace view font: (Font name: 'Courier New' pointSize: 11).
	report workspace text: stream contents!

report: aView on: aStream indent: anInteger 
	"Recursively duplicate the information held in the snoop tree onto aStream"

	| indent |
	indent := (String new: anInteger) atAllPut: $ .
	aStream
		nextPutAll: indent;
		nextPutAll: aView snoopDescription;
		cr.
	indent := indent , ' o '.
	((aView snoopAspects)
		removeFirst;
		yourself) do: 
				[:each | 
				aStream
					nextPutAll: indent;
					nextPutAll: ('%-24s ' sprintfWith: each key);
					nextPutAll: each value printString;
					cr].
	aView snoopChildren do: 
			[:each | 
			self 
				report: each
				on: aStream
				indent: anInteger + 4]!

showSnoopee
	snoopedShell topShell show.
	isHidden := false.
	self updateStatus.
	self topShell setFocus!

snoopee
	"Start up Snoop on an open instance of the selected class. Ensure that any shell
	currently being snooped is closed down first"

	| classList snoopeeClass snoopee |
	classList := CompositePresenter allSubclasses.	"CommonDialog can only be opened modal so we can't snoop on them"
	classList := classList reject: [:each | each includesBehavior: CommonDialog].	"Causes problems as it expects to be updated"
	classList := classList reject: [:each | each includesBehavior: ProgressDialog].
	snoopeeClass := ChoicePrompter choices: classList asSortedCollection
				caption: 'Select a Class to Snoop on'.
	snoopeeClass isNil ifTrue: [^self].
	[snoopee := snoopeeClass show] on: Error
		do: [:e | ^MessageBox notify: 'Unable to snoop on ' , snoopeeClass name].
	self snoopOn: snoopee.
	self topShell setFocus!

snoopOn: aShell 
	"Keep a reference to the shell, so it can be refreshed again later"

	self closeSnoopee.
	snoopedShell := aShell.
	snoopedShell 
		when: #viewClosed
		send: #close
		to: self view.
	isHidden := false.
	self refreshTree!

treeModelFor: anObject 
	"Answer a new tree model suitable for either of the trees used"

	^(VirtualTreeModel new)
		getChildrenBlock: [:each | each snoopChildren];
		getParentBlock: [:each | self error: 'Should never get here'];
		hasChildrenBlock: [:each | each snoopChildren notEmpty];
		roots: (Array with: anObject);
		yourself!

updateStatus
	status value: ((String writeStream)
				nextPutAll: '  Snooping - ';
				print: snoopedShell;
				nextPutAll: (isHidden ifTrue: [' (Hidden)'] ifFalse: ['']);
				contents)! !
!Snoop categoriesFor: #about!commands!public! !
!Snoop categoriesFor: #closeSnoopee!helpers!initializing!public! !
!Snoop categoriesFor: #collapse!commands!public! !
!Snoop categoriesFor: #createComponents!initializing!public! !
!Snoop categoriesFor: #createSchematicWiring!initializing!public! !
!Snoop categoriesFor: #currentListPresenter!helpers!public! !
!Snoop categoriesFor: #currentTreePresenter!helpers!public! !
!Snoop categoriesFor: #expand!commands!public! !
!Snoop categoriesFor: #hideSnoopee!commands!public! !
!Snoop categoriesFor: #inspectItem!commands!public! !
!Snoop categoriesFor: #isViewTab!public!testing! !
!Snoop categoriesFor: #onListActionPerformed!event handling!public! !
!Snoop categoriesFor: #onTreeSelectionChanged!event handling!public! !
!Snoop categoriesFor: #onViewClosed!event handling!public! !
!Snoop categoriesFor: #queryCommand:!commands!public! !
!Snoop categoriesFor: #refreshItem!commands!public! !
!Snoop categoriesFor: #refreshTree!commands!public! !
!Snoop categoriesFor: #report!commands!public! !
!Snoop categoriesFor: #report:on:indent:!helpers!public! !
!Snoop categoriesFor: #showSnoopee!commands!public! !
!Snoop categoriesFor: #snoopee!commands!public! !
!Snoop categoriesFor: #snoopOn:!initializing!public! !
!Snoop categoriesFor: #treeModelFor:!commands!public! !
!Snoop categoriesFor: #updateStatus!helpers!public! !

!Snoop class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 328198 ##(Smalltalk.Point)  1201 801 7 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 592 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 530 193 193 0 592 0 8 4294904209 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 592 0 8 ##(Smalltalk.BasicListAbstract)  0 0 8 'status' 98 1 864 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 592 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 1 649 530 1185 45 592 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 68 1 0 0 80 2 0 0 90 1 0 0] 98 0 530 193 193 0 27 0 0 410 8 ##(Smalltalk.CardContainer)  98 16 0 416 98 2 8 1140850688 131073 1200 0 482 512 0 7 0 0 0 1200 655878 ##(Smalltalk.CardLayout)  202 208 98 2 721414 ##(Smalltalk.Association)  8 'View hierarchy' 410 8 ##(Smalltalk.ContainerView)  98 15 0 1200 98 2 8 1140850688 131073 1408 0 482 512 0 5 0 0 0 1408 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 6 410 8 ##(Smalltalk.TreeView)  98 27 0 1408 98 2 8 1149304867 1025 1568 590918 3 ##(Smalltalk.TreeModel)  0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 98 0 482 512 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #expand 8 'Expand' 1 1 0 0 0 1874 1 1906 8 #collapse 8 'Collapse' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1874 1 1906 8 #refreshTree 8 'Refresh' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1568 0 8 4294904169 459270 ##(Smalltalk.Message)  8 #snoopDescription 98 0 2162 8 #snoopIconIndex 2208 1690 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 0 0 234 240 1792 17 8 #smallIcons 1 0 962 202 208 98 2 1026 1056 98 2 530 1 1 530 465 591 1568 1026 8 #contextMenu: 98 1 1840 1568 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 232 0 0 0 39 1 0 0] 98 0 1184 0 27 81 410 8 ##(Smalltalk.ListView)  98 30 0 1408 98 2 8 1140920397 1025 2544 590662 2 ##(Smalltalk.ListModel)  202 208 1792 0 1696 196934 1 ##(Smalltalk.RGB)  24241131 0 5 1826 0 16 98 2 1874 1 1906 8 #inspectItem 8 'Inspect' 1 1 0 0 0 1874 1 1906 8 #refreshItem 8 'Refresh' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2544 0 8 4294904165 880 8 ##(Smalltalk.IconicListAbstract)  0 0 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Key' 241 8 #left 880 8 ##(Smalltalk.SortedCollection)  2162 8 #key 2208 0 2544 2944 1 0 0 2946 8 'Value' 449 2992 880 3008 2162 8 #value 2208 0 2544 2944 3 0 0 8 #report 1792 0 131169 0 0 962 202 208 98 3 1026 1056 98 2 530 473 1 530 697 591 2544 1026 2464 98 1 2704 2544 1026 8 #text: 98 1 8 'Key' 2544 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 236 0 0 0 0 0 0 0 72 2 0 0 39 1 0 0] 98 0 1184 0 27 121 410 8 ##(Smalltalk.Splitter)  98 12 0 1408 98 2 8 1140850688 1 3392 0 482 512 0 5 0 0 0 3392 962 202 208 98 1 1026 1056 98 2 530 465 1 530 9 591 3392 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 232 0 0 0 0 0 0 0 236 0 0 0 39 1 0 0] 98 0 1184 0 27 1 32 234 256 98 4 2544 8 'viewList' 1568 8 'viewTree' 0 962 202 208 98 1 1026 1056 98 2 530 9 45 530 1169 597 1408 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 76 2 0 0 64 1 0 0] 98 3 1568 3392 2544 1184 0 27 1362 8 'Presenter hierarchy' 410 1424 98 15 0 1200 98 2 8 1140850688 131073 3904 0 482 512 0 7 0 0 0 3904 1506 234 240 98 6 410 2560 98 30 0 3904 98 2 8 1140920397 1025 4032 2626 202 208 1792 0 1696 2674 23068671 0 7 1826 0 16 98 2 1874 1 1906 2768 8 'Inspect' 1 1 0 0 0 1874 1 1906 2832 8 'Refresh' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4032 0 8 4294904165 880 2896 0 0 0 0 0 0 0 202 208 98 2 2946 8 'Key' 241 2992 880 3008 2162 3040 2208 0 4032 2944 1 0 0 2946 8 'Value' 449 2992 880 3008 2162 3104 2208 0 4032 2944 3 0 0 3120 1792 0 131169 0 0 962 202 208 98 3 1026 1056 98 2 530 473 1 530 697 597 4032 1026 2464 98 1 4144 4032 1026 3296 98 1 8 'Key' 4032 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 236 0 0 0 0 0 0 0 72 2 0 0 42 1 0 0] 98 0 1184 0 27 121 410 3408 98 12 0 3904 98 2 8 1140850688 1 4672 0 482 512 0 7 0 0 0 4672 962 202 208 98 1 1026 1056 98 2 530 465 1 530 9 597 4672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 232 0 0 0 0 0 0 0 236 0 0 0 42 1 0 0] 98 0 1184 0 27 1 410 1584 98 27 0 3904 98 2 8 1149304867 1025 4912 1650 0 1696 1746 0 0 0 234 256 1792 482 512 0 7 1826 0 16 98 4 1874 1 1906 1936 8 'Expand' 1 1 0 0 0 1874 1 1906 2000 8 'Collapse' 1 1 0 0 0 2034 4097 1874 1 1906 2096 8 'Refresh' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4912 0 8 4294904169 2162 2192 2208 2162 2240 2208 2256 0 0 0 0 0 234 240 1792 17 2320 1 0 962 202 208 98 2 1026 1056 98 2 530 1 1 530 465 597 4912 1026 2464 98 1 5040 4912 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 232 0 0 0 42 1 0 0] 98 0 1184 0 27 81 32 234 256 98 4 4912 8 'presenterTree' 4032 8 'presenterList' 0 962 202 208 98 1 1026 1056 98 2 530 9 45 530 1169 597 3904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 76 2 0 0 64 1 0 0] 98 3 4912 4672 4032 1184 0 27 3904 234 256 98 4 3904 8 'presenter' 1408 8 'view' 0 410 8 ##(Smalltalk.TabView)  98 23 0 1200 98 2 8 1140916736 1 5792 2626 202 208 98 2 1392 3888 0 1696 674 31 0 1 0 0 0 5792 0 8 4294904153 880 2896 2256 0 0 0 0 0 8 #noIcons 962 202 208 98 3 1026 1056 98 2 530 1 1 530 1185 649 5792 1026 8 #selectionByIndex:ifAbsent: 98 2 5 1026 8 #yourself 1792 0 5792 1026 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 5792 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 68 1 0 0] 98 0 1184 0 27 962 202 208 98 1 1026 1056 98 2 530 1 1 530 1185 649 1200 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 68 1 0 0] 98 3 1408 3904 5792 1184 0 27 234 256 98 2 1200 8 'cards' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 5 1826 0 16 98 3 1874 1 1906 3120 8 '&Report' 1 1 0 0 0 2034 4097 1874 1 1906 8 #exit 8 'E&xit' 1 1 0 0 0 8 '&File' 0 1 0 0 22753 0 0 1874 1 1906 8 #snoopee 8 '&Snoopee' 1 1 0 0 0 1826 0 16 98 7 1874 1 1906 2000 8 '&Collapse' 587 1 0 0 0 1874 1 1906 1936 8 '&Expand' 591 1 0 0 0 2034 4097 1874 1 1906 2096 8 '&Refresh' 1 1 0 0 0 2034 4097 1874 1 1906 8 #hideSnoopee 8 '&Hide snoopee' 1 1 0 0 0 1874 1 1906 8 #showSnoopee 8 '&Show snoopee' 1 1 0 0 0 8 '&Views' 0 1 0 0 22767 0 0 1826 0 16 98 2 1874 1 1906 2768 8 '&Inspect' 1 1 0 0 0 1874 1 1906 2832 8 '&Refresh' 1 1 0 0 0 8 '&Aspects' 0 1 0 0 22773 0 0 1826 0 16 98 19 1874 1 1906 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon)  0 16 1690 8 ##(Smalltalk.ImageRelativeFileLocator)  2288 49 1690 8 ##(Smalltalk.ShellLibrary)  8 #default 0 0 1874 1 1906 8 #help 8 'On this &Tool' 1249 1 0 0 0 1874 1 1906 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2034 4097 1874 1 1906 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 2034 4097 1874 1 1906 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 1874 1 1906 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 1874 1 1906 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 1826 0 16 98 4 1874 2097153 1906 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 7346 0 16 7376 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1874 1 1906 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 7346 0 16 7376 8 'TipOfTheDay.ico' 8016 0 0 2034 4097 1874 1 1906 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 2034 4097 1874 1 1906 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 1874 1 1906 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 1874 1 1906 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 1874 1 1906 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 2034 4097 1874 1 1906 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 7346 0 16 7376 8 'LiveUpdate.ico' 8016 0 0 2034 4097 1874 1 1906 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7346 0 16 7376 8 '!!APPLICATION' 8016 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 7 1362 587 6800 1362 591 6848 1362 1025 1906 7312 8 '&Contents' 1025 1 7346 0 16 7376 49 7408 1362 1249 1906 7488 8 'On this &Tool' 1249 1 0 1362 5345 1906 7552 8 'What''s This?' 5345 1 0 1362 9441 1906 7936 8 '&Next Tip of the Day' 9441 1 7346 0 16 7376 8 'TipOfTheDay.ico' 8016 1362 13537 1906 8080 8 '&Previous Tip of the Day' 13537 1 7346 0 16 7376 8 'TipOfTheDay.ico' 8016 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 530 6399 21 530 1201 801 416 1026 3296 98 1 8 'Snoop' 416 1026 8 #menuBar: 98 1 6480 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 215 14 0 0 154 1 0 0] 98 2 1200 592 1184 0 27 )! !
!Snoop class categoriesFor: #icon!constants!public! !
!Snoop class categoriesFor: #resource_Default_view!public!resources-views! !

