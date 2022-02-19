"Filed out from Dolphin Smallalk"!

ICoreWebView2Interface subclass: #ICoreWebView2EnvironmentInterop
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2EnvironmentInterop guid: (IID fromString: '{ee503a63-c1e2-4fbf-8a4d-824e95f8bb13}')!
ICoreWebView2EnvironmentInterop comment: '`ICoreWebView2EnvironmentInterop` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentInterop'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ee503a63-c1e2-4fbf-8a4d-824e95f8bb13)
]
interface ICoreWebView2EnvironmentInterop : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetProviderForHwnd(
		[in]wireHWND hwnd,
		[out, retval]IUnknown** provider);
};
```
'!
!ICoreWebView2EnvironmentInterop categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2EnvironmentInterop methodsFor!

getProviderForHwnd: hwnd
	"Answer the <IUnknown> result of invoking the GetProviderForHwnd() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self GetProviderForHwnd: hwnd provider: answer.
	^answer asObject!

GetProviderForHwnd: hwnd provider: provider
	"Private - Invoke the GetProviderForHwnd() method of the COM object.

		HRESULT __stdcall GetProviderForHwnd(
			[in]wireHWND hwnd,
			[out, retval]IUnknown** provider);"

	<virtual stdcall: hresult 4 handle IUnknown**>
	^self invalidCall: _failureCode! !
!ICoreWebView2EnvironmentInterop categoriesForMethods!
getProviderForHwnd:!**auto generated**!methods!public! !
GetProviderForHwnd:provider:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentInterop!private! !
!

!ICoreWebView2EnvironmentInterop class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentInterop'
		ICoreWebView2EnvironmentInterop defineTemplate"

	self
		defineFunction: #GetProviderForHwnd:provider:
			argumentTypes: 'handle IUnknown**'
! !
!ICoreWebView2EnvironmentInterop class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

