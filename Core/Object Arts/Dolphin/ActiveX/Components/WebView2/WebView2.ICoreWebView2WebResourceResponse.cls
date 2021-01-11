"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2WebResourceResponse'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WebResourceResponse guid: (OS.COM.IID fromString: '{aafcc94f-fa27-48fd-97df-830ef75aaec9}')!
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

	self put_Content: content!

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

	<virtual stdcall: hresult 7 sdword*>
	^self invalidCall: _failureCode!

headers
	"Answer the <ICoreWebView2HttpResponseHeaders> value of the 'Headers' property of the receiver."

	| answer |
	answer := ICoreWebView2HttpResponseHeaders newPointer.
	self get_Headers: answer.
	^answer asObject!

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

	<virtual stdcall: hresult 8 sdword>
	^self invalidCall: _failureCode!

reasonPhrase
	"Answer the <lpwstr> value of the 'ReasonPhrase' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_ReasonPhrase: answer.
	^answer asObject!

reasonPhrase: reasonPhrase
	"Set the 'ReasonPhrase' property of the receiver to the <lpwstr> value of the argument."

	self put_ReasonPhrase: reasonPhrase asUtf16String!

statusCode
	"Answer the <sdword> value of the 'StatusCode' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_StatusCode: answer.
	^answer asObject!

statusCode: statusCode
	"Set the 'StatusCode' property of the receiver to the <sdword> value of the argument."

	self put_StatusCode: statusCode! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #content!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #content:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #get_Content:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #get_Headers:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #get_ReasonPhrase:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #get_StatusCode:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #headers!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #put_Content:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #put_ReasonPhrase:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #put_StatusCode:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #reasonPhrase!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #reasonPhrase:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #statusCode!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceResponse categoriesFor: #statusCode:!**auto generated**!properties!public! !

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
!WebView2.ICoreWebView2WebResourceResponse class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

