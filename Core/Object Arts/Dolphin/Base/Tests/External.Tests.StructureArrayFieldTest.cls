"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalFieldTest
	subclass: #'External.Tests.StructureArrayFieldTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.StructureArrayFieldTest guid: (Core.GUID fromString: '{643619b7-e103-4887-bc6b-533f1a9c1d98}')!

External.Tests.StructureArrayFieldTest comment: ''!

!External.Tests.StructureArrayFieldTest methodsFor!

testReadFrom
	| struct struct2 subject |
	struct := UInt32Array withAll: #(0 1 2 3 4).
	struct2 := UInt32 fromInteger: struct yourAddress + 4.
	subject := StructureArrayPointerField type: POINTL length: 2.
	subject offset: 0.
	self assert: (subject readFrom: struct2) asArray equals: {1 @ 2. 3 @ 4}!

testWriteInto
	| struct subject |
	struct := StructureArray length: 4 elementClass: POINTL.
	subject := StructureArrayField type: POINTL length: 2.
	subject offset: 8.
	subject writeInto: struct value: (UInt32Array withAll: #(10 11 12 13)) bytes.
	self assert: struct asArray equals: {0 @ 0. 10 @ 11. 12 @ 13. 0 @ 0}! !

!External.Tests.StructureArrayFieldTest categoriesForMethods!
testReadFrom!public! !
testWriteInto!public! !
!

