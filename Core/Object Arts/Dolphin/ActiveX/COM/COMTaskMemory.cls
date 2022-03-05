"Filed out from Dolphin Smalltalk"!

ExternalMemory variableByteSubclass: #COMTaskMemory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMTaskMemory guid: (GUID fromString: '{87b4c51b-026e-11d3-9fd7-00a0cc3e4a32}')!
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
!COMTaskMemory class categoriesForMethods!
allocator!accessing!private! !
initialize!development!initializing!private! !
!

