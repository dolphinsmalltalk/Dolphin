"Filed out from Dolphin Smalltalk 7"!

StVariableNode subclass: #StTempDeclNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StTempDeclNode guid: (GUID fromString: '{3b692e52-8be1-41d2-8300-e8a0e286426a}')!
StTempDeclNode comment: 'StTempDeclNode is a parse tree node that represents a temp definition for a method or block.
'!
!StTempDeclNode categoriesForClass!System-Compiler! !
!StTempDeclNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitTempDeclNode: self! !
!StTempDeclNode categoriesFor: #acceptVisitor:!public!visitor! !

