"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassRefactoring
	subclass: #'Refactory.Browser.ChildrenToSiblingsRefactoring'
	instanceVariableNames: 'parent subclasses'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ChildrenToSiblingsRefactoring guid: (Core.GUID fromString: '{23f61ab3-e5ef-433b-821d-21c019236bef}')!
Refactory.Browser.ChildrenToSiblingsRefactoring comment: ''!
!Refactory.Browser.ChildrenToSiblingsRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ChildrenToSiblingsRefactoring methodsFor!

abstractSuperclass
	^self model classNamed: self className!

addSuperclass
	self performComponentRefactoring: (AddClassRefactoring
				model: self model
				details: ((ClassDetails
						className: self className
						superclass: parent superclass
						categories: parent classCategories)
						package: parent owningPackage;
						isNonInstantiable: true;
						yourself)
				subclasses: {parent})!

changeIsKindOfReferences
	| replacer superclass |
	replacer := ParseTreeRewriter new.
	superclass := model classNamed: self className.
	"A qualified name can be expressed in a number of ways; unqualified, fully-qualified, or partially-qualified. Rather than attempt to match each of these, we use a block rewrite"
	replacer
		replace: '``@object isKindOf: `variable'
		withValueFrom: 
			[:msg |
			| variable |
			variable := msg arguments first.
			msg
				arguments: {(StBasicVariableNode named: (self shortestNameToBind: superclass binding from: variable))
							comments: variable comments;
							yourself}.
			msg]
		when: 
			[:msg |
			| binding |
			"This may be over the top - we can only be here if the method references the class, but maybe an ambiguous partially qualified reference is also present that actually binds more tightly to another variable?"
			binding := msg methodNode fullBindingFor: msg arguments first name.
			binding notNil and: [binding value = parent]].
	self convertAllReferencesToClass: parent using: replacer!

computeSubclassSupersOf: aClass
	| selectors |
	selectors := Set new.
	aClass subclasses
		do: [:each | each selectors do: [:sel | selectors addAll: (each parseTreeFor: sel) superMessages]].
	^selectors!

createSubclassResponsibilityFor: aSelector in: aClass
	| source superclass |
	superclass := aClass superclass.
	(superclass definesMethod: aSelector) ifTrue: [^self].
	source := self subclassResponsibilityFor: aSelector in: aClass.
	source isNil ifTrue: [^self].
	superclass compile: source categories: (aClass protocolsFor: aSelector)!

name: aClassName class: aClass subclasses: subclassCollection 
	self className: aClassName.
	parent := self model classFor: aClass.
	self subclasses: (subclassCollection collect: [:each | self model classFor: each])!

preconditions
	^subclasses
		inject: ((RBCondition isMetaclass: parent) errorMacro: 'Superclass must <1?not :>be a metaclass') not
				& (RBCondition isValidClassName: self className)
					& (RBCondition isStatic: self className in: self model) not
		into: 
			[:sub :each |
			sub & ((RBCondition isMetaclass: each) errorMacro: 'Subclass must <1?not :>be a metaclass') not
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
	parent classBindingNames do: 
			[:each |
			self performComponentRefactoring: (PullUpClassVariableRefactoring
						model: self model
						variable: each
						class: newSuperclass)]

!

pullUpImports
	"Don't remove the pool variables from the subclass since they might be referenced there."

	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent imports do: 
			[:each |
			(newSuperclass importsNamespace: each)
				ifFalse: 
					[self performComponentRefactoring: (AddImportRefactoring
								model: self model
								addImport: each
								to: newSuperclass)]]!

pullUpInstanceVariables
	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent instanceVariableNames do: 
			[:each |
			self performComponentRefactoring: (PullUpInstanceVariableRefactoring
						model: self model
						variable: each
						class: newSuperclass)]!

pushUp: aSelector in: aClass
	| method |
	method := aClass methodFor: aSelector.
	aClass superclass
		compile: method source
		environment: method parseEnvironment
		categories: method categories
		package: method owningPackageIfLoose!

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
	selectorsToPushUp do: [:each | aClass removeSelector: each]!

pushUpVariables
	self pullUpInstanceVariables.
	self pullUpClassInstanceVariables.
	self pullUpClassVariables.
	self pullUpImports!

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
		nextPutAll: ' name: ';
		print: self className;
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
	methodNode := Parser parseMethod: source onError: [:err :pos | ^nil].
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
!Refactory.Browser.ChildrenToSiblingsRefactoring categoriesForMethods!
abstractSuperclass!accessing!private! !
addSuperclass!public!transforming! !
changeIsKindOfReferences!public!transforming! !
computeSubclassSupersOf:!methods!private! !
createSubclassResponsibilityFor:in:!methods!private! !
name:class:subclasses:!initialize/release!private! !
preconditions!preconditions!public! !
pullUpClassInstanceVariables!private!variables! !
pullUpClassVariables!private!variables! !
pullUpImports!private!variables! !
pullUpInstanceVariables!private!variables! !
pushUp:in:!methods!private! !
pushUpMethods!public!transforming! !
pushUpMethodsFrom:!methods!private! !
pushUpVariables!public!transforming! !
reparentSubclasses!public!transforming! !
selectorsToPushUpFrom:!methods!private! !
shouldPushUp:from:!methods!private! !
storeOn:!printing!public! !
subclasses!accessing!public! !
subclasses:!accessing!public! !
subclassResponsibilityFor:in:!methods!private! !
transform!public!transforming! !
!

!Refactory.Browser.ChildrenToSiblingsRefactoring class methodsFor!

model: aRBModel name: aClassName class: aClass subclasses: subclassCollection
	^self new
		model: aRBModel;
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
!Refactory.Browser.ChildrenToSiblingsRefactoring class categoriesForMethods!
model:name:class:subclasses:!instance creation!public! !
name:class:subclasses:!instance creation!public! !
!

