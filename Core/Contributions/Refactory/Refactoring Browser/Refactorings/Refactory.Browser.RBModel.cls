"Filed out from Dolphin Smalltalk"!

Core.Model
	subclass: #'Refactory.Browser.RBModel'
	instanceVariableNames: 'changes environment rootClasses implementorsCache sendersCache rootNamespace smalltalkNamespace selectorsCache'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBModel guid: (Core.GUID fromString: '{e04ee960-3b00-47a4-b10a-e93cb600dad5}')!
Refactory.Browser.RBModel comment: ''!
!Refactory.Browser.RBModel categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBModel methodsFor!

addClassConstant: anAssociation to: aRBClass
	^changes addClassConstant: anAssociation to: aRBClass!

addClassVariable: aString to: aRBClass 
	^changes addClassVariable: aString to: aRBClass!

addInstanceVariable: aString to: aRBClass 
	^changes addInstanceVariable: aString to: aRBClass!

allBehaviorsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the behaviours (instance classes and metaclasses) included in the model."

	self rootNamespace allClassesDo: 
			[:each |
			each realClass
				ifNil: 
					["Model-only class"
					aMonadicValuable
						value: each;
						value: each metaclass]
				ifNotNil: 
					[:realClass |
					(environment includesClass: realClass) ifTrue: [aMonadicValuable value: each].
					(environment includesClass: realClass class) ifTrue: [aMonadicValuable value: each metaclass]]]!

allClassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the instance classes included in the model."

	self rootNamespace allClassesDo: 
			[:each |
			each realClass
				ifNil: 
					["Model-only class"
					aMonadicValuable value: each]
				ifNotNil: [:realClass | (environment includesClass: realClass) ifTrue: [aMonadicValuable value: each]]]!

allImplementorsOf: aSymbol
	^((implementorsCache ifNil: [implementorsCache := IdentityDictionary new]) lookup: aSymbol)
		ifNil: 
			[| classes |
			classes := Set new.
			self allBehaviorsDo: 
					[:each |
					((each directlyDefinesMethod: aSymbol) and: [environment includesSelector: aSymbol in: each])
						ifTrue: [classes add: each]].
			implementorsCache at: aSymbol put: classes]!

allReferencesTo: aSymbol
	^((sendersCache ifNil: [sendersCache := IdentityDictionary new]) lookup: aSymbol)
		ifNil:
			[| refs |
			refs := Array writeStream.
			self allBehaviorsDo: 
					[:each |
					#rbFix.	"Don't include any selectors which should not be visible in the model's environment"
					(each whichMethodsReferToSymbol: aSymbol)
						do: [:eachMethod | (environment includesSelector: eachMethod selector in: each) ifTrue: [refs nextPut: eachMethod]]].
			sendersCache at: aSymbol put: refs contents]!

allReferencesToBinding: aRBVariableBinding
	| methods |
	methods := Array writeStream: 8.
	self allReferencesToBinding: aRBVariableBinding do: [:each | methods nextPut: each].
	^methods contents!

allReferencesToBinding: aRBVariableBinding do: aBlock
	self allBehaviorsDo: [:each | (each whichMethodsReferToBinding: aRBVariableBinding) do: aBlock]!

allReferencesToClass: aRBClass
	| methods |
	methods := OrderedCollection new: 8.
	self allReferencesToClass: aRBClass
		do: 
			[:each |
			"Ensure that the method parse tree has been constructed, bound and cached, so that when searched the variables match as they would before any rename."
			methods addLast: (each
						boundParseTree;
						yourself)].
	^methods!

allReferencesToClass: aRBClass do: aBlock
	self allBehaviorsDo: [:each | (each whichMethodsReferToClass: aRBClass) do: aBlock]!

allSelectors
	^selectorsCache ifNil: [selectorsCache := self buildAllSelectors]!

browserEnvironment
	^environment!

buildAllSelectors
	| set |
	set := IdentitySet new: 256.
	self allBehaviorsDo: [:each | set addAll: each selectors].
	^set!

changes
	^changes!

changes: aCompositeRefactoryChange 
	changes := aCompositeRefactoryChange!

