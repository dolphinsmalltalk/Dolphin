"Filed out from Dolphin Smalltalk"!

Kernel.ParseNodeVisitor
	subclass: #'Kernel.SemanticAnalyser'
	instanceVariableNames: 'methodNode classScope currentScope evalScope errorBlock scopes inStaticExpression inTag'
	classVariableNames: ''
	imports: #(#{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.SemanticAnalyser guid: (Core.GUID fromString: '{8290173a-f40a-473c-bb63-44928d0bda4f}')!

Kernel.SemanticAnalyser comment: '`Kernel.SemanticAnalyser` is the class of `<parseNodeVisitor>`s that performs semantic analysis of an AST.

At this basic level the analyser builds the lexical scope hierarchy and attempts to bind all variables. It detects very few errors and does not report even those, not even undeclared variables, nor perform any other tasks required in a compiler for code generation such as collecting the literals or analyzing block variable usage. The subclass `Kernel.StSemanticAnalyser` performs these tasks for the Smalltalk compiler back-end.'!

!Kernel.SemanticAnalyser categoriesForClass!Refactory-ParseTree Matching! !

!Kernel.SemanticAnalyser methodsFor!

analyseParseTree: aStMethodNode pools: anArray
	^self
		setMethodNode: aStMethodNode pools: anArray;
		visitNode: aStMethodNode!

bindVariable: aStVariableNode
	"Private - Find the correct variable definition for the identifier of aVariableNode, and associate the StVariable describing that definition with the node.
	Answer the variable definition found, or nil if not found."

	^(aStVariableNode lookupInScope: currentScope)
		ifNil: 
			[self undeclaredVariable: aStVariableNode.
			nil]
		ifNotNil: 
			[:var |
			aStVariableNode variable: var.
			var]!

currentScope
	^currentScope!

enterMethodNode: aMethodNode
	currentScope := scopes addLast: (StMethodScope forScopeNode: aMethodNode outer: currentScope).
	aMethodNode scope: currentScope!

exitMethodNode: aMethodNode
	self removeScope!

expectNamespace: aStProgramNode
	"Private - A namespace static variable was expected when parsing a #namespace: annotation, but instead the <StProgramNode> argument was encountered."

	"To be overridden by subclasses that want to report an error, or otherwise handle"!

initialize
	super initialize.
	scopes := OrderedCollection new.
	inTag := inStaticExpression := false!

lineOfSourcePosition: position 
	| line stream |
	stream := methodNode source readStream.
	line := 1.
	[stream atEnd not and: [stream position < position]] 
		whileTrue: [stream next == $\n ifTrue: [line := line + 1]].
	^line!

methodClass
	^classScope methodClass!

removeScope
	^currentScope := currentScope outer!

scopes
	^scopes!

setMethodNode: aStMethodNode pools: anArray
	methodNode := aStMethodNode.
	currentScope := classScope := aStMethodNode newClassScope.
	anArray isEmpty
		ifFalse: 
			[evalScope := StEvalScope pools: anArray outer: currentScope.
			currentScope := evalScope]!

undeclaredVariable: aStVariableNode
	"Private - The argument <StVariableNode> represents an identifier that cannot be bound in its scope."

	"To be overridden by subclasses that want to report an error or otherwise handle."

	!

visitAnnotationNode: aStAnnotationNode
	inTag := true.
	"Visiting the args will detect any undeclared variables."
	[super visitAnnotationNode: aStAnnotationNode] ensure: [inTag := false].
	"We need to process any #namespace: annotation as part of basic analysis as this affects the subsequent binding of static variables"
	aStAnnotationNode selector == #namespace:
		ifTrue: 
			[| arg var binding |
			arg := aStAnnotationNode arguments first.
			(arg isVariable and: 
					[var := arg variable.
					var notNil and: 
							[binding := var binding.
							binding notNil and: [binding isClassBinding]]])
				ifTrue: [currentScope environment: binding value]
				ifFalse: [self expectNamespace: arg]]!

visitAssignmentNode: aStAssignmentNode
	self visitNode: aStAssignmentNode value.
	self visitNode: aStAssignmentNode variable!

