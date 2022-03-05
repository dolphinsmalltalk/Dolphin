"Filed out from Dolphin Smalltalk"!

StParseNodeVisitor subclass: #RBSourceFormatter
	instanceVariableNames: 'codeStream lineStart indent'
	classVariableNames: 'MaxLineLength PeriodsAtEndOfMethod'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBSourceFormatter guid: (GUID fromString: '{9fd4de67-3c87-4496-87b9-7c3cf9655f65}')!
RBSourceFormatter isAbstract: true!
RBSourceFormatter comment: 'RBSourceFormatter is the abstract class of <StParseNodeVisitor>s that pretty print Smalltalk source code.

Instance Variables:
	codeStream	<PositionableStream>	the stream we are writing our output to
	lineStart		<Integer>	the position of the character that started the current line. This is used for calculating the line length.
	indent		<Integer>	how many times are we indenting a new line -- indents are normally tabs but could be any whitespace string
'!
!RBSourceFormatter categoriesForClass!Refactory-ParseTree Matching! !
!RBSourceFormatter methodsFor!

bracketWith: bracketString around: aBlock 
	bracketString isEmpty ifTrue: [^aBlock value].
	codeStream nextPut: bracketString first.
	^aBlock ensure: [codeStream nextPut: bracketString last]!

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

formatTagFor: aMethodNode 
	#rbFix.	"The Dolphin parser is enhanced to actually parse primitives into nodes, so we must visit those nodes"
	"aMethodNode primitiveSources do:
			[:each | 
			codeStream nextPutAll: each.
			self newLine]"
	aMethodNode tag ifNotNil: [:tag | self visitNode: tag]!

indent: anInteger
	indent := anInteger!

indent: anInteger around: aBlock 
	indent := indent + anInteger.
	^aBlock ensure: [indent := indent - anInteger]!

initialize
	super initialize.
	indent := lineStart := 0.
	codeStream := WriteStream on: (Utf8String new: 256)!

isLineTooLong: aString
	^self currentLineLength + aString size >= self maxLineLength!

maxLineLength
	^self class maxLineLength!

newLine
	^self subclassResponsibility!

space
	codeStream space!

visitAnnotationNode: anStPrimitiveNode
	codeStream
		nextPut: $<;
		display: anStPrimitiveNode selector;
		nextPut: $>.
	self newLine!

visitArrayNode: anArrayNode
	self bracketWith: '{}' around: [self formatArray: anArrayNode]!

visitExternalArgTypeNode: anStExternalArgTypeNode
	| typeOrdinal |
	typeOrdinal := anStExternalArgTypeNode typeOrdinal.
	codeStream
		nextPutAll: (ExternalDescriptor nameOf: typeOrdinal type: anStExternalArgTypeNode structClass).
	anStExternalArgTypeNode indirections timesRepeat: [codeStream nextPut: $*]!

visitExternalCallNode: aStExternalCallNode
	codeStream nextPut: $<.
	aStExternalCallNode isOverlapped ifTrue: [codeStream nextPutAll: 'overlap '].
	aStExternalCallNode isVirtual ifTrue: [codeStream nextPutAll: 'virtual '].
	codeStream
		nextPutAll: (ExternalDescriptor nameOfConvention: aStExternalCallNode callingConvention);
		space.
	self visitNode: aStExternalCallNode returnType.
	codeStream space.
	self formatExternalCallName: aStExternalCallNode.
	aStExternalCallNode argumentTypes do: 
			[:each |
			codeStream space.
			self visitNode: each].
	codeStream nextPut: $>.
	self newLine!

visitMethodNode: aMethodNode
	self formatMethodPatternFor: aMethodNode.
	self formatMethodBodyFor: aMethodNode!

visitPrimitiveNode: anStPrimitiveNode
	codeStream
		nextPutAll: '<primitive: ';
		print: anStPrimitiveNode primitiveIndex.
	anStPrimitiveNode errorTemp
		ifNotNil: 
			[:errorTemp |
			codeStream nextPutAll: ' error: '.
			self visitNode: errorTemp].
	codeStream nextPut: $>.
	self newLine!

visitVariableNode: aVariableNode
	codeStream nextPutAll: aVariableNode name! !
!RBSourceFormatter categoriesForMethods!
bracketWith:around:!helpers!private! !
currentLineLength!accessing!private! !
format:!operations!public! !
formatArray:!private! !
formatExternalCallName:!formatting!private! !
formatMethodBodyFor:!formatting!private! !
formatMethodPatternFor:!formatting!private! !
formatStatementCommentsFor:!formatting!private! !
formatTagFor:!formatting!private! !
indent:!formatting!private! !
indent:around:!formatting!private! !
initialize!initializing!private! !
isLineTooLong:!helpers!private! !
maxLineLength!constants!private! !
newLine!formatting!private! !
space!formatting!private! !
visitAnnotationNode:!public!visitor/double dispatching! !
visitArrayNode:!public!visiting! !
visitExternalArgTypeNode:!public!visitor/double dispatching! !
visitExternalCallNode:!public!visitor/double dispatching! !
visitMethodNode:!public!visitor/double dispatching! !
visitPrimitiveNode:!public!visitor/double dispatching! !
visitVariableNode:!public!visitor/double dispatching! !
!

!RBSourceFormatter class methodsFor!

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
!RBSourceFormatter class categoriesForMethods!
format:!public!public interface! !
format:withIndents:!public!public interface! !
initialize!initializing!public! !
maxLineLength!public!settings! !
maxLineLength:!public!settings! !
periodsAtEndOfMethod!public! !
periodsAtEndOfMethod:!public! !
!

