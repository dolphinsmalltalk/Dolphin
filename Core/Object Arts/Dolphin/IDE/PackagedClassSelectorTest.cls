"Filed out from Dolphin Smalltalk"!

ClassSelectorTest subclass: #PackagedClassSelectorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PackagedClassSelectorTest guid: (GUID fromString: '{85913f04-2759-4d36-864b-eac86b435a51}')!

PackagedClassSelectorTest comment: ''!

!PackagedClassSelectorTest categoriesForClass!Unclassified! !

!PackagedClassSelectorTest methodsFor!

assertContains: anObject
	"Private - Asserts that the receiver contains anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection
	of the #selectableItems presenter"

	| sel |
	sel := presenter selectableItems selectionOrNil.
	presenter selectableItems selection: anObject ifAbsent: [].
	self assert: presenter selectableItems selection identicalTo: anObject.
	presenter selectableItems selectionOrNil: sel!

classToTest
	^PackagedClassSelector!

denyContains: anObject 
	"Private - Asserts that the receiver does not contain anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection
	of the #selectableItems presenter"

	| sel |
	sel := presenter selectableItems selectionOrNil.
	self should: [presenter selectableItems selection: anObject] raise: NotFoundError.
	presenter selectableItems selectionOrNil: sel!

removalOfSelectionLeaves: aClass 
	"Private - Answer the class that we would expect to be selected follwing the removal of aClass when it was originally
	selected in the receiver"

	^nil
	"	siblings := aClass superclass subclasses.
	^siblings size = 1 
		ifTrue: [aClass superclass]
		ifFalse: [siblings after: aClass]"!

resetSelection
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageA) parent.
	super resetSelection!

testFilteredPackageAddRemove
	"Test adding/removing classes with a filter in place"

	| abc def |
	self resetSelection.
	"Filter on B"
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageB).

	"These classes should not be displayed"
	abc := self createClassesABC.	"Package A"
	abc do: [:each | self denyContains: each].

	"These classes should be displayed"
	def := self createClassesDEF.	"Package B"
	def do: [:each | self assertContains: each].

	"Switch filter to C"
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageC).
	abc do: [:each | self denyContains: each].
	def do: [:each | self assertContains: each].

	"Switch filter to A - should show all"
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageA).
	abc do: [:each | self assertContains: each].
	def do: [:each | self assertContains: each].

	"Tidy up"
	self removeClassesDEF.
	self removeClassesABC.
	abc do: [:each | self denyContains: each].
	def do: [:each | self denyContains: each]!

testFilteredPackagedHierarchyMove
	"Test moving classes with a filter in place."

	self resetSelection.
	(presenter instVarNamed: 'classesPresenter') view ensureVisible.
	presenter packages: (Array with: packageB).
	self assert: presenter selectableItems selectableItems treeModel asArray isEmpty.
	self createClassesABC.
	self assert: presenter selectableItems selectableItems treeModel asArray isEmpty.
	self createClassesDEF.
	self assertContains: Object.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.

	"Now move some classes under superclasses which are not in the selected package - the tree must update
	to include these."
	"	(self runKnownBug: '#1078' test: #testFilteredPackagedHierarchyMove) ifFalse: [^self]."

	"First move a leaf, but for extra interest make it the selection"
	presenter selection: dolphinTestF.
	self create: #DolphinTestF subclassOf: dolphinTestA.
	self assertContains: dolphinTestF.
	self assert: presenter selection identicalTo: dolphinTestF.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.

	"A should now be in the tree (greyed of course)"
	self assertContains: dolphinTestA.
	"B is a subclass of A, but still should not be in the tree"
	self denyContains: dolphinTestB.
	"Now move a tree of classes under B, bringing it in too"
	self create: #DolphinTestD subclassOf: dolphinTestB.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.
	self assertContains: dolphinTestA.
	self assertContains: dolphinTestB.

	"Now if we move D back, B should disappear"
	self create: #DolphinTestD subclassOf: Object.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.
	self assertContains: dolphinTestA.
	self denyContains: dolphinTestB.

	"And finally move F back under D"
	self create: #DolphinTestF subclassOf: dolphinTestD.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.
	self denyContains: dolphinTestA.
	self denyContains: dolphinTestB.

	"Tidy up"
	self removeClassesDEF.
	self removeClassesABC! !

