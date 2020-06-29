"Filed out from Dolphin Smalltalk 7"!

StValueNode subclass: #StBlockNode
	instanceVariableNames: 'left right colons body arguments bar'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StBlockNode guid: (GUID fromString: '{74b8b736-f1fe-4d03-911f-c6f7f11620e8}')!
StBlockNode comment: 'StBlockNode is a parse tree node that represents a block "[...]".

Instance Variables:
	arguments	<SequenceableCollection> of <StVariableNode>	the arguments for the block
	bar	<Integer | nil>	position of the | after the arguments
	body	<StSequenceNode>	the code inside the block
	colons	<SequenceableCollection> of <Integer>	positions of each : before each argument
	left	<Integer>	position of [
	right	<Integer>	position of ]

'!
!StBlockNode categoriesForClass!System-Compiler! !
!StBlockNode methodsFor!

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
	| vars |
	#rbFix. "asOrderedCollection"
	vars := OrderedCollection withAll: super blockVariables.
	vars addAll: self argumentNames.
	^vars!

body
	^body!

body: stmtsNode 
	body := stmtsNode.
	body parent: self!

childrenDo: aMonadicValuable 
	self arguments do: aMonadicValuable.
	aMonadicValuable value: self body!

colons: aCollection 
	colons := aCollection!

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
!StBlockNode categoriesFor: #=!comparing!public! !
!StBlockNode categoriesFor: #acceptVisitor:!public!visitor! !
!StBlockNode categoriesFor: #actualScope!public! !
!StBlockNode categoriesFor: #addStatementCommentsTo:!accessing!private! !
!StBlockNode categoriesFor: #allArgumentVariableNodesDo:!accessing!public! !
!StBlockNode categoriesFor: #allDefinedVariableNodesDo:!accessing!public! !
!StBlockNode categoriesFor: #argumentCount!accessing!public! !
!StBlockNode categoriesFor: #argumentNames!accessing!public! !
!StBlockNode categoriesFor: #arguments!accessing!public! !
!StBlockNode categoriesFor: #arguments:!accessing!public! !
!StBlockNode categoriesFor: #bar!accessing!public! !
!StBlockNode categoriesFor: #bar:!accessing!public! !
!StBlockNode categoriesFor: #barOrStop!accessing!public! !
!StBlockNode categoriesFor: #blockVariables!accessing!public! !
!StBlockNode categoriesFor: #body!accessing!public! !
!StBlockNode categoriesFor: #body:!accessing!public! !
!StBlockNode categoriesFor: #childrenDo:!accessing!public! !
!StBlockNode categoriesFor: #colons:!accessing!public! !
!StBlockNode categoriesFor: #defines:!public!testing! !
!StBlockNode categoriesFor: #directlyUses:!public!testing! !
!StBlockNode categoriesFor: #hash!comparing!public! !
!StBlockNode categoriesFor: #isBlock!public!testing! !
!StBlockNode categoriesFor: #isEmptyBlock!public!testing! !
!StBlockNode categoriesFor: #isImmediateNode!public!testing! !
!StBlockNode categoriesFor: #isInlined!public! !
!StBlockNode categoriesFor: #isLast:!public!testing! !
!StBlockNode categoriesFor: #left!accessing!public! !
!StBlockNode categoriesFor: #left:!accessing!public! !
!StBlockNode categoriesFor: #needsParenthesis!public!testing! !
!StBlockNode categoriesFor: #postCopy!copying!public! !
!StBlockNode categoriesFor: #precedence!accessing!public! !
!StBlockNode categoriesFor: #right!accessing!public! !
!StBlockNode categoriesFor: #right:!accessing!public! !
!StBlockNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StBlockNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StBlockNode categoriesFor: #uses:!public!testing! !

!StBlockNode class methodsFor!

arguments: argNodes body: sequenceNode 
	^(self new)
		arguments: argNodes;
		body: sequenceNode;
		yourself!

body: sequenceNode 
	^self arguments: #() body: sequenceNode! !
!StBlockNode class categoriesFor: #arguments:body:!instance creation!public! !
!StBlockNode class categoriesFor: #body:!instance creation!public! !

