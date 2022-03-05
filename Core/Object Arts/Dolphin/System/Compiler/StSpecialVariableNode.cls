"Filed out from Dolphin Smalltalk"!

StAbstractVariableNode subclass: #StSpecialVariableNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSpecialVariableNode guid: (GUID fromString: '{e1481f19-627f-4ee4-9c94-e58a0d603fe6}')!
StSpecialVariableNode isAbstract: true!
StSpecialVariableNode comment: 'StSpecialVariableNode is an abstract parse tree node with subclasses to represent each of the special variables ''self'', ''super'' or ''thisContext''. All are constants.
'!
!StSpecialVariableNode categoriesForClass!System-Compiler! !
!StSpecialVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitSpecialVariableNode: self!

isConstantNode
	"Answer whether the receiver describes a constant that cannot be assigned to. All special
	variables are constants."

	^true!

isSpecialVariable
	"Answer whether the variable described by the receiver is one of the special (aka pseudo) variables 'self', 'super' or 'thisContext'."

	^true!

specialVariableInScope: anStSemanticScope
	^self subclassResponsibility! !
!StSpecialVariableNode categoriesForMethods!
acceptVisitor:!public!visitor! !
isConstantNode!public!testing! !
isSpecialVariable!public!testing! !
specialVariableInScope:!double dispatch!public! !
!

!StSpecialVariableNode class methodsFor!

start: anInteger
	^(self new)
		setStart: anInteger;
		yourself! !
!StSpecialVariableNode class categoriesForMethods!
start:!public! !
!

