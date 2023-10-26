﻿"Filed out from Dolphin Smalltalk"!

ICoreWebView2_3 subclass: #ICoreWebView2_4
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
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

Add_DownloadStarting: eventHandler token: token
	"Private - Invoke the add_DownloadStarting() method of the COM object.

		HRESULT __stdcall add_DownloadStarting(
			[in]ICoreWebView2DownloadStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 76 ICoreWebView2DownloadStartingEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_FrameCreated: eventHandler token: token
	"Not supported by this version"

	^E_NOTIMPL!

Remove_DownloadStarting: token
	"Private - Invoke the remove_DownloadStarting() method of the COM object.

		HRESULT __stdcall remove_DownloadStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 77 sqword>
	^self invalidCall: _failureCode!

Remove_FrameCreated: token
	"Private - Invoke the remove_FrameCreated() method of the COM object.

		HRESULT __stdcall remove_FrameCreated(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 75 sqword>
	^self invalidCall: _failureCode! !
!ICoreWebView2_4 categoriesForMethods!
Add_DownloadStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
Add_FrameCreated:token:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
Remove_DownloadStarting:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
Remove_FrameCreated:!**auto generated**!COM Interfaces-ICoreWebView2_4!private! !
!

!ICoreWebView2_4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_4'
		ICoreWebView2_4 defineTemplate"

	self
		defineFunction: #Add_FrameCreated:token:
			argumentTypes: 'ICoreWebView2FrameCreatedEventHandler* sqword*';
		defineFunction: #Remove_FrameCreated:
			argumentTypes: 'sqword';
		defineFunction: #Add_DownloadStarting:token:
			argumentTypes: 'ICoreWebView2DownloadStartingEventHandler* sqword*';
		defineFunction: #Remove_DownloadStarting:
			argumentTypes: 'sqword'
! !
!ICoreWebView2_4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!
