"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler guid: (OS.COM.IID fromString: '{f45e55aa-3bc2-11ee-be56-0242ac120002}')!
WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler comment: '`ICoreWebView2GetProcessExtendedInfosCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f45e55aa-3bc2-11ee-be56-0242ac120002)
]
interface ICoreWebView2GetProcessExtendedInfosCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]ICoreWebView2ProcessExtendedInfoCollection* value);
};
```
'!
!WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler methodsFor!

Invoke: errorCode arg: value
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]ICoreWebView2ProcessExtendedInfoCollection* value);"

	<virtual stdcall: hresult 4 hresult ICoreWebView2ProcessExtendedInfoCollection*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2GetProcessExtendedInfosCompletedHandler!public! !
!

!WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler'
		ICoreWebView2GetProcessExtendedInfosCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult ICoreWebView2ProcessExtendedInfoCollection*'
! !
!WebView2.ICoreWebView2GetProcessExtendedInfosCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

