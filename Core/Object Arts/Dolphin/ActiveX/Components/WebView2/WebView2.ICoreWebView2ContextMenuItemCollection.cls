"Filed out from Dolphin Smalltalk"!

ICoreWebView2Sequence subclass: #ICoreWebView2ContextMenuItemCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2ContextMenuItemCollection guid: (IID fromString: '{f562a2f5-c415-45cf-b909-d4b7c1e276d3}')!
ICoreWebView2ContextMenuItemCollection comment: '`ICoreWebView2ContextMenuItemCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContextMenuItemCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2ContextMenuItemCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ContextMenuItemCollection methodsFor!

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

	<virtual stdcall: hresult 5 dword ICoreWebView2ContextMenuItem**>
	^self invalidCall: _failureCode!

InsertValueAtIndex: index value: value
	"Private - Invoke the InsertValueAtIndex() method of the COM object.

		HRESULT __stdcall InsertValueAtIndex(
			[in]unsigned int index,
			[in]ICoreWebView2ContextMenuItem* value);"

	<virtual stdcall: hresult 7 dword ICoreWebView2ContextMenuItem*>
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

	<virtual stdcall: hresult 6 dword>
	^self invalidCall: _failureCode! !
!ICoreWebView2ContextMenuItemCollection categoriesForMethods!
add:beforeIndex:!**auto generated**!methods!public! !
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItemCollection!private! !
InsertValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItemCollection!private! !
removeAtIndex:!public!removing! !
RemoveValueAtIndex:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItemCollection!private! !
!

!ICoreWebView2ContextMenuItemCollection class methodsFor!

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
!ICoreWebView2ContextMenuItemCollection class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

