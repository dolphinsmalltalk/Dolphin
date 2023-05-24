"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBNamespaceClass
	subclass: #'Refactory.Browser.RBRootNamespace'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBRootNamespace guid: (Core.GUID fromString: '{51fd9f8c-25bd-44be-974c-b851a8e6fa3e}')!
Refactory.Browser.RBRootNamespace comment: ''!
!Refactory.Browser.RBRootNamespace categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBRootNamespace methodsFor!

allClassesDo: aMonadicValuable
	self bindingsDo: 
			[:each |
			each isClassBinding
				ifTrue: 
					[| class |
					aMonadicValuable value: (class := each value).
					class == self ifFalse: [class allClassesDo: aMonadicValuable]]]!

bindingFor: aString
	^self classPool bindingFor: aString!

environment
	^nil!

fullNameFor: aString
	"Private - Answer the full name (i.e. a dot-separated path from Smalltalk) of a variable with the specified local identifier, assumed to be in this namespace.
	Although this is the Root namespace, because it is the enclosing environment of Smalltalk, all of its local bindings are implicitly bindable because Root is the outer scope of Smalltalk. In other words, we don't need the Root qualifier to bind names in Root."

	^aString!

shortNameFor: aString
	"Private - Answer the short name for the receiver's variable named, aString. The short name is the shortest name that binds to variable starting from the Smalltalk namespace. All of the receiver's variables are bindable by unqualified name from Smalltalk because Smalltalk is nested within Root."

	^aString! !
!Refactory.Browser.RBRootNamespace categoriesForMethods!
allClassesDo:!enumerating!public! !
bindingFor:!public! !
environment!accessing!public! !
fullNameFor:!helpers!private! !
shortNameFor:!enquiries!private! !
!

