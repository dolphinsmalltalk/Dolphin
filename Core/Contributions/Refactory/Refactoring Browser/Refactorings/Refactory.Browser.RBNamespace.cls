"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RBNamespace'
	instanceVariableNames: 'changes environment newClasses removedClasses changedClasses rootClasses implementorsCache sendersCache'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBNamespace guid: (Core.GUID fromString: '{e04ee960-3b00-47a4-b10a-e93cb600dad5}')!
Refactory.Browser.RBNamespace comment: ''!
!Refactory.Browser.RBNamespace categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBNamespace methodsFor!

addChangeToClass: aRBClass
	^changedClasses at: aRBClass name put: {aRBClass nonMetaclass. aRBClass metaclass}!

addClassConstant: anAssociation to: aRBClass
	^changes addClassConstant: anAssociation to: aRBClass!

addClassVariable: aString to: aRBClass 
	^changes addClassVariable: aString to: aRBClass!

addImport: aBindingReference to: aRBClass
	^changes addImport: aBindingReference to: aRBClass!

addInstanceVariable: aString to: aRBClass 
	^changes addInstanceVariable: aString to: aRBClass!

allClassesDo: aBlock
	| seen evalBlock |
	seen := Set new.
	evalBlock := 
			[:each |
			seen add: each name.
			aBlock
				value: each;
				value: each metaclass].
	newClasses do: evalBlock.
	changedClasses do: evalBlock.
	environment classesDo: 
			[:each |
			each isMeta
				ifFalse: 
					[((seen includes: each fullName) or: [self hasRemoved: each fullName])
						ifFalse: 
							[| class |
							class := self classFor: each.
							aBlock
								value: class;
								value: class metaclass]]]!

allImplementorsOf: aSelector 
	^implementorsCache at: aSelector
		ifAbsentPut: [self privateImplementorsOf: aSelector]!

allReferencesTo: aSymbol do: aBlock
	(sendersCache at: aSymbol
		ifAbsentPut: 
			[| refs |
			refs := OrderedCollection new.
			self allClassesDo: 
					[:each |
					#rbFix.	"Don't include any selectors which should not be visible in the model's environment"
					refs addAll: ((each whichMethodsReferToSymbol: aSymbol)
								select: [:eachMethod | environment includesSelector: eachMethod selector in: each])].
			refs])
			do: aBlock!

allReferencesToClass: aRBClass do: aBlock
	self allClassesDo: 
			[:each |
			(each whichSelectorsReferToClass: aRBClass) do: [:sel | aBlock value: (each methodFor: sel)]]!

changeClass: aRBClass
	changedClasses at: aRBClass name put: aRBClass nonMetaclass.
	self flushCaches!

changes
	^changes!

changes: aCompositeRefactoryChange 
	changes := aCompositeRefactoryChange!

classFor: aBehavior
	| nonMetaclass |
	aBehavior isNil ifTrue: [^nil].
	nonMetaclass := aBehavior instanceClass.
	^aBehavior isMeta
		ifTrue: [self metaclassNamed: nonMetaclass fullName]
		ifFalse: [self classNamed: nonMetaclass fullName]!

classNamed: aString
	| index |
	aString isNil ifTrue: [^nil].
	(self hasRemoved: aString) ifTrue: [^nil].
	(newClasses lookup: aString) ifNotNil: [:class | ^class].
	(changedClasses lookup: aString) ifNotNil: [:class | ^class].
	index := aString indexOf: $\x20.
	^index ~~ 0
		ifTrue: [(self classNamed: (aString copyFrom: 1 to: index - 1)) ifNotNil: [:class | class metaclass]]
		ifFalse: 
			[(environment associationAt: aString)
				ifNotNil: 
					[:binding |
					| class |
					class := binding value.
					"The environment could be the SystemDictionary, and may return non-Class objects, or a BrowserEnvironment, which won't, so we need to check it is a class"
					(class isBehavior and: [class fullName = aString])
						ifTrue: 
							[| nonMeta |
							nonMeta := self createNewClassFor: class.
							class isMeta ifTrue: [nonMeta metaclass] ifFalse: [nonMeta]]]]!

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

createNewClassFor: aBehavior
	| nonMeta instanceClass |
	instanceClass := aBehavior instanceClass.
	nonMeta := instanceClass rbClass existing: instanceClass.
	nonMeta
		model: self;
		metaclass: ((RBMetaclass existing: instanceClass)
					model: self;
					nonMetaclass: nonMeta;
					yourself).
	^changedClasses at: instanceClass fullName put: nonMeta!

defineClass: aString
	| change newClass newClassName |
	change := changes defineClass: aString.
	newClassName := change changeClassName.
	newClass := self classNamed: newClassName.
	newClass isNil
		ifTrue: 
			[| newMetaclass |
			removedClasses remove: newClassName ifAbsent: nil.
			newClass := RBClass named: newClassName.
			newMetaclass := RBMetaclass named: newClassName.
			newClass
				model: self;
				metaclass: newMetaclass.
			newMetaclass
				model: self;
				nonMetaclass: newClass.
			newClasses at: newClassName put: newClass.
			newClass environment addClass: newClass].
	newClass superclass: (self classNamed: change superclassName).
	newClass superclass isNil
		ifTrue: 
			[self rootClasses add: newClass.
			newClass metaclass superclass: (self classFor: Object class superclass)]
		ifFalse: [newClass metaclass superclass: newClass superclass metaclass].
	newClass instanceVariableNames: change instanceVariableNames.
	newClass classVariableNames: change classVariableNames copy.
	newClass imports: change imports copy.
	newClass category: change category.
	^change!

environment
	^environment!

flushCaches
	implementorsCache := IdentityDictionary new.
	sendersCache := IdentityDictionary new!

