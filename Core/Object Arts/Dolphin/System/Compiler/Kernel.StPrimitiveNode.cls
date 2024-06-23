"Filed out from Dolphin Smalltalk"!

Kernel.AbstractPrimitiveCallNode
	subclass: #'Kernel.StPrimitiveNode'
	instanceVariableNames: 'primitiveIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StPrimitiveNode guid: (Core.GUID fromString: '{d70c8417-c320-465f-ac62-6b81d9e844c9}')!

Kernel.StPrimitiveNode comment: ''!

!Kernel.StPrimitiveNode categoriesForClass!System-Compiler! !

!Kernel.StPrimitiveNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitPrimitiveNode: self!

hasDefaultErrorTemp
	^errorTemp name = '_failureCode'!

hash
	^primitiveIndex hash!

primitiveIndex
	^primitiveIndex!

primitiveIndex: anInteger 
	primitiveIndex := anInteger!

selector
	^self hasDefaultErrorTemp ifTrue: [#primitive:] ifFalse: [#primitive:error:]!

specialErrorTemp
	^self hasDefaultErrorTemp ifFalse: [errorTemp name]! !

!Kernel.StPrimitiveNode categoriesForMethods!
acceptVisitor:!public!visitor! !
hasDefaultErrorTemp!accessing!public! !
hash!comparing!public! !
primitiveIndex!accessing!public! !
primitiveIndex:!accessing!private! !
selector!accessing!public! !
specialErrorTemp!accessing!public! !
!

!Kernel.StPrimitiveNode class methodsFor!

primitiveIndex: anInteger
	^self new
		primitiveIndex: anInteger;
		yourself! !

!Kernel.StPrimitiveNode class categoriesForMethods!
primitiveIndex:!instance creation!public! !
!

