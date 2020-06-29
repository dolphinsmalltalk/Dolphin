"Filed out from Dolphin Smalltalk 7"!

StSpecialVariableNode subclass: #StThisContextVariableNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StThisContextVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!StThisContextVariableNode categoriesFor: #name!constants!public! !
!StThisContextVariableNode categoriesFor: #specialVariableInScope:!double dispatch!public! !

