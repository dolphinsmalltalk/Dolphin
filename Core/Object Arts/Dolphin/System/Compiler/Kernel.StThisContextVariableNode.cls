"Filed out from Dolphin Smalltalk"!

Kernel.StSpecialVariableNode
	subclass: #'Kernel.StThisContextVariableNode'
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

isThisContext
	"Answer whether the variable described by the receiver is the special 'thisContext' variable."

	^true!

name
	^'thisContext'! !
!Kernel.StThisContextVariableNode categoriesForMethods!
acceptVisitor:!public!visitor! !
isThisContext!public!testing! !
name!constants!public! !
!

