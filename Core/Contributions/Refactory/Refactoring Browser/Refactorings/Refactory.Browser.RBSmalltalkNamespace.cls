"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBNamespaceClass
	subclass: #'Refactory.Browser.RBSmalltalkNamespace'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RBSmalltalkNamespace guid: (Core.GUID fromString: '{f5ac20c7-ec92-41b4-8353-a16f02604890}')!

Refactory.Browser.RBSmalltalkNamespace comment: ''!

!Refactory.Browser.RBSmalltalkNamespace categoriesForClass!Refactory-Model! !

!Refactory.Browser.RBSmalltalkNamespace methodsFor!

shortNameFor: aString
	"Private - Answer the short name for the receiver's variable named, aString. The short name is the shortest name that binds to variable starting from the Smalltalk namespace. All of the receiver's variables are of course bindable by unqualified name."

	^aString!

shortNameFor: aString in: aNamespace
	^(aNamespace isNil or: 
			[aNamespace == self or: 
					[(self fullBindingFor: aString)
						ifNil: [self imports anySatisfy: [:each | each value == aNamespace]]
						ifNotNil: [:var | var environment == aNamespace or: [var environment == self]]]])
		ifTrue: [aString]
		ifFalse: [aNamespace fullNameFor: aString]! !

!Refactory.Browser.RBSmalltalkNamespace categoriesForMethods!
shortNameFor:!enquiries!private! !
shortNameFor:in:!helpers!private! !
!

