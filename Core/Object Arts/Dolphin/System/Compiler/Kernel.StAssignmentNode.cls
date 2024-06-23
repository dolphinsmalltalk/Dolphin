"Filed out from Dolphin Smalltalk"!

Kernel.StValueNode
	subclass: #'Kernel.StAssignmentNode'
	instanceVariableNames: 'variable assignment value'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StAssignmentNode guid: (Core.GUID fromString: '{3a82c1ca-7ed8-4a69-9e9e-b58b738abc85}')!

Kernel.StAssignmentNode comment: 'StAssignmentNode is a parse tree node for assignment statements

Instance Variables:
	assignment	<Integer>	position of the :=
	value	<StValueNode>	the value that we''re assigning
	variable	<StVariableNode>	the variable being assigned

'!

!Kernel.StAssignmentNode categoriesForClass!System-Compiler! !

!Kernel.StAssignmentNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^variable = anObject variable and: [value = anObject value]!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitAssignmentNode: self!

assignmentPosition
	^assignment!

assigns: aVariableName 
	^variable name = aVariableName or: [value assigns: aVariableName]!

bestNodeFor: anInterval 
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	assignment isNil ifTrue: [^super bestNodeFor: anInterval].
	((anInterval first between: assignment and: assignment + 1) 
		or: [assignment between: anInterval first and: anInterval last]) ifTrue: [^self].
	self childrenDo: 
			[:each | 
			| node |
			node := each bestNodeFor: anInterval.
			node notNil ifTrue: [^node]]!

childrenDo: aMonadicValuable 
	aMonadicValuable value: value.
	aMonadicValuable value: variable!

directlyUses: aNode 
	^aNode = value ifTrue: [true] ifFalse: [self isDirectlyUsed]!

hash
	^self variable hash bitXor: self value hash!

isAssignment
	^true!

needsParenthesis
	^parent isNil 
		ifTrue: [false]
		ifFalse: [self precedence > parent precedence]!

postCopy
	super postCopy.
	self variable: variable copy.
	self value: value copy.
	^self!

precedence
	^5!

startWithoutParentheses
	^variable start!

stopWithoutParentheses
	^value stop!

uses: aNode 
	^aNode = value ifTrue: [true] ifFalse: [self isUsed]!

value
	^value!

value: aValueNode 
	value := aValueNode.
	value parent: self!

variable
	^variable!

variable: varNode 
	variable := varNode.
	variable parent: self!

variable: aVariableNode value: aValueNode position: anInteger 
	self variable: aVariableNode.
	self value: aValueNode.
	assignment := anInteger! !

!Kernel.StAssignmentNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
assignmentPosition!accessing!public! !
assigns:!public!testing! !
bestNodeFor:!public!querying! !
childrenDo:!accessing!public! !
directlyUses:!public!testing! !
hash!comparing!public! !
isAssignment!public!testing! !
needsParenthesis!public!testing! !
postCopy!copying!public! !
precedence!accessing!public! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
uses:!public!testing! !
value!accessing!public! !
value:!accessing!public! !
variable!accessing!public! !
variable:!accessing!public! !
variable:value:position:!initializing!private! !
!

!Kernel.StAssignmentNode class methodsFor!

variable: aVariableNode value: aValueNode 
	^self 
		variable: aVariableNode
		value: aValueNode
		position: nil!

variable: aVariableNode value: aValueNode position: anInteger 
	^(self new)
		variable: aVariableNode
			value: aValueNode
			position: anInteger;
		yourself! !

!Kernel.StAssignmentNode class categoriesForMethods!
variable:value:!instance creation!public! !
variable:value:position:!instance creation!public! !
!

