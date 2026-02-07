"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CountedArrayOfHeapPointers'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.CountedArrayOfHeapPointers guid: (Core.GUID fromString: '{20019ab9-b86e-4944-911f-b3fcf013a0aa}')!

OS.COM.CountedArrayOfHeapPointers isNonInstantiable: true!

OS.COM.CountedArrayOfHeapPointers comment: ''!

!OS.COM.CountedArrayOfHeapPointers categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CountedArrayOfHeapPointers methodsFor!

basicFree
	"Private - Free external resources owned by the receiver.
	Not only is the array allocated from the task heap, but also each of the individual strings in it."

	| pElems ptrType |
	pElems := (bytes uintPtrAtOffset: _OffsetOf_pElems) asExternalAddress.
	ptrType := self elementClass.
	0 to: (bytes uint32AtOffset: _OffsetOf_cElems) - 1
		do: [:i | ptrType freeHeapObject: (pElems uintPtrAtOffset: i * VMConstants.IntPtrSize)].
	super basicFree!

copyElements: srcAddress to: destAddress count: anInteger
	| ptrClass |
	ptrClass := self elementClass.
	0 to: anInteger * VMConstants.IntPtrSize - 1
		by: VMConstants.IntPtrSize
		do: 
			[:offset |
			destAddress uintPtrAtOffset: offset
				put: (ptrClass copyHeapObject: (srcAddress uintPtrAtOffset: offset)) detach]! !

!OS.COM.CountedArrayOfHeapPointers categoriesForMethods!
basicFree!private!realizing/unrealizing! !
copyElements:to:count:!copying!private! !
!

