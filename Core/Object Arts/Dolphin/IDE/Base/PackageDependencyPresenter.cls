﻿"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #PackageDependencyPresenter
	instanceVariableNames: 'treePresenter tracesPresenter traces packages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageDependencyPresenter guid: (GUID fromString: '{183e540c-f682-44d4-ac9c-77d4e4ca9487}')!
PackageDependencyPresenter isAbstract: true!
PackageDependencyPresenter comment: 'PackageDependencyPresenter is the abstract superclass of the development tool windows which display a tree representing the dependency relationships between packages. Subclasses show emphasise either the pre-requisite relationship (where the children of a package in the tree are the pre-requisistes for that package) or dependency relationship (where the children of a package in the tree are the packages dependent upon it, i.e. of which it is itself a pre-requisite).

Instance Variables:
	prerequisitesPresenter	<TreePresenter> holding the dependency tree.
	tracesPresenter			<ListPresenter> holding the list of traces.
	traces					<IdentityDictionary> of traces generated by Package>>tracePrerequisites.
	packages				<Package>s at the root of the tree for which dependency relationships are being displayed.
'!
!PackageDependencyPresenter categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!PackageDependencyPresenter methodsFor!

browsePackages
	"Browse the currently selected prerequisite package."

	self selectedPair ifNotNil: [:selected | selected key browse]!

browseTrace
	"Browse the currently selected trace object."

	| trace |
	trace := tracesPresenter selections.
	trace notEmpty ifTrue: [
		trace first first browse]!

buildChildNodes: aCollection for: aTreeNode 
	^(aCollection asSortedCollection: Package defaultSortBlock) collect: [:p | p -> aTreeNode]!

childrenFor: aTreeNode 
	"Private - Answer a <sequencedReadableCollection> of the child nodes below the package
	dependency tree node argument."

	^self subclassResponsibility!

choosePackage
	"Prompt for the user to repackage the selected objects."

	| pkg newPkg dependees |
	dependees := IdentitySet new.
	tracesPresenter selections do: [:t | dependees add: t first].
	"Default to moving the selected objects to the pre-requisite package"
	pkg := self prerequisitePackage.
	pkg == Package uncommitted ifTrue: [pkg := nil].
	newPkg := PackagePrompter 
				showModalOn: pkg asValue
				caption: 'Re-package dependencies...'
				default: nil.
	newPkg isNil ifFalse: [self queryMoveObjects: dependees toPackage: newPkg]!

clear
	"Clear down the receiver"

	self packages: #()!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	treePresenter := self add: TreePresenter new name: 'tree'.
	tracesPresenter := self add: ListPresenter new name: 'traces'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	treePresenter
		when: #selectionChanged
			send: #onPackageSelected
			to: self;
		when: #actionPerformed
			send: #browsePackages
			to: self.
	tracesPresenter 
		when: #actionPerformed
		send: #browseTrace
		to: self.
	self packageManager 
		when: #prerequisitesReset:
		send: #onPrerequisitesReset:
		to: self!

dependencyModelWithRoots: anOrderedCollection 
	^(ExpandingTreeModel withRoots: anOrderedCollection)
		getChildrenBlock: [:each | self childrenFor: each];
		yourself!

dependentPackage
	^self subclassResponsibility!

initialize
	super initialize.
	packages := #()!

