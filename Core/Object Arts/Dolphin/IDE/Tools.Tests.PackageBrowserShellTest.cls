"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.PackageBrowserShellTest'
	instanceVariableNames: 'packageA packageB packageC dolphinTestA dolphinTestB dolphinTestC shell cardsPresenter classesPresenter methodsPresenter variablesPresenter resourcesPresenter dependencyPresenters methodAA methodAB methodAC methodBA methodBB methodCA'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.PackageBrowserShellTest guid: (Core.GUID fromString: '{c635384e-76c1-4b7d-b532-6a2ec1916dbe}')!
Tools.Tests.PackageBrowserShellTest comment: ''!
!Tools.Tests.PackageBrowserShellTest categoriesForClass!Unclassified! !
!Tools.Tests.PackageBrowserShellTest methodsFor!

addRemoveRenameClasses
	"Remove classes"

	self assertCurrentCardInSync.
	self
		createClassesABC;
		createMethods.
	self assertCurrentCardInSync.
	self renameClass.
	self removeClass: dolphinTestC.
	self removeClass: dolphinTestB.
	self removeClass: dolphinTestA!

assertClassesInSync
	| classes |
	classes := OrderedCollection new.
	shell packages do: [:each | classes addAll: each classes].
	self assert: (classesPresenter model noDifference: classes)!

assertCurrentCardInSync
	| card |
	card := self currentCard.
	"PB should think the current card is up to date"
	self assert: (shell isCardUpToDate: card).
	card == #classes ifTrue: [^self assertClassesInSync].
	card == #methods ifTrue: [^self assertMethodsInSync].
	card == #variables ifTrue: [^self assertVariablesInSync].
	card == #dependents ifTrue: [^self assertDependencyCard: #dependents inSync: true].
	card == #prerequisites ifTrue: [^self assertDependencyCard: #prerequisites inSync: true].
	card == #resources ifTrue: [^self assertResourcesInSync].
	self assert: false description: 'Unknown card: ' , card!

assertDependencyCard: aSymbol inSync: aBoolean
	| dependencyPresenter tree |
	dependencyPresenter := dependencyPresenters at: aSymbol.
	tree := dependencyPresenter instVarNamed: 'treePresenter'.
	"If this fails, then the test is bogus and needs attention"
	self assert: tree isKindOf: TreePresenter.
	aBoolean | (shell isCardUpToDate: aSymbol)
		ifTrue: 
			[| packages |
			packages := shell packages.
			self assert: ((tree model roots collect: [:each | each key]) noDifference: packages).
			self assert: (tree model rootNodes allSatisfy: [:each | each getChildren isNil])]
		ifFalse: [self assert: tree model roots isEmpty]!

