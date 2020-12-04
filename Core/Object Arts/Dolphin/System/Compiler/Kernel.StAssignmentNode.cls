"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueNode subclass: #'Kernel.StAssignmentNode'
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
	^self variable = anObject variable and: [self value = anObject value]!

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
!Kernel.StAssignmentNode categoriesFor: #=!comparing!public! !
!Kernel.StAssignmentNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StAssignmentNode categoriesFor: #assignmentPosition!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #assigns:!public!testing! !
!Kernel.StAssignmentNode categoriesFor: #bestNodeFor:!public!querying! !
!Kernel.StAssignmentNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #directlyUses:!public!testing! !
!Kernel.StAssignmentNode categoriesFor: #hash!comparing!public! !
!Kernel.StAssignmentNode categoriesFor: #isAssignment!public!testing! !
!Kernel.StAssignmentNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StAssignmentNode categoriesFor: #postCopy!copying!public! !
!Kernel.StAssignmentNode categoriesFor: #precedence!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #uses:!public!testing! !
!Kernel.StAssignmentNode categoriesFor: #value!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #value:!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #variable!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #variable:!accessing!public! !
!Kernel.StAssignmentNode categoriesFor: #variable:value:position:!initializing!private! !

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
!Kernel.StAssignmentNode class categoriesFor: #variable:value:!instance creation!public! !
!Kernel.StAssignmentNode class categoriesFor: #variable:value:position:!instance creation!public! !

