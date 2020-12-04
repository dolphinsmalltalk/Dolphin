"Filed out from Dolphin Smalltalk 7"!

Kernel.StProgramNode subclass: #'Kernel.StSequenceNode'
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

	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	self temporaries size = anObject temporaries size ifFalse: [^false].
	1 to: self temporaries size
		do: 
			[:i | 
			(self temporaries at: i) = (anObject temporaries at: i) ifFalse: [^false]].
	self statements size = anObject statements size ifFalse: [^false].
	1 to: self statements size
		do: [:i | (self statements at: i) = (anObject statements at: i) ifFalse: [^false]].
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
	self temporaries do: aMonadicValuable.
	self statements do: aMonadicValuable!

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
	^methodComments asSortedCollection: [:a :b | a first < b first]!

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
!Kernel.StSequenceNode categoriesFor: #=!comparing!public! !
!Kernel.StSequenceNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StSequenceNode categoriesFor: #allDefinedVariableNodesDo:!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #allTemporaryVariableNodesDo:!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #bestNodeFor:!public!querying! !
!Kernel.StSequenceNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #defines:!public!testing! !
!Kernel.StSequenceNode categoriesFor: #directlyUses:!public!testing! !
!Kernel.StSequenceNode categoriesFor: #hash!comparing!public! !
!Kernel.StSequenceNode categoriesFor: #isLast:!public!testing! !
!Kernel.StSequenceNode categoriesFor: #isSequence!public!testing! !
!Kernel.StSequenceNode categoriesFor: #lastIsReturn!public!testing! !
!Kernel.StSequenceNode categoriesFor: #leftBar!public! !
!Kernel.StSequenceNode categoriesFor: #leftBar:temporaries:rightBar:!initializing!public! !
!Kernel.StSequenceNode categoriesFor: #methodComments!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #outer!public! !
!Kernel.StSequenceNode categoriesFor: #periods:!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #postCopy!copying!public! !
!Kernel.StSequenceNode categoriesFor: #rightBar!accessing!private! !
!Kernel.StSequenceNode categoriesFor: #start!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #statements!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #statements:!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #stop!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #temporaries!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #temporaries:!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #temporaryNames!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #temporaryVariables!accessing!public! !
!Kernel.StSequenceNode categoriesFor: #uses:!public!testing! !
!Kernel.StSequenceNode categoriesFor: #whichNodeIsContainedBy:!public!querying! !

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
!Kernel.StSequenceNode class categoriesFor: #leftBar:temporaries:rightBar:!instance creation!public! !
!Kernel.StSequenceNode class categoriesFor: #statements:!instance creation!public! !
!Kernel.StSequenceNode class categoriesFor: #temporaries:statements:!instance creation!public! !

