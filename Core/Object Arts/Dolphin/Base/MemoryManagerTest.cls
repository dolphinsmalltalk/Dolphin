"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #MemoryManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MemoryManagerTest guid: (GUID fromString: '{088AFEE2-2321-4479-B639-9F5FDC0E4418}')!
MemoryManagerTest comment: ''!
!MemoryManagerTest categoriesForClass!Unclassified! !
!MemoryManagerTest methodsFor!

testBytesUsedByObject
	| meman granularity |
	meman := MemoryManager current.
	granularity := 8.
	self assert: meman objectHeaderSize = 0.
	self assert: (meman bytesUsedByObject: 1) = 0.
	"Byte object"
	"Zero length object has no body"
	self assert: (meman bytesUsedByObject: #[]) = (0 + 16).
	self assert: (meman bytesUsedByObject: #[1]) = (granularity + 16).
	self assert: (meman bytesUsedByObject: #[1 2]) = (granularity + 16).
	self assert: (meman bytesUsedByObject: #[1 2 3]) = (granularity + 16).
	self assert: (meman bytesUsedByObject: (1 to: granularity) asByteArray) = (granularity + 16).
	self 
		assert: (meman bytesUsedByObject: (1 to: granularity + 1) asByteArray) = (granularity * 2 + 16).

	"Null termianted byte object"
	"Cannot have a zero length string because they are null terminated"
	self assert: (meman bytesUsedByObject: '') = (granularity + 16).
	self assert: (meman bytesUsedByObject: '1') = (granularity + 16).
	self assert: (meman bytesUsedByObject: '12') = (granularity + 16).
	self assert: (meman bytesUsedByObject: '123') = (granularity + 16).
	self assert: (meman bytesUsedByObject: '1234') = (granularity + 16).

	"Pointer object with no inst vars"
	self assert: (meman bytesUsedByObject: #()) = (0 + 16).
	self assert: (meman bytesUsedByObject: #(1)) = (granularity + 16).
	self assert: (meman bytesUsedByObject: #(1 2)) = (4 * 2 + 16).
!

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
!MemoryManagerTest categoriesFor: #testBytesUsedByObject!public!unit tests! !
!MemoryManagerTest categoriesFor: #testOtOverflow!public!unit tests! !

