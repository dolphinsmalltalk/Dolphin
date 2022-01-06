"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RBModel'
	instanceVariableNames: 'changes environment newClasses removedClasses modelClasses rootClasses implementorsCache sendersCache enumerating'
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

addImport: aBindingReference to: aRBClass
	^changes addImport: aBindingReference to: aRBClass!

addInstanceVariable: aString to: aRBClass 
	^changes addInstanceVariable: aString to: aRBClass!

allClassesDo: aBlock
	| seen |
	seen := Set new: 128.
	newClasses do: 
			[:each |
			seen add: each fullName.
			aBlock
				value: each;
				value: each metaclass].
	seen addAll: removedClasses.
	environment classesDo: 
			[:each |
			| fullName |
			(each isMeta or: [seen includes: (fullName := each fullName)])
				ifFalse: 
					[| class |
					class := (modelClasses lookup: fullName)
								ifNil: [modelClasses at: fullName put: (each rbClass model: self existing: each)].
					aBlock
						value: class;
						value: class metaclass]]!

allImplementorsOf: aSelector
	^(implementorsCache ifNil: [implementorsCache := IdentityDictionary new]) at: aSelector
		ifAbsentPutClean: [self privateImplementorsOf: aSelector]!

allReferencesTo: aSymbol
	^(sendersCache ifNil: [sendersCache := IdentityDictionary new]) at: aSymbol
		ifAbsentPutClean: 
			[| refs |
			refs := OrderedCollection new.
			self allClassesDo: 
					[:each |
					#rbFix.	"Don't include any selectors which should not be visible in the model's environment"
					refs addAll: ((each whichMethodsReferToSymbol: aSymbol)
								select: [:eachMethod | environment includesSelector: eachMethod selector in: each])].
			refs]!

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
	self allClassesDo: [:each | (each whichMethodsReferToClass: aRBClass) do: aBlock]!

changes
	^changes!

changes: aCompositeRefactoryChange 
	changes := aCompositeRefactoryChange!

classFor: aBehavior
	aBehavior ifNil: [^nil].
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

defineClass: aString
	| change newClass newClassName |
	change := changes defineClass: aString.
	newClassName := change changeClassName.
	newClass := self instanceClassNamed: newClassName.
	newClass
		ifNil: 
			[removedClasses remove: newClassName ifAbsent: nil.
			newClass := RBClass model: self named: newClassName.
			newClasses at: newClassName put: newClass.
			newClass environment addClass: newClass].
	newClass superclass: (self instanceClassNamed: change superclassName).
	newClass superclass ifNil: [self rootClasses add: newClass].
	newClass instanceVariableNames: change instanceVariableNames.
	newClass classVariableNames: change classVariableNames copy.
	newClass classConstants: change classConstants.
	newClass imports: change imports copy.
	newClass category: change category.
	^change!

definesStaticVariable: aString
	"Is the argument the name of a variable defined in this model? See also #includesStaticVariable:"

	| binding |
	(self hasRemoved: aString) ifTrue: [^false].
	(newClasses lookup: aString) ifNotNil: [^true].
	binding := environment associationAt: aString.
	^binding notNil and: 
			[binding fullName = aString or: 
					[| ref |
					ref := aString asQualifiedReference.
					ref unqualifiedName = binding key and: [ref environment == binding environment]]]!

environment
	^environment!

flushCaches
	implementorsCache := sendersCache := nil!

hasRemoved: aString
	^removedClasses includes: aString!

includesClassNamed: aString
	^(self classNamed: aString) notNil!

includesStaticVariable: aString
	"Does the argument resolve to a static variable in the receiver? See also #definesStaticVariable:"

	(self hasRemoved: aString) ifTrue: [^false].
	(newClasses lookup: aString) ifNotNil: [^true].
	^(environment associationAt: aString) notNil!

