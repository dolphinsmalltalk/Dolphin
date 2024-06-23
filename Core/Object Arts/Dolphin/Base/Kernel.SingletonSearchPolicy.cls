"Filed out from Dolphin Smalltalk"!

Core.SearchPolicy
	subclass: #'Kernel.SingletonSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'current'
	classConstants: {}!

Kernel.SingletonSearchPolicy guid: (Core.GUID fromString: '{0f05b43d-e5e5-41cc-91d2-4e924305aafb}')!

Kernel.SingletonSearchPolicy isNonInstantiable: true!

Kernel.SingletonSearchPolicy comment: ''!

!Kernel.SingletonSearchPolicy categoriesForClass!Collections-Support! !

!Kernel.SingletonSearchPolicy methodsFor!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^self subclassResponsibility! !

!Kernel.SingletonSearchPolicy categoriesForMethods!
name!accessing!public! !
!

!Kernel.SingletonSearchPolicy class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^current ifNil: [current := self new]
!

onPreStripImage
	"Private - Tidy up the receiver's lazily initialized subinstances in preparation for image stripping."

	self allSubclassesDo: [:each | each uninitialize]!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	current := nil! !

!Kernel.SingletonSearchPolicy class categoriesForMethods!
current!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

