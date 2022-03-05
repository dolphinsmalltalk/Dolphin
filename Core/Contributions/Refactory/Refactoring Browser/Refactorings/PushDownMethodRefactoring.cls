"Filed out from Dolphin Smalltalk"!

MethodRefactoring subclass: #PushDownMethodRefactoring
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushDownMethodRefactoring guid: (GUID fromString: '{3a03ada6-57cd-40af-b730-0fca36de9319}')!
PushDownMethodRefactoring comment: ''!
!PushDownMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!PushDownMethodRefactoring methodsFor!

preconditions
	| condition |
	condition := selectors inject: RBCondition empty
				into: 
					[:cond :each | 
					cond & (RBCondition definesSelector: each in: class) 
						& (RBCondition subclassesOf: class referToSelector: each) not 
							& (RBCondition withBlock: 
										[| tree |
										tree := class parseTreeFor: each.
										tree isNil or: 
												[tree superMessages 
													allSatisfy: [:superMessage | (class directlyDefinesMethod: superMessage) not]]]
									errorString: each , ' sends super message that is overridden.')].
	^condition & (RBCondition isAbstractClass: class)!

pushDown: aSelector 
	| code protocols refactoring package |
	code := class sourceCodeFor: aSelector.
	protocols := class protocolsFor: aSelector.
	refactoring := ExpandReferencedPoolsRefactoring 
				model: self model
				forMethod: (class parseTreeFor: aSelector)
				fromClass: class
				toClasses: class subclasses.
	self performComponentRefactoring: refactoring.
	#rbFix.	"Bodge change objects to maintain package relationship"
	package := class realClass ifNotNil: [:c | (c compiledMethodAt: aSelector) owningPackageIfLoose].
	class subclasses do: 
			[:each | 
			(each directlyDefinesMethod: aSelector) 
				ifFalse: 
					[| change |
					change := each compile: code classified: protocols.
					package isNil ifFalse: [change package: package]]]!

pushDown: selectorCollection from: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selectors := selectorCollection.
	class := self classObjectFor: aClass.!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' pushDown: '.
	selectors asArray storeOn: aStream.
	aStream nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	selectors do: [:each | self pushDown: each].
	selectors do: [:each | class removeMethod: each]! !
!PushDownMethodRefactoring categoriesForMethods!
preconditions!preconditions!public! !
pushDown:!public!transforming! !
pushDown:from:!initialize/release!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!PushDownMethodRefactoring class methodsFor!

model: aRBNamespace pushDown: selectorCollection from: aClass 
	^(self new)
		model: aRBNamespace;
		pushDown: selectorCollection from: aClass;
		yourself!

pushDown: selectorCollection from: aClass 
	^self new pushDown: selectorCollection from: aClass! !
!PushDownMethodRefactoring class categoriesForMethods!
model:pushDown:from:!instance creation!public! !
pushDown:from:!instance creation!public! !
!

