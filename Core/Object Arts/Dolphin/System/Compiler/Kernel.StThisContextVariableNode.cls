"Filed out from Dolphin Smalltalk 7"!

Kernel.StSpecialVariableNode subclass: #'Kernel.StThisContextVariableNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StThisContextVariableNode guid: (Core.GUID fromString: '{20db816b-6c32-4239-97e8-c3a90a63e126}')!
Kernel.StThisContextVariableNode comment: ''!
!Kernel.StThisContextVariableNode categoriesForClass!System-Compiler! !
!Kernel.StThisContextVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitThisContextVariableNode: self!

name
	^'thisContext'!

specialVariableInScope: anStSemanticScope
	^anStSemanticScope thisContextVariable! !
!Kernel.StThisContextVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StThisContextVariableNode categoriesFor: #name!constants!public! !
!Kernel.StThisContextVariableNode categoriesFor: #specialVariableInScope:!double dispatch!public! !

