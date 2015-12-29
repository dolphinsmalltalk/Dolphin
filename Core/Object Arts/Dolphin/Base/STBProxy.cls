"Filed out from Dolphin Smalltalk X6"!

Object subclass: #STBProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBProxy guid: (GUID fromString: '{87B4C4C3-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	^self subclassResponsibility! !
!STBProxy class categoriesFor: #new!instance creation!private! !

