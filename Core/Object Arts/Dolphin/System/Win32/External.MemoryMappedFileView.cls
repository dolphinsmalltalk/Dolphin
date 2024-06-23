"Filed out from Dolphin Smalltalk"!

External.Address
	variableByteSubclass: #'External.MemoryMappedFileView'
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

	Kernel32 unmapViewOfFile: self!

flush
	"Flush any modifications to the data in the range represented by this view to the underlying file."

	Kernel32 flushViewOfFile: self dwNumberOfBytesToFlush: 0!

free
	"Free external resources held by the receiver, and leave in a clean state."

	self isNull ifFalse: [
		self beUnfinalizable.
		self basicFree.
		self clear]! !

!External.MemoryMappedFileView categoriesForMethods!
basicFree!private!realizing/unrealizing! !
flush!operations!public! !
free!public!realizing/unrealizing! !
!

!External.MemoryMappedFileView class methodsFor!

fromInteger: anInteger
	^self new
		basicUIntPtrAtOffset: 0 put: anInteger;
		yourself! !

!External.MemoryMappedFileView class categoriesForMethods!
fromInteger:!public! !
!

