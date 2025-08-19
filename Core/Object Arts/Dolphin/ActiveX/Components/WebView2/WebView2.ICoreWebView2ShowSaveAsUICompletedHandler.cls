"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2ShowSaveAsUICompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ShowSaveAsUICompletedHandler guid: (OS.COM.IID fromString: '{e24b07e3-8169-5c34-994a-7f6478946a3c}')!

WebView2.ICoreWebView2ShowSaveAsUICompletedHandler comment: '`ICoreWebView2ShowSaveAsUICompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ShowSaveAsUICompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e24b07e3-8169-5c34-994a-7f6478946a3c)
]
interface ICoreWebView2ShowSaveAsUICompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]COREWEBVIEW2_SAVE_AS_UI_RESULT result);
};
```
'!

!WebView2.ICoreWebView2ShowSaveAsUICompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ShowSaveAsUICompletedHandler methodsFor!

Invoke: errorCode arg: result
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]COREWEBVIEW2_SAVE_AS_UI_RESULT result);"

	<virtual stdcall: hresult 4 hresult int32>
	^self invalidCall: _failureCode!

notImplemented
	^self Invoke: E_NOTIMPL arg: COREWEBVIEW2_SAVE_AS_UI_RESULT_CANCELLED! !

!WebView2.ICoreWebView2ShowSaveAsUICompletedHandler categoriesForMethods!
Invoke:arg:!**auto generated**!COM Interfaces-ICoreWebView2ShowSaveAsUICompletedHandler!public! !
notImplemented!exceptions!public! !
!

!WebView2.ICoreWebView2ShowSaveAsUICompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ShowSaveAsUICompletedHandler'
		ICoreWebView2ShowSaveAsUICompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult int32'
! !

!WebView2.ICoreWebView2ShowSaveAsUICompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

