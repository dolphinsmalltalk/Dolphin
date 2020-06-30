"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #MemoryMappedFileTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MemoryMappedFileTest guid: (GUID fromString: '{c5e2483c-650a-4155-a15c-2c4a79201f0c}')!
MemoryMappedFileTest comment: ''!
!MemoryMappedFileTest categoriesForClass!Kernel-Objects! !
!MemoryMappedFileTest methodsFor!

testDoubleArray
	| data array file fname mmf view array2 f |
	data := Random new next: 10000.
	array := DOUBLEArray withAll: data.
	file := File temporary.
	file write: array bytes.
	fname := file name.
	file close.
	file := File open: fname.
	mmf := MemoryMappedFile onFile: file.
	view := mmf mapView.
	array2 := DOUBLEArray fromAddress: view length: 10000.
	self assert: array2 equals: array.
	"Write through the view"
	array2 at: 1 put: 123.45.
	array2 at: array2 size put: 456.78.
	self assert: array2 first equals: 123.45.
	self assert: array2 last equals: 456.78.
	mmf free.
	view free.
	file close.
	file := File open: fname.
	f := Float new.
	file read: f.
	self assert: f equals: 123.45.
	file seek: -1 * f size sense: (Win32Constants at: 'FILE_END').
	file read: f.
	self assert: f equals: 456.78.
	file close.
	"If this fails then one or other thing is holding the file open"
	File delete: fname!

testMaximumSize
	| array file fname mmf view count |
	fname := File temporaryFilename.
	mmf := MemoryMappedFile open: fname.
	"Choose size to be exactly one allocation block so that read/write off the end will cause a fault"
	count := 64 * 1024 / 4.
	mmf maximumSize: 4 * count.
	view := mmf mapView.
	array := DWORDArray fromAddress: view length: count.
	1 to: count do: [:each | array at: each put: each].
	self assert: array asArray equals: (1 to: count).
	mmf free.
	view free.
	self
		should: [array at: count]
		raise: GPFault
		description: 'Wrote to deallocated memory mapped file'.
	(MemoryManager current)
		collectGarbage;
		administerLastRites.
	file := FileStream read: fname text: false.
	self assert: file size equals: count * 4.
	array := (1 to: count) collect: [:each | file nextDWORD].
	self assert: array equals: (1 to: count).
	file close.
	"If this fails then one or other thing is holding the file open"
	File delete: fname!

testReadOnly
	| fname file mmf view data |
	fname := File temporaryFilename.
	data := 'Blah blah'.
	file := FileStream write: fname type: #ansi.
	file nextPutAll: data.
	file close.
	mmf := MemoryMappedFile open: fname mode: #read.
	view := mmf mapView.
	self assert: (view copyFrom: 1 to: data size) equals: data asByteArray.
	"Memory is read-only"
	self should: [view at: 1 put: 0] raise: GPFault.
	view free.
	mmf free.
	File delete: fname! !
!MemoryMappedFileTest categoriesFor: #testDoubleArray!public! !
!MemoryMappedFileTest categoriesFor: #testMaximumSize!public! !
!MemoryMappedFileTest categoriesFor: #testReadOnly!public! !

