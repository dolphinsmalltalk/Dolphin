"Filed out from Dolphin Smalltalk 7"!

Object subclass: #BindingContext
	instanceVariableNames: 'source identifier visited'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
BindingContext guid: (GUID fromString: '{4d343a64-a62f-4214-bca5-ac205fc9ab21}')!
BindingContext comment: ''!
!BindingContext categoriesForClass!Kernel-Objects! !
!BindingContext methodsFor!

identifier
	^identifier!

setSource: aNamespace identifier: aString
	source := aNamespace.
	identifier := aString.
	visited := Set with: aNamespace!

source
	"The source <Namespace> initiating the binding search."

	^source!

visitImport: aBindingReference from: aNamespace
	(aBindingReference isPrivate and: [(source includesNamespace: aNamespace) not]) ifTrue: [^nil].
	^aBindingReference valueOrNil
		ifNotNil: [:namespace | (visited addNewElement: namespace) ifTrue: [namespace]]! !
!BindingContext categoriesFor: #identifier!accessing!public! !
!BindingContext categoriesFor: #setSource:identifier:!initializing!private! !
!BindingContext categoriesFor: #source!accessing!public! !
!BindingContext categoriesFor: #visitImport:from:!public! !

!BindingContext class methodsFor!

source: aNamespace identifier: aString
	^self new
		setSource: aNamespace identifier: aString;
		yourself! !
!BindingContext class categoriesFor: #source:identifier:!instance creation!public! !

