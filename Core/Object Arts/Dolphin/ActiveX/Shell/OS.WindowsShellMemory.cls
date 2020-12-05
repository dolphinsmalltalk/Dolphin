"Filed out from Dolphin Smalltalk 7"!

External.Memory variableByteSubclass: #'OS.WindowsShellMemory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WindowsShellMemory guid: (Core.GUID fromString: '{7d4a2961-9f62-11d3-b376-080046056106}')!
OS.WindowsShellMemory isIndirection: true!
OS.WindowsShellMemory comment: ''!
!OS.WindowsShellMemory categoriesForClass!Unclassified! !
!OS.WindowsShellMemory class methodsFor!

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
!OS.WindowsShellMemory class categoriesFor: #allocator!accessing!private! !
!OS.WindowsShellMemory class categoriesFor: #initialize!development!initializing!private! !

