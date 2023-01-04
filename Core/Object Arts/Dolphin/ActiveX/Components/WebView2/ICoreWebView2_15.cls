"Filed out from Dolphin Smalltalk"!

ICoreWebView2_14 subclass: #ICoreWebView2_15
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2_15 guid: (IID fromString: '{517b2d1d-7dae-4a66-a4f4-10352ffb9518}')!
ICoreWebView2_15 comment: '`ICoreWebView2_15` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_15'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(517b2d1d-7dae-4a66-a4f4-10352ffb9518)
]
interface ICoreWebView2_15 : ICoreWebView2_14
 {
	[id(0x600f0000)]
	HRESULT __stdcall add_FaviconChanged(
		[in]ICoreWebView2FaviconChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x600f0001)]
	HRESULT __stdcall remove_FaviconChanged(
		[in]EventRegistrationToken token);
	[id(0x600f0002), propget]
	HRESULT __stdcall FaviconUri(
		[out, retval]LPWSTR* value);
	[id(0x600f0003)]
	HRESULT __stdcall GetFavicon(
		[in]COREWEBVIEW2_FAVICON_IMAGE_FORMAT format,
		[in]ICoreWebView2GetFaviconCompletedHandler* completedHandler);
};
```
'!
!ICoreWebView2_15 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2_15 methodsFor!

Add_FaviconChanged: eventHandler token: token
	"Private - Invoke the add_FaviconChanged() method of the COM object.

		HRESULT __stdcall add_FaviconChanged(
			[in]ICoreWebView2FaviconChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 110 ICoreWebView2FaviconChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

faviconUri
	"Answer the <lpwstr> value of the 'FaviconUri' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_FaviconUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

get_FaviconUri: value
	"Private - Get the value of the 'FaviconUri' property of the receiver.

		HRESULT __stdcall FaviconUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 112 lpwstr*>
	^self invalidCall: _failureCode!

GetFavicon: format completedHandler: completedHandler
	"Private - Invoke the GetFavicon() method of the COM object.

		HRESULT __stdcall GetFavicon(
			[in]COREWEBVIEW2_FAVICON_IMAGE_FORMAT format,
			[in]ICoreWebView2GetFaviconCompletedHandler* completedHandler);"

	<virtual stdcall: hresult 113 sdword ICoreWebView2GetFaviconCompletedHandler*>
	^self invalidCall: _failureCode!

Remove_FaviconChanged: token
	"Private - Invoke the remove_FaviconChanged() method of the COM object.

		HRESULT __stdcall remove_FaviconChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 111 sqword>
	^self invalidCall: _failureCode! !
!ICoreWebView2_15 categoriesForMethods!
Add_FaviconChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2_15!private! !
faviconUri!properties!public! !
get_FaviconUri:!**auto generated**!COM Interfaces-ICoreWebView2_15!private! !
GetFavicon:completedHandler:!**auto generated**!COM Interfaces-ICoreWebView2_15!private! !
Remove_FaviconChanged:!**auto generated**!COM Interfaces-ICoreWebView2_15!private! !
!

!ICoreWebView2_15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_15'
		ICoreWebView2_15 defineTemplate"

	self
		defineFunction: #Add_FaviconChanged:token:
			argumentTypes: 'ICoreWebView2FaviconChangedEventHandler* sqword*';
		defineFunction: #Remove_FaviconChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_FaviconUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #GetFavicon:completedHandler:
			argumentTypes: 'sdword ICoreWebView2GetFaviconCompletedHandler*'
! !
!ICoreWebView2_15 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

