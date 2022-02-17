"Filed out from Dolphin Smallalk"!

ICoreWebView2_3 subclass: #ICoreWebView2_4
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2_4 guid: (IID fromString: '{20d02d59-6df2-42dc-bd06-f98a694b1302}')!
ICoreWebView2_4 comment: '`ICoreWebView2_4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(20d02d59-6df2-42dc-bd06-f98a694b1302)
]
interface ICoreWebView2_4 : ICoreWebView2_3
 {
	[id(0x60040000)]
	HRESULT __stdcall add_FrameCreated(
		[in]ICoreWebView2FrameCreatedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60040001)]
	HRESULT __stdcall remove_FrameCreated(
		[in]EventRegistrationToken token);
	[id(0x60040002)]
	HRESULT __stdcall add_DownloadStarting(
		[in]ICoreWebView2DownloadStartingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60040003)]
	HRESULT __stdcall remove_DownloadStarting(
		[in]EventRegistrationToken token);
};
```
'!
!ICoreWebView2_4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2_4 methodsFor!

add_DownloadStarting: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_DownloadStarting() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_DownloadStarting: eventHandler token: answer.
	^answer asObject!

Add_DownloadStarting: eventHandler token: token
	"Private - Invoke the add_DownloadStarting() method of the COM object.

		HRESULT __stdcall add_DownloadStarting(
			[in]ICoreWebView2DownloadStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 76 ICoreWebView2DownloadStartingEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_FrameCreated: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_FrameCreated() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_FrameCreated: eventHandler token: answer.
	^answer asObject!

Add_FrameCreated: eventHandler token: token
	"Private - Invoke the add_FrameCreated() method of the COM object.

		HRESULT __stdcall add_FrameCreated(
			[in]ICoreWebView2FrameCreatedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 74 ICoreWebView2FrameCreatedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

remove_DownloadStarting: token
	"Invoke the remove_DownloadStarting() method of the COM object."

	^self Remove_DownloadStarting: token!

Remove_DownloadStarting: token
	"Private - Invoke the remove_DownloadStarting() method of the COM object.

		HRESULT __stdcall remove_DownloadStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 77 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_FrameCreated: token
	"Invoke the remove_FrameCreated() method of the COM object."

	^self Remove_FrameCreated: token!

Remove_FrameCreated: token
	"Private - Invoke the remove_FrameCreated() method of the COM object.

		HRESULT __stdcall remove_FrameCreated(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 75 EventRegistrationToken>
	^self invalidCall: _failureCode! !
!ICoreWebView2_4 categoriesForMethods!
add_DownloadStarting:!**auto generated**!methods!public! !
Add_DownloadStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
add_FrameCreated:!**auto generated**!methods!public! !
Add_FrameCreated:token:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
remove_DownloadStarting:!**auto generated**!methods!public! !
Remove_DownloadStarting:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
remove_FrameCreated:!**auto generated**!methods!public! !
Remove_FrameCreated:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
!

!ICoreWebView2_4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_4'
		ICoreWebView2_4 defineTemplate"

	self
		defineFunction: #Add_FrameCreated:token:
			argumentTypes: 'ICoreWebView2FrameCreatedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_FrameCreated:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_DownloadStarting:token:
			argumentTypes: 'ICoreWebView2DownloadStartingEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_DownloadStarting:
			argumentTypes: 'EventRegistrationToken'
! !
!ICoreWebView2_4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

