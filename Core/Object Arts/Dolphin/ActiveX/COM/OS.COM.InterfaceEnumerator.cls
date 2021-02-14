"Filed out from Dolphin Smalltalk 7"!

OS.COM.Enumerator subclass: #'OS.COM.InterfaceEnumerator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.InterfaceEnumerator guid: (Core.GUID fromString: '{c3eefb00-a19e-11d3-b376-080046056106}')!
OS.COM.InterfaceEnumerator comment: 'COMInterfaceEnumerator is Dolphin''s generic implementation of COM enumerators for collections of interface pointers, i.e. IEnumUnknown.
'!
!OS.COM.InterfaceEnumerator categoriesForClass!COM-Implementations! !
!OS.COM.InterfaceEnumerator methodsFor!

arrayBufferAt: buf length: count
	"Private - Answer a suitable <ExternalArray> wrapping the buffer at <ExternalAddress>,
	buf, of <integer> length, count."

	^DWORDArray fromAddress: buf length: count
!

nextElement
	"Private - Answer a copy of the next element of the receiver.
	Implementation Note: We must add a reference as we are copying
	interface pointers into an output argument."

	| pi |
	pi := contents next.
	pi _addRef.
	^pi yourAddress
! !
!OS.COM.InterfaceEnumerator categoriesFor: #arrayBufferAt:length:!COM Interfaces-IEnumXXXX!private! !
!OS.COM.InterfaceEnumerator categoriesFor: #nextElement!COM Interfaces-IEnumXXXX!private! !

!OS.COM.InterfaceEnumerator class methodsFor!

newEnumeratorOn: sequence
	"Answer a new <IEnumUnknown> onto a new instance of the receiver
	that enumerates over the contents of the <sequencedReadableCollection>, 
	sequence."

	^self newEnumerator: IEnumUnknown on: sequence! !
!OS.COM.InterfaceEnumerator class categoriesFor: #newEnumeratorOn:!instance creation!public! !

