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

details: aClassDetails subclasses: aCollection
	details := aClassDetails.
	details className: (aClassDetails classReference referenceInModel: self model).
	aClassDetails superclassReference
		ifNotNil: [:ref | details superclassName: (ref referenceInModel: self model)].
	subclasses := aCollection collect: [:each | self classObjectFor: each]!

preconditions
	| cond superNotMeta superclass |
	#rbFix.	"Bodge to allow for nil superclass"
	superclass := details superclass.
	superNotMeta := superclass isNil
				ifTrue: [RBCondition empty]
				ifFalse: 
					[((RBCondition isMetaclass: superclass) errorMacro: 'Superclass must <1?not :>be a metaclass') not].
	cond := subclasses inject: superNotMeta
				into: 
					[:sub :each |
					sub & ((RBCondition isMetaclass: each) errorMacro: 'Subclass must <1?not :>be a metaclass') not
						& (RBCondition isImmediateSubclass: each of: superclass)].
	#rbFix.	"Dolphin's class categories are named by Strings, not Symbols, and any class can be in multiple categories"
	^cond & (RBCondition isValidClassName: self className)
		& (RBCondition isStatic: self className in: self model) not!

storeOn: aStream
	aStream
		nextPut: $(;
		store: self class;
		space;
		nextPutAll: #details:;
		space;
		store: details;
		nextPut: $)!

transform
	#rbFix.	"Factor out #definitionMessage in order to permit override in subclass"
	self model
		defineClassWithDetails: details;
		reparentClasses: subclasses to: (model instanceClassNamed: self className)! !
!Refactory.Browser.AddClassRefactoring categoriesForMethods!
className!accessing!public! !
definitionMessage!public!transforming! !
details:subclasses:!initializing!private! !
preconditions!public! !
storeOn:!printing!public! !
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

