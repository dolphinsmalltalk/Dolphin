"Filed out from Dolphin Smalltalk 7"!

COMEnumerator subclass: #COMInterfaceEnumerator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
COMInterfaceEnumerator guid: (GUID fromString: '{c3eefb00-a19e-11d3-b376-080046056106}')!
COMInterfaceEnumerator comment: 'COMInterfaceEnumerator is Dolphin''s generic implementation of COM enumerators for collections of interface pointers, i.e. IEnumUnknown.
'!
!COMInterfaceEnumerator categoriesForClass!COM-Implementations! !
!COMInterfaceEnumerator methodsFor!

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
!COMInterfaceEnumerator categoriesFor: #arrayBufferAt:length:!COM Interfaces-IEnumXXXX!private! !
!COMInterfaceEnumerator categoriesFor: #nextElement!COM Interfaces-IEnumXXXX!private! !

!COMInterfaceEnumerator class methodsFor!

newEnumeratorOn: sequence
	"Answer a new <IEnumUnknown> onto a new instance of the receiver
	that enumerates over the contents of the <sequencedReadableCollection>, 
	sequence."

	^self newEnumerator: IEnumUnknown on: sequence! !
!COMInterfaceEnumerator class categoriesFor: #newEnumeratorOn:!instance creation!public! !

