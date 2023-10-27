"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.ExtractToTemporaryRefactoring'
	instanceVariableNames: 'sourceInterval selector newVariableName method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ExtractToTemporaryRefactoring guid: (Core.GUID fromString: '{78588408-02af-46be-9f03-34d63854d1f1}')!
Refactory.Browser.ExtractToTemporaryRefactoring comment: ''!
!Refactory.Browser.ExtractToTemporaryRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ExtractToTemporaryRefactoring methodsFor!

checkVariableName
	(class whoDefinesInstanceVariable: newVariableName) notNil
		ifTrue: 
			[self refactoringError: ('<1p> defines an instance variable named <2s>' expandMacrosWith: class
						with: newVariableName)].
	(class whoDefinesClassVariable: newVariableName) notNil
		ifTrue: 
			[self refactoringError: ('<1p> defines a class variabled named <2s>' expandMacrosWith: class
						with: newVariableName)].
	(self parseTree allDefinedVariables includes: newVariableName)
		ifTrue: 
			[self
				refactoringError: ('<1s> is already a temporary variable name' expandMacrosWith: newVariableName)]!

compileNewMethod
	model compileTree: self parseTree forMethod: self method!

constructAssignmentFrom: aNode 
	| valueNode |
	valueNode := StBasicVariableNode named: newVariableName.
	^StAssignmentNode variable: valueNode value: aNode!

extract: anInterval to: aString from: aSelector in: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	sourceInterval := anInterval.
	newVariableName := aString.
	class := self classObjectFor: aClass.!

insertTemporary
	| node statementNode |
	node := self parseTree whichNodeIsContainedBy: sourceInterval.
	(node notNil and: [node isValue]) 
		ifFalse: [self refactoringError: 'Cannot assign to non-value nodes'].
	statementNode := node statementNode.
	node replaceWith: (StBasicVariableNode named: newVariableName).
	(statementNode parent)
		addNode: (self constructAssignmentFrom: node)
			before: (node == statementNode 
					ifTrue: [StBasicVariableNode named: newVariableName]
					ifFalse: [statementNode]);
		addTemporaryNamed: newVariableName!

method
	^method ifNil: [method := class methodFor: selector]!

parseTree
	^self method parseTreeWithSourceIntervals ifNil: [self refactoringError: 'Could not parse method']!

preconditions
	^(RBCondition definesSelector: selector in: class)
		& (RBCondition isValidInstanceVariableName: newVariableName)
			& (RBCondition withBlock: 
						[self verifySelectedInterval.
						self checkVariableName.
						true])!

selectedSource
	| source |
	source := class sourceCodeFor: selector.
	source isNil ifTrue: [self refactoringError: 'Couldn''t find sources'].
	((sourceInterval first between: 1 and: source size) 
		and: [sourceInterval last between: 1 and: source size]) 
			ifFalse: [self refactoringError: 'Invalid interval'].
	^source copyFrom: sourceInterval first to: sourceInterval last!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' extract: '.
	sourceInterval storeOn: aStream.
	aStream
		nextPutAll: ' to: ''';
		nextPutAll: newVariableName;
		nextPutAll: ''' from: ';
		print: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		insertTemporary;
		compileNewMethod!

verifySelectedInterval
	| selectedParseTree selectedSources |
	selectedSources := self selectedSource.
	selectedParseTree := Parser parseExpression: selectedSources
				onError: [:message :position | self refactoringError: 'Invalid selection'].
	selectedParseTree isSequence 
		ifTrue: [self refactoringError: 'Cannot assign temp from multiple statements']! !
!Refactory.Browser.ExtractToTemporaryRefactoring categoriesForMethods!
checkVariableName!preconditions!public! !
compileNewMethod!public!transforming! !
constructAssignmentFrom:!public!transforming! !
extract:to:from:in:!initialize/release!private! !
insertTemporary!public!transforming! !
method!accessing!public! !
parseTree!accessing!private! !
preconditions!preconditions!public! !
selectedSource!accessing!private! !
storeOn:!printing!public! !
transform!public!transforming! !
verifySelectedInterval!preconditions!public! !
!

!Refactory.Browser.ExtractToTemporaryRefactoring class methodsFor!

extract: anInterval to: aString from: aSelector in: aClass 
	^self new 
		extract: anInterval
		to: aString
		from: aSelector
		in: aClass!

model: aRBModel extract: anInterval to: aString from: aSelector in: aClass
	^self new
		model: aRBModel;
		extract: anInterval
			to: aString
			from: aSelector
			in: aClass;
		yourself! !
!Refactory.Browser.ExtractToTemporaryRefactoring class categoriesForMethods!
extract:to:from:in:!instance creation!public! !
model:extract:to:from:in:!instance creation!public! !
!

