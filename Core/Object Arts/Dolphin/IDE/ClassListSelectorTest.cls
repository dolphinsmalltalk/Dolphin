"Filed out from Dolphin Smalltalk"!

ClassSelectorTest subclass: #ClassListSelectorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClassListSelectorTest guid: (GUID fromString: '{1e05f062-5ab2-4d18-b534-77cb8b7ca82e}')!

ClassListSelectorTest comment: ''!

!ClassListSelectorTest categoriesForClass!Unclassified! !

!ClassListSelectorTest methodsFor!

assertContains: anObject
	"Private - Asserts that the receiver contains anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection
	of the #selectableItems presenter"

	| sel |
	sel := presenter selectableItems selectionOrNil.
	presenter selectableItems selection: anObject.
	self assert: presenter selectableItems selection identicalTo: anObject.
	presenter selectableItems selectionOrNil: sel!

classToTest
	^ClassListSelector
!

denyContains: anObject 
	"Private - Asserts that the receiver does not contain anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection
	of the #selectableItems presenter"

	| sel |
	sel := presenter selectableItems selectionOrNil.
	self should: [presenter selectableItems selection: anObject] raise: NotFoundError.
	presenter selectableItems selectionOrNil: sel!

initializePresenter
	super initializePresenter.
	presenter browserEnvironment: BrowserEnvironment new!

listModel
	^presenter model!

listPresenter
	^presenter instVarNamed: 'classesListPresenter'!

removalOfSelectionLeaves: aClass 
	"Private - Answer the class that we would expect to be selected follwing the removal of aClass when it was originally
	selected in the receiver"

	^nil!

resetSelection
	super resetSelection.
	self assertContains: Object.
	self assertContains: Behavior.!

testAddRemoveListItems
	"Test adding and removing classes"

	| nilSubclasses |
	self resetSelection.

	"Add classes"
	self createClassesABC do: [:each | self assertContains: each].
	self createClassesDEF do: [:each | self assertContains: each].

	"Add some subclasses of nil"
	nilSubclasses := self createClassesGHI.
	nilSubclasses do: [:each | self assertContains: each].

	"Now remove some classes from the list - first a leaf"
	self listModel remove: dolphinTestC.
	self denyContains: dolphinTestC.
	self assertContains: dolphinTestB.
	self assertContains: dolphinTestA.

	"Now a branch - needs to remain behind"
	self listModel remove: dolphinTestA.
	self assertContains: dolphinTestA.
	self assert: (presenter selectableItems view includesItem: dolphinTestA).
	presenter selectableItems selection: dolphinTestA.
	self assertIsNil: self listPresenter selectionOrNil.
	self assertContains: dolphinTestB.
	self assert: (presenter selectableItems view includesItem: dolphinTestB).
	presenter selectableItems selection: dolphinTestB.
	self assert: self listPresenter selectionOrNil identicalTo: dolphinTestB.

	"Now remove a child, then a branch, then the last child of that branch. The branch should go too"
	self listModel remove: dolphinTestF.
	self denyContains: dolphinTestF.
	self listModel remove: dolphinTestD.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assert: (presenter selectableItems view includesItem: dolphinTestD).
	self listModel remove: dolphinTestE.
	"When we remove E, D should disappear too as it is no longer needed as an infrastructural node"
	self deny: (presenter selectableItems view includesItem: dolphinTestD).
	self denyContains: dolphinTestD.

	"Remove a popular root"
	self listModel remove: Object.
	self assertContains: Object.
	self assert: (self treeModel roots includes: Object).
	self should: [self listPresenter selection: Object] raise: Error.

	"Remove a lonely root"
	self listModel remove: dolphinTestG.
	self should: [self listPresenter selection: dolphinTestG] raise: Error.
	self denyContains: dolphinTestG.
	self deny: (self treeModel roots includes: dolphinTestG).
	self assert: ((self treeModel instVarNamed: 'roots') includes: dolphinTestG).
	"Remove from tree from root"
	self listPresenter selection: ProtoObject.
	ProtoObject withAllSubclassesDo: [:each | self listModel remove: each].
	"Hmmm.. this test fails in deployed release (#1695).
	self assert: self listPresenter selectionOrNil isNil."
	self should: [self listPresenter selection: ProtoObject] raise: Error.
	self denyContains: ProtoObject.
	self deny: (self treeModel roots includes: ProtoObject).
	"Should still be in roots collection, even if filtered out by accessor"
	self assert: ((self treeModel instVarNamed: 'roots') includes: ProtoObject).
	"Add them back"
	ProtoObject withAllSubclasses reverseDo: [:each | self listModel add: each].
	"Now remove tree from bottom up"
	ProtoObject withAllSubclasses reverseDo: 
			[:each |
			self listModel remove: each.
			self deny: (self treeModel filter value: each)].
	self denyContains: ProtoObject.
	self deny: (self treeModel roots includes: ProtoObject).
	"Agaion should still be in roots collection, even if filtered out by accessor"
	self assert: ((self treeModel instVarNamed: 'roots') includes: ProtoObject).

	"Finally remove the classes through the tree"
	self removeClassesGHI.
	nilSubclasses do: [:each | self denyContains: each]!

