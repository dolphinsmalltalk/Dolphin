"Filed out from Dolphin Smallalk"!

ICoreWebView2Environment3 subclass: #ICoreWebView2Environment4
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2Environment4 guid: (IID fromString: '{20944379-6dcf-41d6-a0a0-abc0fc50de0d}')!
ICoreWebView2Environment4 comment: '`ICoreWebView2Environment4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(20944379-6dcf-41d6-a0a0-abc0fc50de0d)
]
interface ICoreWebView2Environment4 : ICoreWebView2Environment3
 {
	[id(0x60040000)]
	HRESULT __stdcall GetProviderForHwnd(
		[in]wireHWND hwnd,
		[out, retval]IUnknown** provider);
};
```
'!
!ICoreWebView2Environment4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Environment4 methodsFor!

GetProviderForHwnd: hwnd provider: provider
	"Private - Invoke the GetProviderForHwnd() method of the COM object.

		HRESULT __stdcall GetProviderForHwnd(
			[in]wireHWND hwnd,
			[out, retval]IUnknown** provider);"

	<virtual stdcall: hresult 12 handle IUnknown**>
	^self invalidCall: _failureCode! !
!ICoreWebView2Environment4 categoriesForMethods!
GetProviderForHwnd:provider:!**auto generated**!COM Interfaces-ICoreWebView2Environment4!private! !
!

!ICoreWebView2Environment4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment4'
		ICoreWebView2Environment4 defineTemplate"

	self
		defineFunction: #GetProviderForHwnd:provider:
			argumentTypes: 'handle IUnknown**'
! !
!ICoreWebView2Environment4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

