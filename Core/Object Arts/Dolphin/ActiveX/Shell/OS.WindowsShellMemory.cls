"Filed out from Dolphin Smalltalk"!

External.Memory
	variableByteSubclass: #'OS.WindowsShellMemory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WindowsShellMemory guid: (Core.GUID fromString: '{7d4a2961-9f62-11d3-b376-080046056106}')!
OS.WindowsShellMemory isIndirection: true!
OS.WindowsShellMemory comment: ''!
!OS.WindowsShellMemory class methodsFor!

allocator
	"Private - Answer the appropriate allocator for the receiver.
	As we are representing a block of memory for the standard COM task allocator,
	answer that."

	^Shell32 allocator!

initialize
	"Private - Initialize the receiver's class variables.
		WindowsShellMemory initialize
	"

	self extraInstanceSpec: VMConstants.IntPtrSize! !
!OS.WindowsShellMemory class categoriesForMethods!
allocator!accessing!private! !
initialize!development!initializing!private! !
!