classFor: aBehavior
	aBehavior ifNil: [^nil].
	(aBehavior isKindOf: RBAbstractClass) ifTrue: [^aBehavior].
	^aBehavior isMeta
		ifTrue: [(self instanceClassFor: aBehavior instanceClass) ifNotNil: [:class | class metaclass]]
		ifFalse: [self instanceClassFor: aBehavior]!

classNamed: aString
	| index |
	aString isNil ifTrue: [^nil].
	index := aString
				nextIndexOf: $\x20
				from: 1
				to: aString size.
	^index == 0
		ifTrue: [self instanceClassNamed: aString]
		ifFalse: 
			[(self instanceClassNamed: (aString copyFrom: 1 to: index - 1)) ifNotNil: [:class | class metaclass]]!

comment: aString in: aClass
	^ changes comment: aString in: aClass!

compile: aString in: aRBClass categories: aCollection
	| change |
	change := changes
				compile: aString
				in: aRBClass
				categories: aCollection.
	self flushCaches.
	^change!

compile: aString in: aRBClass environment: aRBNamespaceClass categories: aCollection package: aPackage
	| change |
	change := changes 
				compile: aString
				in: aRBClass
				environment: aRBNamespaceClass
				categories: aCollection
				package: aPackage.
	self flushCaches.
	^change!

compileTree: aMethodNode forMethod: aRBMethod
	| selector class packageAndEnvironment |
	aRBMethod parseTree: aMethodNode.
	selector := aRBMethod selector.
	class := aRBMethod modelClass.
	self assert: aMethodNode selector == aRBMethod selector.
	class addMethod: aRBMethod.
	packageAndEnvironment := aRBMethod existingPackageAndEnvironment.
	class
		compile: aMethodNode newSource
		environment: packageAndEnvironment second
		categories: (class protocolsFor: selector)
		package: packageAndEnvironment first!

createOrUpdateModelClass: anAddClassChange
	| newClass newClassName details |
	newClassName := anAddClassChange changeClassName.
	newClass := self instanceClassNamed: newClassName.
	newClass
		ifNil: 
			[newClass := RBClass model: self named: newClassName.
			newClass environment addClass: newClass]
		ifNotNil: 
			["If the class previously existed, and was a root class, we need to remove it from the model's cache of root classes."
			newClass superclass ifNil: [self rootClasses remove: newClass]].
	details := anAddClassChange details.
	newClass superclass: (self instanceClassNamed: details superclassName).
	newClass superclass ifNil: [self rootClasses add: newClass].
	newClass
		instanceVariableNames: details instanceVariableNames;
		classVariableNames: details classVariableNames;
		classConstants: details classConstants;
		imports: details imports;
		categoryNames: details categoryNames.
	details isNonInstantiable ifTrue: [newClass isNonInstantiable: true]!

defineClass: aString
	| change |
	change := changes defineClass: aString.
	self createOrUpdateModelClass: change.
	^change!

defineClassWithDetails: aClassDetails
	| change |
	change := changes defineClassWithDetails: aClassDetails.
	self createOrUpdateModelClass: change.
	^change!

definesStaticVariable: aString
	"Is the argument the name of a variable defined in this model? See also #includesStaticVariable:"

	| binding |
	#namespaceToDo. "Why do we have this and #includesStaticVariable:"
	binding := self smalltalkNamespace fullBindingFor: aString.
	^binding notNil and: 
			[binding fullName = aString or: 
					[| ref |
					ref := aString asQualifiedReference.
					ref unqualifiedName = binding key and: [(RBBindingReference model: self reference: ref) environment == binding environment]]]!

environment
	^environment!

flushCaches
	selectorsCache := implementorsCache := sendersCache := nil!

fullBindingFor: aString
	^smalltalkNamespace fullBindingFor: aString!

import: anArrayOfBindingReferences into: aRBClass
	^changes import: anArrayOfBindingReferences into: aRBClass!

includesClassNamed: aString
	^(self classNamed: aString) notNil!

includesImplementorsOf: aSymbol
	^self allSelectors includes: aSymbol!

includesStaticVariable: aString
	"Does the argument resolve to a static variable in the receiver? See also #definesStaticVariable:"

	| binding |
	binding := self smalltalkNamespace fullBindingFor: aString.
	^binding notNil and: 
			[binding isClassBinding
				ifTrue: [environment includesClass: binding value]
				ifFalse: [environment includesClass: binding environment]]!

