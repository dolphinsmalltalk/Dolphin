"Filed out from Dolphin Smallalk"!

ICoreWebView2EventArgs subclass: #ICoreWebView2NavigationCompletedEventArgs
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2NavigationCompletedEventArgs guid: (IID fromString: '{30d68b7d-20d9-4752-a9ca-ec8448fbb5c1}')!
ICoreWebView2NavigationCompletedEventArgs comment: '`ICoreWebView2NavigationCompletedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationCompletedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(30d68b7d-20d9-4752-a9ca-ec8448fbb5c1)
]
interface ICoreWebView2NavigationCompletedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall IsSuccess(
		[out, retval]long* IsSuccess);
	[id(0x60010001), propget]
	HRESULT __stdcall WebErrorStatus(
		[out, retval]COREWEBVIEW2_WEB_ERROR_STATUS* WebErrorStatus);
	[id(0x60010002), propget]
	HRESULT __stdcall NavigationId(
		[out, retval]unsigned __int64* NavigationId);
};
```
'!
!ICoreWebView2NavigationCompletedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2NavigationCompletedEventArgs methodsFor!

get_IsSuccess: isSuccess
	"Private - Get the value of the 'IsSuccess' property of the receiver.

		HRESULT __stdcall IsSuccess(
			[out, retval]long* IsSuccess);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

get_NavigationId: navigationId
	"Private - Get the value of the 'NavigationId' property of the receiver.

		HRESULT __stdcall NavigationId(
			[out, retval]unsigned __int64* NavigationId);"

	<virtual stdcall: hresult 6 qword*>
	^self invalidCall: _failureCode!

get_WebErrorStatus: webErrorStatus
	"Private - Get the value of the 'WebErrorStatus' property of the receiver.

		HRESULT __stdcall WebErrorStatus(
			[out, retval]COREWEBVIEW2_WEB_ERROR_STATUS* WebErrorStatus);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

isSuccess
	"Answer the <Boolean> value of the 'IsSuccess' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsSuccess: answer.
	^answer asObject!

navigationId
	"Answer the <qword> value of the 'NavigationId' property of the receiver."

	| answer |
	answer := ULARGE_INTEGER new.
	self get_NavigationId: answer.
	^answer asObject!

printableProperties
	^#(#navigationId #isSuccess #webErrorStatus)!

webErrorStatus
	"Answer the <sdword> value of the 'WebErrorStatus' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_WebErrorStatus: answer.
	^answer asObject! !
!ICoreWebView2NavigationCompletedEventArgs categoriesForMethods!
get_IsSuccess:!**auto generated**!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs!private! !
get_NavigationId:!**auto generated**!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs!private! !
get_WebErrorStatus:!**auto generated**!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs!private! !
isSuccess!properties!public! !
navigationId!**auto generated**!properties!public! !
printableProperties!printing!private! !
webErrorStatus!**auto generated**!properties!public! !
!

!ICoreWebView2NavigationCompletedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationCompletedEventArgs'
		ICoreWebView2NavigationCompletedEventArgs defineTemplate"

	self
		defineFunction: #get_IsSuccess:
			argumentTypes: 'sdword*';
		defineFunction: #get_WebErrorStatus:
			argumentTypes: 'sdword*';
		defineFunction: #get_NavigationId:
			argumentTypes: 'qword*'
! !
!ICoreWebView2NavigationCompletedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

