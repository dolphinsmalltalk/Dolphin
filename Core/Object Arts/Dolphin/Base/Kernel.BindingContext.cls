"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.BindingContext'
	instanceVariableNames: 'source identifier visited'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.BindingContext guid: (Core.GUID fromString: '{4d343a64-a62f-4214-bca5-ac205fc9ab21}')!
Kernel.BindingContext comment: ''!
!Kernel.BindingContext categoriesForClass!Kernel-Objects! !
!Kernel.BindingContext methodsFor!

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
!Kernel.BindingContext categoriesFor: #identifier!accessing!public! !
!Kernel.BindingContext categoriesFor: #setSource:identifier:!initializing!private! !
!Kernel.BindingContext categoriesFor: #source!accessing!public! !
!Kernel.BindingContext categoriesFor: #visitImport:from:!public! !

!Kernel.BindingContext class methodsFor!

source: aNamespace identifier: aString
	^self new
		setSource: aNamespace identifier: aString;
		yourself! !
!Kernel.BindingContext class categoriesFor: #source:identifier:!instance creation!public! !

