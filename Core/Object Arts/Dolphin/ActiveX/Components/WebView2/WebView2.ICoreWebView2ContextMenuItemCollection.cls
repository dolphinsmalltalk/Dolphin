"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Sequence
	subclass: #'WebView2.ICoreWebView2ContextMenuItemCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ContextMenuItemCollection guid: (OS.COM.IID fromString: '{f562a2f5-c415-45cf-b909-d4b7c1e276d3}')!
WebView2.ICoreWebView2ContextMenuItemCollection comment: '`ICoreWebView2ContextMenuItemCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContextMenuItemCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f562a2f5-c415-45cf-b909-d4b7c1e276d3)
]
interface ICoreWebView2ContextMenuItemCollection : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* value);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]ICoreWebView2ContextMenuItem** value);
	[id(0x60010002)]
	HRESULT __stdcall RemoveValueAtIndex(
		[in]unsigned int index);
	[id(0x60010003)]
	HRESULT __stdcall InsertValueAtIndex(
		[in]unsigned int index,
		[in]ICoreWebView2ContextMenuItem* value);
};
```
'!
!WebView2.ICoreWebView2ContextMenuItemCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ContextMenuItemCollection methodsFor!

add: anICoreWebView2ContextMenuItem beforeIndex: anInteger
	self InsertValueAtIndex: anInteger - 1 value: anICoreWebView2ContextMenuItem.
	^anICoreWebView2ContextMenuItem!

elementClass
	^ICoreWebView2ContextMenuItem!

GetValueAtIndex: index value: value
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2ContextMenuItem** value);"

	<virtual stdcall: hresult 5 uint32 ICoreWebView2ContextMenuItem**>
	^self invalidCall: _failureCode!

InsertValueAtIndex: index value: value
	"Private - Invoke the InsertValueAtIndex() method of the COM object.

		HRESULT __stdcall InsertValueAtIndex(
			[in]unsigned int index,
			[in]ICoreWebView2ContextMenuItem* value);"

	<virtual stdcall: hresult 7 uint32 ICoreWebView2ContextMenuItem*>
	^self invalidCall: _failureCode!

removeAtIndex: anInteger
	"Remove, and answer, the element of the receiver at the specified <integer> index, by shuffling elements which succeed it down one slot.
	Raise a <BoundsError> if there is no element with that index."

	| item |
	item := self at: anInteger.
	self RemoveValueAtIndex: anInteger - 1.
	^item!

RemoveValueAtIndex: index
	"Private - Invoke the RemoveValueAtIndex() method of the COM object.

		HRESULT __stdcall RemoveValueAtIndex(
			[in]unsigned int index);"

	<virtual stdcall: hresult 6 uint32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ContextMenuItemCollection categoriesForMethods!
add:beforeIndex:!**auto generated**!methods!public! !
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItemCollection!private! !
InsertValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItemCollection!private! !
removeAtIndex:!public!removing! !
RemoveValueAtIndex:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItemCollection!private! !
!

!WebView2.ICoreWebView2ContextMenuItemCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContextMenuItemCollection'
		ICoreWebView2ContextMenuItemCollection defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'dword*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'dword ICoreWebView2ContextMenuItem**';
		defineFunction: #RemoveValueAtIndex:
			argumentTypes: 'dword';
		defineFunction: #InsertValueAtIndex:value:
			argumentTypes: 'dword ICoreWebView2ContextMenuItem*'
! !
!WebView2.ICoreWebView2ContextMenuItemCollection class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

