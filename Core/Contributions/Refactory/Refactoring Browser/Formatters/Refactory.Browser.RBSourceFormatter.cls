"Filed out from Dolphin Smalltalk 7"!

Kernel.ParseNodeVisitor subclass: #'Refactory.Browser.RBSourceFormatter'
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
	anStExternalArgTypeNode structClass
		ifNil: 
			[| typeOrdinal |
			typeOrdinal := anStExternalArgTypeNode typeOrdinal.
			codeStream nextPutAll: (External.FunctionDescriptor nameOf: typeOrdinal type: nil)]
		ifNotNil: [:varNode | codeStream nextPutAll: varNode name].
	anStExternalArgTypeNode indirections timesRepeat: [codeStream nextPut: $*]!

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

visitQualifiedReferenceNode: aQualifiedReferenceNode
	codeStream
		nextPutAll: '#{';
		display: aQualifiedReferenceNode pathString.
	aQualifiedReferenceNode isMeta ifTrue: [codeStream nextPutAll: ' class'].
	aQualifiedReferenceNode isPrivate ifTrue: [codeStream nextPutAll: ' private'].
	codeStream nextPut: $}!

visitVariableNode: aVariableNode
	codeStream nextPutAll: aVariableNode name! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #bracketWith:around:!helpers!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #currentLineLength!accessing!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #format:!operations!public! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #formatArray:!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #formatExternalCallName:!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #formatMethodBodyFor:!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #formatMethodPatternFor:!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #formatStatementCommentsFor:!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #formatTagFor:!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #indent:!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #indent:around:!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #initialize!initializing!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #isLineTooLong:!helpers!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #maxLineLength!constants!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #newLine!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #space!formatting!private! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitAnnotationNode:!public!visitor/double dispatching! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitArrayNode:!public!visiting! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitExternalArgTypeNode:!public!visitor/double dispatching! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitExternalCallNode:!public!visitor/double dispatching! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitMethodNode:!public!visitor/double dispatching! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitPrimitiveNode:!public!visitor/double dispatching! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitQualifiedReferenceNode:!public!visiting! !
!Refactory.Browser.RBSourceFormatter categoriesFor: #visitVariableNode:!public!visitor/double dispatching! !

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
!Refactory.Browser.RBSourceFormatter class categoriesFor: #format:!public!public interface! !
!Refactory.Browser.RBSourceFormatter class categoriesFor: #format:withIndents:!public!public interface! !
!Refactory.Browser.RBSourceFormatter class categoriesFor: #initialize!initializing!public! !
!Refactory.Browser.RBSourceFormatter class categoriesFor: #maxLineLength!public!settings! !
!Refactory.Browser.RBSourceFormatter class categoriesFor: #maxLineLength:!public!settings! !
!Refactory.Browser.RBSourceFormatter class categoriesFor: #periodsAtEndOfMethod!public! !
!Refactory.Browser.RBSourceFormatter class categoriesFor: #periodsAtEndOfMethod:!public! !

