"Filed out from Dolphin Smalltalk 7"!

UI.Tests.SelectableItemsTest subclass: #'Tools.Tests.ClassSelectorTest'
	instanceVariableNames: 'packageA packageB packageC dolphinTestA dolphinTestB dolphinTestC dolphinTestD dolphinTestE dolphinTestF dolphinTestG dolphinTestH dolphinTestI'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClassSelectorTest guid: (Core.GUID fromString: '{165b5ae1-4f70-45e2-94d3-cc4f11c068dc}')!
Tools.Tests.ClassSelectorTest isNonInstantiable: true!
Tools.Tests.ClassSelectorTest comment: ''!
!Tools.Tests.ClassSelectorTest categoriesForClass!Unclassified! !
!Tools.Tests.ClassSelectorTest methodsFor!

create: aClassSymbol subclassOf: aClass
	| newClass |
	newClass := aClass subclass: aClassSymbol instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''.
	self assert: (newClass notNil and: [newClass isKindOf: Class]).
	^newClass!

create: aClassSymbol subclassOf: aClass inPackage: aPackage
	| newClass |
	newClass := self create: aClassSymbol subclassOf: aClass.
	aClassSymbol asQualifiedReference value owningPackage: aPackage.
	self assert: newClass owningPackage identicalTo: aPackage.
	^newClass!

createClassesABC
	dolphinTestA := self
				create: 'DolphinTestA' asSymbol
				subclassOf: Object
				inPackage: packageA.
	dolphinTestB := self
				create: 'DolphinTestB' asSymbol
				subclassOf: dolphinTestA
				inPackage: packageA.
	dolphinTestC := self
				create: 'DolphinTestC' asSymbol
				subclassOf: dolphinTestB
				inPackage: packageA.
	^{dolphinTestA. dolphinTestB. dolphinTestC}!

createClassesDEF
	dolphinTestD := self
				create: #DolphinTestD
				subclassOf: Object
				inPackage: packageB.
	dolphinTestE := self
				create: #DolphinTestE
				subclassOf: dolphinTestD
				inPackage: packageB.
	dolphinTestF := self
				create: #DolphinTestF
				subclassOf: dolphinTestD
				inPackage: packageB.
	^{dolphinTestD. dolphinTestE. dolphinTestF}!

createClassesGHI
	dolphinTestG := self
				create: #DolphinTestG
				subclassOf: nil
				inPackage: packageA.
	dolphinTestH := self
				create: #DolphinTestH
				subclassOf: nil
				inPackage: packageB.
	dolphinTestI := self
				create: #DolphinTestI
				subclassOf: nil
				inPackage: packageC.
	^{dolphinTestG. dolphinTestH. dolphinTestI}!

removalOfSelectionLeaves: aClass
	"Private - Answer the class that we would expect to be selected follwing the removal of aClass when it was originally
	selected in the receiver"

	self subclassResponsibility!

removeClassesABC
	self removeClassesNamed: #('DolphinTestA' 'DolphinTestB' 'DolphinTestC')!

removeClassesDEF
	self removeClassesNamed: #(#DolphinTestF #DolphinTestE #DolphinTestD)!

removeClassesGHI
	self removeClassesNamed: #(#DolphinTestG #DolphinTestH #DolphinTestI).
!

removeClassesNamed: anArray
	anArray
		do: [:eachName | eachName asQualifiedReference ifDefined: [:eachClass | eachClass removeFromSystem]]!

resetSelection
	presenter resetSelection.
!

setUp
	super setUp.
	packageA := Core.Tests.DolphinTestPackages current a.
	packageB := Core.Tests.DolphinTestPackages current b.
	packageC := Core.Tests.DolphinTestPackages current c!

tearDown
	super tearDown.
	self
		removeClassesABC;
		removeClassesDEF;
		removeClassesGHI.
	packageA := packageB := packageC := nil!

testAddRemove
	"Test adding and removing classes"

	| nilSubclasses |
	self resetSelection.

	"Add classes"
	self createClassesABC.
	"If Object was not already present, it needs to be now"
	self assertContains: Object.
	self assertContains: dolphinTestB.
	self assertContains: dolphinTestA.
	self assertContains: dolphinTestC.

	"Add some subclasses of nil"
	nilSubclasses := self createClassesGHI.
	nilSubclasses do: [:each | self assertContains: each].

	"Remove classes"
	dolphinTestC removeFromSystem.
	self denyContains: dolphinTestC.
	dolphinTestC := nil.
	self assertContains: dolphinTestB.
	self assertContains: dolphinTestA.
	dolphinTestA removeFromSystem.
	self denyContains: dolphinTestA.
	self denyContains: dolphinTestB.
	dolphinTestA := nil.
	dolphinTestB removeFromSystem.
	dolphinTestB := nil.
	self removeClassesGHI.
	nilSubclasses do: [:each | self denyContains: each]!

