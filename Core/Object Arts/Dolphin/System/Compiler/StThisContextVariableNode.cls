"Filed out from Dolphin Smalltalk"!

StSpecialVariableNode subclass: #StThisContextVariableNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StThisContextVariableNode guid: (GUID fromString: '{20db816b-6c32-4239-97e8-c3a90a63e126}')!
StThisContextVariableNode comment: ''!
!StThisContextVariableNode categoriesForClass!System-Compiler! !
!StThisContextVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitThisContextVariableNode: self!

name
	^'thisContext'!

specialVariableInScope: anStSemanticScope
	^anStSemanticScope thisContextVariable! !
!StThisContextVariableNode categoriesForMethods!
acceptVisitor:!public!visitor! !
name!constants!public! !
specialVariableInScope:!double dispatch!public! !
!

