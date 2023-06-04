"Filed out from Dolphin Smalltalk"!

Kernel.ParseNodeVisitor
	subclass: #'Kernel.AbstractSemanticAnalyser'
	instanceVariableNames: 'methodNode classScope currentScope evalScope errorBlock scopes inStaticExpression inTag'
	classVariableNames: ''
	imports: #(#{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AbstractSemanticAnalyser guid: (Core.GUID fromString: '{8290173a-f40a-473c-bb63-44928d0bda4f}')!
Kernel.AbstractSemanticAnalyser isNonInstantiable: true!
Kernel.AbstractSemanticAnalyser comment: ''!
!Kernel.AbstractSemanticAnalyser categoriesForClass!Refactory-ParseTree Matching! !
!Kernel.AbstractSemanticAnalyser methodsFor!

analyseParseTree: aStMethodNode pools: anArray onError: aMonadicValuableOrNil
	^self
		setMethodNode: aStMethodNode
			pools: anArray
			errorBlock: aMonadicValuableOrNil;
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

compilationErrorClass
	^Parser notificationClass!

currentScope
	^currentScope!

enterMethodNode: aMethodNode
	currentScope := scopes addLast: (StMethodScope forScopeNode: aMethodNode outer: currentScope).
	aMethodNode scope: currentScope!

errorBlock: aMonadicValuable
	"Set the <monadicValuable> that is evaluated for any semantic errors (not warnings) detected while analysing the AST.
	The argument will be a CompilerErrorNotification. If the block returns, then the error will be signalled, but as these 
	are resumable the analysis can recover and continue in order to detect any further errors."

	errorBlock := aMonadicValuable!

exitMethodNode: aMethodNode
	self removeScope!

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

setMethodNode: aStMethodNode pools: anArray errorBlock: aMonadicValuable
	methodNode := aStMethodNode.
	currentScope := classScope := aStMethodNode newClassScope.
	anArray isEmpty
		ifFalse: 
			[evalScope := StEvalScope pools: anArray outer: currentScope.
			currentScope := evalScope].
	errorBlock := aMonadicValuable!

signalError: anInteger forNode: aNode 
	^self 
		signalError: anInteger
		forNode: aNode
		extras: #()!

signalError: anInteger forNode: aNode extra: anObject
	^self
		signalError: anInteger
		forNode: aNode
		extras: {anObject}!

signalError: anInteger forNode: aNode extras: anArray 
	^self 
		signalError: anInteger
		forNode: aNode
		range: aNode sourceInterval
		extras: anArray!

signalError: codeInteger forNode: aStProgramNode range: anInterval extras: anArray
	| source position err |
	source := methodNode source.
	position := aStProgramNode startWithoutParentheses.
	err := self compilationErrorClass
				code: codeInteger
				in: source
				for: self methodClass
				selector: methodNode selector
				position: position
				line: (self lineOfSourcePosition: position)
				range: anInterval
				extras: anArray.
	"Warnings are not passed to the error block"
	(err severityClass == Error and: [errorBlock notNil]) ifTrue: [errorBlock value: err].
	"If the error block returns, then the exception is signalled"
	^err signal!

undeclaredVariable: aStVariableNode
	self signalError: CErrUndeclared forNode: aStVariableNode!

visitAnnotationNode: aStAnnotationNode
	"Visiting the args will detect any undeclared variables."

	inTag := true.
	[super visitAnnotationNode: aStAnnotationNode] ensure: [inTag := false].
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
				ifFalse: [self signalError: CErrExpectNamespace forNode: arg]]!

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
	currentScope declareLocalVariable: (StGeneratedTempVariable
				node: (aStPrimitiveNode errorTemp ifNil: [StTempDeclNode named: '_failureCode']))!

visitTempDeclNode: aStTempDeclNode
	aStTempDeclNode variable: (currentScope declareTemp: aStTempDeclNode)!

visitVariableNode: aVariableNode
	^self subclassResponsibility! !
!Kernel.AbstractSemanticAnalyser categoriesForMethods!
analyseParseTree:pools:onError:!operations!public! !
bindVariable:!helpers!private! !
compilationErrorClass!constants!private! !
currentScope!accessing!private! !
enterMethodNode:!helpers!private! !
errorBlock:!accessing!private! !
exitMethodNode:!helpers!private! !
initialize!initializing!public! !
lineOfSourcePosition:!helpers!private! !
methodClass!accessing!private! !
removeScope!helpers!private! !
scopes!accessing!public! !
setMethodNode:pools:errorBlock:!initializing!private! !
signalError:forNode:!error handling!private! !
signalError:forNode:extra:!error handling!private! !
signalError:forNode:extras:!error handling!private! !
signalError:forNode:range:extras:!error handling!private! !
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

!Kernel.AbstractSemanticAnalyser class methodsFor!

analyseParseTree: aStMethodNode
	^self analyseParseTree: aStMethodNode pools: #() onError: nil!

analyseParseTree: aParseTree pools: anArray onError: aMonadicValuableOrNil
	^self new
		analyseParseTree: aParseTree methodNode
			pools: anArray
			onError: aMonadicValuableOrNil;
		yourself! !
!Kernel.AbstractSemanticAnalyser class categoriesForMethods!
analyseParseTree:!operations!public! !
analyseParseTree:pools:onError:!operations!public! !
!