instanceClassFor: aClass
	| fullName |
	fullName := aClass fullName.
	(removedClasses includes: fullName) ifTrue: [^nil].
	(newClasses lookup: fullName) ifNotNil: [:class | ^class].
	"modelClasses may contain classes that are not in the environment (e.g. namespaces), so we check that first"
	((environment includesClass: aClass) or: [environment includesClass: aClass class]) ifFalse: [^nil].
	^(modelClasses lookup: fullName)
		ifNil: [modelClasses at: fullName put: (aClass rbClass model: self existing: aClass)]!

instanceClassNamed: aString
	| binding class |
	(removedClasses includes: aString) ifTrue: [^nil].
	(newClasses lookup: aString) ifNotNil: [:newClass | ^newClass].
	binding := environment associationAt: aString.
	(binding isNil or: [binding isClassBinding not]) ifTrue: [^nil].
	(class := binding value) fullName = aString ifFalse: [^nil].
	^(modelClasses lookup: aString)
		ifNil: [modelClasses at: aString put: (class rbClass model: self existing: class)]!

metaclassNamed: aString
	^(self instanceClassNamed: aString) ifNotNil: [:class | class metaclass]!

methodsToRewriteForRenameOf: aRBClass
	| methods inbound block |
	methods := self allReferencesToClass: aRBClass.
	inbound := SearchPolicy method newSet.
	inbound addAll: methods.
	block := 
			[:method |
			(inbound includes: method)
				ifFalse: 
					[method boundParseTree.
					methods addLast: method]].
	#namespaceToDo.	"A subclass may refer to external variables that it can only bind via an import that it inherits via the namespace of its superclass (if different to its own). There is therefore (rare) potential for external references in subclasses to be affected by a class rename when that rename moves a class to a new namespace. Enumerating all subclasses could be prohibitively expensive with the current search, however, as it is too broad in scope. If we were to rename Object, for example, then a significant proportion of the methods in the entire system would be in scope."
	aRBClass methodsReferencingExternals do: block.
	aRBClass metaclass methodsReferencingExternals do: block.
	^methods!

modelClassFor: aClass
	"Private - Answer an RBClass for the real <Class> argument, whether or not it is in the receiver's environment."

	| fullName |
	fullName := aClass fullName.
	(removedClasses includes: fullName) ifTrue: [^nil].
	^(newClasses lookup: fullName)
		ifNil: 
			[(modelClasses lookup: fullName)
				ifNil: [modelClasses at: fullName put: (aClass rbClass model: self existing: aClass)]]!

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

privateImplementorsOf: aSelector
	| classes |
	classes := Set new.
	self allClassesDo: 
			[:each |
			#rbFix.	"Ignore defining classes where the class/selector pair is not part of the environment"
			((each directlyDefinesMethod: aSelector) and: [environment includesSelector: aSelector in: each])
				ifTrue: [classes add: each]].
	^classes!

removeClass: aRBClass 
	self removeClassNamed: aRBClass name!

removeClassConstant: anAssociation from: aRBClass
	^changes removeClassConstant: anAssociation from: aRBClass!

removeClassNamed: aString
	| removedClass |
	removedClass := self instanceClassNamed: aString.
	removedClass subclasses do: [:each | self removeClassNamed: each fullName].
	removedClasses add: aString.
	newClasses removeKey: aString ifAbsent: nil.
	modelClasses removeKey: aString ifAbsent: nil.
	removedClass environment ifNotNil: [:env | env removeClass: removedClass].
	self flushCaches.
	^changes removeClassNamed: aString!

removeClassVariable: aString from: aRBClass 
	^changes removeClassVariable: aString from: aRBClass!

removeInstanceVariable: aString from: aRBClass 
	^changes removeInstanceVariable: aString from: aRBClass!

removeMethod: aSelector from: aRBClass 
	self flushCaches.
	^changes removeMethod: aSelector from: aRBClass!

