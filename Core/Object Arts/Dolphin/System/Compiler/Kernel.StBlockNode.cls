"Filed out from Dolphin Smalltalk 7"!

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
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	self body = anObject body ifFalse: [^false].
	self arguments size = anObject arguments size ifFalse: [^false].
	1 to: self arguments size
		do: [:i | (self arguments at: i) = (anObject arguments at: i) ifFalse: [^false]].
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
	self arguments do: aMonadicValuable.
	aMonadicValuable value: self body!

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
!Kernel.StBlockNode categoriesFor: #=!comparing!public! !
!Kernel.StBlockNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StBlockNode categoriesFor: #actualScope!public! !
!Kernel.StBlockNode categoriesFor: #addStatementCommentsTo:!accessing!private! !
!Kernel.StBlockNode categoriesFor: #allArgumentVariableNodesDo:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #allDefinedVariableNodesDo:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #argumentCount!accessing!public! !
!Kernel.StBlockNode categoriesFor: #argumentNames!accessing!public! !
!Kernel.StBlockNode categoriesFor: #arguments!accessing!public! !
!Kernel.StBlockNode categoriesFor: #arguments:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #bar!accessing!public! !
!Kernel.StBlockNode categoriesFor: #bar:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #barOrStop!accessing!public! !
!Kernel.StBlockNode categoriesFor: #blockVariables!accessing!public! !
!Kernel.StBlockNode categoriesFor: #body!accessing!public! !
!Kernel.StBlockNode categoriesFor: #body:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #defines:!public!testing! !
!Kernel.StBlockNode categoriesFor: #directlyUses:!public!testing! !
!Kernel.StBlockNode categoriesFor: #hash!comparing!public! !
!Kernel.StBlockNode categoriesFor: #isBlock!public!testing! !
!Kernel.StBlockNode categoriesFor: #isEmptyBlock!public!testing! !
!Kernel.StBlockNode categoriesFor: #isImmediateNode!public!testing! !
!Kernel.StBlockNode categoriesFor: #isInlined!public! !
!Kernel.StBlockNode categoriesFor: #isLast:!public!testing! !
!Kernel.StBlockNode categoriesFor: #left!accessing!public! !
!Kernel.StBlockNode categoriesFor: #left:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StBlockNode categoriesFor: #postCopy!copying!public! !
!Kernel.StBlockNode categoriesFor: #precedence!accessing!public! !
!Kernel.StBlockNode categoriesFor: #right!accessing!public! !
!Kernel.StBlockNode categoriesFor: #right:!accessing!public! !
!Kernel.StBlockNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StBlockNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StBlockNode categoriesFor: #uses:!public!testing! !

!Kernel.StBlockNode class methodsFor!

arguments: argNodes body: sequenceNode 
	^(self new)
		arguments: argNodes;
		body: sequenceNode;
		yourself!

body: sequenceNode 
	^self arguments: #() body: sequenceNode! !
!Kernel.StBlockNode class categoriesFor: #arguments:body:!instance creation!public! !
!Kernel.StBlockNode class categoriesFor: #body:!instance creation!public! !

