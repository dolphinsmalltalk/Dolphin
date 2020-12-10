"Filed out from Dolphin Smalltalk 7"!

External.Address variableByteSubclass: #'External.MemoryMappedFileView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.MemoryMappedFileView guid: (Core.GUID fromString: '{ff57d052-5958-43e6-ab68-add0ac6bcb64}')!
External.MemoryMappedFileView isIndirection: true!
External.MemoryMappedFileView comment: 'MemoryMappedFileView is an <ExternalAddress> that represents a view onto a block of bytes from a memory-mapped file. It can be treated much like a normal pointer.'!
!External.MemoryMappedFileView categoriesForClass!External-Data-Unstructured! !
!External.MemoryMappedFileView methodsFor!

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
!External.MemoryMappedFileView categoriesFor: #basicFree!private!realizing/unrealizing! !
!External.MemoryMappedFileView categoriesFor: #flush!operations!public! !
!External.MemoryMappedFileView categoriesFor: #free!public!realizing/unrealizing! !

