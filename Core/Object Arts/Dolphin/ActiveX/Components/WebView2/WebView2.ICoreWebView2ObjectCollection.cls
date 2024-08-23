"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ObjectCollectionView
	subclass: #'WebView2.ICoreWebView2ObjectCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ObjectCollection guid: (OS.COM.IID fromString: '{5cfec11c-25bd-4e8d-9e1a-7acdaeeec047}')!

WebView2.ICoreWebView2ObjectCollection comment: '`ICoreWebView2ObjectCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ObjectCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5cfec11c-25bd-4e8d-9e1a-7acdaeeec047)
]
interface ICoreWebView2ObjectCollection : ICoreWebView2ObjectCollectionView
 {
	[id(0x60020000)]
	HRESULT __stdcall RemoveValueAtIndex(
		[in]unsigned int index);
	[id(0x60020001)]
	HRESULT __stdcall InsertValueAtIndex(
		[in]unsigned int index,
		[in]IUnknown* value);
};
```
'!

!WebView2.ICoreWebView2ObjectCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ObjectCollection methodsFor!

InsertValueAtIndex: index value: value
	"Private - Invoke the InsertValueAtIndex() method of the COM object.

		HRESULT __stdcall InsertValueAtIndex(
			[in]unsigned int index,
			[in]IUnknown* value);"

	<virtual stdcall: hresult 7 uint32 IUnknown*>
	^self invalidCall: _failureCode!

RemoveValueAtIndex: index
	"Private - Invoke the RemoveValueAtIndex() method of the COM object.

		HRESULT __stdcall RemoveValueAtIndex(
			[in]unsigned int index);"

	<virtual stdcall: hresult 6 uint32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ObjectCollection categoriesForMethods!
InsertValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ObjectCollection!private! !
RemoveValueAtIndex:!**auto generated**!COM Interfaces-ICoreWebView2ObjectCollection!private! !
!

!WebView2.ICoreWebView2ObjectCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ObjectCollection'
		ICoreWebView2ObjectCollection defineTemplate"

	self
		defineFunction: #RemoveValueAtIndex:
			argumentTypes: 'uint32';
		defineFunction: #InsertValueAtIndex:value:
			argumentTypes: 'uint32 IUnknown*'
! !

!WebView2.ICoreWebView2ObjectCollection class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

