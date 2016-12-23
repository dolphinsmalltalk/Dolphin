"Filed out from Dolphin Smalltalk 7"!

StProgramNode subclass: #StReturnNode
	instanceVariableNames: 'return value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StReturnNode guid: (GUID fromString: '{7C9285E7-8D52-4FC6-9FF5-531771E8FE6E}')!
StReturnNode comment: 'StReturnNode is a parse tree node that represents a return expression.

Instance Variables:
	return	<Integer>	the position of the ^ character
	value	<StValueNode>	the value that is being returned

'!
!StReturnNode categoriesForClass!System-Compiler! !
!StReturnNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self value = anObject value!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitReturnNode: self!

childrenDo: aMonadicValuable 
	aMonadicValuable value: value!

containsReturn
	^true!

equalTo: anObject withMapping: aDictionary 
	^self class = anObject class 
		and: [self value equalTo: anObject value withMapping: aDictionary]!

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
!StReturnNode categoriesFor: #=!comparing!public! !
!StReturnNode categoriesFor: #acceptVisitor:!public!visitor! !
!StReturnNode categoriesFor: #childrenDo:!accessing!public! !
!StReturnNode categoriesFor: #containsReturn!public!testing! !
!StReturnNode categoriesFor: #equalTo:withMapping:!comparing!public! !
!StReturnNode categoriesFor: #hash!comparing!public! !
!StReturnNode categoriesFor: #isReturn!public!testing! !
!StReturnNode categoriesFor: #postCopy!copying!public! !
!StReturnNode categoriesFor: #return:value:!initializing!private! !
!StReturnNode categoriesFor: #start!accessing!public! !
!StReturnNode categoriesFor: #stop!accessing!public! !
!StReturnNode categoriesFor: #value!accessing!public! !
!StReturnNode categoriesFor: #value:!accessing!public! !

!StReturnNode class methodsFor!

return: returnInteger value: aValueNode 
	^self new return: returnInteger value: aValueNode!

value: aNode
	^self return: nil value: aNode! !
!StReturnNode class categoriesFor: #return:value:!instance creation!public! !
!StReturnNode class categoriesFor: #value:!instance creation!public! !

