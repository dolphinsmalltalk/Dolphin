"Filed out from Dolphin Smalltalk"!

Kernel.ParseNodeVisitor subclass: #'Kernel.AbstractSemanticAnalyser'
	instanceVariableNames: 'methodNode classScope currentScope evaluationContext evalScope errorBlock scopes addToFrame inStaticExpression inTag'
	classVariableNames: ''
	imports: #(#{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AbstractSemanticAnalyser guid: (Core.GUID fromString: '{8290173a-f40a-473c-bb63-44928d0bda4f}')!
Kernel.AbstractSemanticAnalyser isNonInstantiable: true!
Kernel.AbstractSemanticAnalyser comment: ''!
!Kernel.AbstractSemanticAnalyser categoriesForClass!Refactory-ParseTree Matching! !
!Kernel.AbstractSemanticAnalyser methodsFor!

addToFrameStatic: aLiteralNode!

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
	addToFrame := [:literal | ].
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

setMethodNode: aStMethodNode methodClass: aClass environment: aNamespace context: anObject pools: anArray errorBlock: aMonadicValuable
	methodNode := aStMethodNode.
	evaluationContext := anObject.
	currentScope := classScope := StClassScope methodClass: aClass environment: aNamespace.
	anArray isEmpty
		ifFalse: 
			[evalScope := (StEvalScope pools: anArray)
						outer: currentScope;
						yourself.
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

signalError: codeInteger forNode: anStProgramNode range: anInterval extras: anArray
	| source position err |
	source := methodNode source.
	position := anStProgramNode startWithoutParentheses.
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

visitAnnotationNode: anStAnnotationNode
	"Visiting the args will detect any undeclared variables."

	inTag := true.
	[super visitAnnotationNode: anStAnnotationNode] ensure: [inTag := false].
	anStAnnotationNode selector == #namespace:
		ifTrue: 
			[| arg var binding |
			arg := anStAnnotationNode arguments first.
			(arg isVariable and: 
					[var := arg variable.
					var notNil and: [var isStaticVariable and: [(binding := var binding) isClassBinding]]])
				ifTrue: [currentScope environment: binding value]
				ifFalse: [self signalError: CErrExpectNamespace forNode: arg]]!

visitAssignmentNode: anStAssignmentNode
	| variableNode |
	self visitNode: anStAssignmentNode value.
	variableNode := anStAssignmentNode variable.
	variableNode scope: currentScope.
	self visitNode: variableNode!

visitBlockNode: aBlockNode
	currentScope := scopes addLast: (StBlockScope forScopeNode: aBlockNode outer: currentScope).
	aBlockNode scope: currentScope.
	self processBlock: aBlockNode.
	self removeScope!

visitExternalArgTypeNode: anStExternalArgTypeNode
	anStExternalArgTypeNode structClass ifNotNil: [:structVar | self visitNode: structVar]!

visitExternalCallNode: anStExternalCallNode
	self currentScope
		declareLocalVariable: (StGeneratedTempVariable node: (StTempDeclNode named: '_failureCode')).
	super visitExternalCallNode: anStExternalCallNode!

visitLiteralNode: aLiteralNode
	addToFrame value: aLiteralNode!

visitMethodNode: aMethodNode
	self enterMethodNode: aMethodNode.
	super visitMethodNode: aMethodNode.
	self exitMethodNode: aMethodNode!

visitNode: aNode 
	aNode scope: currentScope.
	^aNode acceptVisitor: self!

visitOptimizedNode: anOptimizedNode
	| wasInStaticExpression outerAddToFrame outerScopes outerCurrentScope |
	outerAddToFrame := addToFrame.
	outerCurrentScope := currentScope.
	outerScopes := scopes.
	(wasInStaticExpression := inStaticExpression)
		ifFalse: 
			[ | methodClass |
			"If entering a static expression the scope is different (static expressions
			 are compiled in the context of the class side), and only some literals are
			 retained in the frame."
			addToFrame := [:literal | self addToFrameStatic: literal].
			methodClass := self methodClass.
			currentScope := StClassScope
						methodClass: (methodClass isMeta ifTrue: [methodClass] ifFalse: [methodClass class]) environment: classScope environment.
			scopes := OrderedCollection new].
	currentScope := scopes addLast: (StMethodScope forScopeNode: anOptimizedNode outer: currentScope).
	anOptimizedNode scope: currentScope.
	inStaticExpression := true.
	[super visitOptimizedNode: anOptimizedNode] ensure: 
			[self removeScope.
			inStaticExpression := wasInStaticExpression.
			addToFrame := outerAddToFrame.
			currentScope := outerCurrentScope.
			scopes := outerScopes]!

visitParameterNode: anStParameterNode
	self currentScope declareArgument: anStParameterNode!

visitPrimitiveNode: anStPrimitiveNode
	self currentScope declareLocalVariable: (StGeneratedTempVariable
				node: (anStPrimitiveNode errorTemp ifNil: [StTempDeclNode named: '_failureCode']))!

visitSelfVariableNode: anStSelfVariableNode
	self visitVariableNode: anStSelfVariableNode!

visitTempDeclNode: anStTempDeclNode
	currentScope declareTemp: anStTempDeclNode!

visitVariableNode: aStVariableNode
	self subclassResponsibility! !
!Kernel.AbstractSemanticAnalyser categoriesForMethods!
addToFrameStatic:!helpers!private! !
currentScope!accessing!private! !
enterMethodNode:!helpers!private! !
errorBlock:!accessing!private! !
exitMethodNode:!helpers!private! !
initialize!initializing!public! !
lineOfSourcePosition:!helpers!private! !
methodClass!accessing!private! !
removeScope!helpers!private! !
scopes!accessing!public! !
setMethodNode:methodClass:environment:context:pools:errorBlock:!initializing!private! !
signalError:forNode:!error handling!private! !
signalError:forNode:extra:!error handling!private! !
signalError:forNode:extras:!error handling!private! !
signalError:forNode:range:extras:!error handling!private! !
visitAnnotationNode:!public!visiting! !
visitAssignmentNode:!public!visitor/double dispatching! !
visitBlockNode:!public!visitor/double dispatching! !
visitExternalArgTypeNode:!public!visiting! !
visitExternalCallNode:!public!visiting! !
visitLiteralNode:!public!visitor/double dispatching! !
visitMethodNode:!public!visitor/double dispatching! !
visitNode:!public!visiting! !
visitOptimizedNode:!public!visitor/double dispatching! !
visitParameterNode:!public!visiting! !
visitPrimitiveNode:!public!visiting! !
visitSelfVariableNode:!public!visiting! !
visitTempDeclNode:!public!visiting! !
visitVariableNode:!public!visitor/double dispatching! !
!

!Kernel.AbstractSemanticAnalyser class methodsFor!

analyseParseTree: aStMethodNode for: aClass environment: aNamespace
	^self
		analyseParseTree: aStMethodNode
		for: aClass
		environment: aNamespace
		context: nil
		pools: #()
		onError: nil!

analyseParseTree: aParseTree for: aClass environment: aNamespace context: anObject pools: anArray onError: aMonadicValuable
	| methodNode |
	methodNode := aParseTree isMethod ifTrue: [aParseTree] ifFalse: [aParseTree methodNode].
	^self new
		setMethodNode: methodNode
			methodClass: aClass
			environment: aNamespace
			context: anObject
			pools: anArray
			errorBlock: aMonadicValuable;
		visitNode: methodNode! !
!Kernel.AbstractSemanticAnalyser class categoriesForMethods!
analyseParseTree:for:environment:!operations!public! !
analyseParseTree:for:environment:context:pools:onError:!operations!public! !
!

