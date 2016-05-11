"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StParseNodeVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StParseNodeVisitor guid: (GUID fromString: '{8CF81BE6-059C-46DA-86E3-B21A6781066B}')!
StParseNodeVisitor comment: 'BRProgramNodeVisitor is an abstract visitor for the BRProgramNodes.

'!
!StParseNodeVisitor categoriesForClass!Refactory-ParseTree Matching! !
!StParseNodeVisitor methodsFor!

acceptAssignmentNode: anAssignmentNode 
	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value!

acceptBlockNode: aBlockNode
	self processBlock: aBlockNode!

acceptCascadeNode: aCascadeNode 
	aCascadeNode messages do: [:each | self visitNode: each]!

acceptExternalArgTypeNode: anAssignmentNode
		"Dolphin specific extension"!

acceptExternalCallNode: anStExternalCallNode
	"Dolphin specific extension"
	!

acceptLiteralArrayNode: aLiteralArrayNode 
	aLiteralArrayNode contents do: [:each | self visitNode: each]!

acceptLiteralNode: aLiteralNode!

acceptMessageNode: aMessageNode 
	(aMessageNode isCascaded not or: [aMessageNode isFirstCascaded]) 
		ifTrue: [self visitNode: aMessageNode receiver].
	aMessageNode arguments do: [:each | self visitNode: each]!

acceptMethodNode: aMethodNode 
	self visitArguments: aMethodNode arguments.
	self visitNode: aMethodNode body!

acceptOptimizedNode: anOptimizedNode 
	self visitNode: anOptimizedNode body!

acceptPrimitiveNode: anStPrimitiveNode 
	!

acceptReturnNode: aReturnNode 
	self visitNode: aReturnNode value!

acceptSequenceNode: aSequenceNode
	| statements |
	self visitTempDecls: aSequenceNode temporaries.
	self tagBeforeTemporaries
		ifFalse: 
			[aSequenceNode parent
				ifNotNil: [:parent | parent isMethod ifTrue: [parent tag ifNotNil: [:tag | self visitNode: tag]]]].
	statements := aSequenceNode statements.
	self visitStatements: statements!

acceptVariableNode: aVariableNode!

processBlock: aBlockNode
	self visitArguments: aBlockNode arguments.
	self visitNode: aBlockNode body!

tagBeforeTemporaries
	^false!

visitArgument: each 
	"Private - Here to allow subclasses to detect arguments or temporaries."

	^self visitNode: each!

visitArguments: aNodeCollection 
	^aNodeCollection do: [:each | self visitArgument: each]!

visitNode: aNode 
	^aNode acceptVisitor: self!

visitStatements: aNodeCollection
	aNodeCollection do: [:each | self visitNode: each]!

visitTempDecls: aNodeCollection 
	^self visitArguments: aNodeCollection! !
!StParseNodeVisitor categoriesFor: #acceptAssignmentNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptBlockNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptCascadeNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptExternalArgTypeNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptExternalCallNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptLiteralArrayNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptLiteralNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptMessageNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptMethodNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptOptimizedNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptPrimitiveNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptReturnNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptSequenceNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #acceptVariableNode:!public!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #processBlock:!private!visitor/double dispatching! !
!StParseNodeVisitor categoriesFor: #tagBeforeTemporaries!public!testing! !
!StParseNodeVisitor categoriesFor: #visitArgument:!private!visiting! !
!StParseNodeVisitor categoriesFor: #visitArguments:!private!visiting! !
!StParseNodeVisitor categoriesFor: #visitNode:!private!visiting! !
!StParseNodeVisitor categoriesFor: #visitStatements:!private!visiting! !
!StParseNodeVisitor categoriesFor: #visitTempDecls:!private!visiting! !

StParseNodeVisitor methodProtocol: #stParseNodeVisitor attributes: #(#readOnly) selectors: #(#acceptAssignmentNode: #acceptBlockNode: #acceptCascadeNode: #acceptExternalArgTypeNode: #acceptExternalCallNode: #acceptLiteralArrayNode: #acceptLiteralNode: #acceptMessageNode: #acceptMethodNode: #acceptOptimizedNode: #acceptPrimitiveNode: #acceptReturnNode: #acceptSequenceNode: #acceptVariableNode:)!

!StParseNodeVisitor class methodsFor!

new
	^super new initialize! !
!StParseNodeVisitor class categoriesFor: #new!instance creation!public! !

