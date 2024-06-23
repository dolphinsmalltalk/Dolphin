"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler guid: (OS.COM.IID fromString: '{4c9f8229-8f93-444f-a711-2c0dfd6359d5}')!

WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler comment: '`ICoreWebView2PrintToPdfStreamCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4c9f8229-8f93-444f-a711-2c0dfd6359d5)
]
interface ICoreWebView2PrintToPdfStreamCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]IStream* pdfStream);
};
```
'!

!WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2PrintToPdfStreamCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2PrintToPdfStreamCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult OS.COM.IStream*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2PrintToPdfStreamCompletedHandler!public! !
!

!WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler'
		ICoreWebView2PrintToPdfStreamCompletedHandler compileFunctions
	"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult IStream*'
! !

!WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

