"Filed out from Dolphin Smalltalk 7"!

ClassSelector subclass: #ClassListSelector
	instanceVariableNames: 'classesListPresenter environment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassListSelector guid: (GUID fromString: '{337ede86-614b-4281-b0fe-16ffb1e67d72}')!
ClassListSelector comment: 'A ClassListSelector is used to display a list of classes. It implements the class list pane in the <PackagedClassSelector>, as used in the System Browser.

Instance Variables:
	classesListPresenter	<ListPresenter> displaying the list.
	environment			<RBEnvironment> defining the set of classes in the list.

'!
!ClassListSelector categoriesForClass!Development!MVP-Resources-IDE Tools! !
!ClassListSelector methodsFor!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	classesListPresenter hasFocus ifTrue: [^#browseClass].
	^super browseItCommand!

browserEnvironment
	"Answer the <BrowserEnvironment> from which the receiver is displaying a list of classes."

	^environment!

browserEnvironment: aBrowserEnvironment 
	"Set the <BrowserEnvironment> that defines the list of classes displayed in the receiver."

	environment := aBrowserEnvironment.
	self updateClasses!

classesListPresenter
	^classesListPresenter!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesListPresenter := self add: ListPresenter new beSorted name: 'classesList'.
	classesPresenter := self add: TreeListPresenter new name: 'classes'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	classesListPresenter
		when: #actionPerformed
			send: #browseClass
			to: self;
		when: #selectionChanged
			send: #onListSelectionChanged
			to: self;
		when: #labelOf:editedTo:accept:
			send: #onClass:renameTo:accept:
			to: self;
		when: #drag:
			send: #onDrag:
			to: self;
		when: #drop:
			send: #onDropOver:
			to: self;
		when: #dragEnter:
			send: #onDragOverList:
			to: self;
		when: #dragOver:
			send: #onDragOverList:
			to: self.
	"We need to monitor for class updates, as the TreeListPresenter may not update correctly for
	these if a class is moved under a subclass that is not in its current filter. In that case
	the class will disappear from the tree but remain in the list. We need to refresh the filter
	to include the class' new ancestor chain and add that ancestor chain to the tree as new
	infrastructural nodes so that the reparented class can be displayed in the tree again."
	"(self systemModel)
		when: #classUpdated:
			send: #onClassUpdated:
			to: self."

	"It might seem odd to monitor the repackaging event, but we might be displaying classes from a PackageEnvironment."
	#todo.	"Trigger add/remove/update events from RBEnvironments, then we can get rid of this bodge"
	Package manager 
		when: #classRepackaged:from:to:
		send: #onClassRepackaged:from:to:
		to: self!

customDrawClassList: anNMTVCUSTOMDRAW 
	"Private - Custom drawing to implement the emphasis in the class list tree. Owned classes
	are displayed in the normal colour and font. The classes of loose methods are highlighted in
	the loose method colour (dark magenta by default, but configurable in User Preferences)."

	(environment definesClass: anNMTVCUSTOMDRAW item) 
		ifFalse: [anNMTVCUSTOMDRAW forecolor: ClassBrowserAbstract looseMethodColor]!

customDrawClassTree: anNMTVCUSTOMDRAW 
	"Private - Custom drawing to implement the emphasis in the class hierarchy tree. 'Defined
	classes' (the meaning of which is dependent on the RBEnvironment whose content the receiver
	is displaying) are drawn in the normal colour and font. 'Included but not defined' classes
	are highlighted in the loose method colour (dark magenta by default, but configurable in
	User Preferences). Any classes present only to form the structure of the hierarchy (i.e.
	ancestor classes of any of the first two categories of classes) are greyed by fading the
	normal colour."

	| class |
	class := anNMTVCUSTOMDRAW item.
	(environment includesClass: class) 
		ifTrue: 
			[(environment definesClass: class) 
				ifFalse: [anNMTVCUSTOMDRAW forecolor: ClassBrowserAbstract looseMethodColor]]
		ifFalse: 
			[anNMTVCUSTOMDRAW 
				forecolor: (anNMTVCUSTOMDRAW forecolor fadedBy: ClassBrowserAbstract grayedMethodFadeFactor)]!

deleteItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	"packagesPresenter packagesPresenter hasFocus ifTrue: [^#uninstallPackage]."
	classesListPresenter hasFocus ifTrue: [^#deleteClassHierarchy].
	^super deleteItCommand!

initialize
	"Private - Initialize the receiver"

	super initialize.
	environment := BrowserEnvironment new forClasses: #()!

model: aListModel 
	"Connects the receiver to a new model."

	classesPresenter treeModel: Smalltalk developmentSystem classHierarchy.
	super model: aListModel.
	classesListPresenter model: aListModel!

onClassRepackaged: aClass from: anUndefinedObject to: aPackage 
	(environment includesClass: aClass) 
		ifTrue: 
			["Was it previously included? If not then add it."
			(self selectableItems model includes: aClass) 
				ifFalse: 
					[self selectableItems model add: aClass]]
		ifFalse: 
			["Remove if it was previously included"
			self selectableItems model remove: aClass ifAbsent: []]!

onDragOverList: aDragDropSession
	"Private - The user is dragging over the class hierarchy pane.
	Set the operation of the <DragDropSession>, session,
	that would occur if a drop took place now of the objects in that session."

	"We do not accept class drops over the class list, because the results are rather confusing"

	(aDragDropSession isFormatAvailable: #Class) 
		ifTrue: [aDragDropSession operation: nil]
		ifFalse: [self onDragOver: aDragDropSession]!

onListSelectionChanged
	"Private - Sent when the receiver's class list selection has changed."

	"Synchronize the selection change between class list and hierarchy views"

	self selectableItems selectionOrNil: classesListPresenter selectionOrNil!

onSelectionChanged
	"Private - Sent when the receiver's class list selection has changed."

	"Synchronize the selection change between class list and hierarchy views"

	classesListPresenter selection: self selectableItems selectionOrNil
		ifAbsent: [classesListPresenter noEventsDo: [classesListPresenter resetSelection]].
	super onSelectionChanged!

onViewClosed
	super onViewClosed.
	self systemModel removeEventsTriggeredFor: self.
	Package manager removeEventsTriggeredFor: self.!

renameClass
	"Private - Initiate in-place label edit for the selected class."

	classesListPresenter view isWindowVisible 
		ifTrue: [classesListPresenter view editSelectionLabel]
		ifFalse: [super renameClass]!

updateClasses
	"Private - Update the classes list for this package. Try and maintain the existing selection if possible."

	| classes originalSelection |
	classes := Set new.
	environment classesDo: [:each | classes add: each instanceClass].
	originalSelection := self selections.
	self noEventsDo: 
			[classesPresenter list: classes asSortedCollection.
			classesPresenter selections: originalSelection ifAbsent: []].
	self selections == originalSelection ifFalse: [self onSelectionChanged]! !
!ClassListSelector categoriesFor: #browseItCommand!helpers!private! !
!ClassListSelector categoriesFor: #browserEnvironment!public! !
!ClassListSelector categoriesFor: #browserEnvironment:!accessing!public! !
!ClassListSelector categoriesFor: #classesListPresenter!accessing!private! !
!ClassListSelector categoriesFor: #createComponents!initializing!public! !
!ClassListSelector categoriesFor: #createSchematicWiring!initializing!public! !
!ClassListSelector categoriesFor: #customDrawClassList:!helpers!private! !
!ClassListSelector categoriesFor: #customDrawClassTree:!helpers!private! !
!ClassListSelector categoriesFor: #deleteItCommand!helpers!private! !
!ClassListSelector categoriesFor: #initialize!initializing!private! !
!ClassListSelector categoriesFor: #model:!accessing!public! !
!ClassListSelector categoriesFor: #onClassRepackaged:from:to:!event handling!private! !
!ClassListSelector categoriesFor: #onDragOverList:!event handling!private! !
!ClassListSelector categoriesFor: #onListSelectionChanged!event handling!private!selection! !
!ClassListSelector categoriesFor: #onSelectionChanged!event handling!private!selection! !
!ClassListSelector categoriesFor: #onViewClosed!event handling!private! !
!ClassListSelector categoriesFor: #renameClass!commands!private!refactoring! !
!ClassListSelector categoriesFor: #updateClasses!private!updating! !

!ClassListSelector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.CardContainer)  98 16 0 0 98 2 8 1409286144 131073 416 0 0 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 20 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 1180998 4 ##(Smalltalk.CommandDescription)  8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 498 0 16 98 10 546 1 578 8 #browseClassPackage 8 'Package <1d>' 1 1 642 0 16 688 8 'Package.ico' 736 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 546 2097153 578 8 #browseClassReferences 8 '&Class References' 1 1 0 0 0 498 0 16 98 0 8 'Local Re&ferences To' 8 #browseVariablesMenu 134217729 0 0 0 0 0 898 4097 546 1 578 8 #browseChangedMethods 8 'Changed &Methods' 1 1 0 0 0 546 1 578 8 #browseMethodHistoryForClass 8 'Method &History' 1 1 0 0 0 898 4097 546 1 578 8 #browsePublishedEvents 8 'Published &events' 1 1 0 0 0 546 1 578 8 #browsePublishedAspects 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 8 #browseMenu 134217729 0 0 0 0 0 898 4097 546 1 578 8 #newClass 8 '&New...' 1 1 642 0 16 688 8 'NewClass.ico' 736 0 0 546 1 578 8 #deleteClassHierarchy 8 '&Delete' 1 1 642 0 16 688 8 'EditClear.ico' 736 0 0 498 0 16 98 19 546 1 578 8 #safeRemoveClass 8 '&Remove' 1 1 0 0 0 546 2097153 578 8 #renameClass 8 'Re&name...' 1 1 0 0 0 546 1 578 8 #copyClass 8 'Cl&one...' 1 1 0 0 0 898 4097 546 1 578 8 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 546 1 578 8 #addClassVariable 8 'Add &Class Variable...' 1 1 0 0 0 498 0 16 98 0 8 'Re&move Variable' 8 #removeVariables 134217729 0 0 0 0 0 498 0 16 98 0 8 'Ren&ame Variable' 8 #renameVariables 134217729 0 0 0 0 0 898 4097 498 0 16 98 0 8 'Push &Down' 8 #pushDownVariables 134217729 0 0 0 0 0 498 0 16 98 0 8 'Pull &Up' 8 #pullUpVariables 134217729 0 0 0 0 0 898 4097 498 0 16 98 0 8 'Cr&eate Accessors' 8 #createVariableAccessors 134217729 0 0 0 0 0 498 0 16 98 0 8 'A&bstract' 8 #abstractVariables 134217729 0 0 0 0 0 498 0 16 98 0 8 '&Protect/Concrete' 8 #protectVariables 134217729 0 0 0 0 0 898 4097 546 1 578 8 #convertToSibling 8 'Con&vert to Sibling...' 1 1 0 0 0 898 4097 546 1 578 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 8 #classRefactoringsMenu 134217729 642 0 16 688 8 'Refactoring.ico' 736 0 0 0 0 898 4097 546 1 578 8 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 0 0 0 546 1 578 8 #reformatAll 8 'Refor&mat All' 1 1 0 0 0 898 4097 546 1 578 8 #fileInClass 8 'File &In...' 1 1 0 0 0 546 1 578 8 #fileOutClass 8 'File &Out...' 1 1 0 0 0 898 4097 546 1 578 8 #classPackage 8 '&Package...' 1 1 642 0 16 688 8 'Package.ico' 736 0 0 546 1 578 8 #categorizeClass 8 '&Category...' 1 1 0 0 0 898 4097 546 1 578 8 #browseClassEditions 8 'Browse &Editions' 1 1 0 0 0 546 1 578 8 #compareClass 8 'Compare with...' 1 1 0 0 0 898 4097 498 0 16 98 4 546 1 578 8 #newView 8 '&New...' 1 1 0 0 0 898 4097 498 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 1 0 0 0 0 0 498 0 16 98 0 8 '&Show' 8 #viewsShowMenu 1 0 0 0 0 0 8 '&Views' 8 #viewsMenu 1 642 0 16 688 8 'View.ico' 736 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 416 655878 ##(Smalltalk.CardLayout)  202 208 98 2 721414 ##(Smalltalk.Association)  8 'Class List' 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140937293 1 3712 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 29 0 0 0 3712 0 8 4294902131 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Classes' 685 8 #left 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | x name]' 8 #[30 105 17 158 106] 8 #name 4128 7 257 0 4114 0 0 4146 2 1 4176 8 'doIt' 8 '[:x :y | x name <= y name]' 8 #[30 105 17 158 18 158 130 106] 4240 4256 7 513 0 0 0 3712 0 3 0 4114 0 0 4146 5 1 4176 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawClassList: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 8 #view 8 #presenter 8 #parentPresenter 8 #customDrawClassList: 4336 7 257 0 8 #report 3840 0 133217 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  9 45 4626 685 449 3712 4562 8 #text: 98 1 8 'Classes' 3712 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 90 1 0 0 246 0 0 0] 98 0 4626 193 193 0 27 3666 8 'Class Hierarchy' 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140850731 1 4848 590918 3 ##(Smalltalk.TreeModel)  0 3872 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 3840 3890 3920 0 29 0 0 0 4848 0 8 4294902319 4114 0 0 4146 2 1 4176 8 'doIt' 8 '[:x | x name]' 8 #[30 105 17 158 106] 4240 5040 7 257 0 3968 4000 0 0 4114 0 0 4146 5 1 4176 8 'doIt' 8 '[:ctx | ctx view parentView presenter  customDrawClassTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 4416 8 #parentView 4432 8 #customDrawClassTree: 5120 7 257 0 0 0 234 240 3840 17 8 #smallIcons 1 0 4498 202 208 98 1 4562 4592 98 2 4626 9 45 4626 685 449 4848 4738 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 90 1 0 0 246 0 0 0] 98 0 4800 0 27 3712 234 256 98 4 4848 8 'classes' 3712 8 'classesList' 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 416 98 2 8 1140916736 1 5488 3794 202 208 98 2 3696 4832 0 3872 0 0 1 0 0 0 5488 0 8 4294902323 4114 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] 8 #displayString 5632 7 257 0 4114 0 0 5650 2 3 3968 8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 5744 7 257 0 4000 0 0 0 0 0 8 #noIcons 0 0 0 0 0 4498 202 208 98 3 4562 4592 98 2 4626 1 1 4626 701 501 5488 4562 8 #basicSelectionsByIndex: 98 1 98 1 3 5488 4562 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 5488 4738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 4800 0 27 4498 202 208 98 2 4562 4592 98 2 4626 3839 21 4626 701 501 416 4562 8 #contextMenu: 98 1 512 416 4738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 3 3712 4848 5488 4800 0 27 )! !
!ClassListSelector class categoriesFor: #defaultModel!models!public! !
!ClassListSelector class categoriesFor: #resource_Default_view!public!resources-views! !

