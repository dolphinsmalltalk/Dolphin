"Filed out from Dolphin Smalltalk 7"!

Kernel.StVariableNode subclass: #'Kernel.StTempDeclNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StTempDeclNode guid: (Core.GUID fromString: '{3b692e52-8be1-41d2-8300-e8a0e286426a}')!
Kernel.StTempDeclNode comment: 'StTempDeclNode is a parse tree node that represents a temp definition for a method or block.
'!
!Kernel.StTempDeclNode categoriesForClass!System-Compiler! !
!Kernel.StTempDeclNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitTempDeclNode: self! !
!Kernel.StTempDeclNode categoriesFor: #acceptVisitor:!public!visitor! !

