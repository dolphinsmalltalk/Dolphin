"Filed out from Dolphin Smalltalk"!

Kernel.StRealVariableNode
	subclass: #'Kernel.StBasicVariableNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StBasicVariableNode guid: (Core.GUID fromString: '{b60d460e-99a6-4378-8b43-67b3bcb4cd16}')!
Kernel.StBasicVariableNode comment: 'StVariableNode is a parse tree node that represents a normal variable with a user-chosen identifier (global, inst var, temp, etc.).

Instance Variables:
	name	<String> identifier of the variable.'!
!Kernel.StBasicVariableNode categoriesForClass!System-Compiler! !
!Kernel.StBasicVariableNode methodsFor!

binding
	^variable ifNil: [self resolveBinding] ifNotNil: [variable binding]!

hasQualifiedName
	"Answer whether the receiver has a qualified name (i.e. it is a static variable reference with a dot separated path)."

	^BindingReference isQualifiedName: name!

isStaticVariable
	"Answer whether the receiver is a reference to a static variable - this is only valid after binding variables in a parse tree using a semantic analyser."

	^variable notNil and: [variable isStaticVariable]!

resolveBinding
	| initial |
	initial := name at: 1.
	^(initial isUppercase or: [initial == $_])
		ifTrue: [(self lookupInScope: scope) ifNotNil: [:var | var binding]]! !
!Kernel.StBasicVariableNode categoriesForMethods!
binding!accessing!public! !
hasQualifiedName!public!testing! !
isStaticVariable!public!testing! !
resolveBinding!accessing!public! !
!

