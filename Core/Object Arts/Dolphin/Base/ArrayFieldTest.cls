"Filed out from Dolphin Smalltalk"!

ExternalFieldTest subclass: #ArrayFieldTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayFieldTest guid: (GUID fromString: '{56f5e127-bdcd-4629-863f-d4f002b58b46}')!
ArrayFieldTest comment: ''!
!ArrayFieldTest categoriesForClass!Unclassified! !
!ArrayFieldTest methodsFor!

testReadFrom
	| struct actual subject |
	struct := DWORDArray withAll: #(1 16r7FFFFFFF 16rFFFFFFFF 4).
	subject := ArrayField type: DWORDArray length: 2.
	subject offset: 4.
	actual := subject readFrom: struct.
	self assert: actual asArray equals: #(16r7FFFFFFF 16rFFFFFFFF)!

testWriteInto
	| struct subject |
	struct := DWORDArray withAll: #(1 2 3 4).
	subject := ArrayField type: DWORDArray length: 2.
	subject offset: 4.
	subject writeInto: struct value: (DWORDArray withAll: #(16r7FFFFFFF 16rFFFFFFFF)) bytes.
	self assert: struct asArray equals: #(1 16r7FFFFFFF 16rFFFFFFFF 4)! !
!ArrayFieldTest categoriesForMethods!
testReadFrom!public! !
testWriteInto!public! !
!

