"Filed out from Dolphin Smalltalk 7"!

StAbstractVariableNode subclass: #StVariableNode
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StVariableNode guid: (GUID fromString: '{b60d460e-99a6-4378-8b43-67b3bcb4cd16}')!
StVariableNode comment: 'StVariableNode is a parse tree node that represents a normal variable with a user-chosen identifier (global, inst var, temp, etc.).

Instance Variables:
	name	<String> identifier of the variable.'!
!StVariableNode categoriesForClass!System-Compiler! !
!StVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitVariableNode: self!

identifierToken: anIdentifierToken
	name := anIdentifierToken value.
	start := anIdentifierToken start!

name
	^name!

setName: aString start: anInteger
	name := aString.
	start := anInteger! !
!StVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!StVariableNode categoriesFor: #identifierToken:!initializing!private! !
!StVariableNode categoriesFor: #name!accessing!public! !
!StVariableNode categoriesFor: #setName:start:!initializing!private! !

