"Filed out from Dolphin Smalltalk"!

Kernel.StVariableNode
	subclass: #'Kernel.StRealVariableNode'
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StRealVariableNode guid: (Core.GUID fromString: '{a656e14d-cb9c-4066-97ac-a496f2f2a1c0}')!
Kernel.StRealVariableNode isNonInstantiable: true!
Kernel.StRealVariableNode comment: ''!
!Kernel.StRealVariableNode categoriesForClass!System-Compiler! !
!Kernel.StRealVariableNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitVariableNode: self!

identifierToken: anIdentifierToken
	name := anIdentifierToken value.
	start := anIdentifierToken start!

name
	^name!

name: aString
	name := aString!

setName: aString start: anInteger
	name := aString.
	start := anInteger! !
!Kernel.StRealVariableNode categoriesForMethods!
acceptVisitor:!public!visitor! !
identifierToken:!initializing!private! !
name!accessing!public! !
name:!accessing!public! !
setName:start:!initializing!private! !
!

