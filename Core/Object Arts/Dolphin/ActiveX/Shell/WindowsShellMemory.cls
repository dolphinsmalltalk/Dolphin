"Filed out from Dolphin Smalltalk"!

ExternalMemory variableByteSubclass: #WindowsShellMemory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WindowsShellMemory guid: (GUID fromString: '{7d4a2961-9f62-11d3-b376-080046056106}')!
WindowsShellMemory isIndirection: true!
WindowsShellMemory comment: ''!
!WindowsShellMemory categoriesForClass!Unclassified! !
!WindowsShellMemory class methodsFor!

allocator
	"Private - Answer the appropriate allocator for the receiver.
	As we are representing a block of memory for the standard COM task allocator,
	answer that."

	^ShellLibrary default allocator!

initialize
	"Private - Initialize the receiver's class variables.
		WindowsShellMemory initialize
	"

	self extraInstanceSpec: 4! !
!WindowsShellMemory class categoriesForMethods!
allocator!accessing!private! !
initialize!development!initializing!private! !
!

