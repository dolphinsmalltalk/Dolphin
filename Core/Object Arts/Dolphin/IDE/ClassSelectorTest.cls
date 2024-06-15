"Filed out from Dolphin Smalltalk"!

SelectableItemsTest subclass: #ClassSelectorTest
	instanceVariableNames: 'packageA packageB packageC dolphinTestA dolphinTestB dolphinTestC dolphinTestD dolphinTestE dolphinTestF dolphinTestG dolphinTestH dolphinTestI'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClassSelectorTest guid: (GUID fromString: '{165b5ae1-4f70-45e2-94d3-cc4f11c068dc}')!

ClassSelectorTest isAbstract: true!

ClassSelectorTest comment: ''!

!ClassSelectorTest categoriesForClass!Unclassified! !

!ClassSelectorTest methodsFor!

create: aClassSymbol subclassOf: aClass
	| newClass |
	newClass := aClass subclass: aClassSymbol instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''.
	self assert: (newClass notNil and: [newClass isKindOf: Class]).
	^newClass!

create: aClassSymbol subclassOf: aClass inPackage: aPackage
	| newClass |
	newClass := self create: aClassSymbol subclassOf: aClass.
	(Smalltalk at: aClassSymbol) owningPackage: aPackage.
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
	^Array 
		with: dolphinTestA
		with: dolphinTestB
		with: dolphinTestC!

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
	^Array with: dolphinTestD with: dolphinTestE with: dolphinTestF!

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
	^Array with: dolphinTestG with: dolphinTestH with: dolphinTestI!

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
		do: [:eachName | Smalltalk at: eachName ifPresent: [:eachClass | eachClass removeFromSystem]]!

resetSelection
	presenter resetSelection.
!

setUp
	super setUp.
	packageA := DolphinTestPackages current a.
	packageB := DolphinTestPackages current b.
	packageC := DolphinTestPackages current c!

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
	def := self createClassesDEF.	"Package B"
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
	(Array
		with: dolphinTestC
		with: dolphinTestB
		with: dolphinTestA) do: 
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
	self removeClassesABC!

viewClass
	^ContainerView! !

!ClassSelectorTest categoriesForMethods!
create:subclassOf:!helpers!private! !
create:subclassOf:inPackage:!helpers!private! !
createClassesABC!helpers!private! !
createClassesDEF!helpers!private! !
createClassesGHI!helpers!private! !
removalOfSelectionLeaves:!helpers!private! !
removeClassesABC!helpers!private! !
removeClassesDEF!helpers!private! !
removeClassesGHI!helpers!private! !
removeClassesNamed:!helpers!private! !
resetSelection!helpers!private! !
setUp!public!Running! !
tearDown!public!Running! !
testAddRemove!public!unit tests! !
testHierarchyMove!public!unit tests! !
testPackageMove!public!unit tests! !
testSelection!public!unit tests! !
viewClass!constants!private! !
!

!ClassSelectorTest class methodsFor!

resources
	^Array with: DolphinTestPackages! !

!ClassSelectorTest class categoriesForMethods!
resources!Accessing!public! !
!

