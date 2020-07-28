"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RBNamespace
	instanceVariableNames: 'changes environment newClasses removedClasses changedClasses rootClasses implementorsCache sendersCache'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBNamespace guid: (GUID fromString: '{e04ee960-3b00-47a4-b10a-e93cb600dad5}')!
RBNamespace comment: ''!
!RBNamespace categoriesForClass!Refactory-Model! !
!RBNamespace methodsFor!

addChangeToClass: aRBClass
	^changedClasses at: aRBClass name put: {aRBClass nonMetaclass. aRBClass metaclass}!

addClassVariable: aString to: aRBClass 
	^changes addClassVariable: aString to: aRBClass!

addInstanceVariable: aString to: aRBClass 
	^changes addInstanceVariable: aString to: aRBClass!

addPool: aString to: aRBClass 
	^changes addPool: aString to: aRBClass!

allClassesDo: aBlock
	| seen evalBlock |
	seen := IdentitySet new.
	evalBlock := 
			[:each |
			seen add: each first name.
			aBlock
				value: each first;
				value: each last].
	newClasses do: evalBlock.
	changedClasses do: evalBlock.
	environment classesDo: 
			[:each |
			each isMeta
				ifFalse: 
					[((seen includes: each name) or: [self hasRemoved: each instanceClass name])
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
			(each whichSelectorsReferToClass: aRBClass) 
				do: [:sel | aBlock value: (each methodFor: sel)]]!

changeClass: aRBClass
	changedClasses at: aRBClass name put: {aRBClass nonMetaclass. aRBClass metaclass}.
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
		ifTrue: [self metaclassNamed: nonMetaclass name]
		ifFalse: [self classNamed: nonMetaclass name]!

classNamed: aSymbol
	| index |
	aSymbol isNil ifTrue: [^nil].
	(self hasRemoved: aSymbol) ifTrue: [^nil].
	(newClasses lookup: aSymbol) ifNotNil: [:behaviors | ^behaviors first].
	(changedClasses lookup: aSymbol) ifNotNil: [:behaviors | ^behaviors first].
	index := aSymbol indexOf: $\x20.
	^index ~~ 0
		ifTrue: 
			[(self classNamed: (aSymbol copyFrom: 1 to: index - 1) asSymbol)
				ifNotNil: [:class | class metaclass]]
		ifFalse: 
			[(environment lookup: aSymbol)
				ifNotNil: 
					[:class |
					"The environment could be the SystemDictionary, and may return non-Class objects, or a BrowserEnvironment, which won't, so we need to check it is a class"
					class isBehavior
						ifTrue: 
							[| behaviors |
							behaviors := self createNewClassFor: class.
							class isMeta ifTrue: [behaviors last] ifFalse: [behaviors first]]]]!

compile: aString in: aRBClass classified: aSymbol 
	| change |
	change := changes 
				compile: aString
				in: aRBClass
				classified: aSymbol.
	self flushCaches.
	^change!

createNewClassFor: aBehavior
	| nonMeta meta |
	nonMeta := (RBClass existing: aBehavior)
				model: self;
				yourself.
	meta := (RBMetaclass existing: aBehavior)
				model: self;
				yourself.
	^changedClasses at: aBehavior instanceClass name put: {nonMeta. meta}!

defineClass: aString
	| change newClass newClassName |
	change := changes defineClass: aString.
	newClassName := change changeClassName.
	newClass := self classNamed: newClassName.
	newClass isNil
		ifTrue: 
			[| newMetaclass |
			removedClasses
				remove: newClassName ifAbsent: [];
				remove: newClassName , ' class' ifAbsent: [].
			newClass := RBClass named: newClassName.
			newMetaclass := RBMetaclass named: newClassName.
			newClass model: self.
			newMetaclass model: self.
			newClasses at: newClassName put: {newClass. newMetaclass}].
	newClass superclass: (self classNamed: change superclassName).
	newClass superclass isNil
		ifTrue: 
			[self rootClasses add: newClass.
			newClass metaclass superclass: (self classFor: Object class superclass)]
		ifFalse: [newClass metaclass superclass: newClass superclass metaclass].
	newClass instanceVariableNames: change instanceVariableNames.
	newClass classVariableNames: change classVariableNames.
	newClass poolDictionaryNames: change poolDictionaryNames.
	newClass category: change category.
	^change!

environment
	^environment!

environment: aBrowserEnvironment 
	environment := aBrowserEnvironment!

flushCaches
	implementorsCache := IdentityDictionary new.
	sendersCache := IdentityDictionary new!

hasCreatedClassFor: aBehavior
	| className |
	className := aBehavior instanceClass name.
	^(newClasses includesKey: className) or: [changedClasses includesKey: className]!

hasRemoved: aSymbol 
	^removedClasses includes: aSymbol!

includesClassNamed: aSymbol 
	^(self classNamed: aSymbol) notNil!

includesGlobal: aSymbol 
	(self hasRemoved: aSymbol) ifTrue: [^false].
	(self includesClassNamed: aSymbol) ifTrue: [^true].
	environment at: aSymbol ifAbsent: [^false].
	^true!

initialize
	changes := CompositeRefactoryChange new.
	environment := BrowserEnvironment new.
	newClasses := IdentityDictionary new.
	changedClasses := IdentityDictionary new.
	removedClasses := Set new.
	implementorsCache := IdentityDictionary new.
	sendersCache := IdentityDictionary new!

metaclassNamed: aSymbol
	aSymbol isNil ifTrue: [^nil].
	(self hasRemoved: aSymbol) ifTrue: [^nil].
	(newClasses lookup: aSymbol) ifNotNil: [:behaviors | ^behaviors last].
	(changedClasses lookup: aSymbol) ifNotNil: [:behaviors | ^behaviors last].
	(environment lookup: aSymbol)
		ifNotNil: [:class | class isBehavior ifTrue: [^(self createNewClassFor: class) last]].
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
			((each directlyDefinesMethod: aSelector) 
				and: [environment includesSelector: aSelector in: each]) 
					ifTrue: [classes add: each]].
	^classes!

