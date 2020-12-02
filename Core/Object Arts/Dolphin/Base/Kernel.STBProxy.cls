"Filed out from Dolphin Smalltalk 7"!

Object subclass: #STBProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBProxy guid: (GUID fromString: '{87b4c4c3-026e-11d3-9fd7-00a0cc3e4a32}')!
STBProxy isAbstract: true!
STBProxy comment: ''!
!STBProxy categoriesForClass!System-Binary storage!System-Binary storage! !
!STBProxy methodsFor!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents.
	As we use become to change the receiver's identity no fixups are required."

	^self become: self value!

value
	"Answer the object that this one represents."

	^self subclassResponsibility! !
!STBProxy categoriesFor: #stbFixup:at:!converting!public! !
!STBProxy categoriesFor: #value!converting!public! !

!STBProxy class methodsFor!

new
	"Private - Use specialized instance creation methods"

	^self shouldNotImplement! !
!STBProxy class categoriesFor: #new!instance creation!private! !

