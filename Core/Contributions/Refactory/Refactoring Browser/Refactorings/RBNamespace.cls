"Filed out from Dolphin Smalltalk"!

Object subclass: #RBNamespace
	instanceVariableNames: 'changes environment newClasses removedClasses changedClasses rootClasses implementorsCache sendersCache'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBNamespace guid: (GUID fromString: '{e04ee960-3b00-47a4-b10a-e93cb600dad5}')!

RBNamespace comment: ''!

!RBNamespace categoriesForClass!Refactory-Model! !

!RBNamespace methodsFor!

addChangeToClass: aRBClass 
	^changedClasses at: aRBClass name
		put: (Array with: aRBClass nonMetaclass with: aRBClass metaclass)!

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
					[((seen includes: each name) or: [self hasRemoved: (self classNameFor: each)]) 
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
	changedClasses at: aRBClass name
		put: (Array with: aRBClass nonMetaclass with: aRBClass metaclass).
	self flushCaches!

changes
	^changes!

changes: aCompositeRefactoryChange 
	changes := aCompositeRefactoryChange!

classFor: aBehavior 
	| nonMetaclass |
	aBehavior isNil ifTrue: [^nil].
	nonMetaclass := aBehavior isMeta 
				ifTrue: [aBehavior soleInstance]
				ifFalse: [aBehavior].
	^aBehavior isMeta 
		ifTrue: [self metaclassNamed: nonMetaclass name]
		ifFalse: [self classNamed: nonMetaclass name]!

classNamed: aSymbol
	| class index |
	aSymbol isNil ifTrue: [^nil].
	(self hasRemoved: aSymbol) ifTrue: [^nil].
	(newClasses lookup: aSymbol) ifNotNil: [:behaviors | ^behaviors first].
	(changedClasses lookup: aSymbol) ifNotNil: [:behaviors | ^behaviors first].
	(class := environment at: aSymbol ifAbsent: []) isBehavior
		ifTrue: 
			[| classes |
			classes := self createNewClassFor: class.
			^class isMeta ifTrue: [classes last] ifFalse: [classes first]].
	index := aSymbol indexOfSubCollection: ' class' startingAt: 1.
	^index ~~ 0
		ifTrue: 
			[class := self classNamed: (aSymbol copyFrom: 1 to: index - 1) asSymbol.
			class isNil ifTrue: [nil] ifFalse: [class metaclass]]!

classNameFor: aBehavior 
	^(aBehavior isMeta ifTrue: [aBehavior soleInstance] ifFalse: [aBehavior]) 
		name!

compile: aString in: aRBClass classified: aSymbol 
	| change |
	change := changes 
				compile: aString
				in: aRBClass
				classified: aSymbol.
	self flushCaches.
	^change!

createNewClassFor: aBehavior 
	| nonMeta meta className |
	className := (aBehavior isMeta 
				ifTrue: [aBehavior soleInstance]
				ifFalse: [aBehavior]) name.
	nonMeta := (RBClass existingNamed: className)
				model: self;
				yourself.
	meta := (RBMetaclass existingNamed: className)
				model: self;
				yourself.
	^changedClasses at: className put: (Array with: nonMeta with: meta)!

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
			newClasses at: newClassName put: (Array with: newClass with: newMetaclass)].
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
	className := self classNameFor: aBehavior.
	^(newClasses includesKey: className) 
		or: [changedClasses includesKey: className]!

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
	| class |
	aSymbol isNil ifTrue: [^nil].
	(self hasRemoved: aSymbol) ifTrue: [^nil].
	(newClasses includesKey: aSymbol) ifTrue: [^(newClasses at: aSymbol) last].
	(changedClasses includesKey: aSymbol) 
		ifTrue: [^(changedClasses at: aSymbol) last].
	(class := environment at: aSymbol ifAbsent: [nil]) isBehavior 
		ifTrue: [^(self createNewClassFor: class) last].
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

!RBNamespace categoriesForMethods!
addChangeToClass:!changes!private! !
addClassVariable:to:!changes!private! !
addInstanceVariable:to:!changes!private! !
addPool:to:!changes!private! !
allClassesDo:!accessing!public! !
allImplementorsOf:!accessing!public! !
allReferencesTo:do:!accessing!public! !
allReferencesToClass:do:!accessing!public! !
changeClass:!changes!private! !
changes!accessing!public! !
changes:!accessing!public! !
classFor:!accessing/classes!public! !
classNamed:!accessing/classes!public! !
classNameFor:!helpers!private! !
compile:in:classified:!changes!private! !
createNewClassFor:!accessing/classes!public! !
defineClass:!changes!public! !
environment!accessing!public! !
environment:!accessing!public! !
flushCaches!changes!private! !
hasCreatedClassFor:!helpers!private! !
hasRemoved:!public!testing! !
includesClassNamed:!public!testing! !
includesGlobal:!public!testing! !
initialize!initialize/release!public! !
metaclassNamed:!accessing/classes!public! !
name!accessing!public! !
name:!accessing!public! !
performChange:around:!changes!private! !
privateImplementorsOf:!helpers!private! !
removeClass:!changes!public! !
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
whichCategoryIncludes:!accessing/classes!public! !
!

!RBNamespace class methodsFor!

new
	^(super new)
		initialize;
		yourself!

onEnvironment: aBrowserEnvironment 
	^(self new)
		environment: aBrowserEnvironment;
		yourself! !

!RBNamespace class categoriesForMethods!
new!instance creation!public! !
onEnvironment:!instance creation!public! !
!

