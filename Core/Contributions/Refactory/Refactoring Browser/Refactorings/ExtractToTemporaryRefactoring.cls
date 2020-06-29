"Filed out from Dolphin Smalltalk 7"!

MethodRefactoring subclass: #ExtractToTemporaryRefactoring
	instanceVariableNames: 'sourceInterval selector newVariableName parseTree'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExtractToTemporaryRefactoring guid: (GUID fromString: '{78588408-02af-46be-9f03-34d63854d1f1}')!
ExtractToTemporaryRefactoring comment: ''!
!ExtractToTemporaryRefactoring categoriesForClass!Refactory-Refactorings! !
!ExtractToTemporaryRefactoring methodsFor!

checkVariableName
	(class whoDefinesInstanceVariable: newVariableName) notNil 
		ifTrue: 
			[self refactoringError: ('<1p> defines an instance variable named <2s>' 
						expandMacrosWith: class
						with: newVariableName)].
	(class whoDefinesClassVariable: newVariableName) notNil 
		ifTrue: 
			[self refactoringError: ('<1p> defines a class variabled named <2s>' 
						expandMacrosWith: class
						with: newVariableName)].
	(self parseTree allDefinedVariables includes: newVariableName) 
		ifTrue: 
			[self refactoringError: ('<1s> is already a temporary variable name' 
						expandMacrosWith: newVariableName)]!

compileNewMethod
	class compileTree: self parseTree!

constructAssignmentFrom: aNode 
	| valueNode |
	valueNode := RBVariableNode named: newVariableName.
	^RBAssignmentNode variable: valueNode value: aNode!

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
	node replaceWith: (RBVariableNode named: newVariableName).
	(statementNode parent)
		addNode: (self constructAssignmentFrom: node)
			before: (node == statementNode 
					ifTrue: [RBVariableNode named: newVariableName]
					ifFalse: [statementNode]);
		addTemporaryNamed: newVariableName!

parseTree
	parseTree isNil 
		ifTrue: 
			[parseTree := class parseTreeFor: selector.
			parseTree isNil ifTrue: [self refactoringError: 'Could not parse method']].
	^parseTree!

preconditions
	^(RBCondition definesSelector: selector in: class) 
		& (RBCondition isValidInstanceVariableName: newVariableName for: class) 
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
		nextPutAll: ''' from: #';
		nextPutAll: selector;
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
	selectedParseTree := RBParser parseExpression: selectedSources
				onError: [:message :position | self refactoringError: 'Invalid selection'].
	selectedParseTree isSequence 
		ifTrue: [self refactoringError: 'Cannot assign temp from multiple statements']! !
!ExtractToTemporaryRefactoring categoriesFor: #checkVariableName!preconditions!public! !
!ExtractToTemporaryRefactoring categoriesFor: #compileNewMethod!public!transforming! !
!ExtractToTemporaryRefactoring categoriesFor: #constructAssignmentFrom:!public!transforming! !
!ExtractToTemporaryRefactoring categoriesFor: #extract:to:from:in:!initialize/release!public! !
!ExtractToTemporaryRefactoring categoriesFor: #insertTemporary!public!transforming! !
!ExtractToTemporaryRefactoring categoriesFor: #parseTree!accessing!private! !
!ExtractToTemporaryRefactoring categoriesFor: #preconditions!preconditions!public! !
!ExtractToTemporaryRefactoring categoriesFor: #selectedSource!accessing!private! !
!ExtractToTemporaryRefactoring categoriesFor: #storeOn:!printing!public! !
!ExtractToTemporaryRefactoring categoriesFor: #transform!public!transforming! !
!ExtractToTemporaryRefactoring categoriesFor: #verifySelectedInterval!preconditions!public! !

!ExtractToTemporaryRefactoring class methodsFor!

extract: anInterval to: aString from: aSelector in: aClass 
	^self new 
		extract: anInterval
		to: aString
		from: aSelector
		in: aClass!

model: aRBNamespace extract: anInterval to: aString from: aSelector in: aClass 
	^(self new)
		model: aRBNamespace;
		extract: anInterval
			to: aString
			from: aSelector
			in: aClass;
		yourself! !
!ExtractToTemporaryRefactoring class categoriesFor: #extract:to:from:in:!instance creation!public! !
!ExtractToTemporaryRefactoring class categoriesFor: #model:extract:to:from:in:!instance creation!public! !

