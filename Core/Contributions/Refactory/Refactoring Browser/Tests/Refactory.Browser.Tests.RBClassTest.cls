"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.RBClassTest'
	instanceVariableNames: 'model objectClass newClass messageNodeClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBClassTest guid: (Core.GUID fromString: '{5220987d-f53e-4675-8166-5035964aa131}')!
Refactory.Browser.Tests.RBClassTest comment: ''!
!Refactory.Browser.Tests.RBClassTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBClassTest methodsFor!

setUp
	super setUp.
	model := RBModel new.
	objectClass := model classNamed: 'Core.Object'.
	objectClass addClassVariable: 'ModelOnlyClassVariable'.
	messageNodeClass := model classNamed: StMessageNode fullName.
	model
		defineClass: 'Core.Object subclass: #SomeClassName
	instanceVariableNames: ''instanceVariable1 instanceVariable2''
	classVariableNames: ''ClassVariable1''
	imports: #(#{Kernel.OpcodePool})
	classInstanceVariableNames: ''''
	classConstants: { ''ClassConstant1'' -> 1.23 }'.
	newClass := model classNamed: #SomeClassName!

testAllBehaviorsDo
	"RBClass>>allBehaviorsDo: enumerates through the namespace hierarchy, so if we start from the model class for Root it will include all potential classes in the universe, not just those in the model environment. This will include model mirrors of real classes, and model only classes."

	| environmentClasses modelClasses |
	modelClasses := Set new.
	model rootNamespace allBehaviorsDo: [:each | modelClasses add: each fullName].
	environmentClasses := Set new.
	Class allBehaviorsDo: [:each | environmentClasses add: each fullName].
	self assert: (environmentClasses difference: modelClasses) asSortedArray equals: #().
	self assert: (modelClasses difference: environmentClasses) asSortedArray
		equals: #('SomeClassName' 'SomeClassName class')!

testAllClassVarNames
	| objectClassVars newClassVars |
	objectClassVars := (Object classVariableNames copyWith: 'ModelOnlyClassVariable') sort.
	self assert: objectClass allClassVariableNames sort equals: objectClassVars.
	self assert: objectClass metaclass allClassVariableNames sort equals: objectClassVars.
	newClassVars := (objectClassVars copyWith: 'ClassVariable1') sort.
	self assert: newClass allClassVariableNames sort equals: newClassVars.
	self assert: newClass metaclass allClassVariableNames sort equals: newClassVars.
!

testAllImports
	| opcodePool |
	opcodePool := (model classFor: Kernel.OpcodePool) asQualifiedReference.
	self assert: newClass allImports equals: {opcodePool}.
	model
		defineClass: 'SomeClassName subclass: #''Core.Foo'' instanceVariableNames: '''' classVariableNames: '''' imports: #(#{Core} #{Kernel.OpcodePool} #{UI}) classInstanceVariableNames: '''' classConstants: {}'.
	self assert: (model classNamed: 'Core.Foo') allImports
		equals: {(model classFor: Core) asQualifiedReference.
				opcodePool.
				(model classFor: UI) asQualifiedReference}.
	model
		defineClass: 'SomeClassName subclass: #''Core.Bar'' instanceVariableNames: '''' classVariableNames: '''' imports: #(#{Core} #{UI}) classInstanceVariableNames: '''' classConstants: {}'.
	self assert: (model classNamed: 'Core.Bar') allImports
		equals: {(model classFor: Core) asQualifiedReference.
				(model classFor: UI) asQualifiedReference.
				opcodePool}!

testBindings
	| bindings |
	bindings := objectClass bindings.
	self assert: (bindings allSatisfy: [:each | each isVariableBinding]).
	self assert: (bindings allSatisfy: [:each | each environment == objectClass]).
	self assert: (bindings collect: [:each | each key]) sort
		equals: #('_AssertionFailureSignal' '_DependentsRegister' '_EventsRegister' '_PropertyRegister' 'ModelOnlyClassVariable')!

testCategories
	self assert: objectClass categoryNames equals: #('Kernel-Objects').
	self assert: (model classFor: WeakArray) categoryNames equals: #('Collections-Arrayed' 'Collections-Weak').
	self assert: newClass categoryNames equals: #()!

testClassSubclasses
	| class |
	class := model classFor: Class.
	self assert: class subclasses asArray equals: {objectClass metaclass. model classFor: ProtoObject class}!

testDefinesClassVariable
	self deny: (objectClass definesClassVariable: #ClassVariable1).
	self assert: (objectClass definesClassVariable: self objectClassVariable).
	self assert: (newClass definesClassVariable: #ClassVariable1).
	self deny: (messageNodeClass definesClassVariable: #ClassVariable1).
	self 
		assert: (messageNodeClass definesClassVariable: self objectClassVariable)!

testDefinesInstanceVariable
	self deny: (objectClass definesInstanceVariable: 'instanceVariable1').
	self assert: (newClass definesInstanceVariable: 'instanceVariable1').
	self deny: (messageNodeClass definesInstanceVariable: 'instanceVariable1').
	self assert: (messageNodeClass definesInstanceVariable: 'parent').
	self assert: (messageNodeClass definesInstanceVariable: 'selector')!

testDefinesMethod
	self assert: (objectClass definesMethod: #printString).
	self assert: (newClass definesMethod: #printString).
	self assert: (messageNodeClass definesMethod: #printString)!

testDefinesPoolDictionary
	self deny: (objectClass importsNamespace: 'Kernel.OpcodePool').
	self assert: (newClass importsNamespace: 'Kernel.OpcodePool').
	self deny: (messageNodeClass importsNamespace: 'OS.Win32Constants').
	self assert: ((RBModel new classNamed: 'OS.HRESULTError') importsNamespace: 'OS.FacilityCodes')!

testDefinitionString
	self assert: objectClass definition
		equals: 'nil
	subclass: #''Core.Object''
	instanceVariableNames: ''''
	classVariableNames: ''_AssertionFailureSignal _DependentsRegister _EventsRegister _PropertyRegister ModelOnlyClassVariable''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {}'.
	self assert: newClass definition
		equals: 'Core.Object
	subclass: #SomeClassName
	instanceVariableNames: ''instanceVariable1 instanceVariable2''
	classVariableNames: ''ClassVariable1''
	imports: #(#{Kernel.OpcodePool})
	classInstanceVariableNames: ''''
	classConstants: { ''ClassConstant1'' -> 1.23 }'.
	{External.FunctionDescriptor. External.Structure. SessionManager. Scanner} do: 
			[:each |
			| class |
			class := model classFor: each.
			self assert: class definition equals: class realClass definition].
	self should: [objectClass metaclass definition] raise: MessageNotUnderstood!

testEnvironment
	| rbTests myClass refactory root smalltalk |
	myClass := model classFor: self class.
	rbTests := model classFor: self class environment.
	self assert: myClass environment equals: rbTests.
	self assert: myClass basicEnvironment equals: rbTests.
	self assert: myClass baseEnvironmentName equals: #Smalltalk.
	self assert: (rbTests classPool at: self class unqualifiedName) identicalTo: myClass.
	smalltalk := model classNamed: #Smalltalk.
	self assert: newClass environment identicalTo: smalltalk.
	self assert: newClass basicEnvironment identicalTo: smalltalk.
	self assert: newClass baseEnvironmentName equals: #Smalltalk.
	root := model classNamed: #Root.
	self assert: root identicalTo: model rootNamespace.
	self assert: smalltalk environment identicalTo: root.
	self assert: smalltalk basicEnvironment identicalTo: root.
	refactory := model classNamed: #Refactory.
	self assert: rbTests environment environment identicalTo: refactory.
	self assert: refactory environment identicalTo: root.
	self assert: refactory basicEnvironment identicalTo: root.

	"As in the real class hierarchy, the public environment of Root is nil (in order to terminate tree traversal at the root), even though its actual environment is itself."
	self assertIsNil: root environment.
	self assert: root basicEnvironment identicalTo: root.
	self assert: root baseEnvironmentName equals: #Root!

testFullName
	self assert: objectClass fullName equals: 'Core.Object'.
	self assert: objectClass metaclass fullName equals: 'Core.Object class'.
	self assert: messageNodeClass fullName equals: StMessageNode fullName.
	self assert: (model classFor: self class) fullName equals: self class fullName.
	self assert: newClass fullName equals: 'SomeClassName'.
	self assert: objectClass environment environment fullName equals: 'Root'!

testHierarchy
	| meta |
	meta := objectClass metaclass.
	self assert: (objectClass withAllSubclasses includes: meta).
	self assert: (meta withAllSuperclasses includes: objectClass)!

testLegacyDefinitionString
	"We don't use the legacy definition string format for RBClasses"

	| scribble |
	scribble := model classNamed: #Scribble.
	self assert: scribble definition
		equals: 'UI.Presenter
	subclass: #''Smalltalk.Scribble''
	instanceVariableNames: ''newStroke trackingCanvas''
	classVariableNames: ''''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {}'!

