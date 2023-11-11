"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler guid: (OS.COM.IID fromString: '{e9710a06-1d1d-49b2-8234-226f35846ae5}')!
WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler comment: '`ICoreWebView2ClearBrowsingDataCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e9710a06-1d1d-49b2-8234-226f35846ae5)
]
interface ICoreWebView2ClearBrowsingDataCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode);
};
```
'!
!WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler methodsFor!

Invoke: errorCode
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode);"

	<virtual stdcall: hresult 4 hresult>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler categoriesForMethods!
Invoke:!**auto generated**!COM Interfaces-ICoreWebView2ClearBrowsingDataCompletedHandler!public! !
!

!WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler'
		ICoreWebView2ClearBrowsingDataCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke: argumentTypes: 'hresult'! !
!WebView2.ICoreWebView2ClearBrowsingDataCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

