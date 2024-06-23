"Filed out from Dolphin Smalltalk"!

Kernel.AbstractLiteralArrayNode
	subclass: #'Kernel.StLiteralArrayNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StLiteralArrayNode guid: (Core.GUID fromString: '{d0aec5f6-fbc7-4020-8545-2bca5eeb2bca}')!

Kernel.StLiteralArrayNode comment: ''!

!Kernel.StLiteralArrayNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitLiteralArrayNode: self!

isLiteralArray
	^true!

valueClass
	^Array! !

!Kernel.StLiteralArrayNode categoriesForMethods!
acceptVisitor:!public!visitor! !
isLiteralArray!public!testing! !
valueClass!accessing!public! !
!

