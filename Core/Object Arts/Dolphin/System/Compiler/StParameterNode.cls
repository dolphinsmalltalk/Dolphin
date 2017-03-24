"Filed out from Dolphin Smalltalk 7"!

StVariableNode subclass: #StParameterNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StParameterNode guid: (GUID fromString: '{f8fdcb03-7380-4984-a7c1-c79eaeafcbf3}')!
StParameterNode comment: ''!
!StParameterNode categoriesForClass!System-Compiler! !
!StParameterNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitParameterNode: self!

isConstantNode
	"Answer whether the receiver describes a constant that cannot be assigned to."

	^true! !
!StParameterNode categoriesFor: #acceptVisitor:!public!visitor! !
!StParameterNode categoriesFor: #isConstantNode!public!testing! !

