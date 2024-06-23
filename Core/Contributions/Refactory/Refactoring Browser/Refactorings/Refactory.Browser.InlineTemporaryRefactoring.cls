"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.InlineTemporaryRefactoring'
	instanceVariableNames: 'sourceInterval selector assignmentNode definingNode sourceTree method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.InlineTemporaryRefactoring guid: (Core.GUID fromString: '{462b284d-15e3-4d89-ac1a-048036a38c69}')!

Refactory.Browser.InlineTemporaryRefactoring comment: ''!

!Refactory.Browser.InlineTemporaryRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.InlineTemporaryRefactoring methodsFor!

checkMultipleAssignments
	self hasOnlyOneAssignment 
		ifFalse: [self refactoringError: 'There are multiple assignments to the variable']!

checkReadBeforeWritten
	(RBReadBeforeWrittenTester isVariable: assignmentNode variable name
		writtenBeforeReadIn: definingNode)
			ifFalse: [self refactoringError: 'The variable is possibly read before it is assigned']!

compileMethod: aMethodNode
	model compileTree: aMethodNode forMethod: method!

determineAssignmentNode
	assignmentNode := self sourceTree whichNodeIsContainedBy: sourceInterval.
	(assignmentNode isNil or: [assignmentNode isAssignment not]) 
		ifTrue: [self refactoringError: 'The selection does not appear to be an assignment']!

determineVariableDefinition
	definingNode := assignmentNode whoDefines: assignmentNode variable name.
	definingNode isNil 
		ifTrue: [self refactoringError: 'The variable does not appear to be a temporary variable.']!

hasOnlyOneAssignment
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: assignmentNode variable name , ' := ``@object' do: [:aNode :answer | answer + 1].
	^(searcher executeTree: definingNode initialAnswer: 0) == 1!

inline: anInterval from: aSelector in: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	sourceInterval := anInterval.
	class := self classObjectFor: aClass.
!

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
	rewriter replaceTree: assignmentNode variable withTree: assignmentNode value.
	definingNode removeTemporaryNamed: assignmentNode variable name.
	rewriter executeTree: definingNode.
	"The tree is updated in place - otherwise we'd need to replace the body here.
	definingNode parent body: rewriter tree."
	^sourceTree!

sourceTree
	^sourceTree
		ifNil: 
			[method := class methodFor: selector.
			sourceTree := method parseTreeWithSourceIntervals
						ifNil: [self refactoringError: 'Could not parse source']]!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' inline: '.
	sourceInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: ';
		print: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self replaceAssignment.
	self compileMethod: self replaceReferences!

verifySelectedInterval
	self determineAssignmentNode.
	self determineVariableDefinition.
	self checkMultipleAssignments.
	self checkReadBeforeWritten! !

!Refactory.Browser.InlineTemporaryRefactoring categoriesForMethods!
checkMultipleAssignments!preconditions!private! !
checkReadBeforeWritten!preconditions!private! !
compileMethod:!public!transforming! !
determineAssignmentNode!preconditions!private! !
determineVariableDefinition!preconditions!private! !
hasOnlyOneAssignment!public!testing! !
inline:from:in:!initialize/release!public! !
preconditions!preconditions!public! !
replaceAssignment!public!transforming! !
replaceReferences!public!transforming! !
sourceTree!helpers!private! !
storeOn:!printing!public! !
transform!public!transforming! !
verifySelectedInterval!preconditions!public! !
!

!Refactory.Browser.InlineTemporaryRefactoring class methodsFor!

inline: anInterval from: aSelector in: aClass 
	^self new 
		inline: anInterval
		from: aSelector
		in: aClass!

model: aRBModel inline: anInterval from: aSelector in: aClass
	^self new
		model: aRBModel;
		inline: anInterval
			from: aSelector
			in: aClass;
		yourself! !

!Refactory.Browser.InlineTemporaryRefactoring class categoriesForMethods!
inline:from:in:!instance creation!public! !
model:inline:from:in:!instance creation!public! !
!

