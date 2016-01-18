"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #MemoryMappedFileTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MemoryMappedFileTest guid: (GUID fromString: '{C5E2483C-650A-4155-A15C-2C4A79201F0C}')!
MemoryMappedFileTest comment: ''!
!MemoryMappedFileTest categoriesForClass!Kernel-Objects! !
!MemoryMappedFileTest methodsFor!

testReadOnly
	| fname file mmf view data |
	fname := File temporaryFilename.
	data := 'Blah blah'.
	file := FileStream write: fname.
	file nextPutAll: data.
	file close.
	mmf := MemoryMappedFile open: fname mode: #read.
	view := mmf mapView.
	self assert: (view copyFrom: 1 to: data size) = data asByteArray.
	"Memory is read-only"
	self should: [view at: 1 put: 0] raise: GPFault.
	view free.
	mmf free.
	File delete: fname! !
!MemoryMappedFileTest categoriesFor: #testReadOnly!public! !

