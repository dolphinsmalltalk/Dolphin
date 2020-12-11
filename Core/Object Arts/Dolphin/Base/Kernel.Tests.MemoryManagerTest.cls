"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.MemoryManagerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.MemoryManagerTest guid: (Core.GUID fromString: '{088afee2-2321-4479-b639-9f5fdc0e4418}')!
Kernel.Tests.MemoryManagerTest comment: ''!
!Kernel.Tests.MemoryManagerTest categoriesForClass!Unclassified! !
!Kernel.Tests.MemoryManagerTest methodsFor!

testBytesUsedByObject
	| meman granularity |
	meman := MemoryManager current.
	granularity := 8.
	self assert: meman objectHeaderSize equals: 0.
	self assert: (meman bytesUsedByObject: 1) equals: 0.
	"Byte object"
	"Zero length object has no body"
	self assert: (meman bytesUsedByObject: #[]) equals: 0 + 16.
	self assert: (meman bytesUsedByObject: #[1]) equals: granularity + 16.
	self assert: (meman bytesUsedByObject: #[1 2]) equals: granularity + 16.
	self assert: (meman bytesUsedByObject: #[1 2 3]) equals: granularity + 16.
	self assert: (meman bytesUsedByObject: (1 to: granularity) asByteArray) equals: granularity + 16.
	self assert: (meman bytesUsedByObject: (1 to: granularity + 1) asByteArray)
		equals: granularity * 2 + 16.

	"Null termianted byte object"
	"Cannot have a zero length string because they are null terminated"
	self assert: (meman bytesUsedByObject: '') equals: granularity + 16.
	self assert: (meman bytesUsedByObject: '1') equals: granularity + 16.
	self assert: (meman bytesUsedByObject: '12') equals: granularity + 16.
	self assert: (meman bytesUsedByObject: '123') equals: granularity + 16.
	self assert: (meman bytesUsedByObject: '1234') equals: granularity + 16.

	"Pointer object with no inst vars"
	self assert: (meman bytesUsedByObject: #()) equals: 0 + 16.
	self assert: (meman bytesUsedByObject: #(1)) equals: granularity + 16.
	self assert: (meman bytesUsedByObject: #(1 2)) equals: 4 * 2 + 16!

testOtOverflow
	| subject objects max events handler |
	subject := MemoryManager current.
	max := 8192.
	objects := Array new: max.
	events := OrderedCollection new.
	handler := [:otSize | events addLast: otSize].
	subject
		when: #otOverflow:
		send: #value:
		to: handler.
	subject compact.
	1 to: max do: [:i | objects at: i put: Object new].
	self assert: events notEmpty! !
!Kernel.Tests.MemoryManagerTest categoriesFor: #testBytesUsedByObject!public!unit tests! !
!Kernel.Tests.MemoryManagerTest categoriesFor: #testOtOverflow!public!unit tests! !