testLocalBindingFor
	| binding |
	binding := objectClass localBindingFor: 'ModelOnlyClassVariable'.
	self assertNotNil: binding.
	self assert: binding environment identicalTo: objectClass.
	self assertIsNil: binding value.
	self assert: binding identicalTo: binding.
	self assertIsNil: binding realBinding.
	binding := objectClass localBindingFor: '_DependentsRegister'.
	self assertNotNil: binding.
	self assert: binding environment identicalTo: objectClass.
	self assert: binding value identicalTo: Object._DependentsRegister.
	self assert: binding realBinding identicalTo: (Object localBindingFor: '_DependentsRegister').
	binding := (model classFor: TransformationRuleTestData) localBindingFor: 'Bar'.
	self assertNotNil: binding.
	self assert: binding isImmutable.
	self assert: binding environment realClass identicalTo: TransformationRuleTestData.
	self assert: binding value identicalTo: TransformationRuleTestData.Bar.
	self assert: binding realBinding identicalTo: (TransformationRuleTestData localBindingFor: 'Bar')!

testMethodsReferencingExternals1
	| class referers expectedSelectors subclass newMethod |
	class := model classNamed: #'Refactory.Browser.Tests.ClassToRename'.
	referers := (class methodsReferencingExternals asArray collect: [:each | each selector]) sort.
	expectedSelectors := #(#mySubclass #refersToClassInCustomNamespace #refersToClassInPackageDefaultNamespace #refersToClassVariableInCustomNamespace #refersToClassVariablePartiallyQualified #selfReference #testFailure).
	self assert: referers equals: expectedSelectors.
	expectedSelectors do: [:each | class removeSelector: each].
	self assert: class methodsReferencingExternals isEmpty.
	"Modify an existing method (should no longer see the real method)."
	class compile: 'selfReference ^Core.Object'.
	newMethod := class newMethods at: #selfReference.
	self assert: class methodsReferencingExternals asArray equals: { newMethod }.
	"initialize method references class var ClassVar1, but that is locally defined and so should not be considered an external reference"
	self assert: class metaclass methodsReferencingExternals single
		equals: (class metaclass methodFor: #testSkip).
	subclass := class subclasses first.
	self assert: (subclass methodsReferencingExternals collect: [:each | each selector]) asSortedArray
		equals: #(#externalReference:_: #refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2 #refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2 #refersToClassUnqualified #refersToClassUnqualifiedBinding #refersToClassUnqualifiedHybrid #refersToClassUnqualifiedStaticExpression #refersToInheritedClassVariableUnqualifiedBinding #refersToOtherClassPartiallyQualifiedBinding #testSkip #unqualifiedBindingReference)!

testMethodsReferencingExternals2
	| class referers |
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	referers := class methodsReferencingExternals asSet collect: [:each | each selector].
	#(#refersToClassBindingNotFound #refersToClassConstantFullyQualified #refersToClassConstantUnqualified #refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2 #refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2 #refersToClassPartiallyQualifiedBindingInArray #refersToClassUnqualified #refersToClassUnqualifiedBinding #refersToClassUnqualifiedBindingInArray #refersToClassUnqualifiedInArray #refersToClassVariableFullyQualified #refersToClassVariablePartiallyQualified #refersToClassVariablePartiallyQualifiedBinding #refersToOtherClassPartiallyQualifiedBinding)
		do: [:each | self assert: (referers includes: each)].
	"These should perhaps be excluded"
	#(#refersToDolphinTestPartiallyQualifiedBindingMethodNamespace #refersToOwnClassVariableUnqualifiedBinding)
		do: [:each | self assert: (referers includes: each)].
	"Example of a reference to a namespace"
	self assert: (referers includes: #smalltalkAssociationAt).
	"Brace array syntax creates an implict reference to Array"
	self assert: (referers includes: #braceArray).
	"We don't strictly need to include the fully-qualified bindings for rename purposes, so although they are external refs they are not included"
	#(#refersToClassFullyQualifiedBinding #refersToClassFullyQualifiedBindingInArray #refersToClassPartiallyQualifiedName #refersToClassUnqualifiedName #refersToClassUnqualifiedNameInArray #refersToOtherClassPartiallyQualifiedName)
		do: [:each | self deny: (referers includes: each)].
	"References Tools, but as a custom method namespace, so this is not an external reference"
	self deny: (referers includes: #inlineParameterMethod:).
	self deny: (referers includes: #refersToOwnClassVariable).
	"References to the symbolic name are not considered to be references to the named variable as they may not be"
	#(#refersToClassFullyQualifiedName #refersToClassFullyQualifiedNameInArray #refersToDolphinTestBindingFullyQualified)
		do: [:each | self deny: (referers includes: each)]!

testMethodsReferencingExternals3
	| class referers |
	class := model classFor: SubclassOfClassToRename.
	referers := (class methodsReferencingExternals asArray collect: [:each | each selector]) sort.
	self assert: referers
		equals: #(externalReference:_: refersToClassFullyQualified refersToClassPartiallyQualified1 refersToClassPartiallyQualified2 refersToClassPartiallyQualifiedBinding1 refersToClassPartiallyQualifiedBinding2 refersToClassUnqualified refersToClassUnqualifiedBinding refersToClassUnqualifiedHybrid refersToClassUnqualifiedStaticExpression refersToInheritedClassVariableUnqualifiedBinding refersToOtherClassPartiallyQualifiedBinding testSkip unqualifiedBindingReference)!

testModel
	| myClass |
	self assert: objectClass model identicalTo: model.
	self assert: objectClass metaclass model identicalTo: model.
	self assert: newClass model identicalTo: model.
	self assert: newClass metaclass model identicalTo: model.
	myClass := model classFor: self class.
	self assert: myClass model identicalTo: model.
	self assert: myClass metaclass model identicalTo: model!

testName
	self assert: objectClass name equals: 'Core.Object'.
	self assert: objectClass metaclass name equals: 'Core.Object class'.
	self assert: (model classFor: self class) name equals: self class fullName.
	self assert: newClass name equals: 'SomeClassName'.
	self assert: newClass metaclass name equals: 'SomeClassName class'.!

testPrintString
	self assert: objectClass printString equals: 'Object'.
	self assert: objectClass metaclass printString equals: 'Object class'!

testRealClass
	| myClass subclasses |
	self assert: objectClass realClass identicalTo: Object.
	self assert: objectClass metaclass realClass identicalTo: Object class.
	self assert: newClass realClass isNil.
	self assert: newClass metaclass realClass isNil.
	self assertIsNil: objectClass superclass.
	self assert: objectClass metaclass superclass realClass equals: Class.
	self assert: (objectClass subclasses includes: newClass).
	subclasses := objectClass subclasses collect: [:each | each realClass].
	self assert: (subclasses difference: Object subclasses) asArray equals: #(nil).
	self assert: (Object subclasses difference: subclasses) asArray equals: #().
	self assert: (objectClass metaclass subclasses includes: newClass metaclass).
	subclasses := objectClass metaclass subclasses collect: [:each | each realClass].
	self assert: (subclasses difference: Object class subclasses) asArray equals: #(nil).
	self assert: (Object class subclasses difference: subclasses) asArray equals: #().
	myClass := model classFor: self class.
	self assert: myClass realClass identicalTo: self class.
	self assert: myClass metaclass realClass identicalTo: self class class!

testShortName
	self assert: objectClass shortName equals: 'Object'.
	self assert: objectClass metaclass shortName equals: 'Object class'.
	self assert: objectClass environment shortName equals: 'Core'.
	self assert: (model classFor: self class) shortName equals: self class shortName.
	self assert: newClass shortName equals: 'SomeClassName'.
	self assert: model rootNamespace shortName equals: 'Root'.
	self assert: model smalltalkNamespace shortName equals: 'Smalltalk'!

testStoreString
	self assert: objectClass storeString equals: 'Core.Object'.
	self assert: objectClass metaclass storeString equals: 'Core.Object class'!

testSubclasses
	self assert: (objectClass subclasses includes: newClass).
	self assert: (objectClass metaclass subclasses includes: newClass metaclass).
	self assert: (objectClass subclasses collect: [:each | each metaclass])
		equals: objectClass metaclass subclasses.
	self assert: newClass subclasses isEmpty.
	self assert: newClass metaclass subclasses isEmpty!

testSubclassesFilteredByEnvironment
	| object |
	model := RBModel onEnvironment: (BrowserEnvironment new
						forClasses: {Object. Behavior. ClassDescription. Class. Boolean. Collection}).
	object := model classFor: Object.
	self assert: object subclasses
		equals: {model classFor: Behavior. model classFor: Boolean. model classFor: Collection}.
	self assert: (model classFor: Class) subclasses equals: {object metaclass}!

testSubclassesOfClass
	| class rootMetaclasses |
	class := model classFor: Class.
	rootMetaclasses := class subclasses.
	self assert: (rootMetaclasses identityIncludes: (model classFor: Object class)).
	self assert: (rootMetaclasses identityIncludes: (model classFor: ProtoObject class)).
	rootMetaclasses do: 
			[:each |
			self assert: each superclass identicalTo: class.
			self assertIsNil: each instanceClass superclass].
	self assert: class metaclass subclasses isEmpty!

testSuperclass
	self assert: newClass superclass equals: objectClass.
	self assert: newClass metaclass superclass equals: objectClass metaclass.
	self assertIsNil: objectClass superclass.
	self assert: objectClass metaclass superclass equals: (model classFor: Class)!

testUnqualifiedName
	self assert: objectClass unqualifiedName equals: #Object.
	self assert: objectClass metaclass unqualifiedName equals: 'Object class'.
	self assert: (model classFor: self class) unqualifiedName equals: self class unqualifiedName.
	self assert: newClass unqualifiedName equals: 'SomeClassName'.
	self assert: newClass metaclass unqualifiedName equals: 'SomeClassName class'!

testWhichMethodsReferToClass
	| class method targetClass referers |
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	method := class methodFor: #atIfAbsent.
	self assert: (method refersToClass: (model classNamed: #Smalltalk)).
	targetClass := model classNamed: 'Refactory.Browser.Tests.ClassToRename'.
	referers := ((class whichMethodsReferToClass: targetClass) asArray collect: [:each | each selector])
				sort.
	"Note that we don't expect to see any of the symbolic references any more as these are deliberately not matched. Symbolic name references are superseded by BindingReferences as we know these are intended to refer to static variables, which is not necessarily true of symbols."
	self assert: referers
		equals: #(refersToClassBindingNotFoundInArray #refersToClassConstantFullyQualified #refersToClassConstantPartiallyQualified #refersToClassConstantPartiallyQualifiedWithNamespace #refersToClassConstantUnqualified #refersToClassFullyQualified #refersToClassFullyQualifiedBinding #refersToClassFullyQualifiedBindingInArray #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2 #refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2 #refersToClassPartiallyQualifiedBindingInArray #refersToClassUnqualified #refersToClassUnqualifiedBinding #refersToClassUnqualifiedBindingInArray #refersToClassUnqualifiedInArray #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation #refersToClassVariableFullyQualified #refersToClassVariablePartiallyQualified #refersToClassVariablePartiallyQualifiedBinding)!

testWhichMethodsReferToClassViaMethodNamespace
	| class targetClass referers |
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	targetClass := model classNamed: #'Core.Tests.DolphinTest'.
	referers := ((class whichMethodsReferToClass: targetClass) asArray collect: [:each | each selector])
				sort.
	self assert: referers
		equals: #(#refersToDolphinTestBindingFullyQualified #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace)!

testWithAllSubclasses
	| class all |
	class := model classFor: Class.
	all := class withAllSubclasses asSet.
	all remove: class.
	"All classes are subclasses of Class, so that includes also classes under other root classes"
	Smalltalk allClasses do: [:each | all remove: (model classFor: each) metaclass].
	"We should only be left with the model-only defined class"
	self assert: all asArray equals: {newClass metaclass}! !
!Refactory.Browser.Tests.RBClassTest categoriesForMethods!
setUp!private!set up! !
testAllBehaviorsDo!public!unit tests! !
testAllClassVarNames!public!unit tests! !
testAllImports!public!unit tests! !
testBindings!public!unit tests! !
testCategories!public!unit tests! !
testClassSubclasses!public!unit tests! !
testDefinesClassVariable!public!unit tests! !
testDefinesInstanceVariable!public!unit tests! !
testDefinesMethod!public!unit tests! !
testDefinesPoolDictionary!public!unit tests! !
testDefinitionString!public!unit tests! !
testEnvironment!public!unit tests! !
testFullName!public!unit tests! !
testHierarchy!public!unit tests! !
testLegacyDefinitionString!public!unit tests! !
testLocalBindingFor!public!unit tests! !
testMethodsReferencingExternals1!public! !
testMethodsReferencingExternals2!public! !
testMethodsReferencingExternals3!public! !
testModel!public!unit tests! !
testName!public!unit tests! !
testPrintString!public!unit tests! !
testRealClass!public!unit tests! !
testShortName!public!unit tests! !
testStoreString!public!unit tests! !
testSubclasses!public!unit tests! !
testSubclassesFilteredByEnvironment!public!unit tests! !
testSubclassesOfClass!public!unit tests! !
testSuperclass!public! !
testUnqualifiedName!public!unit tests! !
testWhichMethodsReferToClass!public! !
testWhichMethodsReferToClassViaMethodNamespace!public! !
testWithAllSubclasses!public!unit tests! !
!

