"Filed out from Dolphin Smalltalk 7"!

ClassRefactoring subclass: #ChildrenToSiblingsRefactoring
	instanceVariableNames: 'parent subclasses'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChildrenToSiblingsRefactoring guid: (GUID fromString: '{23f61ab3-e5ef-433b-821d-21c019236bef}')!
ChildrenToSiblingsRefactoring comment: ''!
!ChildrenToSiblingsRefactoring categoriesForClass!Refactory-Refactorings! !
!ChildrenToSiblingsRefactoring methodsFor!

abstractSuperclass
	^self model classNamed: className asSymbol!

addSuperclass
	self performComponentRefactoring: (AddClassRefactoring
				model: self model
				addClass: className
				superclass: parent superclass
				subclasses: {parent}
				category: parent category)!

changeIsKindOfReferences
	| replacer |
	replacer := ParseTreeRewriter new.
	replacer replace: '``@object isKindOf: ' , parent name
		with: '``@object isKindOf: ' , className.
	self convertAllReferencesToClass: parent using: replacer!

computeSubclassSupersOf: aClass 
	| selectors |
	selectors := Set new.
	aClass subclasses do: 
			[:each | 
			each selectors 
				do: [:sel | selectors addAll: (each parseTreeFor: sel) superMessages]].
	^selectors!

createSubclassResponsibilityFor: aSelector in: aClass 
	| source |
	(aClass superclass definesMethod: aSelector) ifTrue: [^self].
	source := self subclassResponsibilityFor: aSelector in: aClass.
	source isNil ifTrue: [^self].
	aClass superclass compile: source
		classified: (aClass protocolsFor: aSelector)!

name: aClassName class: aClass subclasses: subclassCollection 
	self className: aClassName.
	parent := self model classFor: aClass.
	self subclasses: (subclassCollection collect: [:each | self model classFor: each])!

preconditions
	^subclasses 
		inject: ((RBCondition isMetaclass: parent) 
				errorMacro: 'Superclass must not be a metaclass') not 
				& (RBCondition isValidClassName: className) 
					& (RBCondition isGlobal: className in: self model) not
		into: 
			[:sub :each | 
			sub 
				& ((RBCondition isMetaclass: each) 
						errorMacro: 'Subclass must <1?not :>be a metaclass') not 
					& (RBCondition isImmediateSubclass: each of: parent)]!

pullUpClassInstanceVariables
	| newSuperclass |
	newSuperclass := self abstractSuperclass metaclass.
	parent metaclass instanceVariableNames do: 
			[:each | 
			self performComponentRefactoring: (PullUpInstanceVariableRefactoring 
						model: self model
						variable: each
						class: newSuperclass)]!

pullUpClassVariables
	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent classVariableNames do: 
			[:each | 
			self performComponentRefactoring: (PullUpClassVariableRefactoring 
						model: self model
						variable: each
						class: newSuperclass)]!

pullUpInstanceVariables
	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent instanceVariableNames do: 
			[:each | 
			self performComponentRefactoring: (PullUpInstanceVariableRefactoring 
						model: self model
						variable: each
						class: newSuperclass)]!

pullUpPoolVariables
	"Don't remove the pool variables from the subclass since they might be referenced there."

	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent poolDictionaryNames 
		do: [:each | newSuperclass addPoolDictionary: each]!

pushUp: aSelector in: aClass 
	| source |
	source := aClass sourceCodeFor: aSelector.
	source isNil 
		ifFalse: 
			[aClass superclass compile: source
				classified: (aClass protocolsFor: aSelector)]!

pushUpMethods
	self pushUpMethodsFrom: parent.
	self pushUpMethodsFrom: parent metaclass!

pushUpMethodsFrom: aClass 
	| selectorsToPushUp |
	selectorsToPushUp := self selectorsToPushUpFrom: aClass.
	aClass selectors do: 
			[:each | 
			(selectorsToPushUp includes: each) 
				ifTrue: [self pushUp: each in: aClass]
				ifFalse: [self createSubclassResponsibilityFor: each in: aClass]].
	selectorsToPushUp do: [:each | aClass removeMethod: each]!

pushUpVariables
	self pullUpInstanceVariables.
	self pullUpClassInstanceVariables.
	self pullUpClassVariables.
	self pullUpPoolVariables!

