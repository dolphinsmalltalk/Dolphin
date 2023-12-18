"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Sequence
	subclass: #'WebView2.ICoreWebView2BrowserExtensionList'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2BrowserExtensionList guid: (OS.COM.IID fromString: '{2ef3d2dc-bd5f-4f4d-90af-fd67798f0c2f}')!
WebView2.ICoreWebView2BrowserExtensionList isEgressOnly: true!
WebView2.ICoreWebView2BrowserExtensionList comment: '`ICoreWebView2BrowserExtensionList` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BrowserExtensionList'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(2ef3d2dc-bd5f-4f4d-90af-fd67798f0c2f)
]
interface ICoreWebView2BrowserExtensionList : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* Count);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]ICoreWebView2BrowserExtension** extension);
};
```
'!
!WebView2.ICoreWebView2BrowserExtensionList categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2BrowserExtensionList methodsFor!

elementClass
	^ICoreWebView2BrowserExtension!

GetValueAtIndex: index value: extension
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2BrowserExtension** extension);"

	<virtual stdcall: hresult 5 uint32 ICoreWebView2BrowserExtension**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2BrowserExtensionList categoriesForMethods!
elementClass!constants!private! !
GetValueAtIndex:value:!COM Interfaces-ICoreWebView2BrowserExtensionList!private! !
!

!WebView2.ICoreWebView2BrowserExtensionList class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BrowserExtensionList'
		ICoreWebView2BrowserExtensionList defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'uint32*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'uint32 ICoreWebView2BrowserExtension**'
! !
!WebView2.ICoreWebView2BrowserExtensionList class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

