"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_26
	subclass: #'WebView2.ICoreWebView2_27'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_27 guid: (OS.COM.IID fromString: '{00fbe33b-8c07-517c-aa23-0ddd4b5f6fa0}')!

WebView2.ICoreWebView2_27 comment: '`ICoreWebView2_27` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_27'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00fbe33b-8c07-517c-aa23-0ddd4b5f6fa0)
]
interface ICoreWebView2_27 : ICoreWebView2_26
 {
	[id(0x601b0000)]
	HRESULT __stdcall add_ScreenCaptureStarting(
		[in]ICoreWebView2ScreenCaptureStartingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x601b0001)]
	HRESULT __stdcall remove_ScreenCaptureStarting(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2_27 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_27 methodsFor!

Add_ScreenCaptureStarting: eventHandler token: token
	"Private - Invoke the add_ScreenCaptureStarting() method of the COM object.

		HRESULT __stdcall add_ScreenCaptureStarting(
			[in]ICoreWebView2ScreenCaptureStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 134 ICoreWebView2ScreenCaptureStartingEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_ScreenCaptureStarting: token
	"Private - Invoke the remove_ScreenCaptureStarting() method of the COM object.

		HRESULT __stdcall remove_ScreenCaptureStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 135 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_27 categoriesForMethods!
Add_ScreenCaptureStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2_27!private! !
Remove_ScreenCaptureStarting:!**auto generated**!COM Interfaces-ICoreWebView2_27!private! !
!

!WebView2.ICoreWebView2_27 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_27'
		ICoreWebView2_27 defineTemplate"

	self
		defineFunction: #Add_ScreenCaptureStarting:token:
			argumentTypes: 'ICoreWebView2ScreenCaptureStartingEventHandler* int64*';
		defineFunction: #Remove_ScreenCaptureStarting:
			argumentTypes: 'int64'
! !

!WebView2.ICoreWebView2_27 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

