"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2FindStartCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FindStartCompletedHandler guid: (OS.COM.IID fromString: '{6a90ecaf-44b0-5bd9-8f07-1967e17be9fb}')!

WebView2.ICoreWebView2FindStartCompletedHandler comment: '`ICoreWebView2FindStartCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FindStartCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(6a90ecaf-44b0-5bd9-8f07-1967e17be9fb)
]
interface ICoreWebView2FindStartCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode);
};
```
'!

!WebView2.ICoreWebView2FindStartCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FindStartCompletedHandler methodsFor!

Invoke: errorCode
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode);"

	<virtual stdcall: hresult 4 hresult>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FindStartCompletedHandler categoriesForMethods!
Invoke:!**auto generated**!COM Interfaces-ICoreWebView2FindStartCompletedHandler!public! !
!

!WebView2.ICoreWebView2FindStartCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FindStartCompletedHandler'
		ICoreWebView2FindStartCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:
			argumentTypes: 'hresult'
! !

!WebView2.ICoreWebView2FindStartCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

