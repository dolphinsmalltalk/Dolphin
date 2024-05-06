"Filed out from Dolphin Smalltalk"!

StTagNode subclass: #StPrimitiveNode
	instanceVariableNames: 'primitiveIndex errorTemp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StPrimitiveNode guid: (GUID fromString: '{d70c8417-c320-465f-ac62-6b81d9e844c9}')!

StPrimitiveNode comment: ''!

!StPrimitiveNode categoriesForClass!System-Compiler! !

!StPrimitiveNode methodsFor!

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

!StPrimitiveNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
errorTemp!accessing!public! !
errorTemp:!accessing!private! !
primitiveIndex!accessing!public! !
primitiveIndex:!accessing!private! !
!

!StPrimitiveNode class methodsFor!

primitiveIndex: anInteger
	^self new
		primitiveIndex: anInteger;
		yourself! !

!StPrimitiveNode class categoriesForMethods!
primitiveIndex:!instance creation!public! !
!

