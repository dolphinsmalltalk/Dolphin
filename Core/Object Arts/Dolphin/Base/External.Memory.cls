"Filed out from Dolphin Smalltalk"!

External.Address
	variableByteSubclass: #'External.Memory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
External.Memory guid: (Core.GUID fromString: '{87b4c51a-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Memory isIndirection: true!
External.Memory comment: ''!
!External.Memory categoriesForClass!External-Data-Unstructured! !
!External.Memory methodsFor!

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
	Kernel32 zeroMemory: pBlock length: anInteger.
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
!External.Memory categoriesForMethods!
allocate:!public!realizing/unrealizing! !
allocator!constants!private! !
basicAllocate:!initializing!private! !
basicFree!private!realizing/unrealizing! !
finalize!finalizing!private! !
free!public!realizing/unrealizing! !
reallocate:!public!realizing/unrealizing! !
resize:!mutating!public! !
size!accessing!public! !
!

!External.Memory class methodsFor!

Alloc: anInteger
	"Private - Allocate and answer anInteger bytes of memory from the process
	heap."

	^Kernel32
		heapAlloc: self processHeap asParameter
		dwFlags: 0
		dwBytes: anInteger!

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
	| len pMem hMem |
	len := aByteObject byteSize.
	hMem := Kernel32 globalAlloc: ##(GHND | GMEM_DDESHARE) dwBytes: len.
	pMem := Kernel32 globalLock: hMem.
	Kernel32
		copyMemory: pMem
		source: aByteObject
		length: len.
	Kernel32 globalUnlock: hMem.
	^hMem!

DidAlloc: anAddress
	"Private - Answer whether the specified memory block was allocated from the
	process heap (0 = no, 1 = yes, -1 = don't know).
	Implementation Note: About the best we can do is to attempt to validate the
	heap block. The answer may not be very reliable, and on a debug kernel
	may cause additional unspecified activity!!"

	anAddress isNull ifTrue: [^-1].
	^(Kernel32
		heapValidate: self processHeap asParameter
		dwFlags: 0
		lpMem: anAddress) ifTrue: [1] ifFalse: [0]!

free: anExternalMemoryAddress
	"Free the memory block (assumed to have been previously allocated via the receiver)
	at anExternalMemoryAddress."

	self assert: [(self allocator DidAlloc: anExternalMemoryAddress) ~~ 0].
	self allocator Free: anExternalMemoryAddress!

Free: anAddress
	"Private - Free the memory at the specified address (which must
	previously have been allocated from the process heap)."

	Kernel32
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
	answer replaceFrom: 1 to: size - aString class elementSize with: aString startingAt: 1.
	^answer!

GetSize: anAddress
	"Private - Answer the size of the specified heap block, or -1
	(actually 16rFFFFFFFF) for failure)."

	^Kernel32
		heapSize: self processHeap asParameter
		dwFlags: 0
		lpMem: anAddress!

HeapMinimize
	"Private - Minimize the size of the process heap."

	Kernel32 heapCompact: self processHeap asParameter dwFlags: 0!

new
	"Answer a new instance of the receiver of the initially holding a null pointer."

	^(self basicNew: VMConstants.IntPtrSize)
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

	^Kernel32 getProcessHeap!

Realloc: anAddress cb: anInteger
	"Private - Resize the specified heap block, answering the new address,
	or 0 on failure."

	^(Kernel32
		heapReAlloc: self processHeap asParameter
		dwFlags: 0
		lpMem: anAddress
		dwBytes: anInteger) asInteger! !
!External.Memory class categoriesForMethods!
Alloc:!operations!private! !
allocator!accessing!private! !
clear:!public!realizing/unrealizing! !
copyBytesToGlobalHeap:!operations!public! !
DidAlloc:!COM Interfaces-OBJIDL.IMalloc!private! !
free:!operations!public! !
Free:!COM Interfaces-OBJIDL.IMalloc!private! !
fromInteger:!instance creation!public! !
fromString:!instance creation!public! !
GetSize:!COM Interfaces-OBJIDL.IMalloc!private! !
HeapMinimize!COM Interfaces-OBJIDL.IMalloc!private! !
new!instance creation!public! !
new:!instance creation!public! !
newFixed:!instance creation!public! !
processHeap!accessing!private! !
Realloc:cb:!COM Interfaces-OBJIDL.IMalloc!private! !
!

External.Memory class methodProtocol: #IMalloc attributes: #(#readOnly) selectors: #(#Alloc: #DidAlloc: #GetSize: #HeapMinimize #Realloc:cb:)!