assertMethodsInSync
	(shell isCardUpToDate: #methods) 
		ifTrue: 
			[| methods |
			methods := OrderedCollection new.
			shell packages do: [:each | methods addAll: each methods].
			self assert: (methodsPresenter model noDifference: methods)]
		ifFalse: [self assert: methodsPresenter model isEmpty]!

assertResourcesInSync
	(shell isCardUpToDate: #resources)
		ifTrue: 
			[| resources |
			resources := OrderedCollection new.
			shell packages do: [:each | resources addAll: each allResourceIdentifiers].
			self assert: (resourcesPresenter model noDifference: resources)]
		ifFalse: [self assert: resourcesPresenter model isEmpty]!

assertVariablesInSync
	| globals |
	globals := OrderedCollection new.
	shell packages do: [:each | globals addAll: each variableNames].
	self assert: (variablesPresenter model noDifference: globals)!

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
				subclassOf: ProtoObject
				inPackage: packageA.
	dolphinTestB := self
				create: 'DolphinTestB' asSymbol
				subclassOf: dolphinTestA
				inPackage: packageB.
	dolphinTestC := self
				create: 'DolphinTestC' asSymbol
				subclassOf: dolphinTestB
				inPackage: packageC.
	^{dolphinTestA. dolphinTestB. dolphinTestC}!

createGlobals
	#(#TestGlobalA #TestGlobalB #TestGlobalC) do: [:each | Smalltalk at: each put: each last]!

createMethods
	| methodCC |
	methodAA := dolphinTestA 
				compile: 'methodAA ^1'
				categories: #()
				package: packageA.
	methodAB := dolphinTestA 
				compile: 'methodAB ^1'
				categories: #()
				package: packageB.
	self assert: methodAB isLoose.
	methodAC := dolphinTestA 
				compile: 'methodAC ^1'
				categories: #()
				package: packageC.
	self assert: methodAC isLoose.
	methodBA := dolphinTestB 
				compile: 'methodBA ^1'
				categories: #()
				package: packageA.
	self assert: methodBA isLoose.
	methodBB := dolphinTestB 
				compile: 'methodBB ^1'
				categories: #()
				package: packageB.
	self assert: methodBB isLoose not.
	methodCA := dolphinTestC 
				compile: 'methodCA ^1'
				categories: #()
				package: packageA.
	self assert: methodCA isLoose.
	methodCA := dolphinTestC 
				compile: 'methodCA ^1'
				categories: #()
				package: packageA.
	self assert: methodCA isLoose.
	methodCC := dolphinTestC 
				compile: 'methodCC ^1'
				categories: #()
				package: packageC.
	self assert: methodCC isLoose not!

currentCard
	^shell instVarAt: (shell class indexOfInstVar: 'currentCard')!

removeClass: aClass
	ClassBuilder removeClass: aClass ignoreInstances: true.
	self assertCurrentCardInSync!

removeClasses
	{dolphinTestA. dolphinTestB. dolphinTestC} do: [:each | each notNil ifTrue: [each removeFromSystem]].
	dolphinTestA := dolphinTestB := dolphinTestC := nil!

removeGlobals
	#(#TestGlobalA #TestGlobalB #TestGlobalC #TestGlobalD) 
		do: [:each | Smalltalk removeKey: each ifAbsent: []]!

renameClass
	| testA testA2 |
	testA := 'DolphinTestA' asQualifiedReference.
	testA2 := 'DolphinTestA2' asQualifiedReference.
	self assert: methodAB isLoose.
	self assert: methodAB methodClass identicalTo: testA value.
	self assert: methodAA isLoose not.
	self assert: methodAB methodClass identicalTo: testA value.
	self assert: methodCA isLoose.
	self assert: methodCA methodClass identicalTo: dolphinTestC.
	ClassBuilder renameClass: testA value to: testA2 asSymbol.
	self assert: methodAB isLoose.
	self assert: methodAB methodClass identicalTo: testA2 value.
	self assert: methodAA isLoose not.
	self assert: methodAB methodClass identicalTo: testA2 value.
	self assert: methodCA isLoose.
	self assert: methodCA methodClass identicalTo: dolphinTestC.
	self assertCurrentCardInSync.
	ClassBuilder renameClass: testA2 value to: testA asSymbol.
	self assert: methodAB isLoose.
	self assert: methodAB methodClass identicalTo: testA value.
	self assert: methodAA isLoose not.
	self assert: methodAB methodClass identicalTo: testA value.
	self assert: methodCA isLoose.
	self assert: methodCA methodClass identicalTo: dolphinTestC.
	self assertCurrentCardInSync!

repackageClasses
	"Remove classes"

	self assertCurrentCardInSync.
	self removeClasses.
	self assertCurrentCardInSync.
	self
		createClassesABC;
		createMethods.
	self assertCurrentCardInSync.
	"Move a displayed class (with loose and non-loose methods) to a non-displayed package"
	packageB addClass: dolphinTestC.
	self assertCurrentCardInSync.
	"Move a class with loose methods in A into A"
	packageA addClass: dolphinTestB.
	self assertCurrentCardInSync.
	"Move a class between displayed packages"
	packageC addClass: dolphinTestA.
	self assertCurrentCardInSync.
!

resourceManager
	^SessionManager current resourceManager!

setUp
	super setUp.
	self assertIsNil: Package manager defaultPackage.
	packageA := Core.Tests.DolphinTestPackages current a.
	packageB := Core.Tests.DolphinTestPackages current b.
	packageC := Core.Tests.DolphinTestPackages current c.
	{packageA. packageB. packageC} do: [:each | self assert: each variableNames isEmpty].
	shell := PackageBrowserShell create showShell.
	cardsPresenter := shell instVarAt: (shell class indexOfInstVar: 'cardsPresenter').
	classesPresenter := shell instVarAt: (shell class indexOfInstVar: 'classesPresenter').
	methodsPresenter := shell instVarAt: (shell class indexOfInstVar: 'methodsPresenter').
	variablesPresenter := shell instVarAt: (shell class indexOfInstVar: 'variablesPresenter').
	resourcesPresenter := shell instVarAt: (shell class indexOfInstVar: 'resourcesPresenter').
	dependencyPresenters := IdentityDictionary new.
	dependencyPresenters at: #prerequisites
		put: (shell instVarAt: (shell class indexOfInstVar: 'prerequisitesPresenter')).
	dependencyPresenters at: #dependents
		put: (shell instVarAt: (shell class indexOfInstVar: 'dependentsPresenter')).
	self createGlobals!

showClassesPane
	classesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #classes!

tearDown
	super tearDown.
	shell destroy.
	shell := cardsPresenter := classesPresenter := methodsPresenter := variablesPresenter := resourcesPresenter := dependencyPresenters := nil.
	self removeClasses.
	self removeGlobals.
	packageA := packageB := packageC := nil!

testAddRemoveClasses
	"Test adding and removing classes"

	shell packages: {packageA. packageC}.
	classesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #classes.
	self addRemoveRenameClasses.
	methodsPresenter ensureVisible.
	self assert: self currentCard identicalTo: #methods.
	self addRemoveRenameClasses.
	variablesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #variables.
	self addRemoveRenameClasses.
	resourcesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #resources.
	self addRemoveRenameClasses!

testAddRemoveMethods
	| methodA methodB methodC |
	self createClassesABC.
	shell packages: {packageA. packageC}.
	methodsPresenter ensureVisible.
	dolphinTestA
		compile: 'testNotLoose ^1'
		categories: #()
		package: packageA.
	self assert: methodsPresenter model isEmpty.
	"Add a method which is loose but not in one of the selected pacakges"
	methodB := dolphinTestA
				compile: 'testLooseInB ^1'
				categories: #()
				package: packageB.
	self assert: methodsPresenter model isEmpty.
	methodC := dolphinTestA
				compile: 'testLooseInC ^1'
				categories: #()
				package: packageC.
	self assert: methodsPresenter model list asArray equals: {methodC}.
	"Now switch away from methods pane and check that it is (or will be) updated"
	classesPresenter ensureVisible.
	methodA := dolphinTestB
				compile: 'testLooseInA ^1'
				categories: #()
				package: packageA.
	self assert: methodsPresenter model isEmpty.
	self assert: (shell isCardUpToDate: #methods) not.
	methodsPresenter ensureVisible.
	self assertMethodsInSync.
	"Remove a visible loose method"
	self assert: (methodsPresenter model includes: methodA).
	dolphinTestB removeSelector: #testLooseInA.
	self assert: (methodsPresenter model includes: methodA) not.
	"Remove an invisible loose method, should have no effect"
	dolphinTestA removeSelector: #testLooseInB.
	self assertMethodsInSync.
	"Remove a non-loose method, no effect either"
	dolphinTestA removeSelector: #testNotLoose.
	self assertMethodsInSync.
	"Remove a loose method with another pane displayed"
	classesPresenter ensureVisible.
	dolphinTestA removeSelector: #testLooseInC.
	self assert: methodsPresenter model isEmpty.
	self assert: (shell isCardUpToDate: #methods) not.
	methodsPresenter ensureVisible.
	self assertMethodsInSync!

testGlobals
	"Test adding, removing, renaming and repackaging globals"

	shell packages: {packageA. packageC}.
	variablesPresenter ensureVisible.

	"Add to displayed package"
	packageA addVariableNamed: #TestGlobalA.
	self assert: variablesPresenter model asArray equals: {(Smalltalk associationAt: #TestGlobalA) fullyQualifiedReference}.

	"Add to displayed package"
	packageC addVariableNamed: #TestGlobalC.
	self assert: (variablesPresenter model asArray
				noDifference: {(Smalltalk associationAt: #TestGlobalA) fullyQualifiedReference. (Smalltalk associationAt: #TestGlobalC) fullyQualifiedReference}).

	"Add to non-displayed package"
	packageB addVariableNamed: #TestGlobalB.
	self assert: (variablesPresenter model asArray
				noDifference: {(Smalltalk associationAt: #TestGlobalA) fullyQualifiedReference. (Smalltalk associationAt: #TestGlobalC) fullyQualifiedReference}).

	"Move to non-displayed package"
	packageB addVariableNamed: #TestGlobalA.
	self assert: (variablesPresenter model asArray noDifference: {(Smalltalk associationAt: #TestGlobalC) fullyQualifiedReference}).

	"Move from non-displayed package"
	packageA addVariableNamed: #TestGlobalB.
	self assert: (variablesPresenter model asArray
				noDifference: {(Smalltalk associationAt: #TestGlobalB) fullyQualifiedReference. (Smalltalk associationAt: #TestGlobalC) fullyQualifiedReference}).

	"Move between displayed packages"
	packageA addVariableNamed: #TestGlobalC.
	self assert: (variablesPresenter model asArray
				noDifference: {(Smalltalk associationAt: #TestGlobalB) fullyQualifiedReference. (Smalltalk associationAt: #TestGlobalC) fullyQualifiedReference}).

	"Remove from displayed package"
	Smalltalk removeKey: #TestGlobalB.
	self assert: (variablesPresenter model asArray noDifference: {(Smalltalk associationAt: #TestGlobalC) fullyQualifiedReference}).

	"Rename in displayed package"
	Smalltalk renameVariable: #TestGlobalC to: #TestGlobalD.
	self assert: (variablesPresenter model asArray noDifference: {(Smalltalk associationAt: #TestGlobalD) fullyQualifiedReference}).

	"Rename in non-displayed package"
	Smalltalk renameVariable: #TestGlobalA to: #TestGlobalC.
	self assert: (variablesPresenter model asArray noDifference: {(Smalltalk associationAt: #TestGlobalD) fullyQualifiedReference}).

	"Remove from non-displayed package"
	Smalltalk removeKey: #TestGlobalC.
	self assert: (variablesPresenter model asArray noDifference: {(Smalltalk associationAt: #TestGlobalD) fullyQualifiedReference}).

	"Move to unpackaged"
	packageA removeVariableNamed: #TestGlobalD.
	self assert: variablesPresenter model isEmpty!

testRepackageClasses
	shell packages: {packageA. packageC}.
	classesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #classes.
	self repackageClasses.
	methodsPresenter ensureVisible.
	self assert: self currentCard identicalTo: #methods.
	self repackageClasses.
	variablesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #variables.
	self repackageClasses.
	resourcesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #resources.
	self repackageClasses!

testRepackageMethods
	self createClassesABC.
	shell packages: {packageA. packageC}.
	methodsPresenter ensureVisible.
	self createMethods.
	self assertMethodsInSync.

	"Loose in A (displayed) to loose in C (displayed)"
	self assert: methodBA isLoose.
	packageC addMethod: methodBA.
	self assert: methodBA isLoose.
	self assertMethodsInSync.

	"Loose in C (displayed) to not loose, not displayed"
	self assert: methodBA isLoose.
	packageB addMethod: methodBA.
	self assert: methodBA isLoose not.
	self assertMethodsInSync.

	"Not loose in B (not displayed) to loose in C (displayed)"
	self assert: methodBA isLoose not.
	packageC addMethod: methodBA.
	self assert: methodBA isLoose.
	self assertMethodsInSync.

	"Loose in C (displayed) to loose in B (not displayed)"
	self assert: methodAC isLoose.
	packageB addMethod: methodAC.
	self assert: methodAC isLoose.
	self assertMethodsInSync.

	"Loose in C (displayed) to loose in B (not displayed)"
	self assert: methodAC isLoose.
	packageB addMethod: methodAC.
	self assert: methodAC isLoose.
	self assertMethodsInSync.

	"Loose in B (displayed) to not loose in A (displayed)"
	self assert: methodAC isLoose.
	packageA addMethod: methodAC.
	self assert: methodAC isLoose not.
	self assertMethodsInSync.

	"Not loose in A (displayed) to loose in B (not displayed)"
	self assert: methodAA isLoose not.
	packageB addMethod: methodAA.
	self assert: methodAA isLoose.
	self assertMethodsInSync.

	"Loose in B (not displayed) to loose in C (displayed)"
	self assert: methodAA isLoose.
	packageC addMethod: methodAA.
	self assert: methodAA isLoose.
	self assertMethodsInSync.

	"Loose in C (displayed) to not loose in A (displayed)"
	packageA addMethod: methodAA.
	self assert: methodAA isLoose not.
	self assertMethodsInSync.

	"Not loose in A (displayed) to loose in C (displayed)"
	packageC addMethod: methodAA.
	self assert: methodAA isLoose.
	self assertMethodsInSync.

	"Remove selection from A so no longer displayed"
	shell packages: {packageC}.
	self assertMethodsInSync.

	"Move AA back to B"
	packageB addMethod: methodAA.
	self assertMethodsInSync.

	"Loose in B (not displayed) to not loose in A (not displayed)"
	self assert: methodAA isLoose.
	packageA addMethod: methodAA.
	self assert: methodAA isLoose not.
	self assertMethodsInSync.

	"And back (not loose not displayed to loose not displayed)"
	packageB addMethod: methodAA.
	self assert: methodAA isLoose.
	self assertMethodsInSync.

	"Finally, loose in A (not displayed) to loose in B (not displayed)"
	self assert: methodCA isLoose.
	packageB addMethod: methodCA.
	self assert: methodCA isLoose.
	self assertMethodsInSync.

	"Now just verify that the other panes are not updating incorrectly"
	shell packages: {packageB}.
	self assertMethodsInSync.
	self showClassesPane.
	packageB addMethod: methodAC.
	self assertMethodsInSync.
	methodsPresenter ensureVisible.
	self assertMethodsInSync.
	resourcesPresenter ensureVisible.
	packageB addMethod: methodBA.
	self assertMethodsInSync.
	methodsPresenter ensureVisible.
	self assertMethodsInSync! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #addRemoveRenameClasses!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #assertClassesInSync!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #assertCurrentCardInSync!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #assertDependencyCard:inSync:!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #assertMethodsInSync!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #assertResourcesInSync!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #assertVariablesInSync!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #create:subclassOf:!helpers!private! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #create:subclassOf:inPackage:!helpers!private! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #createClassesABC!helpers!private! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #createGlobals!helpers!private! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #createMethods!helpers!private! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #currentCard!public!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #removeClass:!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #removeClasses!public!Running! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #removeGlobals!public!Running! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #renameClass!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #repackageClasses!private!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #resourceManager!constants!public! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #setUp!public!Running! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #showClassesPane!public!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #tearDown!public!Running! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #testAddRemoveClasses!public!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #testAddRemoveMethods!public!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #testGlobals!public!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #testRepackageClasses!public!unit tests! !
!Tools.Tests.PackageBrowserShellTest categoriesFor: #testRepackageMethods!public!unit tests! !

!Tools.Tests.PackageBrowserShellTest class methodsFor!

resources
	^{Core.Tests.DolphinTestPackages}! !
!Tools.Tests.PackageBrowserShellTest class categoriesFor: #resources!public! !