treeModel
	^presenter selectableItems treeModel! !

!ClassListSelectorTest categoriesForMethods!
assertContains:!helpers!private! !
classToTest!helpers!private! !
denyContains:!helpers!private! !
initializePresenter!public!Running! !
listModel!accessing!private! !
listPresenter!public!unit tests! !
removalOfSelectionLeaves:!helpers!private! !
resetSelection!helpers!private! !
testAddRemoveListItems!public!unit tests! !
treeModel!accessing!private! !
!

!ClassListSelectorTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.CardContainer)  98 16 0 0 98 2 8 1409286144 131073 416 0 0 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 20 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 1180998 4 ##(Smalltalk.CommandDescription)  8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 498 0 16 98 10 546 1 578 8 #browseClassPackage 8 'Package <1d>' 1 1 642 0 16 688 8 'Package.ico' 736 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 546 2097153 578 8 #browseClassReferences 8 '&Class References' 1 1 0 0 0 498 0 16 98 0 8 'Local Re&ferences To' 8 #browseVariablesMenu 134217729 0 0 0 0 0 898 4097 546 1 578 8 #browseChangedMethods 8 'Changed &Methods' 1 1 0 0 0 546 1 578 8 #browseMethodHistoryForClass 8 'Method &History' 1 1 0 0 0 898 4097 546 1 578 8 #browsePublishedEvents 8 'Published &events' 1 1 0 0 0 546 1 578 8 #browsePublishedAspects 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 8 #browseMenu 134217729 0 0 0 0 0 898 4097 546 1 578 8 #newClass 8 '&New...' 1 1 642 0 16 688 8 'NewClass.ico' 736 0 0 546 1 578 8 #deleteClassHierarchy 8 '&Delete' 1 1 642 0 16 688 8 'EditClear.ico' 736 0 0 498 0 16 98 19 546 1 578 8 #safeRemoveClass 8 '&Remove' 1 1 0 0 0 546 2097153 578 8 #renameClass 8 'Re&name...' 1 1 0 0 0 546 1 578 8 #copyClass 8 'Cl&one...' 1 1 0 0 0 898 4097 546 1 578 8 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 546 1 578 8 #addClassVariable 8 'Add &Class Variable...' 1 1 0 0 0 498 0 16 98 0 8 'Re&move Variable' 8 #removeVariables 134217729 0 0 0 0 0 498 0 16 98 0 8 'Ren&ame Variable' 8 #renameVariables 134217729 0 0 0 0 0 898 4097 498 0 16 98 0 8 'Push &Down' 8 #pushDownVariables 134217729 0 0 0 0 0 498 0 16 98 0 8 'Pull &Up' 8 #pullUpVariables 134217729 0 0 0 0 0 898 4097 498 0 16 98 0 8 'Cr&eate Accessors' 8 #createVariableAccessors 134217729 0 0 0 0 0 498 0 16 98 0 8 'A&bstract' 8 #abstractVariables 134217729 0 0 0 0 0 498 0 16 98 0 8 '&Protect/Concrete' 8 #protectVariables 134217729 0 0 0 0 0 898 4097 546 1 578 8 #convertToSibling 8 'Con&vert to Sibling...' 1 1 0 0 0 898 4097 546 1 578 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 8 #classRefactoringsMenu 134217729 642 0 16 688 8 'Refactoring.ico' 736 0 0 0 0 898 4097 546 1 578 8 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 0 0 0 546 1 578 8 #reformatAll 8 'Refor&mat All' 1 1 0 0 0 898 4097 546 1 578 8 #fileInClass 8 'File &In...' 1 1 0 0 0 546 1 578 8 #fileOutClass 8 'File &Out...' 1 1 0 0 0 898 4097 546 1 578 8 #classPackage 8 '&Package...' 1 1 642 0 16 688 8 'Package.ico' 736 0 0 546 1 578 8 #categorizeClass 8 '&Category...' 1 1 0 0 0 898 4097 546 1 578 8 #browseClassEditions 8 'Browse &Editions' 1 1 0 0 0 546 1 578 8 #compareClass 8 'Compare with...' 1 1 0 0 0 898 4097 498 0 16 98 4 546 1 578 8 #newView 8 '&New...' 1 1 0 0 0 898 4097 498 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 1 0 0 0 0 0 498 0 16 98 0 8 '&Show' 8 #viewsShowMenu 1 0 0 0 0 0 8 '&Views' 8 #viewsMenu 1 642 0 16 688 8 'View.ico' 736 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 416 655878 ##(Smalltalk.CardLayout)  202 208 98 2 721414 ##(Smalltalk.Association)  8 'Class List' 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140937293 1 3712 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 29 0 0 0 3712 0 8 4294902131 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Classes' 685 8 #left 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | x name]' 8 #[30 105 17 158 106] 8 #name 4128 7 257 0 4114 0 0 4146 2 1 4176 8 'doIt' 8 '[:x :y | x name <= y name]' 8 #[30 105 17 158 18 158 130 106] 4240 4256 7 513 0 0 0 3712 0 3 0 4114 0 0 4146 5 1 4176 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawClassList: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 8 #view 8 #presenter 8 #parentPresenter 8 #customDrawClassList: 4336 7 257 0 8 #report 3840 0 133217 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  9 45 4626 685 449 3712 4562 8 #text: 98 1 8 'Classes' 3712 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 90 1 0 0 246 0 0 0] 98 0 4626 193 193 0 27 3666 8 'Class Hierarchy' 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140850731 1 4848 590918 3 ##(Smalltalk.TreeModel)  0 3872 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 3840 3890 3920 0 29 0 0 0 4848 0 8 4294902319 4114 0 0 4146 2 1 4176 8 'doIt' 8 '[:x | x name]' 8 #[30 105 17 158 106] 4240 5040 7 257 0 3968 4000 0 0 4114 0 0 4146 5 1 4176 8 'doIt' 8 '[:ctx | ctx view parentView presenter  customDrawClassTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 4416 8 #parentView 4432 8 #customDrawClassTree: 5120 7 257 0 0 0 234 240 3840 17 8 #smallIcons 1 0 4498 202 208 98 1 4562 4592 98 2 4626 9 45 4626 685 449 4848 4738 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 90 1 0 0 246 0 0 0] 98 0 4800 0 27 3712 234 256 98 4 4848 8 'classes' 3712 8 'classesList' 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 416 98 2 8 1140916736 1 5488 3794 202 208 98 2 3696 4832 0 3872 0 0 1 0 0 0 5488 0 8 4294902323 4114 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] 8 #displayString 5632 7 257 0 4114 0 0 5650 2 3 3968 8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 5744 7 257 0 4000 0 0 0 0 0 8 #noIcons 0 0 0 0 0 4498 202 208 98 3 4562 4592 98 2 4626 1 1 4626 701 501 5488 4562 8 #basicSelectionsByIndex: 98 1 98 1 3 5488 4562 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 5488 4738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 4800 0 27 4498 202 208 98 2 4562 4592 98 2 4626 3839 21 4626 701 501 416 4562 8 #contextMenu: 98 1 512 416 4738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 3 3712 4848 5488 4800 0 27 )! !

!ClassListSelectorTest class categoriesForMethods!
resource_Default_view_D6!constants!public! !
!