onPackageSelected
	"Private - One of the packages in the dependency tree has been selected. Populate the
	traces presenter with a list of all of the dependency relationships between the selected
	package and its parent in the tree."

	| pair |
	pair := self selectedPair.
	(pair notNil and: [pair value notNil]) 
		ifTrue: 
			[tracesPresenter 
				list: ((self prerequisiteTraceFor: self dependentPackage) at: self prerequisitePackage
						ifAbsent: [#()])]
		ifFalse: [tracesPresenter clear]!

onPrerequisitesReset
	"Private - The pre-requisites of a package have been reset, so the dependency tree must be
	rebuilt."

	"Implementation Note: In order to avoid having to immediately calculate the pre-requisites
	of all the pre-requisites of a package when the tree view asks if the root nodes have any
	children, we put the starting package in as the single root. This is also more consistent
	from a usability point of view, since when selected the pre-requisites list shows the
	dependencies on the parent node. It does mean we need to treat selection of the root as a
	special case however."

	| selected |
	selected := self selectedPair.
	traces := LookupTable new.
	treePresenter
		selectionOrNil: nil;
		model: (self dependencyModelWithRoots: (packages collect: [:each | each -> nil])).
	self selectedPair: selected!

onPrerequisitesReset: updatee
	"Private - The <Package>, updatee, has reset its prerequisites, so we need to rebuild the
	dependency tree to reflect any changes. We could do this more efficiently by locating the
	relevant nodes and collapsing only those, but at present we opt for the simple approach of
	collapsing the entire tree."

	self onPrerequisitesReset!

onViewClosed
	"Sent by the receiver's view when it has been closed.
	Disconnect from any events triggered by the devlopment system"

	super onViewClosed.
	self packageManager removeEventsTriggeredFor: self!

onViewOpened
	"Received when the receiver's view has been connected. "

	super onViewOpened.
	self packageManager youShouldBeProcessingEvents!

packageManager
	"Private - Answer the current PackageManager."

	^Package manager

!

packages
	"Answer the packages for which the receiver is showing dependency trees."

	^packages!

packages: aPackageCollection 
	"Set the packages which the constitute the roots of the dependency tree."

	packages := aPackageCollection.
	self onPrerequisitesReset!

prerequisitePackage
	^self subclassResponsibility!

prerequisiteTraceFor: aPackage
	"Private - Answer the pre-requisite trace for the specified package.
	We cache the info. for speed."

	^traces at: aPackage ifAbsentPut: [Cursor wait showWhile: [aPackage tracePrerequisites]]!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#toggleStatusIcons == selector 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: treePresenter view viewMode == #smallIcons.
			^true].
	#browseTrace == selector 
		ifTrue: 
			[aCommandQuery isEnabled: tracesPresenter selectionOrNil size = 1.
			^true].
	#browsePackages == selector 
		ifTrue: 
			[aCommandQuery isEnabled: treePresenter hasSelection.
			^true].
	#choosePackage == selector 
		ifTrue: 
			[aCommandQuery isEnabled: tracesPresenter hasSelection.
			^true].
	^super queryCommand: aCommandQuery!

queryMoveObjects: aCollection toPackage: aPackage 
	"Private - Move the array of packageable objects, anArray, to the specified package."

	| stream max sorted |
	stream := String writeStream.
	stream nextPutAll: 'Are you sure you would like to move '.
	aCollection size = 1 
		ifTrue: [stream nextPutAll: 'the following object']
		ifFalse: 
			[stream
				nextPutAll: 'these ';
				display: aCollection size;
				nextPutAll: ' objects'].
	stream
		nextPutAll: ' to the package ';
		print: aPackage name;
		nextPut: $?;
		cr.
	sorted := aCollection asSortedCollection: [:a :b | a displayString <= b displayString].
	max := 30.
	sorted 
		from: 1
		to: (aCollection size min: max)
		do: 
			[:each | 
			stream
				crtab;
				display: each].
	aCollection size > max 
		ifTrue: 
			[stream
				crtab;
				nextPutAll: '... and ';
				print: aCollection size - max;
				nextPutAll: ' other items ...'].
	stream
		cr;
		cr;
		nextPutAll: 'Press Yes to repackage the object(s), or No to abort the operation'.
	(MessageBox confirm: stream contents) ifFalse: [^self].
	aCollection do: [:each | each owningPackage: aPackage]!

selectedPair
	"Answer the currently selected depedendency node."

	^treePresenter selectionOrNil!

selectedPair: anAssociation 
	"Set the currently selected prerequisite package."

	anAssociation notNil 
		ifTrue: [treePresenter selection: anAssociation ifAbsent: []]
		ifFalse: [treePresenter resetSelection]!

toggleStatusIcons
	treePresenter view 
		viewMode: (treePresenter view viewMode == #noIcons ifTrue: [#smallIcons] ifFalse: [#noIcons])! !
!PackageDependencyPresenter categoriesFor: #browsePackages!commands!public! !
!PackageDependencyPresenter categoriesFor: #browseTrace!commands!public! !
!PackageDependencyPresenter categoriesFor: #buildChildNodes:for:!helpers!private! !
!PackageDependencyPresenter categoriesFor: #childrenFor:!helpers!private! !
!PackageDependencyPresenter categoriesFor: #choosePackage!helpers!private! !
!PackageDependencyPresenter categoriesFor: #clear!commands!public! !
!PackageDependencyPresenter categoriesFor: #createComponents!initializing!public! !
!PackageDependencyPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!PackageDependencyPresenter categoriesFor: #dependencyModelWithRoots:!helpers!private! !
!PackageDependencyPresenter categoriesFor: #dependentPackage!accessing!private! !
!PackageDependencyPresenter categoriesFor: #initialize!initializing!private! !
!PackageDependencyPresenter categoriesFor: #onPackageSelected!event handling!private! !
!PackageDependencyPresenter categoriesFor: #onPrerequisitesReset!event handling!private! !
!PackageDependencyPresenter categoriesFor: #onPrerequisitesReset:!event handling!private! !
!PackageDependencyPresenter categoriesFor: #onViewClosed!event handling!public! !
!PackageDependencyPresenter categoriesFor: #onViewOpened!event handling!public! !
!PackageDependencyPresenter categoriesFor: #packageManager!constants!private! !
!PackageDependencyPresenter categoriesFor: #packages!accessing!public! !
!PackageDependencyPresenter categoriesFor: #packages:!accessing!public! !
!PackageDependencyPresenter categoriesFor: #prerequisitePackage!accessing!private! !
!PackageDependencyPresenter categoriesFor: #prerequisiteTraceFor:!event handling!private! !
!PackageDependencyPresenter categoriesFor: #queryCommand:!commands!private! !
!PackageDependencyPresenter categoriesFor: #queryMoveObjects:toPackage:!helpers!private! !
!PackageDependencyPresenter categoriesFor: #selectedPair!accessing!public! !
!PackageDependencyPresenter categoriesFor: #selectedPair:!accessing!public! !
!PackageDependencyPresenter categoriesFor: #toggleStatusIcons!commands!public! !

!PackageDependencyPresenter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Package icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409482752 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 3 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140920393 1 608 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 496 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #browseTrace 8 'Browse' 1 1 nil nil nil 818 1 850 #choosePackage 8 'Package...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 608 nil 8 1883852064 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 328198 ##(Smalltalk.Point) 65 65 nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Owned' 507 #left ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a displayString < b displayString]' 8 #[30 105 17 158 18 158 128 106] #displayString 1136 7 513 nil 459270 ##(Smalltalk.Message) #first 8 #() nil 608 ##(Smalltalk.IconicListAbstract) 3 nil nil 1074 8 'Dependency' 337 #left ##(Smalltalk.BasicListAbstract) 1234 #<= 8 #() 1234 #last 1264 nil 608 nil 1 nil nil 1074 8 'Prerequisite Object' 339 #left ##(Smalltalk.BasicListAbstract) 1122 0 nil 1154 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a displayString < b displayString]' 8 #[30 105 17 158 18 158 128 106] #displayString 1392 7 513 nil 1122 0 nil 1154 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a at: 2]' 8 #[29 105 17 64 148 106] 1472 7 257 nil nil 608 ##(Smalltalk.IconicListAbstract) 1 nil nil #report 720 nil 131173 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 1010 1 171 1010 1189 285 608 1618 #contextMenu: 34 1 784 608 1618 #text: 34 1 8 'Owned' 608 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 85 0 0 0 82 2 0 0 227 0 0 0] 8 #() 1010 193 193 nil 35 524806 ##(Smalltalk.Fraction) 24567 10361 578 410 ##(Smalltalk.TreeView) 34 27 nil 416 34 2 8 1140916775 1 1904 590918 3 ##(Smalltalk.TreeModel) nil 752 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 720 496 nil 5 770 nil true 34 2 818 1 850 #browsePackages 8 'Browse' 1 1 nil nil nil 818 1 850 #toggleStatusIcons 8 'Show Status Icons' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1904 nil 8 1883652128 1122 0 nil 1154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name]' 8 #[31 105 17 158 159 106] #key #name 2208 7 257 nil 1122 0 nil 1154 7 1 1120 8 'doIt' 8 '[:each |  (each key hasCyclicPrerequisites or: [each key hasUncommittedPrerequisites]) not icon 
	imageIndex]' 8 #[35 105 226 0 159 119 58 112 226 0 160 161 162 163 106] #key #hasCyclicPrerequisites #hasUncommittedPrerequisites #not #icon #imageIndex 2288 7 257 nil 992 nil nil nil nil nil 170 176 720 nil #smallIcons 11 170 ##(Smalltalk.PluggableLookupTable) 720 1554 138 144 34 2 1618 #createAt:extent: 34 2 1010 1 1 1010 1189 161 1904 1618 #contextMenu: 34 1 2048 1904 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 82 2 0 0 80 0 0 0] 8 #() 1840 nil 27 1858 693 519 578 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2624 nil 496 nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2624 nil 1 #left nil nil nil 1010 1 1 1010 9 9 nil 2720 nil 1554 138 144 34 1 1618 #createAt:extent: 34 2 1010 1 161 1010 1189 11 2624 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 80 0 0 0 82 2 0 0 85 0 0 0] 8 #() 1840 nil 27 1 true 170 192 34 4 608 8 'traces' 1904 8 'tree' 590342 ##(Smalltalk.Rectangle) 1010 1 1 1010 1 1 1554 138 144 34 1 1618 #createAt:extent: 34 2 1010 7039 21 1010 1189 455 416 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 17 16 0 0 237 0 0 0] 34 3 1904 2624 608 1840 nil 27 )! !
!PackageDependencyPresenter class categoriesFor: #icon!constants!public! !
!PackageDependencyPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
