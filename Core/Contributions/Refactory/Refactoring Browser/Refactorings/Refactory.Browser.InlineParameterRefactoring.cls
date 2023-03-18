"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RemoveParameterRefactoring
	subclass: #'Refactory.Browser.InlineParameterRefactoring'
	instanceVariableNames: 'expressions'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.InlineParameterRefactoring guid: (Core.GUID fromString: '{9e2f3b66-4a50-4da3-97d8-7b1af9c59ea5}')!
Refactory.Browser.InlineParameterRefactoring comment: ''!
!Refactory.Browser.InlineParameterRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.InlineParameterRefactoring methodsFor!

allExpressionsToInline
	| coll |
	coll := Set new.
	(self model allReferencesTo: oldSelector) do: 
			[:each |
			| tree |
			tree := each parseTree.
			tree notNil ifTrue: [coll addAll: (self expressionsToInlineFrom: tree)]].
	^coll asOrderedCollection!

expressionsToInlineFrom: aTree
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@obj ' , (self buildSelectorString: oldSelector)
		do: 
			[:aNode :answer |
			answer
				add: (aNode arguments at: parameterIndex);
				yourself].
	^searcher executeTree: aTree initialAnswer: OrderedCollection new!

inlineParameter: aString in: aClass selector: aSelector
	#rbFix. "Ensure the displayString works when the model name is initialized"
	class := aClass.
	oldSelector := aSelector asSymbol.
	argument := aString.
	class := self classObjectFor: aClass.
!

modifyImplementorParseTree: parseTree in: aClass 
	| node assignment |
	node := (parseTree arguments at: parameterIndex) copy.
	parseTree body addTemporaryNamed: node name.
	assignment := StAssignmentNode variable: node copy value: expressions first.
	parseTree body addNodeFirst: assignment.
	super modifyImplementorParseTree: parseTree in: aClass!

myConditions
	self getNewSelector.
	expressions := self allExpressionsToInline.
	^(RBCondition definesSelector: oldSelector in: class) 
		& ((RBCondition withBlock: [expressions notEmpty]) 
				errorMacro: 'No callers. Use Remove Method instead.') 
			& ((RBCondition withBlock: [expressions size = 1]) 
					errorMacro: 'All values passed as this argument must be identical.') 
			& ((RBCondition withBlock: [expressions first isLiteralNode]) 
					errorMacro: 'All values passed as this argument must be literal.')!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' inlineParameter: ''';
		nextPutAll: argument;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: ';
		print: oldSelector;
		nextPut: $)! !
!Refactory.Browser.InlineParameterRefactoring categoriesForMethods!
allExpressionsToInline!enquiries!private! !
expressionsToInlineFrom:!private! !
inlineParameter:in:selector:!initialize/release!public! !
modifyImplementorParseTree:in:!public!transforming! !
myConditions!preconditions!public! !
storeOn:!printing!public! !
!

!Refactory.Browser.InlineParameterRefactoring class methodsFor!

inlineParameter: aString in: aClass selector: aSelector 
	^self new 
		inlineParameter: aString
		in: aClass
		selector: aSelector!

model: aRBModel inlineParameter: aString in: aClass selector: aSelector
	^self new
		model: aRBModel;
		inlineParameter: aString
			in: aClass
			selector: aSelector;
		yourself! !
!Refactory.Browser.InlineParameterRefactoring class categoriesForMethods!
inlineParameter:in:selector:!instance creation!public! !
model:inlineParameter:in:selector:!instance creation!public! !
!

