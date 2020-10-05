"Filed out from Dolphin Smalltalk 7"!

External.Memory variableByteSubclass: #'OS.COM.TaskMemory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TaskMemory guid: (Core.GUID fromString: '{87b4c51b-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.TaskMemory isIndirection: true!
OS.COM.TaskMemory comment: ''!
!OS.COM.TaskMemory categoriesForClass!External-Data-Unstructured! !
!OS.COM.TaskMemory class methodsFor!

allocator
	"Private - Answer the appropriate allocator for the receiver.
	As we are representing a block of memory for the standard COM task allocator,
	answer that."

	^IMalloc task!

initialize
	"Private - Initialize the receiver's class variables.
		TaskMemory initialize
	"

	self extraInstanceSpec: 4! !
!OS.COM.TaskMemory class categoriesFor: #allocator!accessing!private! !
!OS.COM.TaskMemory class categoriesFor: #initialize!development!initializing!private! !

