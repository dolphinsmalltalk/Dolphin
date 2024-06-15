"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #PackageBrowserShellTest
	instanceVariableNames: 'packageA packageB packageC dolphinTestA dolphinTestB dolphinTestC cardsPresenter classesPresenter methodsPresenter variablesPresenter resourcesPresenter dependencyPresenters methodAA methodAB methodAC methodBA methodBB methodCA'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PackageBrowserShellTest guid: (GUID fromString: '{c635384e-76c1-4b7d-b532-6a2ec1916dbe}')!

PackageBrowserShellTest comment: ''!

!PackageBrowserShellTest categoriesForClass!Unclassified! !

!PackageBrowserShellTest methodsFor!

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
	presenter packages do: [:each | classes addAll: each classes].
	self assert: (classesPresenter model noDifference: classes)!

assertCurrentCardInSync
	| card |
	card := self currentCard.
	"PB should think the current card is up to date"
	self assert: (presenter isCardUpToDate: card).
	card == #classes ifTrue: [^self assertClassesInSync].
	card == #methods ifTrue: [^self assertMethodsInSync].
	card == #globals ifTrue: [^self assertGlobalsInSync].
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
	aBoolean | (presenter isCardUpToDate: aSymbol)
		ifTrue: 
			[| packages |
			packages := presenter packages.
			self assert: ((tree model roots collect: [:each | each key]) noDifference: packages).
			self assert: (tree model rootNodes allSatisfy: [:each | each getChildren isNil])]
		ifFalse: [self assert: tree model roots isEmpty]!

assertGlobalsInSync
	| globals |
	globals := OrderedCollection new.
	presenter packages do: [:each | globals addAll: each globalNames].
	self assert: (variablesPresenter model noDifference: globals)!

