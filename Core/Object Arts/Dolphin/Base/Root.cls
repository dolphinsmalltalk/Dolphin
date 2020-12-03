"Filed out from Dolphin Smalltalk 7"!

Kernel.Namespace subclass: #Root
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Root guid: (Core.GUID fromString: '{7a840345-c6bf-4463-bf2a-353375064f5a}')!
Root isNonInstantiable: true!
Root comment: 'The distinguished `Namespace`, `Root`, that is the root of the `Namespace` hierarchy. It has no outer environment, and is the environment of the top-level namespaces such as `Core` and `Kernel`, and `Smalltalk` too.'!
!Root categoriesForClass!Kernel-Objects! !
!Root class methodsFor!

environment
	"Logically the Root namespace has no enclosing environment, although physically it has a binding in itself."

	^nil!

fullNameFor: aString
	"Private - Answer the full name (i.e. a dot-separated path from Smalltalk) of a variable with the specified local identifier, assumed to be in this namespace.
	Although this is the Root namespace, because it is the enclosing environment of Smalltalk, all of its local bindings are implicitly bindable because Root is the outer scope of Smalltalk. In other words, we don't need the Root qualifier to bind names in Root."

	^aString!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver relative to the Root namespace. Classes in the legacy 'flat' Smalltalk namespace will have Smalltalk as the first element of the binding path."

	^Kernel.BindingReference pathString: #Root! !
!Root class categoriesFor: #environment!public! !
!Root class categoriesFor: #fullNameFor:!helpers!private! !
!Root class categoriesFor: #fullyQualifiedReference!binding!private! !

