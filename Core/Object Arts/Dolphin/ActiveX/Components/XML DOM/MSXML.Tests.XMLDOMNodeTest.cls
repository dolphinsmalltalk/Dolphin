"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #XMLDOMNodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XMLDOMNodeTest guid: (Core.GUID fromString: '{956b7839-a2fb-47f1-9c74-2aacae4bdffb}')!
XMLDOMNodeTest comment: ''!
!XMLDOMNodeTest categoriesForClass!Unclassified! !
!XMLDOMNodeTest methodsFor!

testDisplayOn
	| elem |
	elem := (IXMLDOMDocument new loadText: '<a/>') firstChild.
	self assert: elem displayString equals: 'an IXMLDOMElement'!

testDownCast
	self assert: (IXMLDOMDocument new loadText: '<a/>') firstChild class identicalTo: IXMLDOMElement!

testSetNodeTypeAndValue
	| doc elem root |
	doc := IXMLDOMDocument new.
	root := doc addElement: 'Root'.
	elem := root addElement: 'Blah'.
	elem setNodeTypeAndValue: nil.
	self assertIsNil: elem nodeTypedValue.
	elem setNodeTypeAndValue: 'a string'.
	self assert: elem dataType equals: 'string'.
	self assert: elem nodeTypedValue equals: 'a string'.
	elem setNodeTypeAndValue: nil.
	self assertIsNil: elem nodeTypedValue.
	elem setNodeTypeAndValue: 123.
	self assert: elem dataType equals: 'i4'.
	self assert: elem nodeTypedValue equals: 123.
	elem setNodeTypeAndValue: 123.456.
	self assert: elem dataType equals: 'r8'.
	self assert: elem nodeTypedValue equals: 123.456.
	elem setNodeTypeAndValue: true.
	self assert: elem dataType equals: 'boolean'.
	self assert: elem nodeTypedValue.
	elem setNodeTypeAndValue: false.
	self assert: elem dataType equals: 'boolean'.
	self assert: elem nodeTypedValue not! !
!XMLDOMNodeTest categoriesFor: #testDisplayOn!public!unit tests! !
!XMLDOMNodeTest categoriesFor: #testDownCast!public!unit tests! !
!XMLDOMNodeTest categoriesFor: #testSetNodeTypeAndValue!public!unit tests! !

