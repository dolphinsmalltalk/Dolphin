"Filed out from Dolphin Smalltalk"!

ICoreWebView2Environment9 subclass: #ICoreWebView2Environment10
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2Environment10 guid: (IID fromString: '{ee0eb9df-6f12-46ce-b53f-3f47b9c928e0}')!
ICoreWebView2Environment10 comment: '`ICoreWebView2Environment10` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment10'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ee0eb9df-6f12-46ce-b53f-3f47b9c928e0)
]
interface ICoreWebView2Environment10 : ICoreWebView2Environment9
 {
	[id(0x600a0000)]
	HRESULT __stdcall CreateCoreWebView2ControllerOptions(
		[out, retval]ICoreWebView2ControllerOptions** options);
	[id(0x600a0001)]
	HRESULT __stdcall CreateCoreWebView2ControllerWithOptions(
		[in]wireHWND ParentWindow,
		[in]ICoreWebView2ControllerOptions* options,
		[in]ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* handler);
	[id(0x600a0002)]
	HRESULT __stdcall CreateCoreWebView2CompositionControllerWithOptions(
		[in]wireHWND ParentWindow,
		[in]ICoreWebView2ControllerOptions* options,
		[in]ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler* handler);
};
```
'!
!ICoreWebView2Environment10 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Environment10 methodsFor!

CreateCoreWebView2CompositionControllerWithOptions: parentWindow options: options handler: handler
	"Private - Invoke the CreateCoreWebView2CompositionControllerWithOptions() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2CompositionControllerWithOptions(
			[in]wireHWND ParentWindow,
			[in]ICoreWebView2ControllerOptions* options,
			[in]ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler* handler);"

	<virtual stdcall: hresult 23 handle ICoreWebView2ControllerOptions* ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler*>
	^self invalidCall: _failureCode!

CreateCoreWebView2ControllerOptions: options
	"Private - Invoke the CreateCoreWebView2ControllerOptions() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2ControllerOptions(
			[out, retval]ICoreWebView2ControllerOptions** options);"

	<virtual stdcall: hresult 21 ICoreWebView2ControllerOptions**>
	^self invalidCall: _failureCode!

CreateCoreWebView2ControllerWithOptions: parentWindow options: options handler: handler
	"Private - Invoke the CreateCoreWebView2ControllerWithOptions() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2ControllerWithOptions(
			[in]wireHWND ParentWindow,
			[in]ICoreWebView2ControllerOptions* options,
			[in]ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* handler);"

	<virtual stdcall: hresult 22 handle ICoreWebView2ControllerOptions* ICoreWebView2CreateCoreWebView2ControllerCompletedHandler*>
	^self invalidCall: _failureCode! !
!ICoreWebView2Environment10 categoriesForMethods!
CreateCoreWebView2CompositionControllerWithOptions:options:handler:!**auto generated**!COM Interfaces-ICoreWebView2Environment10!private! !
CreateCoreWebView2ControllerOptions:!**auto generated**!COM Interfaces-ICoreWebView2Environment10!private! !
CreateCoreWebView2ControllerWithOptions:options:handler:!**auto generated**!COM Interfaces-ICoreWebView2Environment10!private! !
!

!ICoreWebView2Environment10 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment10'
		ICoreWebView2Environment10 defineTemplate"

	self
		defineFunction: #CreateCoreWebView2ControllerOptions:
			argumentTypes: 'ICoreWebView2ControllerOptions**';
		defineFunction: #CreateCoreWebView2ControllerWithOptions:options:handler:
			argumentTypes: 'handle ICoreWebView2ControllerOptions* ICoreWebView2CreateCoreWebView2ControllerCompletedHandler*';
		defineFunction: #CreateCoreWebView2CompositionControllerWithOptions:options:handler:
			argumentTypes: 'handle ICoreWebView2ControllerOptions* ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler*'
! !
!ICoreWebView2Environment10 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

