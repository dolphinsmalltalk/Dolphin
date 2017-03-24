"Filed out from Dolphin Smalltalk 7"!

StVariableNode subclass: #StPseudoVariableNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StPseudoVariableNode guid: (GUID fromString: '{e1481f19-627f-4ee4-9c94-e58a0d603fe6}')!
StPseudoVariableNode comment: ''!
!StPseudoVariableNode categoriesForClass!System-Compiler! !
!StPseudoVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitPseudoVariableNode: self!

isConstantNode
	"Answer whether the receiver describes a constant that cannot be assigned to."

	^true! !
!StPseudoVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!StPseudoVariableNode categoriesFor: #isConstantNode!public!testing! !

