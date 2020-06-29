"Filed out from Dolphin Smalltalk 7"!

StTagNode subclass: #StPrimitiveNode
	instanceVariableNames: 'primitiveIndex errorTemp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StPrimitiveNode categoriesFor: #=!comparing!public! !
!StPrimitiveNode categoriesFor: #acceptVisitor:!public!visitor! !
!StPrimitiveNode categoriesFor: #errorTemp!accessing!public! !
!StPrimitiveNode categoriesFor: #errorTemp:!accessing!private! !
!StPrimitiveNode categoriesFor: #primitiveIndex!accessing!public! !
!StPrimitiveNode categoriesFor: #primitiveIndex:!accessing!private! !

!StPrimitiveNode class methodsFor!

primitiveIndex: anInteger
	^self new
		primitiveIndex: anInteger;
		yourself! !
!StPrimitiveNode class categoriesFor: #primitiveIndex:!instance creation!public! !

