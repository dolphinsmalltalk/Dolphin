"Filed out from Dolphin Smalltalk"!

Kernel.StValueNode subclass: #'Kernel.StBlockNode'
	instanceVariableNames: 'left right body arguments bar'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StBlockNode guid: (Core.GUID fromString: '{74b8b736-f1fe-4d03-911f-c6f7f11620e8}')!
Kernel.StBlockNode comment: 'StBlockNode is a parse tree node that represents a block "[...]".

Instance Variables:
	arguments	<SequenceableCollection> of <StVariableNode>	the arguments for the block
	bar	<Integer | nil>	position of the | after the arguments
	body	<StSequenceNode>	the code inside the block
	colons	<SequenceableCollection> of <Integer>	positions of each : before each argument
	left	<Integer>	position of [
	right	<Integer>	position of ]

'!
!Kernel.StBlockNode categoriesForClass!System-Compiler! !
!Kernel.StBlockNode methodsFor!

= anObject
	| otherArgs |
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	body = anObject body ifFalse: [^false].
	otherArgs := anObject arguments.
	arguments size = otherArgs size ifFalse: [^false].
	1 to: arguments size do: [:i | (arguments at: i) = (otherArgs at: i) ifFalse: [^false]].
	^true!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitBlockNode: self!

actualScope
	"Answer the actual scope in which this nodes variables will be defined."

	^self isInlined ifTrue: [self outer actualScope] ifFalse: [self]!

addStatementCommentsTo: anOrderedCollection
	comments ifNotNil: [anOrderedCollection addAllLast: comments]!

allArgumentVariableNodesDo: aMonadicValuable
	self arguments do: aMonadicValuable.
	super allArgumentVariableNodesDo: aMonadicValuable!

allDefinedVariableNodesDo: aMonadicValuable 
	self arguments do: aMonadicValuable.
	self childrenDo: [:each | each allDefinedVariableNodesDo: aMonadicValuable]!

argumentCount
	^arguments size!

argumentNames
	^self arguments collect: [:each | each name]!

arguments
	^arguments!

arguments: argCollection 
	arguments := argCollection.
	arguments do: [:each | each parent: self]!

bar
	^bar!

bar: anObject
	bar := anObject!

barOrStop
	^self bar ifNil: [self stopWithoutParentheses]!

blockVariables
	^super blockVariables , self argumentNames!

body
	^body!

body: stmtsNode 
	body := stmtsNode.
	body parent: self!

childrenDo: aMonadicValuable
	arguments do: aMonadicValuable.
	aMonadicValuable value: body!

defines: aName 
	^arguments anySatisfy: [:each | each name = aName]!

directlyUses: aNode 
	^false!

hash
	^self arguments hash bitXor: self body hash!

isBlock
	^true!

isEmptyBlock
	^body statements isEmpty!

isImmediateNode
	^true!

isInlined
	"Answer whether the receiver is an inlined block (i.e. one which is the receiver or an argument of an optimised message that is inlined in the home method."

	^self parent isMessage and: [self parent isInlineable]!

isLast: aNode 
	^body isLast: aNode!

left
	^left!

left: anObject
	left := anObject!

needsParenthesis
	^false!

postCopy
	super postCopy.
	self arguments: (arguments collect: [:each | each copy]).
	self body: body copy.
	^self!

precedence
	^0!

right
	^right!

right: anObject
	right := anObject!

startWithoutParentheses
	^left!

stopWithoutParentheses
	^right!

uses: aNode 
	aNode = body ifFalse: [^false].
	^parent isMessage 
		ifTrue: 
			[(#(#ifTrue:ifFalse: #ifTrue: #ifFalse: #ifFalse:ifTrue:) 
				includes: parent selector) not 
				or: [parent isUsed]]
		ifFalse: [self isUsed]! !
!Kernel.StBlockNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
actualScope!accessing!public! !
addStatementCommentsTo:!accessing!private! !
allArgumentVariableNodesDo:!accessing!public! !
allDefinedVariableNodesDo:!accessing!public! !
argumentCount!accessing!public! !
argumentNames!accessing!public! !
arguments!accessing!public! !
arguments:!accessing!public! !
bar!accessing!public! !
bar:!accessing!public! !
barOrStop!accessing!public! !
blockVariables!accessing!public! !
body!accessing!public! !
body:!accessing!public! !
childrenDo:!accessing!public! !
defines:!public!testing! !
directlyUses:!public!testing! !
hash!comparing!public! !
isBlock!public!testing! !
isEmptyBlock!public!testing! !
isImmediateNode!public!testing! !
isInlined!public!testing! !
isLast:!public!testing! !
left!accessing!public! !
left:!accessing!public! !
needsParenthesis!public!testing! !
postCopy!copying!public! !
precedence!accessing!public! !
right!accessing!public! !
right:!accessing!public! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
uses:!public!testing! !
!

!Kernel.StBlockNode class methodsFor!

arguments: argNodes body: sequenceNode 
	^(self new)
		arguments: argNodes;
		body: sequenceNode;
		yourself!

body: sequenceNode 
	^self arguments: #() body: sequenceNode! !
!Kernel.StBlockNode class categoriesForMethods!
arguments:body:!instance creation!public! !
body:!instance creation!public! !
!

