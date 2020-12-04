"Filed out from Dolphin Smalltalk 7"!

Kernel.StSpecialVariableNode subclass: #'Kernel.StSelfVariableNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSelfVariableNode guid: (Core.GUID fromString: '{29220d9b-e07e-475a-95e2-b31f4bf41079}')!
Kernel.StSelfVariableNode comment: 'StSelfVariableNode is an parse tree node that represents the special variable ''self''.
'!
!Kernel.StSelfVariableNode categoriesForClass!System-Compiler! !
!Kernel.StSelfVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitSelfVariableNode: self!

isSelfVariable
	"Answer whether the variable described by the receiver is the special variables 'super'."

	^true!

name
	^'self'!

specialVariableInScope: anStSemanticScope
	^anStSemanticScope selfVariable! !
!Kernel.StSelfVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StSelfVariableNode categoriesFor: #isSelfVariable!public!testing! !
!Kernel.StSelfVariableNode categoriesFor: #name!constants!public! !
!Kernel.StSelfVariableNode categoriesFor: #specialVariableInScope:!double dispatch!public! !

