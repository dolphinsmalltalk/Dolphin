"Filed out from Dolphin Smalltalk 7"!

StSpecialVariableNode subclass: #StSuperVariableNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StSuperVariableNode guid: (GUID fromString: '{8e51ff15-67ba-464c-965a-d091253784a5}')!
StSuperVariableNode comment: 'StSuperVariableNode is an parse tree node that represents the special variable ''super'', which is only valid as the target of a message send.
'!
!StSuperVariableNode categoriesForClass!System-Compiler! !
!StSuperVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitSuperVariableNode: self!

isSuperVariable
	"Answer whether the variable described by the receiver is the special variables 'super'."

	^true!

name
	^'super'!

specialVariableInScope: anStSemanticScope
	^anStSemanticScope superVariable! !
!StSuperVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!StSuperVariableNode categoriesFor: #isSuperVariable!public!testing! !
!StSuperVariableNode categoriesFor: #name!constants!public! !
!StSuperVariableNode categoriesFor: #specialVariableInScope:!double dispatch!public! !

