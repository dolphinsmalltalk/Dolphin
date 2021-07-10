"Filed out from Dolphin Smalltalk"!

Kernel.StTagNode subclass: #'Kernel.StPrimitiveNode'
	instanceVariableNames: 'primitiveIndex errorTemp'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StPrimitiveNode guid: (Core.GUID fromString: '{d70c8417-c320-465f-ac62-6b81d9e844c9}')!
Kernel.StPrimitiveNode comment: ''!
!Kernel.StPrimitiveNode categoriesForClass!System-Compiler! !
!Kernel.StPrimitiveNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self primitiveIndex = anObject primitiveIndex!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitPrimitiveNode: self!

errorTemp
	^errorTemp!

errorTemp: anObject
	errorTemp := anObject!

primitiveIndex
	^primitiveIndex!

primitiveIndex: anInteger 
	primitiveIndex := anInteger! !
!Kernel.StPrimitiveNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
errorTemp!accessing!public! !
errorTemp:!accessing!private! !
primitiveIndex!accessing!public! !
primitiveIndex:!accessing!private! !
!

!Kernel.StPrimitiveNode class methodsFor!

primitiveIndex: anInteger
	^self new
		primitiveIndex: anInteger;
		yourself! !
!Kernel.StPrimitiveNode class categoriesForMethods!
primitiveIndex:!instance creation!public! !
!

