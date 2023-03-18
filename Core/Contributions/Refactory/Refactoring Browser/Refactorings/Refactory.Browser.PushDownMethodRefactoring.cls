"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.PushDownMethodRefactoring'
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
	| code protocols importsRefactoring packageAndEnv method |
	method := class methodFor: aSelector.
	protocols := class protocolsFor: aSelector.
	importsRefactoring := ExpandImportsRefactoring
				model: self model
				forMethod: method parseTree
				fromClass: class
				toClasses: class subclasses.
	self performComponentRefactoring: importsRefactoring.
	"Maintain package and any custom namespace of the method being pushed down"
	code := method source.
	packageAndEnv := class existingMethodPackageAndEnvironment: aSelector.
	class subclasses do: 
			[:each |
			(each directlyDefinesMethod: aSelector)
				ifFalse: 
					[each
						compile: code
						environment: packageAndEnv second
						categories: protocols
						package: packageAndEnv first]]!

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
	selectors do: [:each | class removeSelector: each]! !
!Refactory.Browser.PushDownMethodRefactoring categoriesForMethods!
preconditions!preconditions!public! !
pushDown:!public!transforming! !
pushDown:from:!initialize/release!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.PushDownMethodRefactoring class methodsFor!

model: aRBModel pushDown: selectorCollection from: aClass
	^self new
		model: aRBModel;
		pushDown: selectorCollection from: aClass;
		yourself!

pushDown: selectorCollection from: aClass 
	^self new pushDown: selectorCollection from: aClass! !
!Refactory.Browser.PushDownMethodRefactoring class categoriesForMethods!
model:pushDown:from:!instance creation!public! !
pushDown:from:!instance creation!public! !
!

