"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STxProxy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STxProxy guid: (Core.GUID fromString: '{87b4c4c3-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STxProxy isNonInstantiable: true!
Kernel.STxProxy comment: ''!
!Kernel.STxProxy categoriesForClass!System-Binary storage! !
!Kernel.STxProxy methodsFor!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents.
	As we use become to change the receiver's identity no fixups are required."

	^self become: self value! !
!Kernel.STxProxy categoriesForMethods!
stbFixup:at:!converting!public! !
!

!Kernel.STxProxy class methodsFor!

new
	"Private - Use specialized instance creation methods"

	^self shouldNotImplement! !
!Kernel.STxProxy class categoriesForMethods!
new!instance creation!private! !
!

