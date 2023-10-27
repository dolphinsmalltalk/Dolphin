"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.AddClassRefactoring'
	instanceVariableNames: 'details subclasses'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddClassRefactoring guid: (Core.GUID fromString: '{3623578c-f5f8-44a8-bafa-679532fa3a9a}')!
Refactory.Browser.AddClassRefactoring comment: ''!
!Refactory.Browser.AddClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AddClassRefactoring methodsFor!

className
	^details className!

definitionMessage
	^details printString!

details
	^details!

details: aClassDetails subclasses: aCollection
	details := aClassDetails.
	details className: (aClassDetails classReference referenceInModel: self model).
	aClassDetails superclassReference
		ifNotNil: [:ref | details superclassName: (ref referenceInModel: self model)].
	subclasses := aCollection collect: [:each | self classObjectFor: each]!

preconditions
	| cond superclass |
	superclass := self superclass.
	cond := subclasses inject: self superclassPreconditions
				into: 
					[:sub :each |
					sub & ((RBCondition isMetaclass: each) errorMacro: 'Subclass must <1?not :>be a metaclass') not
						& (RBCondition isImmediateSubclass: each of: superclass)].
	^cond & (RBCondition isValidClassName: self className)
		& (RBCondition isStatic: self className in: self model) not
			& ((RBCondition withBlock: [details isPointers or: [details instanceVariableNames isEmpty]])
					errorMacro: ClassBuilder.ErrorBytesAndNamedInstVars;
					yourself)
			& ((RBCondition withBlock: 
						[details instanceVariableNames asBag
							removeAll: details instanceVariableNames asSet;
							isEmpty])
					errorMacro: 
							[ClassBuilder.ErrorInstVarAlreadyDefined << (details instanceVariableNames asOrderedCollection
										removeAll: details instanceVariableNames asSet;
										first)];
					yourself)
			& ((RBCondition withBlock: 
						[| varNames |
						varNames := details classBindingNames.
						varNames asBag
							removeAll: varNames asSet;
							isEmpty])
					errorMacro: 
							[| varNames |
							varNames := details classBindingNames.
							ClassBuilder.ErrorClassVarAlreadyDefined << {
										self className.
										varNames asSortedCollection
											removeAll: varNames asSet;
											first
									}];
					yourself)!

storeOn: aStream
	aStream
		nextPut: $(;
		store: self class;
		space;
		nextPutAll: #details:;
		space;
		store: details;
		nextPut: $)!

superclass
	^details superclass!

superclassPreconditions
	| superclass cond |
	superclass := self superclass.
	superclass ifNil: [^RBCondition empty].
	cond := (RBCondition isSubclassable: superclass)
				& ((RBCondition isMetaclass: superclass) errorMacro: 'Superclass must <1?not :>be a metaclass') not.
	details isBytes
		ifTrue: 
			[cond := cond & ((RBCondition withBlock: [superclass isBytes or: [superclass isVariable not]])
								errorMacro: [ClassBuilder.ErrorByteSubclassOfVariable << superclass];
								yourself)
						& ((RBCondition withBlock: [superclass instSize == 0])
								errorMacro: [ClassBuilder.ErrorByteSubclassOfFixed << superclass];
								yourself)]
		ifFalse: 
			[cond := cond & ((RBCondition withBlock: [superclass isPointers])
								errorMacro: [ClassBuilder.ErrorPointerSubclassOfBytes << superclass];
								yourself)
						& ((RBCondition withBlock: 
									["If the superclass is variable, then the subclass must be too"
									superclass isVariable not or: [details isVariable]])
								errorMacro: [ClassBuilder.ErrorFixedSubclassOfVariable << superclass];
								yourself)].
	details instanceVariableNames do: 
			[:each |
			cond := cond & (RBCondition isValidInstanceVariableName: each)
						& (RBCondition definesInstanceVariable: each in: superclass) not].
	details classBindingNames do: 
			[:each |
			cond := cond & (RBCondition isValidClassVarName: each)
						& (RBCondition definesClassVariable: each in: superclass) not].
	details classInstanceVariableNames do: 
			[:each |
			cond := cond & (RBCondition isValidInstanceVariableName: each)
						& (RBCondition definesInstanceVariable: each in: superclass metaclass) not].
	^cond!

transform
	#rbFix.	"Factor out #definitionMessage in order to permit override in subclass"
	self model
		defineClassWithDetails: details;
		reparentClasses: subclasses to: (model instanceClassNamed: self className)! !
!Refactory.Browser.AddClassRefactoring categoriesForMethods!
className!accessing!public! !
definitionMessage!public!transforming! !
details!accessing!private! !
details:subclasses:!initializing!private! !
preconditions!preconditions!public! !
storeOn:!printing!public! !
superclass!accessing!private! !
superclassPreconditions!preconditions!private! !
transform!public!transforming! !
!

!Refactory.Browser.AddClassRefactoring class methodsFor!

addClass: aString superclass: aClass subclasses: subclassesCollection categories: categoriesCollection
	^self details: (ClassDetails
				className: aString
				superclass: aClass
				categories: categoriesCollection)
		subclasses: subclassesCollection!

details: aClassDetails subclasses: anArray
	^self new
		details: aClassDetails subclasses: anArray;
		yourself!

model: aRBModel addClass: aString superclass: aClass subclasses: subclassesCollection categories: categoriesCollection
	^self new
		model: aRBModel;
		details: (ClassDetails
					className: aString
					superclass: aClass
					categories: categoriesCollection)
			subclasses: subclassesCollection;
		yourself!

model: aRBModel details: aClassDetails subclasses: anArray
	^self new
		model: aRBModel;
		details: aClassDetails subclasses: anArray;
		yourself! !
!Refactory.Browser.AddClassRefactoring class categoriesForMethods!
addClass:superclass:subclasses:categories:!instance creation!public! !
details:subclasses:!instance creation!public! !
model:addClass:superclass:subclasses:categories:!instance creation!public! !
model:details:subclasses:!instance creation!public! !
!

