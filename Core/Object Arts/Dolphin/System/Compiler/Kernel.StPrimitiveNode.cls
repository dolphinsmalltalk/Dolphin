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

childrenDo: aMonadicValuable
	errorTemp ifNotNil: [aMonadicValuable value: errorTemp]!

defines: aName
	^(errorTemp ifNil: ['_failureCode'] ifNotNil: [errorTemp name]) = aName!

errorTemp
	^errorTemp!

errorTemp: aStTempDeclNode
	errorTemp := aStTempDeclNode.
	aStTempDeclNode parent: self!

hash
	^primitiveIndex hash!

postCopy
	super postCopy.
	errorTemp ifNotNil: [self errorTemp: errorTemp copy].
	^self!

primitiveIndex
	^primitiveIndex!

primitiveIndex: anInteger 
	primitiveIndex := anInteger!

selector
	^errorTemp ifNil: [#primitive:] ifNotNil: [#primitive:error:]! !
!Kernel.StPrimitiveNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
childrenDo:!accessing!public! !
defines:!public!testing! !
errorTemp!accessing!public! !
errorTemp:!accessing!private! !
hash!comparing!public! !
postCopy!copying!public! !
primitiveIndex!accessing!public! !
primitiveIndex:!accessing!private! !
selector!accessing!public! !
!

!Kernel.StPrimitiveNode class methodsFor!

primitiveIndex: anInteger
	^self new
		primitiveIndex: anInteger;
		yourself! !
!Kernel.StPrimitiveNode class categoriesForMethods!
primitiveIndex:!instance creation!public! !
!

