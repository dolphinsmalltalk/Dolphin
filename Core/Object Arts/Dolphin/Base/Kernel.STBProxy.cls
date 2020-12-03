"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.STBProxy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBProxy guid: (Core.GUID fromString: '{87b4c4c3-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBProxy isNonInstantiable: true!
Kernel.STBProxy comment: ''!
!Kernel.STBProxy categoriesForClass!System-Binary storage!System-Binary storage! !
!Kernel.STBProxy methodsFor!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents.
	As we use become to change the receiver's identity no fixups are required."

	^self become: self value!

value
	"Answer the object that this one represents."

	^self subclassResponsibility! !
!Kernel.STBProxy categoriesFor: #stbFixup:at:!converting!public! !
!Kernel.STBProxy categoriesFor: #value!converting!public! !

!Kernel.STBProxy class methodsFor!

new
	"Private - Use specialized instance creation methods"

	^self shouldNotImplement! !
!Kernel.STBProxy class categoriesFor: #new!instance creation!private! !

