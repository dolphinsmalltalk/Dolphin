"Filed out from Dolphin Smalltalk"!

Kernel.Parser subclass: #'Refactory.Browser.RBPatternParser'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBPatternParser guid: (Core.GUID fromString: '{efae231d-9476-470e-9bef-e65273b2f157}')!
Refactory.Browser.RBPatternParser comment: 'RBPatternParser is an extended <SmalltalkParser> that supports the RB''s extended syntax for pattern matching trees. The resulting trees are used as inputs to the <ParseTreeSearcher> and <ParseTreeRewriter> for searching and transforming source code (respectively).
'!
!Refactory.Browser.RBPatternParser categoriesForClass!Refactory-Parser! !
!Refactory.Browser.RBPatternParser methodsFor!

annotationNodeClass
	^RBPatternAnnotationNode!

evaluateStatements: aStSequenceNode
	^nil!

messageNodeClass
	^RBPatternMessageNode!

methodNodeClass
	^RBPatternMethodNode!

parameterNodeClass
	^RBPatternVariableNode!

parseLiteralByteArrayObject
	(currentToken isIdentifier and: [currentToken isPatternVariable]) 
		ifTrue: 
			[| node |
			node := self variableNodeClass identifierToken: currentToken.
			node isLiteralNode 
				ifTrue: 
					[self step.
					^node]].
	^super parseLiteralByteArrayObject!

parsePatternBlock: aClass
	| position node |
	position := currentToken start.
	self step.
	node := self parseBlockArgsInto: aClass new.
	node left: position.
	node body: (self parseStatementsOf: node).
	#rbFix.	"Use #isSpecial: and Dolphin compiler compatible error reporting"
	(currentToken isSpecial: $}) ifFalse: [self parserError: CErrBraceNotClosed].
	node right: currentToken start.
	self step.
	^node!

parsePrimitiveLiteral
	(currentToken isIdentifier and: [currentToken isPatternVariable])
		ifTrue: 
			[| node |
			node := self variableNodeClass identifierToken: currentToken.
			node isLiteralNode
				ifTrue: 
					[self step.
					^node].
			currentToken := StLiteralToken
						start: currentToken start
						comments: nil
						value: currentToken value asSymbol
						stop: currentToken stop].
	^super parsePrimitiveLiteral!

parsePrimitiveObject
	currentToken isPatternBlock ifTrue: [^self parsePatternBlock: RBPatternBlockNode].
	^super parsePrimitiveObject!

parseUnaryMessage
	| node |
	node := self parsePrimitiveObject.
	self addCommentsTo: node.
	
	[currentToken isLiteralToken ifTrue: [self patchLiteralMessage].
	currentToken isPatternBlock
		ifTrue: 
			[node := (self parsePatternBlock: RBPatternWrapperBlockNode)
						wrappedNode: node;
						yourself].
	currentToken isIdentifier]
			whileTrue: [node := self parseUnaryMessageWith: node].
	self addCommentsTo: node.
	^node!

patchLiteralArrayToken
	(currentToken isIdentifier and: [currentToken isPatternVariable]) 
		ifTrue: [^self].
	super patchLiteralArrayToken!

scannerClass
	^RBPatternScanner!

tempDeclClass
	^self variableNodeClass!

variableNodeClass
	^RBPatternVariableNode! !
!Refactory.Browser.RBPatternParser categoriesForMethods!
annotationNodeClass!constants!private! !
evaluateStatements:!parsing!private! !
messageNodeClass!constants!private! !
methodNodeClass!constants!private! !
parameterNodeClass!constants!private! !
parseLiteralByteArrayObject!parsing!public! !
parsePatternBlock:!parsing!private! !
parsePrimitiveLiteral!parsing!public! !
parsePrimitiveObject!parsing!private! !
parseUnaryMessage!parsing!private! !
patchLiteralArrayToken!helpers!public! !
scannerClass!accessing!public! !
tempDeclClass!parsing!private! !
variableNodeClass!constants!private! !
!