!PackagedClassSelectorTest categoriesForMethods!
assertContains:!helpers!private! !
classToTest!helpers!private! !
denyContains:!helpers!private! !
removalOfSelectionLeaves:!helpers!private! !
resetSelection!helpers!private! !
testFilteredPackageAddRemove!public!unit tests! !
testFilteredPackagedHierarchyMove!public!unit tests! !
!

!PackagedClassSelectorTest class methodsFor!

resource_Choice_view_D6
	"Answer the literal data from which the 'Choice view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Choice_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 2 410 432 98 15 0 416 98 2 8 1140850688 131073 560 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 560 498 234 240 98 4 410 8 ##(Smalltalk.TreeView)  98 27 0 560 98 2 8 1140916259 1025 720 590918 3 ##(Smalltalk.TreeModel)  0 1310726 ##(Smalltalk.IdentitySearchPolicy)  525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 98 0 626 656 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 1 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #browseFolder 8 '&Browse Folder' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 720 0 8 4294903619 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 234 240 912 17 8 #smallIcons 1 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1346 407 263 720 1282 8 #contextMenu: 98 1 960 720 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 131 0 0 0] 98 0 1346 193 193 0 27 7 410 8 ##(Smalltalk.ListView)  98 30 0 560 98 2 8 1140920393 1025 1520 590662 2 ##(Smalltalk.ListModel)  202 208 912 0 848 626 656 0 21 946 0 16 98 3 994 2097153 1026 8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 994 1 1026 8 #browsePackages 8 '&Browse' 1 1 0 0 0 8 '&Package' 0 1 0 0 0 0 0 0 0 1520 0 8 4294903801 1120 1136 1168 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 1904 7 257 0 1346 65 65 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Packages' 359 8 #left 1120 1890 0 0 1922 2 1 1952 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 8 #name 2192 7 513 0 0 0 1520 1136 3 0 1890 0 0 1922 5 1 1952 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2016 2032 2048 2064 2288 7 257 0 2130 8 '' 41 2176 1890 0 0 1922 3 1 1952 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 2400 7 257 0 1890 0 0 1922 3 1 1952 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 2512 7 513 0 459270 ##(Smalltalk.Message)  8 #isChanged 98 0 0 1520 1890 0 0 1922 4 1 1952 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 8 #imageIndex 2688 7 257 0 1 0 0 8 #report 912 0 133221 0 0 1218 202 208 98 4 1282 1312 98 2 1346 1 273 1346 407 351 1520 1282 1408 98 1 1664 1520 1282 8 #text: 98 1 8 'Packages' 1520 1282 8 #columnOrder: 98 1 98 2 5 3 1520 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 136 0 0 0 203 0 0 0 55 1 0 0] 98 0 1504 0 27 9 16 234 256 98 4 720 8 'filter' 1520 8 'packages' 0 1218 202 208 98 1 1282 1312 98 2 1346 1 1 1346 407 623 560 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 55 1 0 0] 98 3 720 410 8 ##(Smalltalk.Splitter)  98 12 0 560 98 2 8 1140850688 1 3424 0 626 656 0 517 0 0 0 3424 1218 202 208 98 1 1282 1312 98 2 1346 1 263 1346 407 11 3424 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 131 0 0 0 203 0 0 0 136 0 0 0] 98 0 1504 0 27 1520 1504 0 27 3 32 234 256 98 4 560 8 'packages' 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 3728 0 0 0 29 0 0 0 3728 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ClassListSelector)  8 #resource_Default_view 0 1218 202 208 98 1 1282 1312 98 2 1346 417 1 1346 409 623 3728 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 0 0 0 0 156 1 0 0 55 1 0 0] 912 1504 0 27 8 'classes' 0 1218 202 208 98 1 1282 1312 98 2 1346 2799 21 1346 825 623 416 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 19 7 0 0 65 1 0 0] 98 3 560 410 3440 98 12 0 416 98 2 8 1140850688 1 4192 0 626 656 0 517 0 0 0 4192 1218 202 208 98 1 1282 1312 98 2 1346 407 1 1346 11 623 4192 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 203 0 0 0 0 0 0 0 208 0 0 0 55 1 0 0] 98 0 1504 0 27 3728 1504 0 27 )! !

!PackagedClassSelectorTest class categoriesForMethods!
resource_Choice_view_D6!constants!public! !
!

