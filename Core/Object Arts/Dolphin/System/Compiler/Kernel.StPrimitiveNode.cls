"Filed out from Dolphin Smalltalk 7"!

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
!Kernel.StPrimitiveNode categoriesFor: #=!comparing!public! !
!Kernel.StPrimitiveNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StPrimitiveNode categoriesFor: #errorTemp!accessing!public! !
!Kernel.StPrimitiveNode categoriesFor: #errorTemp:!accessing!private! !
!Kernel.StPrimitiveNode categoriesFor: #primitiveIndex!accessing!public! !
!Kernel.StPrimitiveNode categoriesFor: #primitiveIndex:!accessing!private! !

!Kernel.StPrimitiveNode class methodsFor!

primitiveIndex: anInteger
	^self new
		primitiveIndex: anInteger;
		yourself! !
!Kernel.StPrimitiveNode class categoriesFor: #primitiveIndex:!instance creation!public! !

