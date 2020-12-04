"Filed out from Dolphin Smalltalk 7"!

Kernel.StSpecialVariableNode subclass: #'Kernel.StSuperVariableNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSuperVariableNode guid: (Core.GUID fromString: '{8e51ff15-67ba-464c-965a-d091253784a5}')!
Kernel.StSuperVariableNode comment: 'StSuperVariableNode is an parse tree node that represents the special variable ''super'', which is only valid as the target of a message send.
'!
!Kernel.StSuperVariableNode categoriesForClass!System-Compiler! !
!Kernel.StSuperVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitSuperVariableNode: self!

isSuperVariable
	"Answer whether the variable described by the receiver is the special variables 'super'."

	^true!

name
	^'super'!

specialVariableInScope: anStSemanticScope
	^anStSemanticScope superVariable! !
!Kernel.StSuperVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StSuperVariableNode categoriesFor: #isSuperVariable!public!testing! !
!Kernel.StSuperVariableNode categoriesFor: #name!constants!public! !
!Kernel.StSuperVariableNode categoriesFor: #specialVariableInScope:!double dispatch!public! !

