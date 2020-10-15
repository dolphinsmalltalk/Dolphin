"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMNodeList subclass: #'MSXML.IXMLDOMSelection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMSelection guid: (OS.COM.IID fromString: '{aa634fc7-5888-44a7-a257-3a47150d3a0e}')!
MSXML.IXMLDOMSelection comment: '<IXMLDOMSelection> is a wrapper class for the COM interface ''MSXML2.IXMLDOMSelection'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(AA634FC7-5888-44A7-A257-3A47150D3A0E), 
	dual, 
	nonextensible
]
interface IXMLDOMSelection : IXMLDOMNodeList
 {
	[id(0x00000051), propget, helpstring("selection expression")]
	HRESULT __stdcall expr(
		[out, retval]BSTR* expression);
	[id(0x00000051), propput, helpstring("selection expression")]
	HRESULT __stdcall expr(
		[in]BSTR expression);
	[id(0x00000052), propget, helpstring("nodes to apply selection expression to")]
	HRESULT __stdcall context(
		[out, retval]IXMLDOMNode** ppNode);
	[id(0x00000052), propputref, helpstring("nodes to apply selection expression to")]
	HRESULT __stdcall context(
		[in]IXMLDOMNode* ppNode);
	[id(0x00000053), helpstring("gets the next node without advancing the list position")]
	HRESULT __stdcall peekNode(
		[out, retval]IXMLDOMNode** ppNode);
	[id(0x00000054), helpstring("checks to see if the node matches the pattern")]
	HRESULT __stdcall matches(
		[in]IXMLDOMNode* pNode,
		[out, retval]IXMLDOMNode** ppNode);
	[id(0x00000055), helpstring("removes the next node")]
	HRESULT __stdcall removeNext(
		[out, retval]IXMLDOMNode** ppNode);
	[id(0x00000056), helpstring("removes all the nodes that match the selection")]
	HRESULT __stdcall removeAll();
	[id(0x00000057), helpstring("clone this object with the same position and context")]
	HRESULT __stdcall clone(
		[out, retval]IXMLDOMSelection** ppNode);
	[id(0x00000058), helpstring("get the value of the named property")]
	HRESULT __stdcall getProperty(
		[in]BSTR name,
		[out, retval]VARIANT* value);
	[id(0x00000059), helpstring("set the value of the named property")]
	HRESULT __stdcall setProperty(
		[in]BSTR name,
		[in]VARIANT value);
};
'!
!MSXML.IXMLDOMSelection categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IXMLDOMSelection methodsFor!

clone
	"Answer the <IXMLDOMSelection> result of invoking the clone() method of the COM object.
	Helpstring: clone this object with the same position and context"

	| answer |
	answer := IXMLDOMSelection newPointer.
	self Clone: answer.
	^answer asObject!

Clone: ppNode
	"Private - Invoke the clone() method of the COM object.
	Helpstring: clone this object with the same position and context

		HRESULT __stdcall clone(
			[out, retval]IXMLDOMSelection** ppNode);"

	<virtual stdcall: hresult 21 IXMLDOMSelection**>
	^self invalidCall: _failureCode!

context
	"Answer the <IXMLDOMNode> value of the 'context' property of the receiver.
	Helpstring: nodes to apply selection expression to"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_context: answer.
	^answer asObject!

expr
	"Answer the <bstr> value of the 'expr' property of the receiver.
	Helpstring: selection expression"

	| answer |
	answer := BSTR new.
	self get_expr: answer.
	^answer asObject!

expr: expression
	"Set the 'expr' property of the receiver to the <bstr> value of the argument.
	Helpstring: selection expression"

	self put_expr: expression!

get_context: ppNode
	"Private - Get the value of the 'context' property of the receiver.

		HRESULT __stdcall context(
			[out, retval]IXMLDOMNode** ppNode);"

	<virtual stdcall: hresult 15 IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_expr: expression
	"Private - Get the value of the 'expr' property of the receiver.

		HRESULT __stdcall expr(
			[out, retval]BSTR* expression);"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall: _failureCode!

GetProperty: name value: value
	"Private - Invoke the getProperty() method of the COM object.
	Helpstring: get the value of the named property

		HRESULT __stdcall getProperty(
			[in]BSTR name,
			[out, retval]VARIANT* value);"

	<virtual stdcall: hresult 22 bstr variant*>
	^self invalidCall: _failureCode!

getProperty_: name
	"Answer the <variant> result of invoking the getProperty() method of the COM object.
	Helpstring: get the value of the named property"

	| answer |
	answer := VARIANT new.
	self GetProperty: name value: answer.
	^answer asObject!

matches: pNode
	"Answer the <IXMLDOMNode> result of invoking the matches() method of the COM object.
	Helpstring: checks to see if the node matches the pattern"

	| answer |
	answer := IXMLDOMNode newPointer.
	self Matches: pNode ppNode: answer.
	^answer asObject!

Matches: pNode ppNode: ppNode
	"Private - Invoke the matches() method of the COM object.
	Helpstring: checks to see if the node matches the pattern

		HRESULT __stdcall matches(
			[in]IXMLDOMNode* pNode,
			[out, retval]IXMLDOMNode** ppNode);"

	<virtual stdcall: hresult 18 IXMLDOMNode* IXMLDOMNode**>
	^self invalidCall: _failureCode!

