"Filed out from Dolphin Smalltalk"!

ICoreWebView2CompletedHandler subclass: #ICoreWebView2PrintToPdfStreamCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2PrintToPdfStreamCompletedHandler guid: (IID fromString: '{4c9f8229-8f93-444f-a711-2c0dfd6359d5}')!
ICoreWebView2PrintToPdfStreamCompletedHandler comment: '`ICoreWebView2PrintToPdfStreamCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2PrintToPdfStreamCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2PrintToPdfStreamCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PrintToPdfStreamCompletedHandler'
		ICoreWebView2PrintToPdfStreamCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult IStream*'
! !
!ICoreWebView2PrintToPdfStreamCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

