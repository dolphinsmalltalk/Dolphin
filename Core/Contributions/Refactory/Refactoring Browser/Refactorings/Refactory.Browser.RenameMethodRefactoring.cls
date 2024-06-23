"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ChangeMethodNameRefactoring
	subclass: #'Refactory.Browser.RenameMethodRefactoring'
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
	^RBCondition withBlock: [oldSelector argumentCount = newSelector argumentCount]
		errorString: [newSelector printString , ' doesn''t have the correct number of arguments.']!

parseTreeRewriter
	| rewriteRule oldString newString replaceSends replace search |
	oldString := self buildSelectorString: oldSelector.
	newString := self buildSelectorString: newSelector withPermuteMap: permutation.
	rewriteRule := self hasPermutedArguments
				ifTrue: [ParseTreeRewriter new]
				ifFalse: [ParseTreeRewriter replaceLiteral: oldSelector with: newSelector].
	replaceSends := rewriteRule replace: '``@object ' , oldString with: '``@object ' , newString.
	"Synthesize a replace rule for annotations from the message rewrite - we can't parse annotations as an expression"
	search := replaceSends searchTree.
	replace := replaceSends replaceTree.
	rewriteRule replaceTree: (StAnnotationNode selector: search selector
				arguments: (search arguments collect: [:each | each copy]))
		withTree: (StAnnotationNode selector: replace selector
				arguments: (replace arguments collect: [:each | each copy])).
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
		nextPutAll: ' renameMethod: ';
		print: oldSelector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' to: ';
		print: newSelector;
		nextPutAll: ' permuation: '.
	permutation storeOn: aStream.
	aStream nextPut: $)! !

!Refactory.Browser.RenameMethodRefactoring categoriesForMethods!
hasPermutedArguments!public!testing! !
implementorsCanBePrimitives!public!testing! !
myConditions!preconditions!public! !
parseTreeRewriter!public!transforming! !
preconditions!preconditions!public! !
storeOn:!printing!public! !
!

!Refactory.Browser.RenameMethodRefactoring class methodsFor!

model: aRBmodel renameMethod: aSelector in: aClass to: newSelector permutation: aMap
	^self new
		model: aRBmodel;
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

!Refactory.Browser.RenameMethodRefactoring class categoriesForMethods!
model:renameMethod:in:to:permutation:!instance creation!public! !
renameMethod:in:to:permutation:!instance creation!public! !
!

