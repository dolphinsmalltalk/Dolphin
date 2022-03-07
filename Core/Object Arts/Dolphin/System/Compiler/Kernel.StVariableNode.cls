"Filed out from Dolphin Smalltalk"!

Kernel.StRealVariableNode subclass: #'Kernel.StVariableNode'
	instanceVariableNames: ''
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

binding
	^variable ifNil: [self resolveBinding] ifNotNil: [variable binding]!

hasQualifiedName
	"Answer whether the receiver has a qualified name (i.e. it is a static variable reference with a dot separated path)."

	^BindingReference isQualifiedName: name!

isBindingChanged
	"Private - Assuming that this node has been bound by a semantic analyser, would it bind differently now?"

	| originalBinding |
	originalBinding := self binding.
	^originalBinding notNil and: [originalBinding ~~ self resolveBinding]!

isStaticVariable
	"Answer whether the receiver is a reference to a static variable - this is only valid after binding variables in a parse tree using a semantic analyser."

	^variable isStaticVariable!

resolveBinding
	| initial |
	initial := name at: 1.
	^(initial isUppercase or: [initial == $_]) ifTrue: [self lookupInScope: scope]! !
!Kernel.StVariableNode categoriesForMethods!
binding!accessing!private! !
hasQualifiedName!public!testing! !
isBindingChanged!accessing!private! !
isStaticVariable!public!testing! !
resolveBinding!accessing!private! !
!

