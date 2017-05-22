"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #XMLDOMNodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XMLDOMNodeTest guid: (GUID fromString: '{956b7839-a2fb-47f1-9c74-2aacae4bdffb}')!
XMLDOMNodeTest comment: ''!
!XMLDOMNodeTest categoriesForClass!Unclassified! !
!XMLDOMNodeTest methodsFor!

testDisplayOn
	| elem |
	elem := (IXMLDOMDocument new loadText: '<a/>') firstChild.
	self assert: elem displayString = 'an IXMLDOMElement'!

testDownCast
	self assert: (IXMLDOMDocument new loadText: '<a/>') firstChild class == IXMLDOMElement
!

testSetNodeTypeAndValue
	| doc elem root |
	doc := IXMLDOMDocument new.
	root := doc addElement: 'Root'.
	elem := root addElement: 'Blah'.
	elem setNodeTypeAndValue: nil.
	self assert: elem nodeTypedValue isNil.
	elem setNodeTypeAndValue: 'a string'.
	self assert: elem dataType = 'string'.
	self assert: elem nodeTypedValue = 'a string'.
	elem setNodeTypeAndValue: nil.
	self assert: elem nodeTypedValue isNil.
	elem setNodeTypeAndValue: 123.
	self assert: elem dataType = 'i4'.
	self assert: elem nodeTypedValue = 123.
	elem setNodeTypeAndValue: 123.456.
	self assert: elem dataType = 'r8'.
	self assert: elem nodeTypedValue = 123.456.
	elem setNodeTypeAndValue: true.
	self assert: elem dataType = 'boolean'.
	self assert: elem nodeTypedValue.
	elem setNodeTypeAndValue: false.
	self assert: elem dataType = 'boolean'.
	self assert: elem nodeTypedValue not! !
!XMLDOMNodeTest categoriesFor: #testDisplayOn!public!unit tests! !
!XMLDOMNodeTest categoriesFor: #testDownCast!public!unit tests! !
!XMLDOMNodeTest categoriesFor: #testSetNodeTypeAndValue!public!unit tests! !

