"Filed out from Dolphin Smalltalk X6.1"!

ExternalAddress variableByteSubclass: #MemoryMappedFileView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MemoryMappedFileView guid: (GUID fromString: '{FF57D052-5958-43E6-AB68-ADD0AC6BCB64}')!
MemoryMappedFileView isIndirection: true!
MemoryMappedFileView comment: 'MemoryMappedFileView is an <ExternalAddress> that represents a view onto a block of bytes from a memory-mapped file. It can be treated much like a normal pointer.'!
!MemoryMappedFileView categoriesForClass!External-Data-Unstructured! !
!MemoryMappedFileView methodsFor!

basicFree
	"Private - Free external resources held by the receiver."

	"Transcript
		display: 'Unmapping  ';
		print: self;
		cr."

	KernelLibrary default unmapViewOfFile: self!

flush
	"Flush any modifications to the data in the range represented by this view to the underlying file."

	KernelLibrary default flushViewOfFile: self dwNumberOfBytesToFlush: 0!

free
	"Free external resources held by the receiver, and leave in a clean state."

	self isNull ifFalse: [
		self beUnfinalizable.
		self basicFree.
		self clear]! !
!MemoryMappedFileView categoriesFor: #basicFree!private!realizing/unrealizing! !
!MemoryMappedFileView categoriesFor: #flush!operations!public! !
!MemoryMappedFileView categoriesFor: #free!public!realizing/unrealizing! !

