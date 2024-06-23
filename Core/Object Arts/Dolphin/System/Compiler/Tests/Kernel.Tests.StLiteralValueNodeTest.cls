"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.StLiteralValueNodeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.StLiteralValueNodeTest guid: (Core.GUID fromString: '{f8a26c7d-e798-4b63-bfa2-411d30509b7e}')!

Kernel.Tests.StLiteralValueNodeTest comment: ''!

!Kernel.Tests.StLiteralValueNodeTest methodsFor!

testEqualValuesOfDifferentTypes
	"See #977/#978"

	#('foo' #foo 1 1.0 '🐬' #'🐬') pairsDo: 
			[:a :b |
			| aNode bNode |
			self assert: a equals: b.
			aNode := StLiteralValueNode value: a.
			bNode := StLiteralValueNode value: b.
			self deny: aNode equals: bNode.
			self deny: bNode equals: aNode]! !

!Kernel.Tests.StLiteralValueNodeTest categoriesForMethods!
testEqualValuesOfDifferentTypes!public! !
!