instanceClassFor: aClass
	^(aClass classInModel: self)
		ifNotNil: 
			[:modelClass |
			modelClass realClass
				ifNotNil: [:realClass | (environment includesClassOrMetaclass: realClass) ifFalse: [^nil]].
			modelClass]!

instanceClassNamed: aString
	aString isNil ifTrue: [^nil].
	^(self fullBindingFor: aString)
		ifNotNil: 
			[:binding |
			binding isClassBinding
				ifTrue: 
					[| modelClass realClass |
					modelClass := binding value.
					realClass := modelClass realClass.
					(realClass isNil or: [environment includesClassOrMetaclass: realClass]) ifTrue: [modelClass]]]!

metaclassNamed: aString
	^(self instanceClassNamed: aString) ifNotNil: [:class | class metaclass]!

name
	^changes name!

name: aString
	^changes name: aString!

performChange: aCompositeRefactoryChange around: aBlock 
	| oldChanges |
	changes addChange: aCompositeRefactoryChange.
	oldChanges := changes.
	changes := aCompositeRefactoryChange.
	aBlock ensure: [changes := oldChanges].
	^aCompositeRefactoryChange!

removeClass: aRBClass 
	self removeClassNamed: aRBClass name!

removeClassConstant: anAssociation from: aRBClass
	^changes removeClassConstant: anAssociation from: aRBClass!

removeClassNamed: aString
	| removedClass |
	removedClass := self instanceClassNamed: aString.
	removedClass subclasses do: [:each | self removeClassNamed: each fullName].
	removedClass environment ifNotNil: [:env | env removeClass: removedClass].
	self flushCaches.
	^changes removeClassNamed: aString!

removeClassVariable: aVariableBinding
	^changes removeClassVariable: aVariableBinding!

removeInstanceVariable: aString from: aRBClass 
	^changes removeInstanceVariable: aString from: aRBClass!

removeSelector: aSelector from: aRBClass
	self flushCaches.
	^changes removeSelector: aSelector from: aRBClass!

renameClass: aRBClass to: aString around: aDyadicValuable
	| change oldName methods oldUnqualified originalEnvironment binding block |
	oldName := aRBClass fullName.
	change := RenameClassChange rename: oldName to: aString.
	"The ordering is important here. We need the RB model namespaces to reflect the change so that any attempt to look up the old class name in its old environment will fail, but we also need method searches to find references to the old class name. Therefore we have to capture the references in advance of making any model changes, and build the parse trees now so that we can bind any variables/qualified refs to their original target. This will allow us to detect if the bindings change after the rename. Note that the bindings may change because they refer to the original name, directly or indirectly, or because the rename is changing the class' namespace, or because of shadowing."
	methods := SearchPolicy method newSet.
	methods addAll: (self allReferencesToClass: aRBClass).
	block := [:method | (methods addIfAbsent: method) boundParseTree].
	#namespaceToDo.	"A subclass may refer to external variables that it can only bind via an import that it inherits via the namespace of its superclass (if different to its own). There is therefore (rare) potential for external references in subclasses to be affected by a class rename when that rename moves a class to a new namespace. Enumerating all subclasses could be prohibitively expensive with the current search, however, as it is too broad in scope. If we were to rename Object, for example, then a significant proportion of the methods in the entire system would be in scope."
	"References to class variables may be fully qualified, and so may require renaming. We could either eliminate these from consideration by reducing them first (a refactoring to do that would be useful anyway), or just include all methods containing static variable references in the search, rather than trying to be clever and exclude the 'internal' references. At the moment we include the class variables as potential references to externals."
	aRBClass methodsReferencingExternals do: block.
	aRBClass metaclass methodsReferencingExternals do: block.
	oldUnqualified := aRBClass unqualifiedName.
	originalEnvironment := aRBClass environment.
	self assert: [(originalEnvironment localBindingFor: oldUnqualified) value == aRBClass].
	"Apply the name change in the model class and the model namespaces"
	aRBClass name: aString.
	binding := originalEnvironment removeBindingFor: oldUnqualified.
	self assert: [binding value == aRBClass].
	binding setKey: aRBClass unqualifiedName.
	aRBClass environment addBinding: binding.
	self performChange: change around: [aDyadicValuable value: methods].
	self flushCaches.
	^change!

