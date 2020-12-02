"Filed out from Dolphin Smalltalk 7"!

ExternalAddress variableByteSubclass: #ExternalMemory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalMemory guid: (GUID fromString: '{87b4c51a-026e-11d3-9fd7-00a0cc3e4a32}')!
ExternalMemory isIndirection: true!
ExternalMemory comment: ''!
!ExternalMemory categoriesForClass!External-Data-Unstructured! !
!ExternalMemory methodsFor!

allocate: anInteger
	"Allocate anInteger bytes of memory through the receiver's
	allocator, freeing any existing allocation. Answer the receiver."

	self isNull
		ifFalse: [self basicFree].
	self basicAllocate: anInteger!

allocator
	"Private - Answer the appropriate allocator for the receiver.
	The allocator must implement:
		#Alloc:
		#Free:
		#Realloc:cb:"

	^self class allocator!

basicAllocate: anInteger
	"Private - Allocate anInteger bytes of memory through the receiver's
	IMalloc interface. Answer the receiver. The memory is initialized with zeros.
	N.B. Does not free any existing allocation."

	| pBlock |
	pBlock := self allocator Alloc: anInteger.
	pBlock isNull ifTrue: [^OutOfMemoryError signal].
	KernelLibrary default zeroMemory: pBlock length: anInteger.
	self value: pBlock!

basicFree
	"Private - Free external resources held by the receiver."

	self allocator Free: self!

finalize
	"Private - Finalize the affairs of the receiver - certain death imminent.
	As the receiver points at memory allocated using a COM allocator,
	we must free it back using the appropriate IMalloc."

	self basicFree!

free
	"Free external resources held by the receiver, and leave in a clean state."

	self isNull ifTrue: [^self].
	self beUnfinalizable.
	self basicFree.
	self clear!

reallocate: anInteger
	"Resize the memory block pointed at by the receiver (may change the
	receiver's value) through the receiver's IMalloc. Answer the receiver."

	| newAddress |
	newAddress := self allocator Realloc: self cb: anInteger.
	newAddress isNull ifTrue: [^OutOfMemoryError signal].
	self value: newAddress!

resize: anInteger
	"Resize the memory block pointed at by the receiver. Answer the receiver.
	Implementation Note: This works via IMalloc::Realloc()."

	^self reallocate: anInteger!

size
	"Answer the size of the memory block pointed at by the receiver."

	| sz |
	sz := self allocator GetSize: self.
	sz = 16rFFFFFFFF ifTrue: [self error: 'bad heap block'].
	^sz! !
!ExternalMemory categoriesFor: #allocate:!public!realizing/unrealizing! !
!ExternalMemory categoriesFor: #allocator!constants!private! !
!ExternalMemory categoriesFor: #basicAllocate:!initializing!private! !
!ExternalMemory categoriesFor: #basicFree!private!realizing/unrealizing! !
!ExternalMemory categoriesFor: #finalize!finalizing!private! !
!ExternalMemory categoriesFor: #free!public!realizing/unrealizing! !
!ExternalMemory categoriesFor: #reallocate:!public!realizing/unrealizing! !
!ExternalMemory categoriesFor: #resize:!mutating!public! !
!ExternalMemory categoriesFor: #size!accessing!public! !

!ExternalMemory class methodsFor!

Alloc: anInteger
	"Private - Allocate and answer anInteger bytes of memory from the process
	heap."

	^KernelLibrary default 
		heapAlloc: self processHeap asParameter
		dwFlags: 0
		dwBytes: anInteger
!

allocator
	"Private - Answer the appropriate allocator for the receiver.
	The allocator must implement:
		#Alloc:
		#Free:
		#Realloc:cb:"

	^self!

clear: anExternalAddress
	self free: anExternalAddress!

copyBytesToGlobalHeap: aByteObject
	| len pMem hMem kernel |
	kernel := KernelLibrary default.
	len := aByteObject byteSize.
	hMem := kernel globalAlloc: ##(GHND | GMEM_DDESHARE) dwBytes: len.
	pMem := kernel globalLock: hMem.
	kernel
		copyMemory: pMem
		source: aByteObject
		length: len.
	kernel globalUnlock: hMem.
	^hMem!

