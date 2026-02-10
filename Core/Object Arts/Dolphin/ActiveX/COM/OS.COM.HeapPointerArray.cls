"Filed out from Dolphin Smalltalk"!

External.UIntPtrArray
	subclass: #'OS.COM.HeapPointerArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.HeapPointerArray guid: (Core.GUID fromString: '{619931c8-b104-45f7-9a6c-9f006e50b144}')!

OS.COM.HeapPointerArray isNonInstantiable: true!

OS.COM.HeapPointerArray comment: '`HeapPointerArray` is an abstract class of `ExternalArray`s, the subinstances of which are pointers to blocks of memory allocated from an external heap, but which are managed by the array. Assigning into the array will generally require allocating a new heap block and freeing the existing one pointed at by the indexed pointer element. When the array itself is free''d, if it has no owner then it must typically free all the individual blocks at which it points. The block of memory storing the pointers could itself be a heap object, but this is managed by using a suitable smart pointer from the `Memory` hierarchy, e.g. `TaskMemory` for an allocation from the process-wide COM task heap.'!

!OS.COM.HeapPointerArray methodsFor!

basicFree
	"Private - Free external resources owned by the receiver. Both the array of pointers, and the individual strings it references, may be allocated from an external heap."

	| ptrType |
	ptrType := self elementClass.
	0 to: bytes size - 1
		by: VMConstants.IntPtrSize
		do: [:offset | ptrType freeHeapObject: (bytes uintPtrAtOffset: offset)].
	bytes free!

copyBytes: aByteObject
	self class
		copyBytes: aByteObject
		from: 1
		to: self byteSize
		into: bytes!

initialize
	super initialize.
	self beFinalizable!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources. Subinstances that own external heap memory will need to be freed."

	^owner isNil and: [self isNull not]!

onStartup
	"Private - Clear down the receiver as it is pointing at an externally allocated safe array from the session when the image was saved which no longer exists."

	self beUnfinalizable.
	bytes := nil.
	length := 0!

uncheckedAt: anInteger
	"Private - Answer a Smalltalk <Object> copy of the external heap object of the receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^self subclassResponsibility!

uncheckedAt: indexInteger put: anObject
	"Private - Replace the external heap object pointer at the index specified by the `<integer>` 1st argument with a freshly allocated heap copy of the 2nd argument <Object>. No bounds checks are performed on the subscript. "

	| offset ptrType |
	offset := (indexInteger - 1) * VMConstants.IntPtrSize.
	ptrType := self elementClass.
	"We must release the overwritten value"
	ptrType freeHeapObject: (bytes uintPtrAtOffset: offset).
	"Then overwrite with a copy"
	bytes uintPtrAtOffset: offset put: (ptrType allocHeapObject: anObject) detach.
	^anObject! !

!OS.COM.HeapPointerArray categoriesForMethods!
basicFree!private!realizing/unrealizing! !
copyBytes:!copying!private! !
initialize!initializing!private! !
needsFree!private!realizing/unrealizing! !
onStartup!event handling!private! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.HeapPointerArray class methodsFor!

copyBytes: srcByteObject from: startInteger to: stopInteger into: destByteObject
	| ptrType pDest |
	ptrType := self elementClass.
	pDest := (destByteObject yourAddress - (startInteger - 1)) asExternalAddress.
	startInteger - 1 to: stopInteger - 1
		by: VMConstants.IntPtrSize
		do: 
			[:offset |
			pDest uintPtrAtOffset: offset
				put: (ptrType copyHeapObject: (srcByteObject uintPtrAtOffset: offset)) detach].
	^destByteObject!

requiresFinalization
	"Answer whether instances of the receiver that own their own resources will require free'ing either explicitly or by finalization.
	HeapPointerArrays contain pointers to independently allocated heap blocks. They require finalization to free those blocks one-by-one."

	^true! !

!OS.COM.HeapPointerArray class categoriesForMethods!
copyBytes:from:to:into:!copying!private! !
requiresFinalization!public!realizing/unrealizing!testing! !
!