visitBlockNode: aBlockNode
	currentScope := scopes addLast: (StBlockScope forScopeNode: aBlockNode outer: currentScope).
	aBlockNode scope: currentScope.
	self processBlock: aBlockNode.
	self removeScope!

visitExternalArgTypeNode: aStExternalArgTypeNode
	aStExternalArgTypeNode structClass ifNotNil: [:structVar | self visitNode: structVar]!

visitExternalCallNode: aStExternalCallNode
	currentScope
		declareLocalVariable: (StGeneratedTempVariable node: (StTempDeclNode named: '_failureCode')).
	super visitExternalCallNode: aStExternalCallNode!

visitLiteralByteArrayNode: aLiteralByteArrayNode
	"We don't need to visit the individual elements (i.e. the value nodes for the bytes)"
!

visitMethodNode: aMethodNode
	self enterMethodNode: aMethodNode.
	super visitMethodNode: aMethodNode.
	self exitMethodNode: aMethodNode.
	^aMethodNode!

visitNode: aNode 
	aNode scope: currentScope.
	^aNode acceptVisitor: self!

visitOptimizedNode: anOptimizedNode
	| wasInStaticExpression outerScopes outerCurrentScope |
	outerCurrentScope := currentScope.
	outerScopes := scopes.
	(wasInStaticExpression := inStaticExpression)
		ifFalse: 
			["If entering a static expression the scope is different (static expressions are compiled in the context of the class side), and only some literals are retained in the frame."
			currentScope := classScope metaScope.
			scopes := OrderedCollection new].
	currentScope := scopes addLast: (StMethodScope forScopeNode: anOptimizedNode outer: currentScope).
	anOptimizedNode scope: currentScope.
	inStaticExpression := true.
	[self visitNode: anOptimizedNode body] ensure: 
			[self removeScope.
			inStaticExpression := wasInStaticExpression.
			currentScope := outerCurrentScope.
			scopes := outerScopes]!

visitParameterNode: aStParameterNode
	aStParameterNode variable: (currentScope declareArgument: aStParameterNode)!

visitPrimitiveNode: aStPrimitiveNode
	currentScope declareLocalVariable: (StGeneratedTempVariable node: aStPrimitiveNode errorTemp)!

visitTempDeclNode: aStTempDeclNode
	aStTempDeclNode variable: (currentScope declareTemp: aStTempDeclNode)!

visitVariableNode: aVariableNode
	^self bindVariable: aVariableNode! !

!Kernel.SemanticAnalyser categoriesForMethods!
analyseParseTree:pools:!operations!public! !
bindVariable:!helpers!private! !
currentScope!accessing!private! !
enterMethodNode:!helpers!private! !
exitMethodNode:!helpers!private! !
expectNamespace:!error handling!private! !
initialize!initializing!public! !
lineOfSourcePosition:!helpers!private! !
methodClass!accessing!private! !
removeScope!helpers!private! !
scopes!accessing!public! !
setMethodNode:pools:!initializing!private! !
undeclaredVariable:!error handling!private! !
visitAnnotationNode:!public!visiting! !
visitAssignmentNode:!public!visitor/double dispatching! !
visitBlockNode:!public!visitor/double dispatching! !
visitExternalArgTypeNode:!public!visiting! !
visitExternalCallNode:!public!visiting! !
visitLiteralByteArrayNode:!public!visiting! !
visitMethodNode:!public!visitor/double dispatching! !
visitNode:!public!visiting! !
visitOptimizedNode:!public!visitor/double dispatching! !
visitParameterNode:!public!visiting! !
visitPrimitiveNode:!public!visiting! !
visitTempDeclNode:!public!visiting! !
visitVariableNode:!public!visitor/double dispatching! !
!

!Kernel.SemanticAnalyser class methodsFor!

analyseParseTree: aStProgramNode
	^self analyseParseTree: aStProgramNode pools: #()!

analyseParseTree: aParseTree pools: anArray
	^self new
		analyseParseTree: aParseTree methodNode pools: anArray;
		yourself! !

!Kernel.SemanticAnalyser class categoriesForMethods!
analyseParseTree:!operations!public! !
analyseParseTree:pools:!operations!public! !
!

