"Filed out from Dolphin Smalltalk"!

StVariableNode subclass: #StParameterNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StParameterNode guid: (GUID fromString: '{f8fdcb03-7380-4984-a7c1-c79eaeafcbf3}')!

StParameterNode comment: 'StParameterNode is a parse tree node that represents a parameter definition for a method or block.
'!

!StParameterNode categoriesForClass!System-Compiler! !

!StParameterNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitParameterNode: self!

isConstantNode
	"Answer whether the receiver describes a constant that cannot be assigned to."

	^true! !

!StParameterNode categoriesForMethods!
acceptVisitor:!public!visitor! !
isConstantNode!public!testing! !
!

