"Filed out from Dolphin Smalltalk 7"!

StValueNode subclass: #StAssignmentNode
	instanceVariableNames: 'variable assignment value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StAssignmentNode guid: (GUID fromString: '{3a82c1ca-7ed8-4a69-9e9e-b58b738abc85}')!
StAssignmentNode comment: 'StAssignmentNode is a parse tree node for assignment statements

Instance Variables:
	assignment	<Integer>	position of the :=
	value	<StValueNode>	the value that we''re assigning
	variable	<StVariableNode>	the variable being assigned

'!
!StAssignmentNode categoriesForClass!System-Compiler! !
!StAssignmentNode methodsFor!

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
!StAssignmentNode categoriesFor: #=!comparing!public! !
!StAssignmentNode categoriesFor: #acceptVisitor:!public!visitor! !
!StAssignmentNode categoriesFor: #assignmentPosition!accessing!public! !
!StAssignmentNode categoriesFor: #assigns:!public!testing! !
!StAssignmentNode categoriesFor: #bestNodeFor:!public!querying! !
!StAssignmentNode categoriesFor: #childrenDo:!accessing!public! !
!StAssignmentNode categoriesFor: #directlyUses:!public!testing! !
!StAssignmentNode categoriesFor: #hash!comparing!public! !
!StAssignmentNode categoriesFor: #isAssignment!public!testing! !
!StAssignmentNode categoriesFor: #needsParenthesis!public!testing! !
!StAssignmentNode categoriesFor: #postCopy!copying!public! !
!StAssignmentNode categoriesFor: #precedence!accessing!public! !
!StAssignmentNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StAssignmentNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StAssignmentNode categoriesFor: #uses:!public!testing! !
!StAssignmentNode categoriesFor: #value!accessing!public! !
!StAssignmentNode categoriesFor: #value:!accessing!public! !
!StAssignmentNode categoriesFor: #variable!accessing!public! !
!StAssignmentNode categoriesFor: #variable:!accessing!public! !
!StAssignmentNode categoriesFor: #variable:value:position:!initializing!private! !

!StAssignmentNode class methodsFor!

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
!StAssignmentNode class categoriesFor: #variable:value:!instance creation!public! !
!StAssignmentNode class categoriesFor: #variable:value:position:!instance creation!public! !