DidAlloc: anAddress
	"Private - Answer whether the specified memory block was allocated from the
	process heap (0 = no, 1 = yes, -1 = don't know).
	Implementation Note: About the best we can do is to attempt to validate the
	heap block. The answer may not be very reliable, and on a debug kernel
	may cause additional unspecified activity!!"

	anAddress isNull ifTrue: [^-1].
	^(KernelLibrary default
		heapValidate: self processHeap asParameter
		dwFlags: 0
		lpMem: anAddress)
			ifTrue: [1]
			ifFalse: [0]!

free: anExternalMemoryAddress
	"Free the memory block (assumed to have been previously allocated via the receiver)
	at anExternalMemoryAddress."

	self assert: [(self allocator DidAlloc: anExternalMemoryAddress) ~~ 0].
	self allocator Free: anExternalMemoryAddress!

Free: anAddress
	"Private - Free the memory at the specified address (which must
	previously have been allocated from the process heap)."

	KernelLibrary default
		heapFree: self processHeap asParameter
		dwFlags: 0
		lpMem: anAddress!

fromInteger: anInteger
	"Answer a new instance of the receiver with contents copied from anInteger
	Implementation note: Override superclass to make use of the external call
	primitive coercion trick."

	^(super fromInteger: anInteger) becomeA: self!

fromString: aString
	"Answer a new instance of the receiver pointing at a memory block containing
	the bytes of the argument, aString. There is no need to null terminate because
	ExternalMemory blocks are initialized with zeros."

	| answer size |
	size := aString byteSize.
	answer := self new: size.
	answer replaceFrom: 1 to: aString basicSize with: aString startingAt: 1.
	^answer!

GetSize: anAddress
	"Private - Answer the size of the specified heap block, or -1
	(actually 16rFFFFFFFF) for failure)."

	^KernelLibrary default 
		heapSize: self processHeap asParameter
		dwFlags: 0
		lpMem: anAddress!

HeapMinimize
	"Private - Minimize the size of the process heap."

	KernelLibrary default
		heapCompact: self processHeap asParameter
		dwFlags: 0!

new
	"Answer a new instance of the receiver of the initially holding a null pointer."

	^(self basicNew: 4)
		beFinalizable; 
		yourself!

new: anInteger
	"Answer a new instance of the receiver of the 
	pointing at a block of memory of size anInteger bytes,
	allocated from a COM IMalloc allocator."

	^self new 
		allocate: anInteger!

newFixed: anInteger
	"Answer a new instance of the receiver of the 
	pointing at an immovable block of memory of size anInteger bytes,
	allocated from an external heap."

	^self new: anInteger!

processHeap
	"Private - Answer an object representing the process heap which
	can be passed to a Win32 HeapXXX() API call."

	^KernelLibrary default getProcessHeap!

Realloc: anAddress cb: anInteger
	"Private - Resize the specified heap block, answering the new address,
	or 0 on failure."

	^(KernelLibrary default
		heapReAlloc: self processHeap asParameter
		dwFlags: 0
		lpMem: anAddress
		dwBytes: anInteger) asInteger! !
!ExternalMemory class categoriesFor: #Alloc:!operations!private! !
!ExternalMemory class categoriesFor: #allocator!accessing!private! !
!ExternalMemory class categoriesFor: #clear:!public!realizing/unrealizing! !
!ExternalMemory class categoriesFor: #copyBytesToGlobalHeap:!operations!public! !
!ExternalMemory class categoriesFor: #DidAlloc:!COM Interfaces-OBJIDL.IMalloc!private! !
!ExternalMemory class categoriesFor: #free:!operations!public! !
!ExternalMemory class categoriesFor: #Free:!COM Interfaces-OBJIDL.IMalloc!private! !
!ExternalMemory class categoriesFor: #fromInteger:!instance creation!public! !
!ExternalMemory class categoriesFor: #fromString:!instance creation!public! !
!ExternalMemory class categoriesFor: #GetSize:!COM Interfaces-OBJIDL.IMalloc!private! !
!ExternalMemory class categoriesFor: #HeapMinimize!COM Interfaces-OBJIDL.IMalloc!private! !
!ExternalMemory class categoriesFor: #new!instance creation!public! !
!ExternalMemory class categoriesFor: #new:!instance creation!public! !
!ExternalMemory class categoriesFor: #newFixed:!instance creation!public! !
!ExternalMemory class categoriesFor: #processHeap!accessing!private! !
!ExternalMemory class categoriesFor: #Realloc:cb:!COM Interfaces-OBJIDL.IMalloc!private! !

ExternalMemory class methodProtocol: #IMalloc attributes: #(#readOnly) selectors: #(#Alloc: #DidAlloc: #GetSize: #HeapMinimize #Realloc:cb:)!