hasRemoved: aSymbol 
	^removedClasses includes: aSymbol!

includesClassNamed: aSymbol 
	^(self classNamed: aSymbol) notNil!

includesGlobal: aSymbol
	(self hasRemoved: aSymbol) ifTrue: [^false].
	(self includesClassNamed: aSymbol) ifTrue: [^true].
	#namespaceToDo.	"Hack to get renaming classes working. Probably not the right thing to do."
	^(BindingReference isQualifiedName: aSymbol)
		ifTrue: 
			[| nsBinding names |
			"We need to establish if any binding found is actually in the namespace at the end of the path."
			names := BindingReference splitQualifiedName: aSymbol.
			nsBinding := environment associationAt: ($. join: names allButLast).
			nsBinding notNil and: 
					[| ns |
					ns := nsBinding value.
					ns class isMeta and: [(ns localBindingFor: names last) notNil]]]
		ifFalse: [(environment associationAt: aSymbol) notNil]!

metaclassNamed: aSymbol
	aSymbol isNil ifTrue: [^nil].
	(self hasRemoved: aSymbol) ifTrue: [^nil].
	(newClasses lookup: aSymbol) ifNotNil: [:class | ^class metaclass].
	(changedClasses lookup: aSymbol) ifNotNil: [:class | ^class metaclass].
	(environment lookup: aSymbol)
		ifNotNil: [:class | class isBehavior ifTrue: [^(self createNewClassFor: class) metaclass]].
	^nil!

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

removeClassConstant: anAssociation from: anRBClass
	^changes removeClassConstant: anAssociation from: anRBClass!

removeClassNamed: aSymbol
	| removedClass |
	removedClass := self classNamed: aSymbol.
	removedClass subclasses do: [:each | self removeClassNamed: each fullName].
	removedClasses add: aSymbol.
	newClasses removeKey: aSymbol ifAbsent: nil.
	changedClasses removeKey: aSymbol ifAbsent: nil.
	removedClass environment ifNotNil: [:env | env removeVariableNamed: removedClass unqualifiedName].
	self flushCaches.
	^changes removeClassNamed: aSymbol!

removeClassVariable: aString from: aRBClass 
	^changes removeClassVariable: aString from: aRBClass!

removeInstanceVariable: aString from: aRBClass 
	^changes removeInstanceVariable: aString from: aRBClass!

removeMethod: aSelector from: aRBClass 
	self flushCaches.
	^changes removeMethod: aSelector from: aRBClass!

renameClass: aRBClass to: aSymbol around: aBlock
	| change value dict oldName meta refs |
	oldName := aRBClass fullName.
	change := RenameClassChange rename: oldName to: aSymbol.
	"The ordering is tricky here. We want the namespaces to reflect the change so that any attempt to look up the old class name in its old environment will fail, but we need method searches to find references to the old class name. Therefore we have to capture the references in advance of making an model changes."
	refs := OrderedCollection new.
	self allReferencesToClass: aRBClass do: [:each | refs add: each].
	meta := aRBClass metaclass.
	aRBClass environment removeClass: aRBClass.
	aRBClass name: aSymbol.
	aRBClass environment addClass: aRBClass.
	meta name: aSymbol.
	self performChange: change around: [aBlock value: refs].
	self flushCaches.
	dict := (newClasses includesKey: oldName) ifTrue: [newClasses] ifFalse: [changedClasses].
	removedClasses add: oldName.
	value := dict removeKey: oldName.
	dict at: aSymbol put: value.
	value subclasses do: [:each | each superclass: value].
	value metaclass subclasses do: [:each | each superclass: value metaclass].
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
					class := self classFor: each.
					(class notNil and: [class superclass isNil]) ifTrue: [rootClasses add: class]]].
	^rootClasses!

setEnvironment: aBrowserEnvironment
	changes := CompositeRefactoryChange new.
	environment := aBrowserEnvironment.
	newClasses := LookupTable new.
	changedClasses := LookupTable new.
	removedClasses := Set new.
	implementorsCache := IdentityDictionary new.
	sendersCache := IdentityDictionary new!

whichCategoryIncludes: aSymbol
	^self environment whichCategoryIncludes: aSymbol! !
!Refactory.Browser.RBNamespace categoriesForMethods!
addChangeToClass:!changes!private! !
addClassConstant:to:!changes!private! !
addClassVariable:to:!changes!private! !
addImport:to:!changes!private! !
addInstanceVariable:to:!changes!private! !
allClassesDo:!accessing!public! !
allImplementorsOf:!accessing!public! !
allReferencesTo:do:!accessing!public! !
allReferencesToClass:do:!accessing!public! !
changeClass:!changes!private! !
changes!accessing!public! !
changes:!accessing!public! !
classFor:!accessing/classes!public! !
classNamed:!accessing/classes!public! !
comment:in:!changes!private! !
compile:in:categories:!changes!private! !
compile:in:environment:categories:package:!public! !
createNewClassFor:!accessing/classes!public! !
defineClass:!changes!public! !
environment!accessing!public! !
flushCaches!changes!private! !
hasRemoved:!public!testing! !
includesClassNamed:!public!testing! !
includesGlobal:!public!testing! !
metaclassNamed:!accessing/classes!public! !
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
whichCategoryIncludes:!accessing/classes!public! !
!

!Refactory.Browser.RBNamespace class methodsFor!

new
	^self onEnvironment: BrowserEnvironment new!

onEnvironment: aBrowserEnvironment
	^self basicNew
		setEnvironment: aBrowserEnvironment;
		yourself! !
!Refactory.Browser.RBNamespace class categoriesForMethods!
new!instance creation!public! !
onEnvironment:!instance creation!public! !
!