renameClassVariable: oldName to: newName in: aRBClass around: aBlock
	^self performChange: (RenameClassVariableChange
				rename: oldName
				to: newName
				in: aRBClass)
		around: aBlock!

renameInstanceVariable: oldName to: newName in: aRBClass around: aBlock
	^self performChange: (RenameInstanceVariableChange
				rename: oldName
				to: newName
				in: aRBClass)
		around: aBlock!

reparentClasses: aRBClassCollection to: newClass
	aRBClassCollection do: 
			[:aClass |
			self defineClassWithDetails: ((ClassDetails fromClass: aClass)
						superclassName: newClass fullName;
						yourself)]!

rootClasses
	^rootClasses
		ifNil: 
			[rootClasses := OrderedCollection new.
			Class rootsOfTheWorld do: 
					[:each |
					| class |
					class := self instanceClassFor: each.
					(class notNil and: [class superclass isNil]) ifTrue: [rootClasses add: class]].
			rootClasses]!

rootNamespace
	^rootNamespace!

setEnvironment: aBrowserEnvironment
	changes := CompositeRefactoryChange new.
	environment := aBrowserEnvironment.
	rootNamespace :=RBRootNamespace new model: self existing: Root.
	smalltalkNamespace := rootNamespace classPool at: #Smalltalk.
	self flushCaches!

smalltalkNamespace
	^smalltalkNamespace!

upgradePackage: aPackage
	^changes addChange: (PackageVersionChange package: aPackage version: Package paxVersion)! !
!Refactory.Browser.RBModel categoriesForMethods!
addClassConstant:to:!changes!private! !
addClassVariable:to:!changes!private! !
addInstanceVariable:to:!changes!private! !
allBehaviorsDo:!accessing!public! !
allClassesDo:!accessing!public! !
allImplementorsOf:!accessing!public! !
allReferencesTo:!accessing!public! !
allReferencesToBinding:!helpers!private! !
allReferencesToBinding:do:!accessing!public! !
allReferencesToClass:!helpers!private! !
allReferencesToClass:do:!accessing!public! !
allSelectors!accessing!public! !
browserEnvironment!accessing!public! !
buildAllSelectors!helpers!private! !
changes!accessing!public! !
changes:!accessing!public! !
classFor:!accessing/classes!public! !
classNamed:!accessing/classes!public! !
comment:in:!changes!private! !
compile:in:categories:!changes!private! !
compile:in:environment:categories:package:!compiling!public! !
compileTree:forMethod:!public!support! !
createOrUpdateModelClass:!changes!private! !
defineClass:!changes!public! !
defineClassWithDetails:!changes!public! !
definesStaticVariable:!public!testing! !
environment!accessing!public! !
flushCaches!changes!private! !
fullBindingFor:!binding!public! !
import:into:!changes!public! !
includesClassNamed:!public!testing! !
includesImplementorsOf:!public!testing! !
includesStaticVariable:!public!testing! !
instanceClassFor:!accessing/classes!public! !
instanceClassNamed:!accessing/classes!public! !
metaclassNamed:!accessing/classes!public! !
name!accessing!public! !
name:!accessing!public! !
performChange:around:!changes!private! !
removeClass:!changes!public! !
removeClassConstant:from:!changes!private! !
removeClassNamed:!changes!private! !
removeClassVariable:!changes!public! !
removeInstanceVariable:from:!changes!private! !
removeSelector:from:!changes!private! !
renameClass:to:around:!changes!public! !
renameClassVariable:to:in:around:!changes!private! !
renameInstanceVariable:to:in:around:!changes!private! !
reparentClasses:to:!changes!public! !
rootClasses!accessing/classes!public! !
rootNamespace!accessing/classes!public! !
setEnvironment:!initialize/release!private! !
smalltalkNamespace!accessing/classes!public! !
upgradePackage:!changes!public! !
!

!Refactory.Browser.RBModel class methodsFor!

new
	^self onEnvironment: BrowserEnvironment new!

onEnvironment: aBrowserEnvironment
	^self basicNew
		setEnvironment: aBrowserEnvironment;
		yourself! !
!Refactory.Browser.RBModel class categoriesForMethods!
new!instance creation!public! !
onEnvironment:!instance creation!public! !
!

