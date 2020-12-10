"Filed out from Dolphin Smalltalk 7"!

Kernel.ParseNodeVisitor subclass: #'Tools.Tests.StStyler'
	instanceVariableNames: 'view arrayDepth'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.StStyler guid: (Core.GUID fromString: '{c4f1cf3f-646a-4233-9f38-c110bf4f4dfb}')!
Tools.Tests.StStyler comment: 'StStyler is a <StParseNodeVisitor>s that generates visual style runs for Smalltalk source code from a parse tree. It is intended solely for testing the syntax colouring in DX6.'!
!Tools.Tests.StStyler categoriesForClass!Refactory-ParseTree Matching! !
!Tools.Tests.StStyler methodsFor!

acceptLiteralByteArrayNode: aStLiteralArrayNode 
	| style |
	style := #literalBytes.
	view applyStyle: style toNext: 2.
	aStLiteralArrayNode contents do: 
			[:each | 
			self colourBefore: each.
			self assert: [each value isKindOf: Number].
			view applyStyle: style toNext: each sourceInterval size.
			self colorComments: each postComments.
			self].
	self styleIntersticesUpTo: aStLiteralArrayNode stop - 1.
	view applyStyle: style toNext: 1!

colorComments: aCollection 
	"Note that the anInteger is the start position in the text of the token stream, not the text
	of the view."

	| currentPos |
	currentPos := view stylingPosition.
	aCollection do: 
			[:each | 
			each start >= currentPos 
				ifTrue: 
					[self emitWhitespaceFrom: currentPos to: each start - 1.
					currentPos := each stop + 1.
					view applyStyle: #comment toNext: currentPos - each start]].
	^currentPos!

colourBefore: aStProgramNode 
	self colorComments: aStProgramNode preComments.
	self emitWhitespaceBefore: aStProgramNode!

emitWhitespaceBefore: aStProgramNode 
	self styleInterstitialSpaceBefore: aStProgramNode
	"self emitWhitespaceFrom: view getLastStyled to: aStProgramNode start - 1"!

emitWhitespaceFrom: start to: stop 
	| white |
	white := view plainTextFrom: start to: stop.
	white 
		do: [:each | view applyStyle: (each isSeparator ifTrue: [#whitespace] ifFalse: [#specialCharacter]) toNext: 1]!

onStyleNeeded: aScintillaView from: startInteger to: stopInteger 
	"Callback from Scintilla requesting that the specified text range be coloured."

	| startPos text tree |
	startPos := 1.
	aScintillaView startStylingFrom: startPos.
	text := aScintillaView text.
	tree := Parser parseMethod: text.
	self style: tree in: aScintillaView!

prepareToStyleView: aScintillaView!

style: aNode in: aScintillaView 
	view := aScintillaView.
	arrayDepth := 0.
	view startStylingFrom: 1.
	self visitNode: aNode.
	self emitWhitespaceFrom: view stylingPosition to: view textLength!

styleIntersticesUpTo: anInteger
	| interstice pos last scanner |
	last := view stylingPosition.
	interstice := view plainTextFrom: last to: anInteger.
	pos := 1.
	scanner := Scanner on: interstice readStream.
	scanner do: 
			[:each |
			view applyStyle: #whitespace toNext: each start - pos.
			view applyStyle: (self styleNameFor: each) toNext: each sourceInterval size.
			pos := each stop + 1].
	"Colour any remaining comments"
	scanner getComments
		ifNotNil: 
			[:comments |
			self colorComments: (comments collect: [:each | each start + last - 1 to: each stop + last - 1])].
	view applyStyle: #whitespace toNext: last + interstice size - view stylingPosition!

styleInterstitialSpaceBefore: aStProgramNode 
	self styleIntersticesUpTo: aStProgramNode startWithoutParentheses - 1!

styleMethodPatternFor: aStMethodNode 
	| pos |
	aStMethodNode arguments isEmpty 
		ifTrue: [view applyStyle: #unarySelector toNext: aStMethodNode selectorParts first length]
		ifFalse: 
			[| style |
			style := (aStMethodNode arguments size = 1 and: [aStMethodNode selector isInfix]) 
						ifTrue: [#binarySelector]
						ifFalse: [#keywordSelector].
			aStMethodNode selectorParts with: aStMethodNode arguments
				do: 
					[:key :arg | 
					self styleIntersticesUpTo: key start - 1.
					view applyStyle: style toNext: key length.
					self colourBefore: arg.
					view applyStyle: #argDecl toNext: arg name size.
					self colorComments: arg postComments]].
	pos := view stylingPosition.
	self colorComments: (aStMethodNode comments select: [:each | each start > pos])!

styleNameFor: aStToken 
	aStToken isSpecial ifTrue: [^#specialCharacter].
	aStToken isAssignment ifTrue: [^#assignment].
	aStToken isIdentifier ifTrue: [^#identifier].
	^aStToken value literalTextStyle!

styleSelectorAndArguments: aStMessageNode 
	aStMessageNode arguments isEmpty 
		ifTrue: 
			[| selector |
			selector := aStMessageNode selectorParts first.
			self styleIntersticesUpTo: selector start - 1.
			view applyStyle: #unaryMessage toNext: selector length]
		ifFalse: 
			[| style |
			style := (aStMessageNode arguments size = 1 and: [aStMessageNode selector isInfix]) 
						ifTrue: [#binaryMessage]
						ifFalse: [#keywordMessage].
			aStMessageNode selectorParts with: aStMessageNode arguments
				do: 
					[:key :arg | 
					self styleIntersticesUpTo: key start - 1.
					view applyStyle: style toNext: key length.
					self visitNode: arg]]!

styleTemporaries: anArray 
	anArray do: 
			[:each | 
			self colourBefore: each.
			view applyStyle: #tempDecl toNext: each name size.
			self colorComments: each postComments]!

visitAnnotationNode: anStAnnotationNode
	(view plainTextRange: anStAnnotationNode sourceInterval)
		do: [:each | view applyStyle: (each isSeparator ifTrue: [#whitespace] ifFalse: [#tag]) toNext: 1]!

visitAssignmentNode: anAssignmentNode
	self visitNode: anAssignmentNode variable.
	self styleInterstitialSpaceBefore: anAssignmentNode value.
	self visitNode: anAssignmentNode value!

visitBlockNode: aBlockNode
	| pos |
	view applyStyle: #specialCharacter toNext: 1.
	aBlockNode arguments notEmpty
		ifTrue: 
			[aBlockNode arguments do: 
					[:each |
					self colourBefore: each.
					view applyStyle: #blockArgDecl toNext: each name size.
					self colorComments: each postComments].
			pos := view stylingPosition.
			[(view characterAt: pos) isSeparator] whileTrue: [pos := pos + 1].
			view applyStyle: #whitespace toNext: pos - view stylingPosition.
			view applyStyle: #tempCloseBar toNext: 1].
	aBlockNode body sourceInterval isEmpty ifFalse: [self visitNode: aBlockNode body].
	self styleIntersticesUpTo: aBlockNode stopWithoutParentheses - 1.
	view applyStyle: #specialCharacter toNext: 1!

visitCascadeNode: aCascadeNode
	self visitNode: aCascadeNode messages first.
	(aCascadeNode messages copyFrom: 2) with: aCascadeNode semicolons
		do: 
			[:eachNode :eachSemi |
			"self colorComments: eachNode preComments.
			self emitWhitespaceFrom: view getLastStyled to: eachSemi."
			self styleSelectorAndArguments: eachNode.
			self colorComments: eachNode postComments]!

visitExternalCallNode: anStExternalCallNode
	self visitPrimitiveNode: anStExternalCallNode!

visitLiteralArrayNode: aRBLiteralArrayNode
	aRBLiteralArrayNode isForByteArray
		ifTrue: 
			[self acceptLiteralByteArrayNode: aRBLiteralArrayNode.
			^self].
	arrayDepth := arrayDepth + 1.
	view applyStyle: #literalArray
		toNext: ((view characterAt: view stylingPosition) = $# ifTrue: [2] ifFalse: [1]).
	"view applyStyle: #specialCharacter toNext: 2."
	aRBLiteralArrayNode contents do: [:each | self visitNode: each].
	self styleIntersticesUpTo: aRBLiteralArrayNode stop - 1.
	view applyStyle: #literalArray toNext: 1.
	arrayDepth := arrayDepth - 1!

visitLiteralNode: aLiteralNode
	| value sourceSize |
	value := aLiteralNode value.
	sourceSize := aLiteralNode stopWithoutParentheses - aLiteralNode startWithoutParentheses + 1.
	(value isKindOf: Number)
		ifTrue: [view applyStyle: #literalNumber toNext: sourceSize]
		ifFalse: 
			[(#(false true nil) includes: value)
				ifTrue: [view applyStyle: #literalPseudo toNext: value printString size]
				ifFalse: 
					[value class == Symbol
						ifTrue: [view applyStyle: #literalSymbol toNext: sourceSize]
						ifFalse: 
							[value class == Character
								ifTrue: [view applyStyle: #literalCharacter toNext: 2]
								ifFalse: [view applyStyle: #literalString toNext: value printString size]]]]!

visitMessageNode: aMessageNode
	self visitNode: aMessageNode receiver.
	self styleSelectorAndArguments: aMessageNode!

visitMethodNode: aMethodNode
	self styleMethodPatternFor: aMethodNode.
	aMethodNode body acceptVisitor: self.
	self colorComments: aMethodNode body postComments!

visitNode: aNode 
	self colourBefore: aNode.
	aNode acceptVisitor: self.
	self colorComments: aNode postComments!

visitOptimizedNode: anOptimizedNode
	view applyStyle: #specialCharacter toNext: 2.
	self visitNode: anOptimizedNode body!

visitPrimitiveNode: anStPrimitiveNode
	(view plainTextRange: anStPrimitiveNode sourceInterval)
		do: [:each | view applyStyle: (each isSeparator ifTrue: [#whitespace] ifFalse: [#tag]) toNext: 1]!

visitReturnNode: aReturnNode
	view applyStyle: #specialCharacter toNext: 1.
	self visitNode: aReturnNode value!

visitSequenceNode: aSequenceNode
	aSequenceNode leftBar
		ifNotNil: 
			[:start |
			self styleIntersticesUpTo: start - 1.
			view applyStyle: #tempOpenBar toNext: 1.
			self styleTemporaries: aSequenceNode temporaries.
			self styleIntersticesUpTo: aSequenceNode rightBar - 1.
			view applyStyle: #tempCloseBar toNext: 1].
	aSequenceNode statements do: [:each | self visitNode: each]!

visitVariableNode: aVariableNode
	view applyStyle: #identifier toNext: aVariableNode name size! !
!Tools.Tests.StStyler categoriesFor: #acceptLiteralByteArrayNode:!public!unit tests! !
!Tools.Tests.StStyler categoriesFor: #colorComments:!helpers!private! !
!Tools.Tests.StStyler categoriesFor: #colourBefore:!helpers!private! !
!Tools.Tests.StStyler categoriesFor: #emitWhitespaceBefore:!private!unit tests! !
!Tools.Tests.StStyler categoriesFor: #emitWhitespaceFrom:to:!helpers!private! !
!Tools.Tests.StStyler categoriesFor: #onStyleNeeded:from:to:!event handling!public! !
!Tools.Tests.StStyler categoriesFor: #prepareToStyleView:!event handling!public! !
!Tools.Tests.StStyler categoriesFor: #style:in:!operations!public! !
!Tools.Tests.StStyler categoriesFor: #styleIntersticesUpTo:!private!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #styleInterstitialSpaceBefore:!private!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #styleMethodPatternFor:!private!unit tests! !
!Tools.Tests.StStyler categoriesFor: #styleNameFor:!private!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #styleSelectorAndArguments:!private!unit tests! !
!Tools.Tests.StStyler categoriesFor: #styleTemporaries:!private!unit tests! !
!Tools.Tests.StStyler categoriesFor: #visitAnnotationNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitAssignmentNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitBlockNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitCascadeNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitExternalCallNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitLiteralArrayNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitMethodNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitNode:!public!visiting! !
!Tools.Tests.StStyler categoriesFor: #visitOptimizedNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitPrimitiveNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitReturnNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitSequenceNode:!public!visitor/double dispatching! !
!Tools.Tests.StStyler categoriesFor: #visitVariableNode:!public!visitor/double dispatching! !

