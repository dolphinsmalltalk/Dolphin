"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassRefactoring subclass: #'Refactory.Browser.AddClassRefactoring'
	instanceVariableNames: 'category superclass subclasses'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddClassRefactoring guid: (Core.GUID fromString: '{3623578c-f5f8-44a8-bafa-679532fa3a9a}')!
Refactory.Browser.AddClassRefactoring comment: ''!
!Refactory.Browser.AddClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AddClassRefactoring methodsFor!

addClass: aName superclass: aClass subclasses: aCollection category: aSymbol 
	self className: aName.
	superclass := self classObjectFor: aClass.
	subclasses := aCollection collect: [:each | self classObjectFor: each].
	category := aSymbol!

definitionMessage
	| classType |
	#rbFix.	"Factored out from #transform, and allow for indexed/byte superclasses and for nil superclass."
	classType := superclass isNil
				ifTrue: ['subclass']
				ifFalse: 
					[superclass isPointers
						ifTrue: [superclass isVariable ifTrue: ['variableSubclass'] ifFalse: ['subclass']]
						ifFalse: ['variableByteSubclass']].
	^'<1p> <2s>: <3p> instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: <4p>'
		expandMacrosWith: superclass
		with: classType
		with: className asSymbol
		with: category!

preconditions
	| cond superNotMeta |
	#rbFix.	"Bodge to allow for nil superclass"
	superNotMeta := superclass isNil
				ifTrue: [RBCondition empty]
				ifFalse: [((RBCondition isMetaclass: superclass) errorMacro: 'Superclass must <1?not :>be a metaclass') not].
	cond := subclasses inject: superNotMeta
				into: 
					[:sub :each |
					sub & ((RBCondition isMetaclass: each) errorMacro: 'Subclass must <1?not :>be a metaclass') not
						& (RBCondition isImmediateSubclass: each of: superclass)].
	#rbFix.	"Dolphin's categories are Strings, not Symbols"
	^cond & (RBCondition isValidClassName: self className)
		& (RBCondition isStatic: self className in: self model) not & (RBCondition isString: category)
		& ((RBCondition withBlock: 
					["*** & (RBCondition isSymbol: category) "
					category notEmpty])
				errorMacro: 'Invalid category name')!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addClass: ';
		print: self className;
		nextPutAll: ' superclass: '.
	superclass storeOn: aStream.
	aStream nextPutAll: ' subclasses: '.
	subclasses asArray storeOn: aStream.
	aStream nextPutAll: ' category: '.
	category storeOn: aStream.
	aStream nextPut: $)!

transform
	#rbFix.	"Factor out #definitionMessage in order to permit override in subclass"
	self model
		defineClass: self definitionMessage;
		reparentClasses: subclasses to: (model instanceClassNamed: self className)! !
!Refactory.Browser.AddClassRefactoring categoriesForMethods!
addClass:superclass:subclasses:category:!initialize/release!public! !
definitionMessage!public!transforming! !
preconditions!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.AddClassRefactoring class methodsFor!

addClass: aName superclass: aClass subclasses: aCollection category: aSymbol
	^self new
		addClass: aName
		superclass: aClass
		subclasses: aCollection
		category: aSymbol!

model: aRBModel addClass: aName superclass: aClass subclasses: aCollection category: aSymbol
	^self new
		model: aRBModel;
		addClass: aName
			superclass: aClass
			subclasses: aCollection
			category: aSymbol;
		yourself! !
!Refactory.Browser.AddClassRefactoring class categoriesForMethods!
addClass:superclass:subclasses:category:!instance creation!public! !
model:addClass:superclass:subclasses:category:!instance creation!public! !
!

