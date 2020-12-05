"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.ChangeMethodNameRefactoring subclass: #'Refactory.Browser.RenameMethodRefactoring'
	instanceVariableNames: 'hasPermutedArguments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameMethodRefactoring guid: (Core.GUID fromString: '{fca8f1a0-da69-4108-82f9-2b61aa651e4b}')!
Refactory.Browser.RenameMethodRefactoring comment: ''!
!Refactory.Browser.RenameMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RenameMethodRefactoring methodsFor!

hasPermutedArguments
	^hasPermutedArguments isNil 
		ifTrue: [hasPermutedArguments := super hasPermutedArguments]
		ifFalse: [hasPermutedArguments]!

implementorsCanBePrimitives
	^self hasPermutedArguments not!

myConditions
	^RBCondition 
		withBlock: [oldSelector argumentCount = newSelector argumentCount]
		errorString: newSelector printString 
				, ' doesn''t have the correct number of arguments.'!

parseTreeRewriter
	| rewriteRule oldString newString |
	oldString := self buildSelectorString: oldSelector.
	newString := self buildSelectorString: newSelector withPermuteMap: permutation.
	rewriteRule := self hasPermutedArguments
				ifTrue: [ParseTreeRewriter new]
				ifFalse: [ParseTreeRewriter replaceLiteral: oldSelector with: newSelector].
	rewriteRule replace: '``@object ' , oldString with: '``@object ' , newString.
	^rewriteRule!

preconditions
	| newCondition |
	newCondition := (RBCondition withBlock: [newSelector = oldSelector]
				errorString: 'The selectors are <1?:not >equivalent') & (RBCondition 
							withBlock: [permutation asArray ~= (1 to: oldSelector argumentCount) asArray]
							errorString: 'The arguments are <1?:not >permuted').
	^newCondition | super preconditions!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' renameMethod: #';
		nextPutAll: oldSelector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' to: #';
		nextPutAll: newSelector;
		nextPutAll: ' permuation: '.
	permutation storeOn: aStream.
	aStream nextPut: $)! !
!Refactory.Browser.RenameMethodRefactoring categoriesFor: #hasPermutedArguments!public!testing! !
!Refactory.Browser.RenameMethodRefactoring categoriesFor: #implementorsCanBePrimitives!public!testing! !
!Refactory.Browser.RenameMethodRefactoring categoriesFor: #myConditions!preconditions!public! !
!Refactory.Browser.RenameMethodRefactoring categoriesFor: #parseTreeRewriter!public!transforming! !
!Refactory.Browser.RenameMethodRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.RenameMethodRefactoring categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.RenameMethodRefactoring class methodsFor!

model: aRBNamespace renameMethod: aSelector in: aClass to: newSelector permutation: aMap 
	^(self new)
		model: aRBNamespace;
		renameMethod: aSelector
			in: aClass
			to: newSelector
			permutation: aMap;
		yourself!

renameMethod: aSelector in: aClass to: newSelector permutation: aMap 
	^self new 
		renameMethod: aSelector
		in: aClass
		to: newSelector
		permutation: aMap! !
!Refactory.Browser.RenameMethodRefactoring class categoriesFor: #model:renameMethod:in:to:permutation:!instance creation!public! !
!Refactory.Browser.RenameMethodRefactoring class categoriesFor: #renameMethod:in:to:permutation:!instance creation!public! !