removeClass: aRBClass 
	self removeClassNamed: aRBClass name!

removeClassNamed: aSymbol 
	(self classNamed: aSymbol) subclasses 
		do: [:each | self removeClassNamed: each name].
	removedClasses
		add: aSymbol;
		add: aSymbol , ' class'.
	newClasses removeKey: aSymbol ifAbsent: [].
	changedClasses removeKey: aSymbol ifAbsent: [].
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
	| change value dict |

	change := RenameClassChange rename: aRBClass name to: aSymbol.
	self performChange: change around: aBlock.
	self flushCaches.
	dict := (newClasses includesKey: aSymbol) 
				ifTrue: [newClasses]
				ifFalse: [changedClasses].
	removedClasses
		add: aRBClass name;
		add: aRBClass name , ' class'.
	value := dict at: aRBClass name.
	dict removeKey: aRBClass name.
	dict at: aSymbol put: value.
	value first name: aSymbol.
	value last name: aSymbol.
	value first subclasses do: [:each | each superclass: value first].
	value last subclasses do: [:each | each superclass: value last].
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
						to: newClass name)]!

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
					(class notNil and: [class superclass isNil]) 
						ifTrue: [rootClasses add: class]]].
	^rootClasses!

whichCategoryIncludes: aSymbol
	^self environment whichCategoryIncludes: aSymbol! !
!RBNamespace categoriesFor: #addChangeToClass:!changes!private! !
!RBNamespace categoriesFor: #addClassVariable:to:!changes!private! !
!RBNamespace categoriesFor: #addInstanceVariable:to:!changes!private! !
!RBNamespace categoriesFor: #addPool:to:!changes!private! !
!RBNamespace categoriesFor: #allClassesDo:!accessing!public! !
!RBNamespace categoriesFor: #allImplementorsOf:!accessing!public! !
!RBNamespace categoriesFor: #allReferencesTo:do:!accessing!public! !
!RBNamespace categoriesFor: #allReferencesToClass:do:!accessing!public! !
!RBNamespace categoriesFor: #changeClass:!changes!private! !
!RBNamespace categoriesFor: #changes!accessing!public! !
!RBNamespace categoriesFor: #changes:!accessing!public! !
!RBNamespace categoriesFor: #classFor:!accessing/classes!public! !
!RBNamespace categoriesFor: #classNamed:!accessing/classes!public! !
!RBNamespace categoriesFor: #compile:in:classified:!changes!private! !
!RBNamespace categoriesFor: #createNewClassFor:!accessing/classes!public! !
!RBNamespace categoriesFor: #defineClass:!changes!public! !
!RBNamespace categoriesFor: #environment!accessing!public! !
!RBNamespace categoriesFor: #environment:!accessing!public! !
!RBNamespace categoriesFor: #flushCaches!changes!private! !
!RBNamespace categoriesFor: #hasCreatedClassFor:!helpers!private! !
!RBNamespace categoriesFor: #hasRemoved:!public!testing! !
!RBNamespace categoriesFor: #includesClassNamed:!public!testing! !
!RBNamespace categoriesFor: #includesGlobal:!public!testing! !
!RBNamespace categoriesFor: #initialize!initialize/release!public! !
!RBNamespace categoriesFor: #metaclassNamed:!accessing/classes!public! !
!RBNamespace categoriesFor: #name!accessing!public! !
!RBNamespace categoriesFor: #name:!accessing!public! !
!RBNamespace categoriesFor: #performChange:around:!changes!private! !
!RBNamespace categoriesFor: #privateImplementorsOf:!helpers!private! !
!RBNamespace categoriesFor: #removeClass:!changes!public! !
!RBNamespace categoriesFor: #removeClassNamed:!changes!public! !
!RBNamespace categoriesFor: #removeClassVariable:from:!changes!private! !
!RBNamespace categoriesFor: #removeInstanceVariable:from:!changes!private! !
!RBNamespace categoriesFor: #removeMethod:from:!changes!private! !
!RBNamespace categoriesFor: #renameClass:to:around:!changes!public! !
!RBNamespace categoriesFor: #renameClassVariable:to:in:around:!changes!private! !
!RBNamespace categoriesFor: #renameInstanceVariable:to:in:around:!changes!private! !
!RBNamespace categoriesFor: #reparentClasses:to:!changes!public! !
!RBNamespace categoriesFor: #replaceClassNameIn:to:!changes!private! !
!RBNamespace categoriesFor: #rootClasses!accessing!public! !
!RBNamespace categoriesFor: #whichCategoryIncludes:!accessing/classes!public! !

!RBNamespace class methodsFor!

new
	^(super new)
		initialize;
		yourself!

onEnvironment: aBrowserEnvironment 
	^(self new)
		environment: aBrowserEnvironment;
		yourself! !
!RBNamespace class categoriesFor: #new!instance creation!public! !
!RBNamespace class categoriesFor: #onEnvironment:!instance creation!public! !

