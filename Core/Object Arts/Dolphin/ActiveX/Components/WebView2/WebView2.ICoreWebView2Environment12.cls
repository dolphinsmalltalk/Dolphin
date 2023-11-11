"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment11
	subclass: #'WebView2.ICoreWebView2Environment12'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Environment12 guid: (OS.COM.IID fromString: '{f503db9b-739f-48dd-b151-fdfcf253f54e}')!
WebView2.ICoreWebView2Environment12 isEgressOnly: true!
WebView2.ICoreWebView2Environment12 comment: '`ICoreWebView2Environment12` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment12'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f503db9b-739f-48dd-b151-fdfcf253f54e)
]
interface ICoreWebView2Environment12 : ICoreWebView2Environment11
 {
	[id(0x600c0000)]
	HRESULT __stdcall CreateSharedBuffer(
		[in]unsigned __int64 Size,
		[out, retval]ICoreWebView2SharedBuffer** shared_buffer);
};
```
'!
!WebView2.ICoreWebView2Environment12 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Environment12 methodsFor!

CreateSharedBuffer: size shared_buffer: shared_buffer
	"Private - Invoke the CreateSharedBuffer() method of the COM object.

		HRESULT __stdcall CreateSharedBuffer(
			[in]unsigned __int64 Size,
			[out, retval]ICoreWebView2SharedBuffer** shared_buffer);"

	<virtual stdcall: hresult 25 uint64 ICoreWebView2SharedBuffer**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Environment12 categoriesForMethods!
CreateSharedBuffer:shared_buffer:!**auto generated**!COM Interfaces-ICoreWebView2Environment12!private! !
!

!WebView2.ICoreWebView2Environment12 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment12'
		ICoreWebView2Environment12 defineTemplate"

	self
		defineFunction: #CreateSharedBuffer:shared_buffer:
			argumentTypes: 'uint64 ICoreWebView2SharedBuffer**'
! !
!WebView2.ICoreWebView2Environment12 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

