"Filed out from Dolphin Smalltalk 7"!

GeneralBindingReference subclass: #BindingReference
	instanceVariableNames: 'home'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BindingReference guid: (GUID fromString: '{801fde8c-7556-4b95-bb9d-eafb33552e79}')!
BindingReference comment: 'Generic binding reference for non-literal use.'!
!BindingReference categoriesForClass!System-Namespaces! !
!BindingReference methodsFor!

home
	"Answer the home namespace to which this BindingReference is relative."

	^home ifNil: [Smalltalk]!

home: aNamespace
	home := aNamespace!

initialize
	path := #().
	^self!

setPath: anArray home: anObject
	path := anArray.
	^self! !
!BindingReference categoriesFor: #home!accessing!public! !
!BindingReference categoriesFor: #home:!accessing!private! !
!BindingReference categoriesFor: #initialize!initializing!private! !
!BindingReference categoriesFor: #setPath:home:!initializing!private! !

!BindingReference class methodsFor!

path: aSequencedReadableCollection home: aNamespace
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^(self path: aSequencedReadableCollection)
		home: aNamespace;
		yourself!

pathString: aString home: aNamespace
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument,
	homed in the specified <Namespace>."

	^self path: (self splitQualifiedName: aString) home: aNamespace!

simpleName: aString in: aNamespace
	"Answer a new instance of the receiver representing the variable with the specified unqualified name in the specified <Namespace>."

	^(self path: {aString})
		home: aNamespace;
		yourself! !
!BindingReference class categoriesFor: #path:home:!instance creation!public! !
!BindingReference class categoriesFor: #pathString:home:!instance creation!public! !
!BindingReference class categoriesFor: #simpleName:in:!instance creation!public! !

