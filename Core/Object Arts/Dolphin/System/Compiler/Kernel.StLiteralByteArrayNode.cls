"Filed out from Dolphin Smalltalk"!

Kernel.AbstractLiteralArrayNode
	subclass: #'Kernel.StLiteralByteArrayNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StLiteralByteArrayNode guid: (Core.GUID fromString: '{393dade0-96e2-4f5b-a724-b3f28ee09a17}')!

Kernel.StLiteralByteArrayNode comment: ''!

!Kernel.StLiteralByteArrayNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitLiteralByteArrayNode: self!

valueClass
	^ByteArray! !

!Kernel.StLiteralByteArrayNode categoriesForMethods!
acceptVisitor:!public!visitor! !
valueClass!accessing!public! !
!

