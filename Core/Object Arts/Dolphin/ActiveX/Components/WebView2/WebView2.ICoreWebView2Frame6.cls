"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Frame5
	subclass: #'WebView2.ICoreWebView2Frame6'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Frame6 guid: (OS.COM.IID fromString: '{0de611fd-31e9-5ddc-9d71-95eda26eff32}')!

WebView2.ICoreWebView2Frame6 comment: '`ICoreWebView2Frame6` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Frame6'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0de611fd-31e9-5ddc-9d71-95eda26eff32)
]
interface ICoreWebView2Frame6 : ICoreWebView2Frame5
 {
	[id(0x60060000)]
	HRESULT __stdcall add_ScreenCaptureStarting(
		[in]ICoreWebView2FrameScreenCaptureStartingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60060001)]
	HRESULT __stdcall remove_ScreenCaptureStarting(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2Frame6 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Frame6 methodsFor!

Add_ScreenCaptureStarting: eventHandler token: token
	"Private - Invoke the add_ScreenCaptureStarting() method of the COM object.

		HRESULT __stdcall add_ScreenCaptureStarting(
			[in]ICoreWebView2FrameScreenCaptureStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 29 ICoreWebView2FrameScreenCaptureStartingEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_ScreenCaptureStarting: token
	"Private - Invoke the remove_ScreenCaptureStarting() method of the COM object.

		HRESULT __stdcall remove_ScreenCaptureStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 30 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Frame6 categoriesForMethods!
Add_ScreenCaptureStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame6!private! !
Remove_ScreenCaptureStarting:!**auto generated**!COM Interfaces-ICoreWebView2Frame6!private! !
!

!WebView2.ICoreWebView2Frame6 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame6'
		ICoreWebView2Frame6 defineTemplate"

	self
		defineFunction: #Add_ScreenCaptureStarting:token:
			argumentTypes: 'ICoreWebView2FrameScreenCaptureStartingEventHandler* int64*';
		defineFunction: #Remove_ScreenCaptureStarting:
			argumentTypes: 'int64'
! !

!WebView2.ICoreWebView2Frame6 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

