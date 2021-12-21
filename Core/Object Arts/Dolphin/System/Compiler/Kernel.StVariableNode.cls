"Filed out from Dolphin Smalltalk"!

Kernel.StAbstractVariableNode subclass: #'Kernel.StVariableNode'
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StVariableNode guid: (Core.GUID fromString: '{b60d460e-99a6-4378-8b43-67b3bcb4cd16}')!
Kernel.StVariableNode comment: 'StVariableNode is a parse tree node that represents a normal variable with a user-chosen identifier (global, inst var, temp, etc.).

Instance Variables:
	name	<String> identifier of the variable.'!
!Kernel.StVariableNode categoriesForClass!System-Compiler! !
!Kernel.StVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitVariableNode: self!

identifierToken: anIdentifierToken
	name := anIdentifierToken value.
	start := anIdentifierToken start!

isStaticVariable
	"Answer whether the receiver is a reference to a static variable - this is only valid after binding variables in a parse tree using a semantic analyser."

	^variable isStaticVariable!

name
	^name!

setName: aString start: anInteger
	name := aString.
	start := anInteger! !
!Kernel.StVariableNode categoriesForMethods!
acceptVisitor:!public!visitor! !
identifierToken:!initializing!private! !
isStaticVariable!public!testing! !
name!accessing!public! !
setName:start:!initializing!private! !
!