assertMethodsInSync
	(presenter isCardUpToDate: #methods) 
		ifTrue: 
			[| methods |
			methods := OrderedCollection new.
			presenter packages do: [:each | methods addAll: each methods].
			self assert: (methodsPresenter model noDifference: methods)]
		ifFalse: [self assert: methodsPresenter model isEmpty]!

assertResourcesInSync
	(presenter isCardUpToDate: #resources)
		ifTrue: 
			[| resources |
			resources := OrderedCollection new.
			presenter packages do: [:each | resources addAll: each allResourceIdentifiers].
			self assert: (resourcesPresenter model noDifference: resources)]
		ifFalse: [self assert: resourcesPresenter model isEmpty]!

assertVariablesInSync
	| globals |
	globals := OrderedCollection new.
	presenter packages do: [:each | globals addAll: each globalNames].
	self assert: (variablesPresenter model noDifference: globals)!

classToTest
	^PackageBrowserShell!

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
	^Array 
		with: dolphinTestA
		with: dolphinTestB
		with: dolphinTestC!

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
	^presenter instVarAt: (presenter class indexOfInstVar: 'currentCard')!

destroyPresenter
	cardsPresenter := classesPresenter := methodsPresenter := variablesPresenter := resourcesPresenter := dependencyPresenters := nil.
	super destroyPresenter!

initializePresenter
	presenter := self classToTest create showShell.
	cardsPresenter := presenter instVarAt: (presenter class indexOfInstVar: 'cardsPresenter').
	classesPresenter := presenter instVarAt: (presenter class indexOfInstVar: 'classesPresenter').
	methodsPresenter := presenter instVarAt: (presenter class indexOfInstVar: 'methodsPresenter').
	variablesPresenter := presenter instVarAt: (presenter class indexOfInstVar: 'globalsPresenter').
	resourcesPresenter := presenter instVarAt: (presenter class indexOfInstVar: 'resourcesPresenter').
	dependencyPresenters := IdentityDictionary new.
	dependencyPresenters at: #prerequisites
		put: (presenter instVarAt: (presenter class indexOfInstVar: 'prerequisitesPresenter')).
	dependencyPresenters at: #dependents
		put: (presenter instVarAt: (presenter class indexOfInstVar: 'dependentsPresenter'))!

removeClass: aClass
	ClassBuilder removeClass: aClass ignoreInstances: true.
	self assertCurrentCardInSync!

removeClasses
	(Array 
		with: dolphinTestA
		with: dolphinTestB
		with: dolphinTestC) do: [:each | each notNil ifTrue: [each removeFromSystem]].
	dolphinTestA := dolphinTestB := dolphinTestC := nil!

removeGlobals
	#(#TestGlobalA #TestGlobalB #TestGlobalC #TestGlobalD) 
		do: [:each | Smalltalk removeKey: each ifAbsent: []]!

renameClass
	| testA testA2 |
	testA := 'DolphinTestA' asSymbol.
	testA2 := 'DolphinTestA2' asSymbol.
	self assert: methodAB isLoose.
	self assert: methodAB methodClass identicalTo: (Smalltalk at: testA).
	self assert: methodAA isLoose not.
	self assert: methodAB methodClass identicalTo: (Smalltalk at: testA).
	self assert: methodCA isLoose.
	self assert: methodCA methodClass identicalTo: dolphinTestC.
	ClassBuilder renameClass: (Smalltalk at: testA) to: testA2.
	self assert: methodAB isLoose.
	self assert: methodAB methodClass identicalTo: (Smalltalk at: testA2).
	self assert: methodAA isLoose not.
	self assert: methodAB methodClass identicalTo: (Smalltalk at: testA2).
	self assert: methodCA isLoose.
	self assert: methodCA methodClass identicalTo: dolphinTestC.
	self assertCurrentCardInSync.
	ClassBuilder renameClass: (Smalltalk at: testA2) to: testA.
	self assert: methodAB isLoose.
	self assert: methodAB methodClass identicalTo: (Smalltalk at: testA).
	self assert: methodAA isLoose not.
	self assert: methodAB methodClass identicalTo: (Smalltalk at: testA).
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
	self assertIsNil: Package manager defaultPackage.
	packageA := DolphinTestPackages current a.
	packageB := DolphinTestPackages current b.
	packageC := DolphinTestPackages current c.
	{ packageA. packageB. packageC } do: [:each | self assert: each globalNames isEmpty].
	super setUp.
	self createGlobals!

showClassesPane
	classesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #classes!

tearDown
	super tearDown.
	self removeClasses.
	self removeGlobals.
	packageA := packageB := packageC := nil!

testAddRemoveClasses
	"Test adding and removing classes"

	presenter packages: {packageA. packageC}.
	classesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #classes.
	self addRemoveRenameClasses.
	methodsPresenter ensureVisible.
	self assert: self currentCard identicalTo: #methods.
	self addRemoveRenameClasses.
	variablesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #globals.
	self addRemoveRenameClasses.
	resourcesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #resources.
	self addRemoveRenameClasses!

testAddRemoveMethods
	| methodA methodB methodC |
	self createClassesABC.
	presenter packages: {packageA. packageC}.
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
	self assert: methodsPresenter model list asArray equals: (Array with: methodC).
	"Now switch away from methods pane and check that it is (or will be) updated"
	classesPresenter ensureVisible.
	methodA := dolphinTestB
				compile: 'testLooseInA ^1'
				categories: #()
				package: packageA.
	self assert: methodsPresenter model isEmpty.
	self assert: (presenter isCardUpToDate: #methods) not.
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
	self assert: (presenter isCardUpToDate: #methods) not.
	methodsPresenter ensureVisible.
	self assertMethodsInSync!

testGlobals
	"Test adding, removing, renaming and repackaging globals"

	| variablesModel |
	presenter packages: {packageA. packageC}.
	variablesPresenter ensureVisible.
	
	variablesModel := variablesPresenter model.

	"Add to displayed package"
	packageA addGlobalNamed: #TestGlobalA.

	self assert: variablesModel asArray equals: #(#TestGlobalA).

	"Add to displayed package"
	packageC addGlobalNamed: #TestGlobalC.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalA #TestGlobalC)).

	"Add to non-displayed package"
	packageB addGlobalNamed: #TestGlobalB.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalA #TestGlobalC)).

	"Move to non-displayed package"
	packageB addGlobalNamed: #TestGlobalA.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalC)).

	"Move from non-displayed package"
	packageA addGlobalNamed: #TestGlobalB.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalB #TestGlobalC)).

	"Move between displayed packages"
	packageA addGlobalNamed: #TestGlobalC.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalB #TestGlobalC)).

	"Remove from displayed package"
	Smalltalk removeKey: #TestGlobalB.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalC)).

	"Rename in displayed package"
	Smalltalk renameGlobal: #TestGlobalC to: #TestGlobalD.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalD)).

	"Rename in non-displayed package"
	Smalltalk renameGlobal: #TestGlobalA to: #TestGlobalC.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalD)).

	"Remove from non-displayed package"
	Smalltalk removeKey: #TestGlobalC.
	self assert: (variablesModel asArray noDifference: #(#TestGlobalD)).

	"Move to unpackaged"
	packageA removeGlobalNamed: #TestGlobalD.
	self assert: variablesModel isEmpty!

testRepackageClasses
	presenter packages: {packageA. packageC}.
	classesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #classes.
	self repackageClasses.
	methodsPresenter ensureVisible.
	self assert: self currentCard identicalTo: #methods.
	self repackageClasses.
	variablesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #globals.
	self repackageClasses.
	resourcesPresenter ensureVisible.
	self assert: self currentCard identicalTo: #resources.
	self repackageClasses!

testRepackageMethods
	self createClassesABC.
	presenter packages: {packageA. packageC}.
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
	presenter packages: {packageC}.
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
	presenter packages: {packageB}.
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
	self assertMethodsInSync!

viewClass
	^ShellView! !

!PackageBrowserShellTest categoriesForMethods!
addRemoveRenameClasses!private!unit tests! !
assertClassesInSync!private!unit tests! !
assertCurrentCardInSync!private!unit tests! !
assertDependencyCard:inSync:!private!unit tests! !
assertGlobalsInSync!private!unit tests! !
assertMethodsInSync!private!unit tests! !
assertResourcesInSync!private!unit tests! !
assertVariablesInSync!private!unit tests! !
classToTest!helpers!private! !
create:subclassOf:!helpers!private! !
create:subclassOf:inPackage:!helpers!private! !
createClassesABC!helpers!private! !
createGlobals!helpers!private! !
createMethods!helpers!private! !
currentCard!public!unit tests! !
destroyPresenter!public!Running! !
initializePresenter!private!Running! !
removeClass:!private!unit tests! !
removeClasses!public!Running! !
removeGlobals!public!Running! !
renameClass!private!unit tests! !
repackageClasses!private!unit tests! !
resourceManager!constants!public! !
setUp!public!Running! !
showClassesPane!public!unit tests! !
tearDown!public!Running! !
testAddRemoveClasses!public!unit tests! !
testAddRemoveMethods!public!unit tests! !
testGlobals!public!unit tests! !
testRepackageClasses!public!unit tests! !
testRepackageMethods!public!unit tests! !
viewClass!constants!private! !
!

!PackageBrowserShellTest class methodsFor!

resource_Default_view_D6

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 131073 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 167 4 112 212 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point)  193 193 0 560 482 656 8 4294906605 234 256 98 8 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 848 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 1 754 63 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'imageTools' 410 576 98 25 0 560 98 2 8 1140853612 131137 1264 0 482 656 0 519 0 0 0 1264 482 656 8 4294906605 234 256 1216 234 256 98 2 18867 853766 ##(Smalltalk.ToolbarButton)  18867 0 1264 17 1180998 4 ##(Smalltalk.CommandDescription)  8 #viewModeSelect 8 'Views' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ViewBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 754 129 33 3 98 1 1440 234 240 98 2 1536 1 0 1 0 754 33 33 754 45 45 0 0 1010 202 208 98 2 1074 1104 98 2 754 1253 1 754 77 51 1264 1074 8 #updateSize 1216 1264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 114 2 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 98 0 1232 0 27 8 'viewTools' 410 576 98 25 0 560 98 2 8 1140853580 131073 1952 0 482 656 0 519 0 0 0 1952 482 656 8 4294906605 234 256 1216 234 256 98 8 18859 1115910 ##(Smalltalk.ToolbarIconButton)  18859 0 1952 1 1458 8 #newPackage 8 'New Package' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1568 8 'DocumentShell.ico' 0 1522 0 16 0 0 0 0 3 754 33 33 1 18861 2114 18861 0 1952 1 1458 8 #openPackage 8 'Install Package' 1 1 2194 0 16 1568 8 'FileOpen.ico' 1616 1522 0 16 0 0 0 0 3 754 33 33 1 18863 2114 18863 0 1952 1 1458 8 #savePackageChanges 8 'Save Package Changes' 1 1 2194 0 16 1568 8 'FileSave.ico' 1616 1522 0 16 0 0 0 0 3 754 33 33 1 18865 2114 18865 0 1952 1 1458 8 #browsePackageSources 8 'Open Source Browser' 1 1 2194 0 16 1568 8 'SourceManager.ico' 1616 1522 0 16 0 0 0 0 3 754 33 33 1 98 5 2128 2272 2400 2528 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 1952 3 0 1 234 240 98 8 2496 5 2240 1 2368 3 2624 7 0 1 0 754 33 33 754 45 45 0 0 1010 202 208 98 2 1074 1104 98 2 754 1053 1 754 201 51 1952 1074 1872 1216 1952 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 114 2 0 0 25 0 0 0] 98 0 1232 0 27 8 'fileTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 2960 0 930 31 0 7 0 0 0 2960 962 576 8 #resource_Smalltalk_tools 0 1010 202 208 98 1 1074 1104 98 2 754 63 1 754 991 51 2960 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1216 1232 0 27 8 'smalltalkTools' 234 256 1216 98 0 234 240 1216 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 1010 202 208 98 2 1074 1104 98 2 754 1 1 754 1389 51 560 1074 1872 1216 560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 25 0 0 0] 98 4 848 2960 1952 1264 1232 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 3520 0 482 656 0 7 0 674 0 16 706 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 3520 0 8 4294905313 234 256 98 4 853766 ##(Smalltalk.StatusBarItem)  1 -1 3520 0 459270 ##(Smalltalk.Message)  8 #displayString 98 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 3728 8 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] 8 #iconImageIndex 3840 7 257 0 0 8 'version' 3730 1 -1 3520 0 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  8 'errors' 98 1 3952 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 3520 0 0 1010 202 208 98 1 1074 1104 98 2 754 1 889 754 1389 41 3520 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 188 1 0 0 182 2 0 0 208 1 0 0] 98 0 1232 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 4256 0 0 0 7 0 0 0 4256 1180166 ##(Smalltalk.ProportionalLayout)  234 240 1216 16 234 256 1216 0 1010 202 208 98 1 1074 1104 98 2 754 1 51 754 1389 839 4256 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 182 2 0 0 188 1 0 0] 98 1 410 4272 98 15 0 4256 98 2 8 1140850688 131073 4560 0 0 0 7 0 0 0 4560 4338 234 240 98 2 410 4272 98 15 0 4560 98 2 8 1140850688 131073 4672 0 0 0 7 0 0 0 4672 4338 202 8 ##(Smalltalk.Dictionary)  98 1 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.CardContainer)  98 16 0 4672 98 2 8 1140850688 131073 4832 0 482 8 4278190080 0 7 0 0 0 4832 655878 ##(Smalltalk.CardLayout)  202 208 98 8 4802 8 'Scripts' 410 4272 98 15 0 4832 98 2 8 1140850688 131073 5040 0 482 4928 0 5 0 0 0 5040 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.ScintillaView)  98 46 0 5040 98 2 8 1176572228 1025 5184 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 482 4928 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 16 984134 2 ##(Smalltalk.CommandMenuItem)  1 1458 8 #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 5346 0 16 98 9 5394 1 1458 8 #undo 8 '&Undo' 1 1 0 0 0 5474 4097 5394 1 1458 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 5394 1 1458 8 #copySelection 8 '&Copy' 1 1 0 0 0 5394 1 1458 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 5394 1 1458 8 #clearSelection 8 'De&lete' 1 1 0 0 0 5394 1 1458 8 #reformatSource 8 'Re&format' 1 1 0 0 0 5474 4097 5394 1 1458 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 5394 1 1458 8 #clear 8 'Clea&r' 1 1 0 0 0 5474 4097 5394 1 1458 8 #browseIt 8 'Bro&wse It' 1 1 2194 0 16 1568 8 'ClassBrowserShell.ico' 1616 0 0 5394 1 1458 8 #displayIt 8 '&Display It' 1 1 0 0 0 5394 1 1458 8 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 5394 1 1458 8 #inspectIt 8 '&Inspect It' 1 1 2194 0 16 1568 8 'BasicInspector.ico' 1616 0 0 5394 1 1458 8 #debugIt 8 'Deb&ug It' 1 1 2194 0 16 1568 8 'Debugger.ico' 1616 0 0 5474 4097 5394 1 1458 8 #chooseEvaluationPools 8 '&Pools...' 1 1 0 0 0 5394 1 1458 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 5394 1 1458 8 #cloneNew 8 'Clo&ne' 1 1 0 0 0 5474 4097 5346 0 16 98 3 5394 2097153 1458 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 5394 1 1458 8 #browseReferences 8 '&References...' 1 1 0 0 0 5394 1 1458 8 #browseMessages 8 '&Messages...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 5184 0 8 4294905987 852486 ##(Smalltalk.NullConverter)  0 0 9 0 234 256 98 2 8 #normal 1182726 ##(Smalltalk.ScintillaTextStyle)  1 0 0 1 0 0 0 0 7088 0 0 0 98 40 7120 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler)  1 0 0 32 202 208 1216 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 786694 ##(Smalltalk.IndexedColor)  33554433 7282 33554471 5184 8 #circle 202 208 1216 0 63 9215 0 0 0 0 7282 33554447 0 0 0 0 0 234 256 98 6 8 #literalBytes 8 '[]' 8 #specialCharacter 8 '()[]<>' 8 #literalArray 8 '()' 8 '' 3 234 256 98 2 8 #container 7056 0 0 0 0 3 0 234 256 98 4 8 #Warning 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  17 5184 33423361 3 32 7600 0 8 #Error 7618 19 5184 33554459 3 32 7648 0 1010 202 208 98 10 1074 1104 98 2 754 21 21 754 787 703 5184 1074 8 #contextMenu: 98 1 5360 5184 1074 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 5184 1074 8 #isTextModified: 98 1 32 5184 1074 8 #modificationEventMask: 98 1 9215 5184 1074 8 #wordWrap: 98 1 16 5184 1074 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 5184 1 3 32 1 8130 3 5184 1 1 32 67108863 8130 5 5184 1 1 32 1 5184 1074 8 #canHScroll: 98 1 32 5184 1074 8 #indentationGuides: 98 1 0 5184 1074 8 #tabIndents: 98 1 16 5184 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 147 1 0 0 105 1 0 0] 98 0 1232 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 21 8418 8 #fixedParentRight -91 8418 8 #fixedParentTop 21 8418 8 #fixedParentBottom -19 410 8 ##(Smalltalk.TabView)  98 23 0 5040 98 2 8 1140916866 1 8560 590662 2 ##(Smalltalk.ListModel)  202 208 1216 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 4928 0 5 0 0 0 8560 0 8 4294905447 3826 0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] 8 #key 8752 7 257 0 3826 0 0 8770 3 1 8800 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] 8 #icon 8 #imageIndex 8880 7 257 0 4016 0 0 0 0 0 8 #smallIcons 1010 202 208 98 2 1074 1104 98 2 754 1 1 754 899 743 8560 1074 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 8560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 193 1 0 0 115 1 0 0] 98 0 1232 0 27 8386 8432 1 8464 1 8496 1 8528 1 234 256 98 4 5184 8 'scriptText' 8560 8 'scriptNames' 0 1010 202 208 98 1 1074 1104 98 2 754 9 89 754 899 743 5040 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 98 2 5184 8560 1232 0 27 4802 8 'Prerequisites' 410 864 98 14 0 4832 98 2 8 1140850688 131073 9488 0 0 0 5 0 0 0 9488 962 8 ##(Smalltalk.PackageDependencyPresenter)  8 #resource_Default_view 0 1010 202 208 98 1 1074 1104 98 2 754 9 89 754 899 743 9488 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 1216 1232 0 27 4802 8 'Comment' 410 5200 98 46 0 4832 98 2 8 1176572228 1 9776 5266 0 32 5312 0 196934 1 ##(Smalltalk.RGB)  30932991 0 7 5346 0 16 98 12 5394 1 1458 5440 8 '&Accept' 1 1 0 0 0 5474 4097 5346 0 16 98 8 5394 1 1458 5568 8 '&Undo' 1 1 0 0 0 5474 4097 5394 1 1458 5648 8 'Cu&t' 1 1 0 0 0 5394 1 1458 5712 8 '&Copy' 1 1 0 0 0 5394 1 1458 5776 8 '&Paste' 1 1 0 0 0 5394 1 1458 5840 8 'De&lete' 1 1 0 0 0 5474 4097 5394 1 1458 5984 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 5394 1 1458 6064 8 'Clea&r' 1 1 0 0 0 5474 4097 5394 1 1458 6144 8 'Bro&wse It' 1 1 6176 0 0 5394 1 1458 6240 8 '&Display It' 1 1 0 0 0 5394 1 1458 6304 8 'E&valuate It' 1 1 0 0 0 5394 1 1458 6368 8 '&Inspect It' 1 1 6400 0 0 5394 1 1458 6464 6480 1 1 6496 0 0 5474 4097 5346 0 16 98 2 5394 2097153 1458 6816 8 'Defi&nitions...' 1 1 0 0 0 5394 1 1458 6880 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 9776 9858 8454145 8 4294905987 7026 0 0 9 0 234 256 98 2 7088 7106 1 0 0 1 0 0 0 0 7088 0 0 0 98 40 10896 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler)  7088 234 256 98 2 7232 7250 1 1 7296 7312 9776 7328 202 208 1216 0 63 9215 0 0 0 0 7360 0 0 0 0 0 0 7504 3 234 256 98 2 7552 10864 0 0 0 0 1 0 234 256 98 4 7600 7618 19 9776 33423361 3 32 7600 0 7648 7618 17 9776 33554459 3 32 7648 0 1010 202 208 98 9 1074 1104 98 2 754 9 89 754 899 743 9776 1074 7808 98 1 9888 9776 1074 7856 98 1 7890 3 1 3 9776 1074 7936 98 1 32 9776 1074 7984 98 1 9215 9776 1074 8032 98 1 16 9776 1074 8080 98 1 98 3 8130 1 9776 1 3 32 1 8130 3 9776 1 1 32 67108863 8130 5 9776 1 1 32 1 9776 1074 8256 98 1 0 9776 1074 8304 98 1 16 9776 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 98 0 1232 0 27 4802 8 'Dependents' 410 864 98 14 0 4832 98 2 8 1140850688 131073 11648 0 0 0 5 0 0 0 11648 962 9568 9584 0 1010 202 208 98 1 1074 1104 98 2 754 9 89 754 899 743 11648 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 1216 1232 0 27 4802 8 'Loose Methods' 410 8 ##(Smalltalk.ListView)  98 30 0 4832 98 2 8 1140920393 1 11904 8642 202 208 1216 0 8704 482 4928 0 29 5346 0 16 98 10 5394 2097153 1458 8 #browseMethods 8 'Browse <1d>' 1 1 0 0 0 5394 1 1458 8 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 0 0 0 5394 1 1458 8 #browseMessageReferences 8 'All Re&ferences' 1 1 0 0 0 5394 1 1458 8 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 0 0 0 5394 1 1458 8 #browseLocalMessageReferences 8 '&Local References' 1 1 0 0 0 5474 4097 5394 1 1458 8 #removeLooseMethods 8 '&Remove from Package' 1 1 0 0 0 5346 0 16 98 7 5394 1 1458 8 #renameMethod 8 'Re&name' 1 1 0 0 0 5394 1 1458 8 #renameMethodReferences 8 'Rename Re&ferences' 1 1 0 0 0 5474 4097 5394 1 1458 8 #safeRemoveMethods 8 '&Remove' 1 1 0 0 0 5474 4097 5394 1 1458 8 #addParameterToMethod 8 'Add &Parameter...' 1 1 0 0 0 5346 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 0 0 0 0 0 5474 4097 5346 0 16 98 1 5394 1 1458 8 #browseLooseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 11904 0 8 4294905441 3968 3984 4016 0 0 0 754 65 65 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Selector' 401 8 #left 3762 8 #selector 98 0 3826 0 0 8770 2 1 8800 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] 13168 13200 7 513 0 0 0 11904 3984 1 0 3826 0 0 8770 4 1 8800 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4802 8 #ClassBrowserAbstract 8 ##(Smalltalk.ClassBrowserAbstract)  8 #looseMethodColor 8 #forecolor: 13280 7 257 0 13090 8 'Class' 389 13136 3968 8 ##(Smalltalk.SortedCollection)  3762 8 #methodClass 98 0 0 11904 3984 1 0 3826 0 0 8770 4 1 8800 8 'doIt' 8 '[:ctx | ctx forecolor: Color black]' 8 #[32 105 17 45 159 178 106] 4802 8 #Color 8 ##(Smalltalk.Color)  8 #black 13424 13536 7 257 0 13090 8 'Package' 111 13136 3968 3826 0 0 8770 2 1 8800 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 8 #name 13712 7 513 0 3762 8 #owningPackage 98 0 0 11904 0 3 0 0 8 #report 1216 0 131173 0 0 1010 202 208 98 3 1074 1104 98 2 754 9 89 754 899 743 11904 1074 7808 98 1 12032 11904 1074 8 #text: 98 1 8 'Selector' 11904 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 98 0 1232 0 27 4802 8 'Globals' 410 11920 98 30 0 4832 98 2 8 1140920393 1 14160 8642 202 208 1216 0 8704 482 4928 0 29 5346 0 16 98 6 5394 1 1458 8 #addGlobal 8 '&Add Uncommitted...' 1 1 0 0 0 5394 1 1458 8 #removeGlobals 8 '&Remove from Package' 1 1 0 0 0 5474 4097 5394 2097153 1458 8 #inspectGlobals 8 '&Inspect' 1 1 0 0 0 5394 1 1458 8 #browseGlobalReferences 8 'All Re&ferences' 1 1 0 0 0 5394 1 1458 8 #browseLocalGlobalReferences 8 '&Local References' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 14160 0 8 4294905441 3968 3826 0 0 8770 4 1 8800 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 4802 8 #Smalltalk 48 8960 8976 14672 7 257 0 4016 0 0 0 754 65 65 0 0 202 208 98 4 13090 8 '' 41 13136 3826 0 0 8770 3 1 8800 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 14864 7 257 0 3826 0 0 8770 3 1 8800 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 14976 7 513 0 3826 0 0 8770 6 1 8800 8 'doIt' 8 '[:x | [(Smalltalk at: x) isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 14752 8 #isChanged 4802 7648 8 ##(Smalltalk.Error)  8 #on:do: 15088 3826 0 0 15104 39 257 0 7 257 0 0 14160 3826 0 0 8770 4 1 8800 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4802 8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 8976 15248 7 257 0 1 0 0 13090 8 'Global' 301 13136 3968 13472 0 0 14160 3826 0 0 8770 4 1 8800 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 14752 8960 8976 15424 7 257 0 1 0 0 13090 8 'Package' 201 13136 3968 3826 0 0 8770 2 1 8800 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 13792 15536 7 513 0 3826 0 0 8770 4 1 8800 8 'doIt' 8 '[:x | Package manager packageOfGlobalNamed: x]' 8 #[32 105 45 159 17 178 106] 15328 8 #manager 8 #packageOfGlobalNamed: 15616 7 257 0 0 14160 0 1 0 0 13090 8 'File Out Name' 2001 13136 3968 13472 3826 0 0 8770 6 1 8800 8 'doIt' 8 '[:x | | glob |
glob := Smalltalk at: x.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4802 14768 48 8 #sourceObject 8 #conformsToProtocol: 8 #fileOutName 8 '' 15760 7 65793 0 0 14160 0 1 0 0 13856 1216 0 133221 0 0 1010 202 208 98 2 1074 1104 98 2 754 9 89 754 899 743 14160 1074 7808 98 1 14272 14160 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 98 0 1232 0 27 4802 8 'Classes' 410 11920 98 30 0 4832 98 2 8 1140920395 1 16144 8642 202 208 1216 0 8704 482 4928 0 29 5346 0 16 98 8 5394 2097153 1458 8 #browseClass 8 '&Browse' 1 1 2194 0 16 1568 8 'ClassBrowserShell.ico' 1616 0 0 5394 1 1458 8 #browseClassReferences 8 'All Re&ferences' 1 1 0 0 0 5394 1 1458 8 #browseLocalClassReferences 8 'L&ocal References' 1 1 0 0 0 5474 4097 5394 1 1458 8 #addClass 8 '&Add Uncommitted..' 1 1 0 0 0 5394 1 1458 8 #removeClasses 8 '&Remove from Package' 1 1 0 0 0 5474 4097 5346 0 16 98 2 5394 1 1458 8 #browseClassEditions 8 'Browse Class &Editions' 1 1 0 0 0 5394 1 1458 8 #compareClass 8 'Compare Class Edition...' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 16144 0 8 4294905441 3762 13792 98 0 3984 4016 0 0 0 754 65 65 0 0 202 208 98 4 13090 8 '' 41 13136 3826 0 0 8770 3 1 8800 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 14960 16992 7 257 0 3826 0 0 8770 3 1 8800 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] 15056 15072 17088 7 513 0 3762 15168 98 0 0 16144 3826 0 0 8770 4 1 8800 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 15328 15376 8976 17200 7 257 0 1 0 0 13090 8 'Name' 375 13136 3762 13792 98 0 13472 0 0 16144 3984 1 0 0 13090 8 'Package' 201 13136 3968 3826 0 0 8770 2 1 8800 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 13792 17376 7 513 0 3762 13824 98 0 0 16144 0 1 0 0 13090 8 'File Out Name' 2001 13136 3968 13472 3826 0 0 8770 2 1 8800 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] 15888 17520 7 257 0 0 16144 0 1 0 0 8 #list 1216 0 133221 0 0 1010 202 208 98 2 1074 1104 98 2 754 9 89 754 899 743 16144 1074 7808 98 1 16256 16144 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 98 0 1232 0 27 4802 8 'Resources' 410 864 98 14 0 4832 98 2 8 1140850688 131073 17840 0 482 8 4278190080 0 5 5346 0 16 98 4 5394 2097153 1458 8 #editResource 8 '&Edit' 1 1 0 0 0 5394 1 1458 8 #showResource 8 '&Show' 1 1 0 0 0 5474 4097 5394 1 1458 8 #deleteResource 8 '&Delete' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 17840 962 8 ##(Smalltalk.ResourceListPresenter)  8 #resource_Package_view 0 1010 202 208 98 2 1074 1104 98 2 754 9 89 754 899 743 17840 1074 7808 98 1 17936 17840 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 197 1 0 0 159 1 0 0] 1216 1232 0 27 9776 234 256 98 16 17840 8 'resources' 14160 8 'globals' 5040 8 'scripts' 11648 8 'dependents' 9776 8 'comment' 16144 8 'classes' 11904 8 'methods' 9488 8 'prerequisites' 0 410 8576 98 23 0 4832 98 2 8 1140916736 1 18576 8642 202 208 98 8 9760 16128 11888 17824 14144 5024 9472 11632 0 8704 930 31 0 1 0 0 0 18576 0 8 4294905447 3968 3984 4016 0 0 0 0 0 8 #noIcons 1010 202 208 98 3 1074 1104 98 2 754 1 1 754 915 839 18576 1074 8 #basicSelectionsByIndex: 98 1 98 1 3 18576 1074 9136 98 2 -1 1 18576 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 201 1 0 0 163 1 0 0] 98 0 1232 0 27 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 915 839 4832 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 201 1 0 0 163 1 0 0] 98 9 9776 16144 11904 17840 14160 5040 9488 11648 18576 1232 0 27 5 32 234 256 98 2 4832 8 'ownedCards' 0 1010 202 208 98 1 1074 1104 98 2 754 475 1 754 915 839 4672 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 237 0 0 0 0 0 0 0 182 2 0 0 163 1 0 0] 98 1 4832 1232 0 27 5 32 234 256 98 2 410 864 98 14 0 4560 98 2 8 1140850688 131073 19392 0 0 0 7 0 0 0 19392 962 8 ##(Smalltalk.PackageSelector)  9584 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 457 839 19392 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 0 0 0 163 1 0 0] 1216 1232 0 27 8 'packages' 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 1389 839 4560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 163 1 0 0] 98 3 19392 410 8 ##(Smalltalk.Splitter)  98 12 0 4560 98 2 8 1140850688 1 19808 0 482 4928 0 519 0 0 0 19808 1010 202 208 98 1 1074 1104 98 2 754 457 1 754 19 839 19808 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 0 0 0 0 237 0 0 0 163 1 0 0] 98 0 1232 0 27 4672 1232 0 27 1232 0 27 234 256 98 4 560 8 'toolbar' 3520 8 'statusbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 10 5346 0 16 98 30 5394 1 1458 2160 8 '&New Package...' 9373 5 0 0 0 5394 1 1458 2304 8 '&Install Package...' 9375 5 0 0 0 5394 1 1458 8 #removePackage 8 '&Uninstall Package' 1 5 0 0 0 5474 4097 5346 0 16 98 2 5394 2097153 1458 16560 8 '&Class...' 1 1 0 0 0 5394 1 1458 14336 8 '&Global...' 1 1 0 0 0 8 'Add Unco&mmitted' 0 134217729 0 0 18641 0 0 5394 1 1458 8 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 0 0 0 5394 1 1458 8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 5474 4097 5394 1 1458 8 #savePackages 8 '&Save Package' 1 1 2194 0 16 1568 8 'FileSave.ico' 1616 0 0 5394 1 1458 2432 8 'Save Package C&hanges' 1 1 0 0 0 5394 1 1458 8 #savePackageAs 8 'Save Package &As...' 1 1 0 0 0 5474 4097 5394 1 1458 8 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 0 0 0 5394 1 1458 2560 8 'Bro&wse PAX Sources' 1 1 0 0 0 5474 4097 5394 1 1458 8 #loadPackageFromRepository 8 'Load Edition...' 1 1 0 0 0 5394 1 1458 8 #importPackageFromFile 8 'Import to Repository...' 1 5 0 0 0 5394 1 1458 8 #versionPackage 8 'Version...' 1 1 0 0 0 5394 1 1458 8 #browsePackageEditions 8 'Browse Editions' 1 1 0 0 0 5394 1 1458 8 #compareWithAnotherEdition 8 'Compare with...' 1 1 0 0 0 5474 4097 5394 1 1458 8 #saveImage 8 'Sa&ve Image' 1 1 2194 0 16 1568 8 'Snapshot.ico' 1616 0 0 5394 1 1458 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 2194 0 16 1568 8 'PowerSwitch.ico' 1616 0 0 5474 4097 5346 0 16 98 1 5394 2097153 1458 8 #browseTests 8 '&Browse' 1 1 0 0 0 8 '&Tests' 0 1 2194 0 16 1568 8 'TestRunner.ico' 0 0 18673 0 0 5346 0 16 98 4 5394 2097153 1458 8 #deploy 8 '&Deploy Executable...' 13445 1 0 0 0 5394 1 1458 8 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 0 0 0 5474 4097 5394 1 1458 8 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 0 0 0 8 '&Deployment' 0 134217729 2194 0 16 1568 8 'ApplicationDeploymentWizard.ico' 1616 0 18681 0 0 5474 4097 5394 1 1458 8 #inspectPackage 8 'P&roperties' 1 1 0 0 0 5474 4097 5394 1 1458 8 #exit 8 '&Close' 17639 1 2194 0 16 1568 8 'CloseWindow.ico' 1616 0 0 8 '&File' 0 134217729 0 0 18687 0 0 5346 0 16 98 12 5394 1 1458 5568 8 '&Undo' 9397 1 2194 0 16 1568 8 'EditUndo.ico' 1616 0 0 5474 4097 5394 1 1458 5648 8 'Cu&t' 9393 1 2194 0 16 1568 8 'EditCut.ico' 1616 0 0 5394 1 1458 5712 8 '&Copy' 9351 1 2194 0 16 1568 8 'EditCopy.ico' 1616 0 0 5394 1 1458 5776 8 '&Paste' 9389 1 2194 0 16 1568 8 'EditPaste.ico' 1616 0 0 5394 1 1458 8 #editDelete 8 '&Delete' 1 1 2194 0 16 1568 8 'EditClear.ico' 1616 0 0 5474 4097 5394 1 1458 5984 8 'Select &All' 9347 1 0 0 0 5474 4097 5394 1 1458 8 #editFind 8 '&Find...' 9357 1 2194 0 16 1568 47 786694 ##(Smalltalk.ShellLibrary)  0 0 5394 1 1458 8 #findNext 8 'Find &Next' 1253 1 2194 0 16 1568 8 'FindNext.ico' 1616 0 0 5394 1 1458 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 18707 0 0 5346 0 16 98 13 5394 1 1458 6144 8 '&Browse It' 9349 1 2194 0 16 1568 8 'ClassBrowserShell.ico' 1616 0 0 5394 1 1458 6240 8 '&Display It' 9353 1 2194 0 16 1568 8 'DisplayIt.ico' 1616 0 0 5394 1 1458 6304 8 '&Evaluate It' 9355 1 2194 0 16 1568 8 'EvaluateIt.ico' 1616 0 0 5394 1 1458 6368 8 '&Inspect It' 9363 1 2194 0 16 1568 8 'BasicInspector.ico' 1616 0 0 5394 1 1458 6464 8 'Deb&ug It' 1269 1 2194 0 16 1568 8 'Debugger.ico' 1616 0 0 5394 1 1458 8 #fileItIn 8 '&File It In' 1 1 0 0 0 5474 4097 5394 1 1458 6816 8 'Defi&nitions...' 1271 1 0 0 0 5394 1 1458 6880 8 '&References...' 5367 1 0 0 0 5474 4097 5394 1 1458 5440 8 '&Accept' 9383 1 0 0 0 5474 4097 5346 0 16 98 7 5394 1 1458 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 5394 1 1458 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 5394 1 1458 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 5394 1 1458 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 5394 1 1458 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 5394 1 1458 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 5394 1 1458 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 18741 0 0 8 '&Workspace' 0 134217729 0 0 18743 0 0 5346 0 16 98 4 5394 1 1458 12288 8 '&Definitions Of...' 1 1 0 0 0 5394 1 1458 12352 8 '&References To...' 1 1 0 0 0 5474 4097 5394 1 1458 8 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 18751 0 0 5346 0 16 98 10 5394 1 1458 20928 8 'Use PAX S&ource Format' 1 1 0 0 0 5394 2097153 1458 2560 8 'Bro&wse PAX Sources' 1 1 0 0 0 5474 4097 5394 1 1458 8 #checkOut 8 'Check Out &All' 1 1 0 0 0 5394 1 1458 8 #checkOutChanges 8 '&Check Out Changes' 9367 1 0 0 0 5394 1 1458 8 #checkIn 8 'Check &In' 9387 1 0 0 0 5474 4097 5394 1 1458 2432 8 'Save C&hanges' 1 1 2194 0 16 1568 8 'FileSave.ico' 1616 0 0 5474 4097 5394 1 1458 8 #resetChangeFlags 8 'Clear Change &Markers' 1 1 0 0 0 8 'Sou&rce Control' 0 134217729 0 0 18767 0 0 5346 0 16 98 10 5394 1 1458 12528 8 'Re&name Method...' 1 1 0 0 0 5394 1 1458 12592 8 'Rename Re&ferences...' 1 1 0 0 0 5474 4097 5394 1 1458 8 #safeRemoveMethod 8 'Re&move Method...' 1 1 0 0 0 5394 1 1458 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 5474 4097 5394 1 1458 8 #addParameter 8 'Add Method &Parameter...' 1 1 0 0 0 5394 1 1458 8 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 0 0 0 5474 4097 5394 1 1458 8 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 0 0 0 8 'Refactorin&gs' 8 #refactoringsMenu 134217729 0 0 18783 0 0 5346 0 16 98 3 5394 1 1458 8 #undoChange 8 '&Undo <1d>' 1 1 2194 0 16 1568 8 'EditUndo.ico' 1616 0 0 5394 1 1458 8 #redoChange 8 '&Redo <1d>' 1 1 2194 0 16 1568 8 'EditRedo.ico' 1616 0 0 5394 1 1458 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 18791 0 0 5346 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 18793 0 0 5346 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 18795 0 0 5346 0 16 98 19 5394 1 1458 8 #helpContents 8 '&Contents' 1025 1 2194 0 16 1568 49 22848 0 0 5394 1 1458 8 #help 8 'On this &Tool' 1249 1 0 0 0 5394 1 1458 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5474 4097 5394 1 1458 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 5474 4097 5394 1 1458 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 5394 1 1458 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 5394 1 1458 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5346 0 16 98 4 5394 2097153 1458 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 2194 0 16 1568 8 'TipOfTheDay.ico' 1616 0 0 5394 1 1458 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 2194 0 16 1568 8 'TipOfTheDay.ico' 1616 0 0 5474 4097 5394 1 1458 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 18817 0 0 5474 4097 5394 1 1458 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 5394 1 1458 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 5394 1 1458 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5394 1 1458 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5474 4097 5394 1 1458 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 2194 0 16 1568 8 'LiveUpdate.ico' 1616 0 0 5474 4097 5394 1 1458 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2194 0 16 1568 8 '!!APPLICATION' 1616 0 0 8 '&Help' 0 134217729 0 0 18831 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 754 771 621 1 0 0 1010 202 208 98 3 1074 1104 98 2 754 3359 21 754 1421 1041 416 1074 14032 98 1 8 'Package Browser' 416 1074 8 #updateMenuBar 1216 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 85 9 0 0 18 2 0 0] 98 3 560 4256 3520 1232 0 27 )!

resources
	^{DolphinTestPackages}! !

!PackageBrowserShellTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resources!public! !
!

