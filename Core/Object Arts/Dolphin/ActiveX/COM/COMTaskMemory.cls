"Filed out from Dolphin Smalltalk X6"!

ExternalMemory variableByteSubclass: #COMTaskMemory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMTaskMemory guid: (GUID fromString: '{87B4C51B-026E-11D3-9FD7-00A0CC3E4A32}')!
COMTaskMemory isIndirection: true!
COMTaskMemory comment: ''!
!COMTaskMemory categoriesForClass!External-Data-Unstructured! !
!COMTaskMemory class methodsFor!

allocator
	"Private - Answer the appropriate allocator for the receiver.
	As we are representing a block of memory for the standard COM task allocator,
	answer that."

	^IMalloc task!

initialize
	"Private - Initialize the receiver's class variables.
		COMTaskMemory initialize
	"

	self extraInstanceSpec: 4! !
!COMTaskMemory class categoriesFor: #allocator!accessing!private! !
!COMTaskMemory class categoriesFor: #initialize!development!initializing!private! !

