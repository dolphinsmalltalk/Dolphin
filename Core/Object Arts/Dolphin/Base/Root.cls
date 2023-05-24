"Filed out from Dolphin Smalltalk"!

Kernel.Namespace
	subclass: #Root
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Root guid: (Core.GUID fromString: '{7a840345-c6bf-4463-bf2a-353375064f5a}')!
Root isNonInstantiable: true!
Root comment: '`Root` represents the distinguished `Namespace` that is the root of the `Namespace` hierarchy. It has no outer environment, and is the environment of the top-level namespaces such as `Core` and `Kernel`, and `Smalltalk`.

Physically, for implementation reasons, `Root` contains its own binding (i.e. it is its own environment), but logically it does not.'!
!Root categoriesForClass!Kernel-Objects! !
!Root class methodsFor!

bindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class (not including imports). If there is no such variable, then answer nil."

	^classPool bindingFor: aString!

environment
	"Logically the Root namespace has no enclosing environment, although physically it has a binding in itself."

	^nil!

fullNameFor: aString
	"Private - Answer the full name (i.e. a dot-separated path from Smalltalk) of a variable with the specified local identifier, assumed to be in this namespace.
	Although this is the Root namespace, because it is the enclosing environment of Smalltalk, all of its local bindings are implicitly bindable because Root is the outer scope of Smalltalk. In other words, we don't need the Root qualifier to bind names in Root."

	^aString!

imports: anArray
	anArray isEmpty ifFalse: [self error: 'Root must not have imports']!

nestedClasses
	^super nestedClasses copyWithout: self!

shortName
	^#Root!

shortNameFor: aString
	"Private - Answer the short name for the receiver's variable named, aString. The short name is the shortest name that binds to variable starting from the Smalltalk namespace. All of the receiver's variables are bindable by unqualified name from Smalltalk because Smalltalk is nested within Root."

	^aString! !
!Root class categoriesForMethods!
bindingFor:!bindings!public! !
environment!public! !
fullNameFor:!helpers!private! !
imports:!pool variables!public! !
nestedClasses!accessing!public! !
shortName!accessing!public! !
shortNameFor:!enquiries!private! !
!

