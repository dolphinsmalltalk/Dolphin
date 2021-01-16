"Filed out from Dolphin Smalltalk 7"!

External.Tests.ExternalFieldTest subclass: #'External.Tests.ArrayFieldTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.ArrayFieldTest guid: (Core.GUID fromString: '{56f5e127-bdcd-4629-863f-d4f002b58b46}')!
External.Tests.ArrayFieldTest comment: ''!
!External.Tests.ArrayFieldTest categoriesForClass!Unclassified! !
!External.Tests.ArrayFieldTest methodsFor!

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
!External.Tests.ArrayFieldTest categoriesFor: #testReadFrom!public! !
!External.Tests.ArrayFieldTest categoriesFor: #testWriteInto!public! !

