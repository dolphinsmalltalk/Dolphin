"Filed out from Dolphin Smalltalk"!

Kernel.StProgramNode
	subclass: #'Kernel.StReturnNode'
	instanceVariableNames: 'return value'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StReturnNode guid: (Core.GUID fromString: '{7c9285e7-8d52-4fc6-9ff5-531771e8fe6e}')!

Kernel.StReturnNode comment: 'StReturnNode is a parse tree node that represents a return expression.

Instance Variables:
	return	<Integer>	the position of the ^ character
	value	<StValueNode>	the value that is being returned

'!

!Kernel.StReturnNode categoriesForClass!System-Compiler! !

!Kernel.StReturnNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^value = anObject value!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitReturnNode: self!

childrenDo: aMonadicValuable 
	aMonadicValuable value: value!

containsReturn
	^true!

hash
	^self value hash!

isReturn
	^true!

postCopy
	super postCopy.
	self value: value copy.
	^self!

return: returnInteger value: aValueNode 
	return := returnInteger.
	self value: aValueNode!

start
	^return!

stop
	^value stop!

value
	^value!

value: valueNode 
	value := valueNode.
	value parent: self! !

!Kernel.StReturnNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
childrenDo:!accessing!public! !
containsReturn!public!testing! !
hash!comparing!public! !
isReturn!public!testing! !
postCopy!copying!public! !
return:value:!initializing!private! !
start!accessing!public! !
stop!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!Kernel.StReturnNode class methodsFor!

return: returnInteger value: aValueNode 
	^self new return: returnInteger value: aValueNode!

value: aNode
	^self return: nil value: aNode! !

!Kernel.StReturnNode class categoriesForMethods!
return:value:!instance creation!public! !
value:!instance creation!public! !
!

