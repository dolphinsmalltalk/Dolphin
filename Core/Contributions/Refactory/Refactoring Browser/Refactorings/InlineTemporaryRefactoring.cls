"Filed out from Dolphin Smalltalk"!

MethodRefactoring subclass: #InlineTemporaryRefactoring
	instanceVariableNames: 'sourceInterval selector sourceTree assignmentNode definingNode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlineTemporaryRefactoring guid: (GUID fromString: '{462b284d-15e3-4d89-ac1a-048036a38c69}')!
InlineTemporaryRefactoring comment: ''!
!InlineTemporaryRefactoring categoriesForClass!Refactory-Refactorings! !
!InlineTemporaryRefactoring methodsFor!

checkMultipleAssignments
	self hasOnlyOneAssignment 
		ifFalse: [self refactoringError: 'There are multiple assignments to the variable']!

checkReadBeforeWritten
	(RBReadBeforeWrittenTester isVariable: assignmentNode variable name
		writtenBeforeReadIn: definingNode) 
			ifFalse: [self refactoringError: 'The variable is possibly read before it is assigned']!

compileMethod
	class compileTree: sourceTree!

determineAssignmentNode
	assignmentNode := sourceTree whichNodeIsContainedBy: sourceInterval.
	(assignmentNode isNil or: [assignmentNode isAssignment not]) 
		ifTrue: [self refactoringError: 'The selection does not appear to be an assignment']!

determineVariableDefinition
	definingNode := assignmentNode whoDefines: assignmentNode variable name.
	definingNode isNil 
		ifTrue: [self refactoringError: 'The variable does not appear to be a temporary variable.']!

hasOnlyOneAssignment
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: assignmentNode variable name , ' := ``@object'
		do: [:aNode :answer | answer + 1].
	^(searcher executeTree: definingNode initialAnswer: 0) == 1!

inline: anInterval from: aSelector in: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	sourceInterval := anInterval.
	class := self classObjectFor: aClass.
!

parseMethod
	sourceTree := class parseTreeFor: selector.
	sourceTree isNil ifTrue: [self refactoringError: 'Could not parse source']!

preconditions
	^(RBCondition definesSelector: selector in: class) 
		& (RBCondition withBlock: 
					[self verifySelectedInterval.
					true])!

replaceAssignment
	assignmentNode isUsed 
		ifTrue: [assignmentNode replaceWith: assignmentNode value]
		ifFalse: [assignmentNode parent removeNode: assignmentNode]!

replaceReferences
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replaceTree: assignmentNode variable
		withTree: assignmentNode value.
	definingNode removeTemporaryNamed: assignmentNode variable name.
	rewriter executeTree: definingNode!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' inline: '.
	sourceInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		replaceAssignment;
		replaceReferences;
		compileMethod!

verifySelectedInterval
	self parseMethod.
	self determineAssignmentNode.
	self determineVariableDefinition.
	self checkMultipleAssignments.
	self checkReadBeforeWritten! !
!InlineTemporaryRefactoring categoriesForMethods!
checkMultipleAssignments!preconditions!private! !
checkReadBeforeWritten!preconditions!private! !
compileMethod!public!transforming! !
determineAssignmentNode!preconditions!private! !
determineVariableDefinition!preconditions!private! !
hasOnlyOneAssignment!public!testing! !
inline:from:in:!initialize/release!public! !
parseMethod!helpers!private! !
preconditions!preconditions!public! !
replaceAssignment!public!transforming! !
replaceReferences!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
verifySelectedInterval!preconditions!public! !
!

!InlineTemporaryRefactoring class methodsFor!

inline: anInterval from: aSelector in: aClass 
	^self new 
		inline: anInterval
		from: aSelector
		in: aClass!

model: aRBNamespace inline: anInterval from: aSelector in: aClass 
	^(self new)
		model: aRBNamespace;
		inline: anInterval
			from: aSelector
			in: aClass;
		yourself! !
!InlineTemporaryRefactoring class categoriesForMethods!
inline:from:in:!instance creation!public! !
model:inline:from:in:!instance creation!public! !
!

