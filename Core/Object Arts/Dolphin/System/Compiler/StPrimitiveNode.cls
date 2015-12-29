"Filed out from Dolphin Smalltalk X6"!

StTagNode subclass: #StPrimitiveNode
	instanceVariableNames: 'primitiveIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StPrimitiveNode guid: (GUID fromString: '{D70C8417-C320-465F-AC62-6B81D9E844C9}')!
StPrimitiveNode comment: ''!
!StPrimitiveNode categoriesForClass!System-Compiler! !
!StPrimitiveNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self primitiveIndex = anObject primitiveIndex!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptPrimitiveNode: self!

primitiveIndex
	^primitiveIndex!

primitiveIndex: anInteger 
	primitiveIndex := anInteger! !
!StPrimitiveNode categoriesFor: #=!comparing!public! !
!StPrimitiveNode categoriesFor: #acceptVisitor:!public!visitor! !
!StPrimitiveNode categoriesFor: #primitiveIndex!accessing!public! !
!StPrimitiveNode categoriesFor: #primitiveIndex:!accessing!private! !

!StPrimitiveNode class methodsFor!

primitiveIndex: anInteger
	^self new
		primitiveIndex: anInteger;
		yourself! !
!StPrimitiveNode class categoriesFor: #primitiveIndex:!instance creation!public! !

