"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_7 subclass: #'WebView2.ICoreWebView2_8'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_8 guid: (OS.COM.IID fromString: '{e9632730-6e1e-43ab-b7b8-7b2c9e62e094}')!
WebView2.ICoreWebView2_8 comment: '`ICoreWebView2_8` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_8'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e9632730-6e1e-43ab-b7b8-7b2c9e62e094)
]
interface ICoreWebView2_8 : ICoreWebView2_7
 {
	[id(0x60080000)]
	HRESULT __stdcall add_IsMutedChanged(
		[in]ICoreWebView2IsMutedChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60080001)]
	HRESULT __stdcall remove_IsMutedChanged(
		[in]EventRegistrationToken token);
	[id(0x60080002), propget]
	HRESULT __stdcall IsMuted(
		[out, retval]long* value);
	[id(0x60080002), propput]
	HRESULT __stdcall IsMuted(
		[in]long value);
	[id(0x60080004)]
	HRESULT __stdcall add_IsDocumentPlayingAudioChanged(
		[in]ICoreWebView2IsDocumentPlayingAudioChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60080005)]
	HRESULT __stdcall remove_IsDocumentPlayingAudioChanged(
		[in]EventRegistrationToken token);
	[id(0x60080006), propget]
	HRESULT __stdcall IsDocumentPlayingAudio(
		[out, retval]long* value);
};
```
'!
!WebView2.ICoreWebView2_8 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_8 methodsFor!

Add_IsDocumentPlayingAudioChanged: eventHandler token: token
	"Private - Invoke the add_IsDocumentPlayingAudioChanged() method of the COM object.

		HRESULT __stdcall add_IsDocumentPlayingAudioChanged(
			[in]ICoreWebView2IsDocumentPlayingAudioChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 86 ICoreWebView2IsDocumentPlayingAudioChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_IsMutedChanged: eventHandler token: token
	"Private - Invoke the add_IsMutedChanged() method of the COM object.

		HRESULT __stdcall add_IsMutedChanged(
			[in]ICoreWebView2IsMutedChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 82 ICoreWebView2IsMutedChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

get_IsDocumentPlayingAudio: value
	"Private - Get the value of the 'IsDocumentPlayingAudio' property of the receiver.

		HRESULT __stdcall IsDocumentPlayingAudio(
			[out, retval]long* value);"

	<virtual stdcall: hresult 88 sdword*>
	^self invalidCall: _failureCode!

get_IsMuted: value
	"Private - Get the value of the 'IsMuted' property of the receiver.

		HRESULT __stdcall IsMuted(
			[out, retval]long* value);"

	<virtual stdcall: hresult 84 sdword*>
	^self invalidCall: _failureCode!

put_IsMuted: value
	"Private - Set the value of the 'IsMuted' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsMuted(
			[in]long value);"

	<virtual stdcall: hresult 85 sdword>
	^self invalidCall: _failureCode!

Remove_IsDocumentPlayingAudioChanged: token
	"Private - Invoke the remove_IsDocumentPlayingAudioChanged() method of the COM object.

		HRESULT __stdcall remove_IsDocumentPlayingAudioChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 87 sqword>
	^self invalidCall: _failureCode!

Remove_IsMutedChanged: token
	"Private - Invoke the remove_IsMutedChanged() method of the COM object.

		HRESULT __stdcall remove_IsMutedChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 83 sqword>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_8 categoriesForMethods!
Add_IsDocumentPlayingAudioChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2_8!private! !
Add_IsMutedChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2_8!private! !
get_IsDocumentPlayingAudio:!**auto generated**!COM Interfaces-ICoreWebView2_8!private! !
get_IsMuted:!**auto generated**!COM Interfaces-ICoreWebView2_8!private! !
put_IsMuted:!**auto generated**!COM Interfaces-ICoreWebView2_8!private! !
Remove_IsDocumentPlayingAudioChanged:!**auto generated**!COM Interfaces-ICoreWebView2_8!private! !
Remove_IsMutedChanged:!**auto generated**!COM Interfaces-ICoreWebView2_8!private! !
!

!WebView2.ICoreWebView2_8 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_8'
		ICoreWebView2_8 defineTemplate"

	self
		defineFunction: #Add_IsMutedChanged:token:
			argumentTypes: 'ICoreWebView2IsMutedChangedEventHandler* sqword*';
		defineFunction: #Remove_IsMutedChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_IsMuted:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsMuted:
			argumentTypes: 'sdword';
		defineFunction: #Add_IsDocumentPlayingAudioChanged:token:
			argumentTypes: 'ICoreWebView2IsDocumentPlayingAudioChangedEventHandler* sqword*';
		defineFunction: #Remove_IsDocumentPlayingAudioChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_IsDocumentPlayingAudio:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2_8 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

