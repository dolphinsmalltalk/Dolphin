"Filed out from Dolphin Smalltalk 7"!

StProgramNode subclass: #StSequenceNode
	instanceVariableNames: 'leftBar rightBar statements periods temporaries'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StSequenceNode guid: (GUID fromString: '{73c3638c-06a8-4c0d-99ae-a572d08b5150}')!
StSequenceNode comment: 'StSequenceNode is a parse tree node that represents a sequence of statements. Both StBlockNodes and StMethodNodes contain these.

Instance Variables:
	leftBar	<Integer | nil>	the position of the left | in the temporaries definition
	periods	<SequenceableCollection> of <Integer>	the positions of all the periods that separate the statements
	rightBar	<Integer | nil>	the position of the right | in the temporaries definition
	statements	<SequenceableCollection> of <StStatementNode>	the statement nodes
	temporaries	<SequenceableCollection> of <StVariableNode>	the temporaries defined

'!
!StSequenceNode categoriesForClass!System-Compiler! !
!StSequenceNode methodsFor!

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

periods: anObject
	periods := anObject!

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
	#rbFix. "asOrderedCollection non-copying on Dolphin"
	^(OrderedCollection withAll: super temporaryVariables) 
		addAll: self temporaryNames;
		yourself!

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
!StSequenceNode categoriesFor: #=!comparing!public! !
!StSequenceNode categoriesFor: #acceptVisitor:!public!visitor! !
!StSequenceNode categoriesFor: #allDefinedVariableNodesDo:!accessing!public! !
!StSequenceNode categoriesFor: #allTemporaryVariableNodesDo:!accessing!public! !
!StSequenceNode categoriesFor: #bestNodeFor:!public!querying! !
!StSequenceNode categoriesFor: #childrenDo:!accessing!public! !
!StSequenceNode categoriesFor: #defines:!public!testing! !
!StSequenceNode categoriesFor: #directlyUses:!public!testing! !
!StSequenceNode categoriesFor: #hash!comparing!public! !
!StSequenceNode categoriesFor: #isLast:!public!testing! !
!StSequenceNode categoriesFor: #isSequence!public!testing! !
!StSequenceNode categoriesFor: #lastIsReturn!public!testing! !
!StSequenceNode categoriesFor: #leftBar!public! !
!StSequenceNode categoriesFor: #leftBar:temporaries:rightBar:!initializing!public! !
!StSequenceNode categoriesFor: #methodComments!accessing!public! !
!StSequenceNode categoriesFor: #outer!public! !
!StSequenceNode categoriesFor: #periods:!accessing!public! !
!StSequenceNode categoriesFor: #postCopy!copying!public! !
!StSequenceNode categoriesFor: #rightBar!accessing!private! !
!StSequenceNode categoriesFor: #start!accessing!public! !
!StSequenceNode categoriesFor: #statements!accessing!public! !
!StSequenceNode categoriesFor: #statements:!accessing!public! !
!StSequenceNode categoriesFor: #stop!accessing!public! !
!StSequenceNode categoriesFor: #temporaries!accessing!public! !
!StSequenceNode categoriesFor: #temporaries:!accessing!public! !
!StSequenceNode categoriesFor: #temporaryNames!accessing!public! !
!StSequenceNode categoriesFor: #temporaryVariables!accessing!public! !
!StSequenceNode categoriesFor: #uses:!public!testing! !
!StSequenceNode categoriesFor: #whichNodeIsContainedBy:!public!querying! !

!StSequenceNode class methodsFor!

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
!StSequenceNode class categoriesFor: #leftBar:temporaries:rightBar:!instance creation!public! !
!StSequenceNode class categoriesFor: #statements:!instance creation!public! !
!StSequenceNode class categoriesFor: #temporaries:statements:!instance creation!public! !

