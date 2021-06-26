"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.StLiteralValueNodeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.StLiteralValueNodeTest guid: (Core.GUID fromString: '{7dd892ce-527c-45da-ab0a-3a79c30f0075}')!
Kernel.Tests.StLiteralValueNodeTest comment: ''!
!Kernel.Tests.StLiteralValueNodeTest categoriesForClass!Unclassified! !
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
!Kernel.Tests.StLiteralValueNodeTest categoriesFor: #testEqualValuesOfDifferentTypes!public! !

