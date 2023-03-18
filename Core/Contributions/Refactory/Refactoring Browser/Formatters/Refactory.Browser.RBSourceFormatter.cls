"Filed out from Dolphin Smalltalk"!

Kernel.ParseNodeVisitor
	subclass: #'Refactory.Browser.RBSourceFormatter'
	instanceVariableNames: 'codeStream lineStart indent'
	classVariableNames: 'MaxLineLength PeriodsAtEndOfMethod'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBSourceFormatter guid: (Core.GUID fromString: '{9fd4de67-3c87-4496-87b9-7c3cf9655f65}')!
Refactory.Browser.RBSourceFormatter isNonInstantiable: true!
Refactory.Browser.RBSourceFormatter comment: 'RBSourceFormatter is the abstract class of <StParseNodeVisitor>s that pretty print Smalltalk source code.

Instance Variables:
	codeStream	<PositionableStream>	the stream we are writing our output to
	lineStart		<Integer>	the position of the character that started the current line. This is used for calculating the line length.
	indent		<Integer>	how many times are we indenting a new line -- indents are normally tabs but could be any whitespace string
'!
!Refactory.Browser.RBSourceFormatter categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.RBSourceFormatter methodsFor!

currentLineLength
	^codeStream position - lineStart!

format: aNode
	self visitNode: aNode.
	^codeStream contents!

formatArray: anArrayNode 
	^self subclassResponsibility!

formatExternalCallName: aStExternalCallNode
	| name |
	name := aStExternalCallNode nameOrOrdinal.
	(name isInteger or: [Symbol isLiteralSymbol: name])
		ifTrue: [codeStream display: name]
		ifFalse: [codeStream print: name]!

formatMethodBodyFor: aMethodNode 
	^self subclassResponsibility!

formatMethodPatternFor: aMethodNode 
	^self subclassResponsibility!

formatStatementCommentsFor: aStatementNode
	^self subclassResponsibility!

formatTagsFor: aMethodNode
	#rbFix.	"The Dolphin parser is enhanced to actually parse primitives into nodes, so we must visit those nodes"
	"aMethodNode primitiveSources do:
			[:each | 
			codeStream nextPutAll: each.
			self newLine]"
	aMethodNode tags do: [:each | self visitNode: each. self newLine]!

indent: anInteger
	indent := anInteger!

initialize
	super initialize.
	indent := lineStart := 0.
	codeStream := WriteStream on: (Utf8String new: 256)!

isLineTooLong: aString
	^self currentLineLength + aString size >= MaxLineLength!

newLine
	^self subclassResponsibility!

space
	codeStream space!

visitAnnotationNode: aStAnnotationNode
	codeStream nextPut: $<.
	aStAnnotationNode argumentCount == 0
		ifTrue: [codeStream display: aStAnnotationNode selector]
		ifFalse: 
			[| keywords args |
			keywords := aStAnnotationNode selector keywords.
			args := aStAnnotationNode arguments.
			1 to: keywords size
				do: 
					[:i |
					i == 1 ifFalse: [codeStream space].
					codeStream
						nextPutAll: (keywords at: i);
						space.
					self visitNode: (args at: i)]].
	codeStream nextPut: $>!

visitArrayNode: anArrayNode
	codeStream nextPut: ${.
	self formatArray: anArrayNode.
	codeStream nextPut: $}!

visitExternalArgTypeNode: aStExternalArgTypeNode
	aStExternalArgTypeNode structClass
		ifNil: 
			[| typeOrdinal |
			typeOrdinal := aStExternalArgTypeNode typeOrdinal.
			codeStream nextPutAll: (External.FunctionDescriptor nameOf: typeOrdinal type: nil)]
		ifNotNil: [:varNode | self visitNode: varNode].
	aStExternalArgTypeNode indirections timesRepeat: [codeStream nextPut: $*]!

visitExternalCallNode: aStExternalCallNode
	codeStream nextPut: $<.
	aStExternalCallNode isOverlapped ifTrue: [codeStream nextPutAll: 'overlap '].
	aStExternalCallNode isVirtual ifTrue: [codeStream nextPutAll: 'virtual '].
	codeStream
		nextPutAll: (External.FunctionDescriptor nameOfConvention: aStExternalCallNode callingConvention);
		space.
	self visitNode: aStExternalCallNode returnType.
	codeStream space.
	self formatExternalCallName: aStExternalCallNode.
	aStExternalCallNode argumentTypes do: 
			[:each |
			codeStream space.
			self visitNode: each].
	codeStream nextPut: $>.!