peekNode
	"Answer the <IXMLDOMNode> result of invoking the peekNode() method of the COM object.
	Helpstring: gets the next node without advancing the list position"

	| answer |
	answer := IXMLDOMNode newPointer.
	self PeekNode: answer.
	^answer asObject!

PeekNode: ppNode
	"Private - Invoke the peekNode() method of the COM object.
	Helpstring: gets the next node without advancing the list position

		HRESULT __stdcall peekNode(
			[out, retval]IXMLDOMNode** ppNode);"

	<virtual stdcall: hresult 17 IXMLDOMNode**>
	^self invalidCall: _failureCode!

put_expr: expression
	"Private - Set the value of the 'expr' property of the object wrapped by the 
	 receiver to the <bstr> argument, expression.

		HRESULT __stdcall expr(
			[in]BSTR expression);"

	<virtual stdcall: hresult 14 bstr>
	^self invalidCall: _failureCode!

putref_context: ppNode
	"Private - Set the value of the 'context' property of the object wrapped by the 
	 receiver to the <IXMLDOMNode*> argument, ppNode.

		HRESULT __stdcall context(
			[in]IXMLDOMNode* ppNode);"

	<virtual stdcall: hresult 16 IXMLDOMNode*>
	^self invalidCall: _failureCode!

RemoveAll
	"Invoke the removeAll() method of the COM object.
	Helpstring: removes all the nodes that match the selection

		HRESULT __stdcall removeAll();"

	<virtual stdcall: hresult 20>
	^self invalidCall: _failureCode!

removeNext
	"Answer the <IXMLDOMNode> result of invoking the removeNext() method of the COM object.
	Helpstring: removes the next node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self RemoveNext: answer.
	^answer asObject!

RemoveNext: ppNode
	"Private - Invoke the removeNext() method of the COM object.
	Helpstring: removes the next node

		HRESULT __stdcall removeNext(
			[out, retval]IXMLDOMNode** ppNode);"

	<virtual stdcall: hresult 19 IXMLDOMNode**>
	^self invalidCall: _failureCode!

setContext: ppNode
	"Set the 'context' property of the receiver to the <IXMLDOMNode*> value of the argument.
	Helpstring: nodes to apply selection expression to"

	self putref_context: ppNode!

SetProperty: name value: value
	"Private - Invoke the setProperty() method of the COM object.
	Helpstring: set the value of the named property

		HRESULT __stdcall setProperty(
			[in]BSTR name,
			[in]VARIANT value);"

	<virtual stdcall: hresult 23 bstr variant>
	^self invalidCall: _failureCode!

setProperty_: name value: value
	"Invoke the setProperty() method of the COM object.
	Helpstring: set the value of the named property"

	^self SetProperty: name value: value asVariant! !
!MSXML.IXMLDOMSelection categoriesFor: #clone!**auto generated**!methods!public! !
!MSXML.IXMLDOMSelection categoriesFor: #Clone:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #context!**auto generated**!properties!public! !
!MSXML.IXMLDOMSelection categoriesFor: #expr!**auto generated**!properties!public! !
!MSXML.IXMLDOMSelection categoriesFor: #expr:!**auto generated**!properties!public! !
!MSXML.IXMLDOMSelection categoriesFor: #get_context:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #get_expr:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #GetProperty:value:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #getProperty_:!**auto generated**!methods!public! !
!MSXML.IXMLDOMSelection categoriesFor: #matches:!**auto generated**!methods!public! !
!MSXML.IXMLDOMSelection categoriesFor: #Matches:ppNode:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #peekNode!**auto generated**!methods!public! !
!MSXML.IXMLDOMSelection categoriesFor: #PeekNode:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #put_expr:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #putref_context:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #RemoveAll!**auto generated**!COM Interfaces-IXMLDOMSelection!public! !
!MSXML.IXMLDOMSelection categoriesFor: #removeNext!**auto generated**!methods!public! !
!MSXML.IXMLDOMSelection categoriesFor: #RemoveNext:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #setContext:!**auto generated**!properties!public! !
!MSXML.IXMLDOMSelection categoriesFor: #SetProperty:value:!**auto generated**!COM Interfaces-IXMLDOMSelection!private! !
!MSXML.IXMLDOMSelection categoriesFor: #setProperty_:value:!**auto generated**!methods!public! !

!MSXML.IXMLDOMSelection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMSelection'
		IXMLDOMSelection defineTemplate"

	self
		defineFunction: #get_expr:
			argumentTypes: 'bstr*';
		defineFunction: #put_expr:
			argumentTypes: 'bstr';
		defineFunction: #get_context:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #putref_context:
			argumentTypes: 'IXMLDOMNode*';
		defineFunction: #PeekNode:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #Matches:ppNode:
			argumentTypes: 'IXMLDOMNode* IXMLDOMNode**';
		defineFunction: #RemoveNext:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #RemoveAll;
		defineFunction: #Clone:
			argumentTypes: 'IXMLDOMSelection**';
		defineFunction: #GetProperty:value:
			argumentTypes: 'bstr variant*';
		defineFunction: #SetProperty:value:
			argumentTypes: 'bstr variant'
! !
!MSXML.IXMLDOMSelection class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

