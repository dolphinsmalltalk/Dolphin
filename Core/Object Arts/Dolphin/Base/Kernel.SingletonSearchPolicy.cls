"Filed out from Dolphin Smalltalk 7"!

Core.SearchPolicy subclass: #'Kernel.SingletonSearchPolicy'
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

	^self subclassResponsibility!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !
!Kernel.SingletonSearchPolicy categoriesFor: #name!accessing!public! !
!Kernel.SingletonSearchPolicy categoriesFor: #stbSaveOn:!binary filing!public! !

!Kernel.SingletonSearchPolicy class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^current ifNil: [current := self new]
!

onPreStripImage
	"Private - Tidy up the receiver's lazily initialized subinstances in preparation for image stripping."

	self allSubclassesDo: [:each | each uninitialize]!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| singleton |
	singleton := self current.
	anSTBInFiler register: singleton.
	^singleton!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	current := nil! !
!Kernel.SingletonSearchPolicy class categoriesFor: #current!instance creation!public! !
!Kernel.SingletonSearchPolicy class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Kernel.SingletonSearchPolicy class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!Kernel.SingletonSearchPolicy class categoriesFor: #uninitialize!class hierarchy-removing!private! !

