﻿"Filed out from Dolphin Smalltalk"!

WebView2.AbstractICoreWebView2WebResourceResponse
	subclass: #'WebView2.ICoreWebView2WebResourceResponse'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2WebResourceResponse guid: (OS.COM.IID fromString: '{aafcc94f-fa27-48fd-97df-830ef75aaec9}')!

WebView2.ICoreWebView2WebResourceResponse isEgressOnly: true!

WebView2.ICoreWebView2WebResourceResponse comment: '`ICoreWebView2WebResourceResponse` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponse'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(aafcc94f-fa27-48fd-97df-830ef75aaec9)
]
interface ICoreWebView2WebResourceResponse : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Content(
		[out, retval]IStream** Content);
	[id(0x60010000), propput]
	HRESULT __stdcall Content(
		[in]IStream* Content);
	[id(0x60010002), propget]
	HRESULT __stdcall Headers(
		[out, retval]ICoreWebView2HttpResponseHeaders** Headers);
	[id(0x60010003), propget]
	HRESULT __stdcall StatusCode(
		[out, retval]int* StatusCode);
	[id(0x60010003), propput]
	HRESULT __stdcall StatusCode(
		[in]int StatusCode);
	[id(0x60010005), propget]
	HRESULT __stdcall ReasonPhrase(
		[out, retval]LPWSTR* ReasonPhrase);
	[id(0x60010005), propput]
	HRESULT __stdcall ReasonPhrase(
		[in]LPWSTR ReasonPhrase);
};
```
'!

!WebView2.ICoreWebView2WebResourceResponse categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2WebResourceResponse methodsFor!

content
	"Answer the <IStream> value of the 'Content' property of the receiver."

	| answer |
	answer := IStream newPointer.
	self get_Content: answer.
	^answer asObject!

content: content
	"Set the 'Content' property of the receiver to the <IStream*> value of the argument."

	self put_Content: (content queryInterface: IStream)!

get_Content: content
	"Private - Get the value of the 'Content' property of the receiver.

		HRESULT __stdcall Content(
			[out, retval]IStream** Content);"

	<virtual stdcall: hresult 4 IStream**>
	^self invalidCall: _failureCode!

get_Headers: headers
	"Private - Get the value of the 'Headers' property of the receiver.

		HRESULT __stdcall Headers(
			[out, retval]ICoreWebView2HttpResponseHeaders** Headers);"

	<virtual stdcall: hresult 6 ICoreWebView2HttpResponseHeaders**>
	^self invalidCall: _failureCode!

get_ReasonPhrase: reasonPhrase
	"Private - Get the value of the 'ReasonPhrase' property of the receiver.

		HRESULT __stdcall ReasonPhrase(
			[out, retval]LPWSTR* ReasonPhrase);"

	<virtual stdcall: hresult 9 lpwstr*>
	^self invalidCall: _failureCode!

get_StatusCode: statusCode
	"Private - Get the value of the 'StatusCode' property of the receiver.

		HRESULT __stdcall StatusCode(
			[out, retval]int* StatusCode);"

	<virtual stdcall: hresult 7 int32*>
	^self invalidCall: _failureCode!

put_Content: content
	"Private - Set the value of the 'Content' property of the object wrapped by the 
	 receiver to the <IStream*> argument, content.

		HRESULT __stdcall Content(
			[in]IStream* Content);"

	<virtual stdcall: hresult 5 IStream*>
	^self invalidCall: _failureCode!

put_ReasonPhrase: reasonPhrase
	"Private - Set the value of the 'ReasonPhrase' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, reasonPhrase.

		HRESULT __stdcall ReasonPhrase(
			[in]LPWSTR ReasonPhrase);"

	<virtual stdcall: hresult 10 lpwstr>
	^self invalidCall: _failureCode!

put_StatusCode: statusCode
	"Private - Set the value of the 'StatusCode' property of the object wrapped by the 
	 receiver to the <sdword> argument, statusCode.

		HRESULT __stdcall StatusCode(
			[in]int StatusCode);"

	<virtual stdcall: hresult 8 int32>
	^self invalidCall: _failureCode!

reasonPhrase: reasonPhrase
	"Set the 'ReasonPhrase' property of the receiver to the <lpwstr> value of the argument."

	self put_ReasonPhrase: reasonPhrase asUtf16String!

statusCode: statusCode
	"Set the 'StatusCode' property of the receiver to the <integer> value of the argument."

	self put_StatusCode: statusCode! !

!WebView2.ICoreWebView2WebResourceResponse categoriesForMethods!
content!**auto generated**!properties!public! !
content:!**auto generated**!properties!public! !
get_Content:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
get_Headers:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
get_ReasonPhrase:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
get_StatusCode:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
put_Content:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
put_ReasonPhrase:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
put_StatusCode:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
reasonPhrase:!**auto generated**!properties!public! !
statusCode:!properties!public! !
!

!WebView2.ICoreWebView2WebResourceResponse class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponse'
		ICoreWebView2WebResourceResponse defineTemplate"

	self
		defineFunction: #get_Content:
			argumentTypes: 'IStream**';
		defineFunction: #put_Content:
			argumentTypes: 'IStream*';
		defineFunction: #get_Headers:
			argumentTypes: 'ICoreWebView2HttpResponseHeaders**';
		defineFunction: #get_StatusCode:
			argumentTypes: 'sdword*';
		defineFunction: #put_StatusCode:
			argumentTypes: 'sdword';
		defineFunction: #get_ReasonPhrase:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_ReasonPhrase:
			argumentTypes: 'lpwstr'
! !

!WebView2.ICoreWebView2WebResourceResponse class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

