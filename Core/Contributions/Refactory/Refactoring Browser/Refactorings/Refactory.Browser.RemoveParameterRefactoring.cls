"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.ChangeMethodNameRefactoring subclass: #'Refactory.Browser.RemoveParameterRefactoring'
	instanceVariableNames: 'parameterIndex argument'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveParameterRefactoring guid: (Core.GUID fromString: '{275c77ed-2071-4c69-8d2f-063d31a8d03b}')!
Refactory.Browser.RemoveParameterRefactoring comment: ''!
!Refactory.Browser.RemoveParameterRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RemoveParameterRefactoring methodsFor!

computeNewSelector
	| keywords stream |
	oldSelector argumentCount == 0 ifTrue: [self refactoringError: 'This method contains no arguments'].
	oldSelector isInfix ifTrue: [self refactoringError: 'Cannot remove parameters of infix selectors'].
	keywords := oldSelector keywords asOrderedCollection.
	keywords size = 1 ifTrue: [^(keywords first copyWithout: $:) asSymbol].
	keywords removeAtIndex: parameterIndex.
	stream := WriteStream on: String new.
	keywords do: [:each | stream nextPutAll: each].
	^stream contents asSymbol!

getNewSelector
	| tree |
	(class directlyDefinesMethod: oldSelector) 
		ifFalse: [self refactoringError: 'Method doesn''t exist'].
	tree := class parseTreeFor: oldSelector.
	tree isNil ifTrue: [self refactoringError: 'Cannot parse sources'].
	parameterIndex := tree argumentNames indexOf: argument
				ifAbsent: [self refactoringError: 'Select a parameter!!!!'].
	permutation := (1 to: oldSelector argumentCount) 
				copyWithout: parameterIndex.
	newSelector := self computeNewSelector!

hasReferencesToTemporaryIn: each 
	| tree |
	tree := each parseTreeFor: oldSelector.
	tree isNil ifTrue: [self refactoringError: 'Cannot parse sources.'].
	^tree references: (tree argumentNames at: parameterIndex)!

myConditions
	| imps |
	imps := self model allImplementorsOf: oldSelector.
	self getNewSelector.
	^imps inject: (RBCondition definesSelector: oldSelector in: class)
		into: 
			[:cond :each | 
			cond 
				& (RBCondition withBlock: [(self hasReferencesToTemporaryIn: each) not]
						errorString: 'This argument is still referenced in atleast one implementor!!!!')]!

removeParameter: aString in: aClass selector: aSelector 
	#rbFix. "Ensure the displayString works when the model name is initialized"
	class := aClass.
	oldSelector := aSelector.
	argument := aString.
	class := self classObjectFor: aClass.
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' removeParameter: ''';
		nextPutAll: argument;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: oldSelector.
	aStream nextPut: $)! !
!Refactory.Browser.RemoveParameterRefactoring categoriesFor: #computeNewSelector!private! !
!Refactory.Browser.RemoveParameterRefactoring categoriesFor: #getNewSelector!public!transforming! !
!Refactory.Browser.RemoveParameterRefactoring categoriesFor: #hasReferencesToTemporaryIn:!public!transforming! !
!Refactory.Browser.RemoveParameterRefactoring categoriesFor: #myConditions!preconditions!public! !
!Refactory.Browser.RemoveParameterRefactoring categoriesFor: #removeParameter:in:selector:!initialize/release!public! !
!Refactory.Browser.RemoveParameterRefactoring categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.RemoveParameterRefactoring class methodsFor!

model: aRBNamespace removeParameter: aString in: aClass selector: aSelector 
	^(self new)
		model: aRBNamespace;
		removeParameter: aString
			in: aClass
			selector: aSelector;
		yourself!

removeParameter: aString in: aClass selector: aSelector
	^self new removeParameter: aString in: aClass selector: aSelector! !
!Refactory.Browser.RemoveParameterRefactoring class categoriesFor: #model:removeParameter:in:selector:!instance creation!public! !
!Refactory.Browser.RemoveParameterRefactoring class categoriesFor: #removeParameter:in:selector:!instance creation!public! !

