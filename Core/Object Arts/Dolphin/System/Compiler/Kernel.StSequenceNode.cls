"Filed out from Dolphin Smalltalk"!

Kernel.StProgramNode
	subclass: #'Kernel.StSequenceNode'
	instanceVariableNames: 'leftBar rightBar statements periods temporaries'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSequenceNode guid: (Core.GUID fromString: '{73c3638c-06a8-4c0d-99ae-a572d08b5150}')!
Kernel.StSequenceNode comment: 'StSequenceNode is a parse tree node that represents a sequence of statements. Both StBlockNodes and StMethodNodes contain these.

Instance Variables:
	leftBar	<Integer | nil>	the position of the left | in the temporaries definition
	periods	<SequenceableCollection> of <Integer>	the positions of all the periods that separate the statements
	rightBar	<Integer | nil>	the position of the right | in the temporaries definition
	statements	<SequenceableCollection> of <StStatementNode>	the statement nodes
	temporaries	<SequenceableCollection> of <StVariableNode>	the temporaries defined

'!
!Kernel.StSequenceNode categoriesForClass!System-Compiler! !
!Kernel.StSequenceNode methodsFor!

= anObject
	"Can't send = to the temporaries and statements collection since they might change from arrays to OCs"

	| count hisChildren |
	self == anObject ifTrue: [^true].
	self class == anObject class ifFalse: [^false].
	count := temporaries size.
	count == (hisChildren := anObject temporaries) size ifFalse: [^false].
	1 to: count do: [:i | (temporaries at: i) = (hisChildren at: i) ifFalse: [^false]].
	count := statements size.
	count == (hisChildren := anObject statements) size ifFalse: [^false].
	1 to: count do: [:i | (statements at: i) = (hisChildren at: i) ifFalse: [^false]].
	^true!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitSequenceNode: self!

allDefinedVariableNodesDo: aMonadicValuable 
	self temporaries do: aMonadicValuable.
	self childrenDo: [:each | each allDefinedVariableNodesDo: aMonadicValuable]!

allTemporaryVariableNodesDo: aMonadicValuable
	self temporaries do: aMonadicValuable.
	super allTemporaryVariableNodesDo: aMonadicValuable!

bestNodeFor: anInterval 
	| node |
	node := super bestNodeFor: anInterval.
	node == self 
		ifTrue: 
			[(temporaries isEmpty and: [statements size == 1]) 
				ifTrue: [^statements first]].
	^node!

childrenDo: aMonadicValuable
	temporaries do: aMonadicValuable.
	statements do: aMonadicValuable!

defines: aName 
	^temporaries anySatisfy: [:each | each name = aName]!

directlyUses: aNode 
	^false!

hash
	^(self hashForCollection: self temporaries) bitXor: (self hashForCollection: self statements)!

isLast: aNode 
	| last |
	statements isEmpty ifTrue: [^false].
	last := statements last.
	^last == aNode or: 
			[last isMessage and: 
					[(#(#ifTrue:ifFalse: #ifFalse:ifTrue:) includes: last selector) 
						and: [last arguments anySatisfy: [:each | each isLast: aNode]]]]!

isSequence
	^true!

lastIsReturn
	^statements notEmpty and: [statements last lastIsReturn]!

leftBar
	^leftBar!

leftBar: leftInteger temporaries: variableNodes rightBar: rightInteger 
	leftBar := leftInteger.
	self temporaries: variableNodes.
	rightBar := rightInteger!

methodComments
	| methodComments |
	methodComments := OrderedCollection withAll: self comments.
	temporaries do: [:each | methodComments addAll: each comments].
	(parent notNil and: [parent isBlock]) 
		ifTrue: [parent arguments do: [:each | methodComments addAll: each comments]].
	^methodComments sort: [:a :b | a first < b first]!

outer
	"Answer the <StMethodNode> or <StBlockNode> being the scope in which this node exists."

	^self parent!

periods: anOrderedCollection
	periods := anOrderedCollection!

postCopy
	super postCopy.
	self temporaries: (temporaries collect: [:each | each copy]).
	self statements: (statements collect: [:each | each copy]).
	^self!

rightBar
	^rightBar!

start
	^leftBar ifNil: [statements isEmpty ifTrue: [1] ifFalse: [statements first start]]!

statements
	^statements!

statements: stmtCollection 
	statements := stmtCollection.
	statements do: [:each | each parent: self]!

stop
	^(periods isEmpty ifTrue: [0] ifFalse: [periods last]) 
		max: (statements isEmpty ifTrue: [0] ifFalse: [statements last stop])!

temporaries
	^temporaries!

temporaries: tempCollection 
	temporaries := tempCollection.
	temporaries do: [:each | each parent: self]!

temporaryNames
	^temporaries collect: [:each | each name]!

temporaryVariables
	^super temporaryVariables , self temporaryNames!

uses: aNode 
	statements isEmpty ifTrue: [^false].
	aNode == statements last ifFalse: [^false].
	^self isUsed!

whichNodeIsContainedBy: anInterval 
	| node |
	node := super whichNodeIsContainedBy: anInterval.
	node == self 
		ifTrue: 
			[(temporaries isEmpty and: [statements size == 1]) 
				ifTrue: [^statements first]].
	^node! !
!Kernel.StSequenceNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
allDefinedVariableNodesDo:!accessing!public! !
allTemporaryVariableNodesDo:!accessing!public! !
bestNodeFor:!public!querying! !
childrenDo:!accessing!public! !
defines:!public!testing! !
directlyUses:!public!testing! !
hash!comparing!public! !
isLast:!public!testing! !
isSequence!public!testing! !
lastIsReturn!public!testing! !
leftBar!accessing!public! !
leftBar:temporaries:rightBar:!initializing!public! !
methodComments!accessing!public! !
outer!accessing!public! !
periods:!accessing!public! !
postCopy!copying!public! !
rightBar!accessing!private! !
start!accessing!public! !
statements!accessing!public! !
statements:!accessing!public! !
stop!accessing!public! !
temporaries!accessing!public! !
temporaries:!accessing!public! !
temporaryNames!accessing!public! !
temporaryVariables!accessing!public! !
uses:!public!testing! !
whichNodeIsContainedBy:!public!querying! !
!

!Kernel.StSequenceNode class methodsFor!

leftBar: leftInteger temporaries: variableNodes rightBar: rightInteger 
	^(self new)
		leftBar: leftInteger
			temporaries: variableNodes
			rightBar: rightInteger;
		yourself!

statements: statementNodes 
	^self temporaries: #() statements: statementNodes!

temporaries: variableNodes statements: statementNodes 
	^(self new)
		temporaries: variableNodes;
		statements: statementNodes;
		yourself! !
!Kernel.StSequenceNode class categoriesForMethods!
leftBar:temporaries:rightBar:!instance creation!public! !
statements:!instance creation!public! !
temporaries:statements:!instance creation!public! !
!

