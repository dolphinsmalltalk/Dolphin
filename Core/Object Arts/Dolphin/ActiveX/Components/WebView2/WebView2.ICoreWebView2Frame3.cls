"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Frame2 subclass: #'WebView2.ICoreWebView2Frame3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Frame3 guid: (OS.COM.IID fromString: '{b50d82cc-cc28-481d-9614-cb048895e6a0}')!
WebView2.ICoreWebView2Frame3 comment: '`ICoreWebView2Frame3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Frame3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b50d82cc-cc28-481d-9614-cb048895e6a0)
]
interface ICoreWebView2Frame3 : ICoreWebView2Frame2
 {
	[id(0x60030000)]
	HRESULT __stdcall add_PermissionRequested(
		[in]ICoreWebView2FramePermissionRequestedEventHandler* handler,
		[out]EventRegistrationToken* token);
	[id(0x60030001)]
	HRESULT __stdcall remove_PermissionRequested(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2Frame3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Frame3 methodsFor!

Add_PermissionRequested: handler token: token
	"Private - Invoke the add_PermissionRequested() method of the COM object.

		HRESULT __stdcall add_PermissionRequested(
			[in]ICoreWebView2FramePermissionRequestedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 25 ICoreWebView2FramePermissionRequestedEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_PermissionRequested: token
	"Private - Invoke the remove_PermissionRequested() method of the COM object.

		HRESULT __stdcall remove_PermissionRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 26 int64>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Frame3 categoriesForMethods!
Add_PermissionRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame3!private! !
Remove_PermissionRequested:!**auto generated**!COM Interfaces-ICoreWebView2Frame3!private! !
!

!WebView2.ICoreWebView2Frame3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame3'
		ICoreWebView2Frame3 defineTemplate"

	self
		defineFunction: #Add_PermissionRequested:token:
			argumentTypes: 'ICoreWebView2FramePermissionRequestedEventHandler* sqword*';
		defineFunction: #Remove_PermissionRequested:
			argumentTypes: 'sqword'
! !
!WebView2.ICoreWebView2Frame3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

