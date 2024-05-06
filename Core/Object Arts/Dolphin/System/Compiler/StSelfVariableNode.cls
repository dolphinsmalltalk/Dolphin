"Filed out from Dolphin Smalltalk"!

StSpecialVariableNode subclass: #StSelfVariableNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StSelfVariableNode guid: (GUID fromString: '{29220d9b-e07e-475a-95e2-b31f4bf41079}')!

StSelfVariableNode comment: 'StSelfVariableNode is an parse tree node that represents the special variable ''self''.
'!

!StSelfVariableNode categoriesForClass!System-Compiler! !

!StSelfVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitSelfVariableNode: self!

isSelfVariable
	"Answer whether the variable described by the receiver is the special variables 'super'."

	^true!

name
	^'self'!

specialVariableInScope: anStSemanticScope
	^anStSemanticScope selfVariable! !

!StSelfVariableNode categoriesForMethods!
acceptVisitor:!public!visitor! !
isSelfVariable!public!testing! !
name!constants!public! !
specialVariableInScope:!double dispatch!public! !
!

