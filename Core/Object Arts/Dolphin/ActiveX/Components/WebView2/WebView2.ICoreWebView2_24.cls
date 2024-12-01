"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_23
	subclass: #'WebView2.ICoreWebView2_24'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_24 guid: (OS.COM.IID fromString: '{39a7ad55-4287-5cc1-88a1-c6f458593824}')!

WebView2.ICoreWebView2_24 comment: '`ICoreWebView2_24` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_24'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(39a7ad55-4287-5cc1-88a1-c6f458593824)
]
interface ICoreWebView2_24 : ICoreWebView2_23
 {
	[id(0x60180000)]
	HRESULT __stdcall add_NotificationReceived(
		[in]ICoreWebView2NotificationReceivedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60180001)]
	HRESULT __stdcall remove_NotificationReceived(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2_24 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_24 methodsFor!

Add_NotificationReceived: eventHandler token: token
	"Private - Invoke the add_NotificationReceived() method of the COM object.

		HRESULT __stdcall add_NotificationReceived(
			[in]ICoreWebView2NotificationReceivedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 127 ICoreWebView2NotificationReceivedEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_NotificationReceived: token
	"Private - Invoke the remove_NotificationReceived() method of the COM object.

		HRESULT __stdcall remove_NotificationReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 128 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_24 categoriesForMethods!
Add_NotificationReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2_24!private! !
Remove_NotificationReceived:!**auto generated**!COM Interfaces-ICoreWebView2_24!private! !
!

!WebView2.ICoreWebView2_24 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_24'
		ICoreWebView2_24 defineTemplate"

	self
		defineFunction: #Add_NotificationReceived:token:
			argumentTypes: 'ICoreWebView2NotificationReceivedEventHandler* int64*';
		defineFunction: #Remove_NotificationReceived:
			argumentTypes: 'int64'
! !

!WebView2.ICoreWebView2_24 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

