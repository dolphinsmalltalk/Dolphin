"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.MethodRefactoring subclass: #'Refactory.Browser.PushDownMethodRefactoring'
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.PushDownMethodRefactoring guid: (Core.GUID fromString: '{3a03ada6-57cd-40af-b730-0fca36de9319}')!
Refactory.Browser.PushDownMethodRefactoring comment: ''!
!Refactory.Browser.PushDownMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.PushDownMethodRefactoring methodsFor!

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
!Refactory.Browser.PushDownMethodRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.PushDownMethodRefactoring categoriesFor: #pushDown:!public!transforming! !
!Refactory.Browser.PushDownMethodRefactoring categoriesFor: #pushDown:from:!initialize/release!public! !
!Refactory.Browser.PushDownMethodRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.PushDownMethodRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.PushDownMethodRefactoring class methodsFor!

model: aRBNamespace pushDown: selectorCollection from: aClass 
	^(self new)
		model: aRBNamespace;
		pushDown: selectorCollection from: aClass;
		yourself!

pushDown: selectorCollection from: aClass 
	^self new pushDown: selectorCollection from: aClass! !
!Refactory.Browser.PushDownMethodRefactoring class categoriesFor: #model:pushDown:from:!instance creation!public! !
!Refactory.Browser.PushDownMethodRefactoring class categoriesFor: #pushDown:from:!instance creation!public! !

