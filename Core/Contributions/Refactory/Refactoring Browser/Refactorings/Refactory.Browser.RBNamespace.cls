"Filed out from Dolphin Smalltalk 7"!

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
					[((seen includes: each fullName) or: [self hasRemoved: each instanceClass fullName])
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
		ifTrue: [self metaclassNamed: nonMetaclass fullName]
		ifFalse: [self classNamed: nonMetaclass fullName]!

classNamed: aString
	| index |
	aString isNil ifTrue: [^nil].
	(self hasRemoved: aString) ifTrue: [^nil].
	(newClasses lookup: aString) ifNotNil: [:behaviors | ^behaviors first].
	(changedClasses lookup: aString) ifNotNil: [:behaviors | ^behaviors first].
	index := aString indexOf: $\x20.
	^index ~~ 0
		ifTrue: 
			[(self classNamed: (aString copyFrom: 1 to: index - 1) asSymbol)
				ifNotNil: [:class | class metaclass]]
		ifFalse: 
			[(environment lookup: aString)
				ifNotNil: 
					[:class |
					"The environment could be the SystemDictionary, and may return non-Class objects, or a BrowserEnvironment, which won't, so we need to check it is a class"
					(class isBehavior and: 
							[aString
								= ((BindingReference isQualifiedName: aString) ifTrue: [class fullName] ifFalse: [class fullName])])
						ifTrue: 
							[| behaviors |
							behaviors := self createNewClassFor: class.
							class isMeta ifTrue: [behaviors last] ifFalse: [behaviors first]]]]!

comment: aString in: aClass
	^ changes comment: aString in: aClass!

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
	^changedClasses at: aBehavior instanceClass fullName put: {nonMeta. meta}!

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
	newClass classVariableNames: change classVariableNames copy.
	newClass imports: change imports copy.
	newClass category: change category.
	^change!

environment
	^environment!

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
			((each directlyDefinesMethod: aSelector) and: [environment includesSelector: aSelector in: each])
				ifTrue: [classes add: each]].
	^classes!

removeClass: aRBClass 
	self removeClassNamed: aRBClass name!

removeClassNamed: aSymbol
	(self classNamed: aSymbol) subclasses do: [:each | self removeClassNamed: each fullName].
	removedClasses
		add: aSymbol;
		add: aSymbol , ' class'.
	newClasses removeKey: aSymbol ifAbsent: [].
	changedClasses removeKey: aSymbol ifAbsent: [].
	self flushCaches.
	^changes removeClassNamed: aSymbol!

removeClassVariable: aString from: aRBClass 
	^changes removeClassVariable: aString from: aRBClass!

removeImport: aBindingReference from: aRBClass
	^changes removeImport: aBindingReference from: aRBClass!

removeInstanceVariable: aString from: aRBClass 
	^changes removeInstanceVariable: aString from: aRBClass!

removeMethod: aSelector from: aRBClass 
	self flushCaches.
	^changes removeMethod: aSelector from: aRBClass!

renameClass: aRBClass to: aSymbol around: aBlock
	| change value dict |
	change := RenameClassChange rename: aRBClass fullName to: aSymbol.
	self performChange: change around: aBlock.
	self flushCaches.
	dict := (newClasses includesKey: aRBClass fullName) ifTrue: [newClasses] ifFalse: [changedClasses].
	removedClasses
		add: aRBClass name;
		add: aRBClass name , ' class'.
	value := dict at: aRBClass fullName.
	dict removeKey: aRBClass fullName.
	dict at: aSymbol put: value.
	value first shortName: aSymbol.
	value last shortName: aSymbol.
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
!Refactory.Browser.RBNamespace categoriesFor: #addChangeToClass:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #addClassVariable:to:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #addImport:to:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #addInstanceVariable:to:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #allClassesDo:!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #allImplementorsOf:!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #allReferencesTo:do:!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #allReferencesToClass:do:!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #changeClass:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #changes!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #changes:!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #classFor:!accessing/classes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #classNamed:!accessing/classes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #comment:in:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #compile:in:classified:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #createNewClassFor:!accessing/classes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #defineClass:!changes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #environment!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #flushCaches!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #hasCreatedClassFor:!helpers!private! !
!Refactory.Browser.RBNamespace categoriesFor: #hasRemoved:!public!testing! !
!Refactory.Browser.RBNamespace categoriesFor: #includesClassNamed:!public!testing! !
!Refactory.Browser.RBNamespace categoriesFor: #includesGlobal:!public!testing! !
!Refactory.Browser.RBNamespace categoriesFor: #metaclassNamed:!accessing/classes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #name!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #name:!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #performChange:around:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #privateImplementorsOf:!helpers!private! !
!Refactory.Browser.RBNamespace categoriesFor: #removeClass:!changes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #removeClassNamed:!changes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #removeClassVariable:from:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #removeImport:from:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #removeInstanceVariable:from:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #removeMethod:from:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #renameClass:to:around:!changes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #renameClassVariable:to:in:around:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #renameInstanceVariable:to:in:around:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #reparentClasses:to:!changes!public! !
!Refactory.Browser.RBNamespace categoriesFor: #replaceClassNameIn:to:!changes!private! !
!Refactory.Browser.RBNamespace categoriesFor: #rootClasses!accessing!public! !
!Refactory.Browser.RBNamespace categoriesFor: #setEnvironment:!initialize/release!private! !
!Refactory.Browser.RBNamespace categoriesFor: #whichCategoryIncludes:!accessing/classes!public! !

!Refactory.Browser.RBNamespace class methodsFor!

new
	^self onEnvironment: BrowserEnvironment new!

onEnvironment: aBrowserEnvironment
	^self basicNew
		setEnvironment: aBrowserEnvironment;
		yourself! !
!Refactory.Browser.RBNamespace class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.RBNamespace class categoriesFor: #onEnvironment:!instance creation!public! !