renameClass: aRBClass to: aString around: aBlock
	| change oldName methods oldUnqualified originalEnvironment binding |
	oldName := aRBClass fullName.
	change := RenameClassChange rename: oldName to: aString.
	"The ordering is tricky here. We want the namespaces to reflect the change so that any attempt to look up the old class name in its old environment will fail, but we need method searches to find references to the old class name. Therefore we have to capture the references in advance of making any model changes."
	methods := self methodsToRewriteForRenameOf: aRBClass.
	oldUnqualified := aRBClass unqualifiedName.
	originalEnvironment := aRBClass environment.
	self assert: [(originalEnvironment localBindingFor: oldUnqualified) value == aRBClass].
	"Apply the name change in the model class and the model namespaces"
	aRBClass name: aString.
	binding := originalEnvironment removeBindingFor: oldUnqualified.
	self assert: [binding value == aRBClass].
	binding setKey: aRBClass unqualifiedName.
	aRBClass environment addBinding: binding.
	removedClasses add: oldName.
	((newClasses includesKey: oldName) ifTrue: [newClasses] ifFalse: [modelClasses]) removeKey: oldName.
	newClasses at: aString put: aRBClass.
	aRBClass subclasses do: [:each | each superclass: aRBClass].
	self performChange: change around: [aBlock value: methods].
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
			self defineClass: (self replaceClassNameIn: aClass definitionString
						to: newClass fullName)]!

replaceClassNameIn: definitionString to: aSymbol 
	| parseTree |
	parseTree := RBParser parseExpression: definitionString.
	parseTree receiver: (RBVariableNode named: aSymbol).
	^parseTree formattedCode!

rootClasses
	rootClasses isNil
		ifTrue: 
			[rootClasses := OrderedCollection new.
			Class rootsOfTheWorld do: 
					[:each |
					| class |
					class := self instanceClassFor: each.
					(class notNil and: [class superclass isNil]) ifTrue: [rootClasses add: class]]].
	^rootClasses!

setEnvironment: aBrowserEnvironment
	changes := CompositeRefactoryChange new.
	environment := aBrowserEnvironment.
	newClasses := LookupTable new.
	modelClasses := LookupTable new.
	removedClasses := Set new.
	self flushCaches!

smalltalkNamespace
	^self modelClassFor: Smalltalk!

whichCategoryIncludes: aSymbol
	^self environment whichCategoryIncludes: aSymbol! !
!Refactory.Browser.RBModel categoriesForMethods!
addClassConstant:to:!changes!private! !
addClassVariable:to:!changes!private! !
addImport:to:!changes!private! !
addInstanceVariable:to:!changes!private! !
allClassesDo:!accessing!public! !
allImplementorsOf:!accessing!public! !
allReferencesTo:!accessing!public! !
allReferencesToClass:!helpers!private! !
allReferencesToClass:do:!accessing!public! !
changes!accessing!public! !
changes:!accessing!public! !
classFor:!accessing/classes!public! !
classNamed:!accessing/classes!public! !
comment:in:!changes!private! !
compile:in:categories:!changes!private! !
compile:in:environment:categories:package:!public! !
defineClass:!changes!public! !
definesStaticVariable:!public!testing! !
environment!accessing!public! !
flushCaches!changes!private! !
hasRemoved:!public!testing! !
includesClassNamed:!public!testing! !
includesStaticVariable:!public!testing! !
instanceClassFor:!accessing/classes!public! !
instanceClassNamed:!accessing/classes!public! !
metaclassNamed:!accessing/classes!public! !
methodsToRewriteForRenameOf:!changes!private! !
modelClassFor:!accessing/classes!private! !
name!accessing!public! !
name:!accessing!public! !
performChange:around:!changes!private! !
privateImplementorsOf:!helpers!private! !
removeClass:!changes!public! !
removeClassConstant:from:!changes!private! !
removeClassNamed:!changes!public! !
removeClassVariable:from:!changes!private! !
removeInstanceVariable:from:!changes!private! !
removeMethod:from:!changes!private! !
renameClass:to:around:!changes!public! !
renameClassVariable:to:in:around:!changes!private! !
renameInstanceVariable:to:in:around:!changes!private! !
reparentClasses:to:!changes!public! !
replaceClassNameIn:to:!changes!private! !
rootClasses!accessing!public! !
setEnvironment:!initialize/release!private! !
smalltalkNamespace!accessing!public! !
whichCategoryIncludes:!accessing/classes!public! !
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