reparentSubclasses
	self model reparentClasses: subclasses to: self abstractSuperclass!

selectorsToPushUpFrom: aClass 
	| superSelectors |
	superSelectors := self computeSubclassSupersOf: aClass.
	^aClass selectors select: 
			[:each | 
			(superSelectors includes: each) or: [self shouldPushUp: each from: aClass]]!

shouldPushUp: aSelector from: aClass 
	^(aClass isMeta 
		ifTrue: [subclasses collect: [:each | each metaclass]]
		ifFalse: [subclasses]) anySatisfy: [:each | (each directlyDefinesMethod: aSelector) not]!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' name: #';
		nextPutAll: className;
		nextPutAll: ' class: '.
	parent storeOn: aStream.
	aStream nextPutAll: ' subclasses: '.
	subclasses asArray storeOn: aStream.
	aStream nextPut: $)!

subclasses
	^subclasses!

subclasses: aCollectionOfRBClasses 
	subclasses := aCollectionOfRBClasses!

subclassResponsibilityFor: aSelector in: aClass 
	| methodNode position source |
	source := aClass sourceCodeFor: aSelector.
	methodNode := RBParser parseMethod: source onError: [:err :pos | ^nil].
	position := methodNode arguments isEmpty 
				ifTrue: [methodNode selectorParts last stop]
				ifFalse: [methodNode arguments last stop].
	^'<1s><n><t>self subclassResponsibility' 
		expandMacrosWith: (source copyFrom: 1 to: position)!

transform
	self
		addSuperclass;
		pushUpVariables;
		pushUpMethods;
		changeIsKindOfReferences;
		reparentSubclasses! !
!ChildrenToSiblingsRefactoring categoriesFor: #abstractSuperclass!accessing!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #addSuperclass!public!transforming! !
!ChildrenToSiblingsRefactoring categoriesFor: #changeIsKindOfReferences!public!transforming! !
!ChildrenToSiblingsRefactoring categoriesFor: #computeSubclassSupersOf:!methods!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #createSubclassResponsibilityFor:in:!methods!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #name:class:subclasses:!initialize/release!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #preconditions!preconditions!public! !
!ChildrenToSiblingsRefactoring categoriesFor: #pullUpClassInstanceVariables!private!variables! !
!ChildrenToSiblingsRefactoring categoriesFor: #pullUpClassVariables!private!variables! !
!ChildrenToSiblingsRefactoring categoriesFor: #pullUpInstanceVariables!private!variables! !
!ChildrenToSiblingsRefactoring categoriesFor: #pullUpPoolVariables!private!variables! !
!ChildrenToSiblingsRefactoring categoriesFor: #pushUp:in:!methods!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #pushUpMethods!public!transforming! !
!ChildrenToSiblingsRefactoring categoriesFor: #pushUpMethodsFrom:!methods!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #pushUpVariables!public!transforming! !
!ChildrenToSiblingsRefactoring categoriesFor: #reparentSubclasses!public!transforming! !
!ChildrenToSiblingsRefactoring categoriesFor: #selectorsToPushUpFrom:!methods!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #shouldPushUp:from:!methods!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #storeOn:!printing!public! !
!ChildrenToSiblingsRefactoring categoriesFor: #subclasses!accessing!public! !
!ChildrenToSiblingsRefactoring categoriesFor: #subclasses:!accessing!public! !
!ChildrenToSiblingsRefactoring categoriesFor: #subclassResponsibilityFor:in:!methods!private! !
!ChildrenToSiblingsRefactoring categoriesFor: #transform!public!transforming! !

!ChildrenToSiblingsRefactoring class methodsFor!

model: aRBNamespace name: aClassName class: aClass subclasses: subclassCollection 
	^(self new)
		model: aRBNamespace;
		name: aClassName
			class: aClass
			subclasses: subclassCollection;
		yourself!

name: aClassName class: aClass subclasses: subclassCollection 
	^(self new)
		name: aClassName
			class: aClass
			subclasses: subclassCollection;
		yourself! !
!ChildrenToSiblingsRefactoring class categoriesFor: #model:name:class:subclasses:!instance creation!public! !
!ChildrenToSiblingsRefactoring class categoriesFor: #name:class:subclasses:!instance creation!public! !