visitLiteralArrayNode: aRBArrayLiteralNode
	codeStream nextPutAll: '#('.
	aRBArrayLiteralNode contents do: [:each | self visitNode: each] separatedBy: [self space].
	codeStream nextPut: $)!

visitLiteralByteArrayNode: aRBLiteralByteArrayNode
	codeStream nextPutAll: '#['.
	aRBLiteralByteArrayNode contents do: [:each | self visitNode: each] separatedBy: [self space].
	codeStream nextPut: $]!

visitMethodNode: aMethodNode
	self formatMethodPatternFor: aMethodNode.
	self formatMethodBodyFor: aMethodNode!

visitPrimitiveNode: aStPrimitiveNode
	codeStream
		nextPutAll: '<primitive: ';
		print: aStPrimitiveNode primitiveIndex.
	aStPrimitiveNode errorTemp
		ifNotNil: 
			[:errorTemp |
			codeStream nextPutAll: ' error: '.
			self visitNode: errorTemp].
	codeStream nextPut: $>!

visitQualifiedReferenceNode: aQualifiedReferenceNode
	codeStream
		nextPutAll: '#{';
		display: aQualifiedReferenceNode pathString.
	aQualifiedReferenceNode isMeta ifTrue: [codeStream nextPutAll: ' class'].
	aQualifiedReferenceNode isPrivate ifTrue: [codeStream nextPutAll: ' private'].
	codeStream nextPut: $}!

visitVariableNode: aVariableNode
	codeStream nextPutAll: aVariableNode name.
	^aVariableNode! !
!Refactory.Browser.RBSourceFormatter categoriesForMethods!
currentLineLength!accessing!private! !
format:!operations!public! !
formatArray:!private! !
formatExternalCallName:!formatting!private! !
formatMethodBodyFor:!formatting!private! !
formatMethodPatternFor:!formatting!private! !
formatStatementCommentsFor:!formatting!private! !
formatTagsFor:!formatting!private! !
indent:!formatting!private! !
initialize!initializing!private! !
isLineTooLong:!helpers!private! !
newLine!formatting!private! !
space!formatting!private! !
visitAnnotationNode:!public!visitor/double dispatching! !
visitArrayNode:!public!visiting! !
visitExternalArgTypeNode:!public!visitor/double dispatching! !
visitExternalCallNode:!public!visitor/double dispatching! !
visitLiteralArrayNode:!public!visitor/double dispatching! !
visitLiteralByteArrayNode:!public!visitor/double dispatching! !
visitMethodNode:!public!visitor/double dispatching! !
visitPrimitiveNode:!public!visitor/double dispatching! !
visitQualifiedReferenceNode:!public!visiting! !
visitVariableNode:!public!visitor/double dispatching! !
!

!Refactory.Browser.RBSourceFormatter class methodsFor!

format: aParseTree 
	^self format: aParseTree withIndents: 0!

format: aParseTree withIndents: anInteger 
	^(self new)
		indent: anInteger;
		format: aParseTree!

initialize
	"
		self initialize
	"

	self maxLineLength: 100.
	self periodsAtEndOfMethod: true!

maxLineLength
	^MaxLineLength!

maxLineLength: anInteger 
	MaxLineLength := anInteger!

periodsAtEndOfMethod
	"Answer whether the methods should be formatted with a period at the end of the last
	statement in the method or not - syntactically the period is not required, but it makes it
	easier to add new statements at the end of the method."

	^PeriodsAtEndOfMethod!

periodsAtEndOfMethod: aBoolean 
	PeriodsAtEndOfMethod := aBoolean! !
!Refactory.Browser.RBSourceFormatter class categoriesForMethods!
format:!public!public interface! !
format:withIndents:!public!public interface! !
initialize!initializing!public! !
maxLineLength!public!settings! !
maxLineLength:!public!settings! !
periodsAtEndOfMethod!public! !
periodsAtEndOfMethod:!public! !
!

