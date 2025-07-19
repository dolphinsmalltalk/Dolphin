"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Frame6
	subclass: #'WebView2.ICoreWebView2Frame7'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Frame7 guid: (OS.COM.IID fromString: '{3598cfa2-d85d-5a9f-9228-4dde1f59ec64}')!

WebView2.ICoreWebView2Frame7 comment: '`ICoreWebView2Frame7` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Frame7'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3598cfa2-d85d-5a9f-9228-4dde1f59ec64)
]
interface ICoreWebView2Frame7 : ICoreWebView2Frame6
 {
	[id(0x60070000)]
	HRESULT __stdcall add_FrameCreated(
		[in]ICoreWebView2FrameChildFrameCreatedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60070001)]
	HRESULT __stdcall remove_FrameCreated(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2Frame7 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Frame7 methodsFor!

Add_FrameCreated: eventHandler token: token
	"Private - Invoke the add_FrameCreated() method of the COM object.

		HRESULT __stdcall add_FrameCreated(
			[in]ICoreWebView2FrameChildFrameCreatedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 31 ICoreWebView2FrameChildFrameCreatedEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_FrameCreated: token
	"Private - Invoke the remove_FrameCreated() method of the COM object.

		HRESULT __stdcall remove_FrameCreated(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 32 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Frame7 categoriesForMethods!
Add_FrameCreated:token:!COM Interfaces-ICoreWebView2Frame7!private! !
Remove_FrameCreated:!COM Interfaces-ICoreWebView2Frame7!private! !
!

!WebView2.ICoreWebView2Frame7 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame7'
		ICoreWebView2Frame7 defineTemplate"

	self
		defineFunction: #Add_FrameCreated:token:
			argumentTypes: 'ICoreWebView2FrameChildFrameCreatedEventHandler* int64*';
		defineFunction: #Remove_FrameCreated:
			argumentTypes: 'int64'
! !

!WebView2.ICoreWebView2Frame7 class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