testHierarchyMove
	"Test moving classes around the hierarchy"

	self resetSelection.
	self createClassesABC.
	self createClassesDEF.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.

	"Make some changes to the hierarchy which shouldn't alter the displayed classes"
	self create: #DolphinTestF subclassOf: dolphinTestA.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.
	self create: #DolphinTestD subclassOf: dolphinTestB.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.

	"Remove the moved classes"
	self removeClassesDEF.
	self denyContains: dolphinTestD.
	self denyContains: dolphinTestE.
	self denyContains: dolphinTestF.

	"Check that moving a selected class doesn't alter selection or trigger #selectionChanged events"
	self resetSelection.
	self
		shouldnt: [self createClassesDEF]
		trigger: #selectionChanged
		against: presenter.
	presenter selection: dolphinTestF.
	self
		shouldnt: [self create: #DolphinTestF subclassOf: dolphinTestA]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection equals: dolphinTestF.

	"Check that moving the parent of a selected class doesn't alter selection or trigger #selectionChanged events"
	presenter selection: dolphinTestE.
	self assert: presenter selection superclass identicalTo: dolphinTestD.
	self
		shouldnt: [self create: #DolphinTestD subclassOf: dolphinTestB]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection equals: dolphinTestE.

	"Tidy up"
	self removeClassesDEF.
	self removeClassesABC!

testPackageMove
	"Test moving classes around the package hierarchy"

	| abc def |
	self resetSelection.
	abc := self createClassesABC.	"Package A"
	def := self createClassesDEF.	"Package B"

	"Make some changes to the packaging which shouldn't alter the displayed classes"
	dolphinTestF owningPackage: packageA.
	def do: [:each | self assertContains: each].
	dolphinTestD owningPackage: packageA.
	def do: [:each | self assertContains: each].
	self assert: dolphinTestD owningPackage identicalTo: packageA.
	self assert: dolphinTestE owningPackage identicalTo: packageB.
	self assert: dolphinTestF owningPackage identicalTo: packageA.
	dolphinTestE owningPackage: packageC.
	def do: [:each | self assertContains: each].
	self assert: dolphinTestD owningPackage identicalTo: packageA.
	self assert: dolphinTestE owningPackage identicalTo: packageC.
	self assert: dolphinTestF owningPackage identicalTo: packageA.

	"Check that moving the package of the selected class doesn't alter selection or trigger #selectionChanged events."
	def do: [:each | each owningPackage: packageB].
	self resetSelection.
	presenter selection: dolphinTestF.
	self
		shouldnt: [dolphinTestF owningPackage: packageA]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection equals: dolphinTestF.

	"Check that moving the package of the parent of a selected class doesn't alter selection or trigger #selectionChanged events"
	presenter selection: dolphinTestE.
	self assert: presenter selection superclass identicalTo: dolphinTestD.
	self
		shouldnt: [dolphinTestD owningPackage: packageA]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection equals: dolphinTestE.

	"Tidy up"
	self removeClassesDEF.
	self removeClassesABC!

testSelection
	"Test selection"

	self resetSelection.
	self createClassesABC do: 
			[:each |
			self
				should: [presenter selection: each]
				trigger: #selectionChanged
				against: presenter.
			self assert: presenter selection identicalTo: each].

	"remove should not upset selection"
	presenter selection: dolphinTestA.
	self
		shouldnt: [dolphinTestC removeFromSystem]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection identicalTo: dolphinTestA.

	"add should not upset selection"
	self
		shouldnt: [self createClassesABC]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection identicalTo: dolphinTestA.
	self
		removeClassesABC;
		createClassesABC.

	"remove of selected object should trigger #selectionChanged and leave no selection"
	{dolphinTestC. dolphinTestB. dolphinTestA} do: 
			[:each |
			| selAfterRemoval |
			presenter selection: each.
			"Because the PCS is using a TreeListPresenter connected to the model
				 of a ListPresenter, the list sees the remove event first, and so the the PCS 
				then syncs the selection of the tree to nil before it sees the remove event,
				which means we get list style selection change behaviour on removal (i.e.
				selection is lost) rather than tree style (where selection is moved to the
				previous sibling or parent). "
			selAfterRemoval := self removalOfSelectionLeaves: each.
			self
				should: [each removeFromSystem]
				trigger: #selectionChanged
				against: presenter.
			self assert: presenter selectionOrNil identicalTo: selAfterRemoval].

	"No selection tests"
	self createClassesABC do: 
			[:each |
			presenter selection: each.
			self
				should: [presenter resetSelection]
				trigger: #selectionChanged
				against: presenter.
			self assertIsNil: presenter selectionOrNil.
			self should: [presenter selection] raise: Error].
	self removeClassesABC! !
!Tools.Tests.ClassSelectorTest categoriesFor: #create:subclassOf:!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #create:subclassOf:inPackage:!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #createClassesABC!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #createClassesDEF!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #createClassesGHI!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #removalOfSelectionLeaves:!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #removeClassesABC!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #removeClassesDEF!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #removeClassesGHI!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #removeClassesNamed:!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #resetSelection!helpers!private! !
!Tools.Tests.ClassSelectorTest categoriesFor: #setUp!public!Running! !
!Tools.Tests.ClassSelectorTest categoriesFor: #tearDown!public!Running! !
!Tools.Tests.ClassSelectorTest categoriesFor: #testAddRemove!public!unit tests! !
!Tools.Tests.ClassSelectorTest categoriesFor: #testHierarchyMove!public!unit tests! !
!Tools.Tests.ClassSelectorTest categoriesFor: #testPackageMove!public!unit tests! !
!Tools.Tests.ClassSelectorTest categoriesFor: #testSelection!public!unit tests! !

!Tools.Tests.ClassSelectorTest class methodsFor!

resources
	^{Core.Tests.DolphinTestPackages}! !
!Tools.Tests.ClassSelectorTest class categoriesFor: #resources!Accessing!public! !

