"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2WebResourceRequest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WebResourceRequest guid: (OS.COM.IID fromString: '{97055cd4-512c-4264-8b5f-e3f446cea6a5}')!
WebView2.ICoreWebView2WebResourceRequest comment: '`ICoreWebView2WebResourceRequest` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceRequest'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(97055cd4-512c-4264-8b5f-e3f446cea6a5)
]
interface ICoreWebView2WebResourceRequest : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* uri);
	[id(0x60010000), propput]
	HRESULT __stdcall uri(
		[in]LPWSTR uri);
	[id(0x60010002), propget]
	HRESULT __stdcall Method(
		[out, retval]LPWSTR* Method);
	[id(0x60010002), propput]
	HRESULT __stdcall Method(
		[in]LPWSTR Method);
	[id(0x60010004), propget]
	HRESULT __stdcall Content(
		[out, retval]IStream** Content);
	[id(0x60010004), propput]
	HRESULT __stdcall Content(
		[in]IStream* Content);
	[id(0x60010006), propget]
	HRESULT __stdcall Headers(
		[out, retval]ICoreWebView2HttpRequestHeaders** Headers);
};
```
'!
!WebView2.ICoreWebView2WebResourceRequest categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WebResourceRequest methodsFor!

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

	<virtual stdcall: hresult 8 IStream**>
	^self invalidCall: _failureCode!

get_Headers: headers
	"Private - Get the value of the 'Headers' property of the receiver.

		HRESULT __stdcall Headers(
			[out, retval]ICoreWebView2HttpRequestHeaders** Headers);"

	<virtual stdcall: hresult 10 ICoreWebView2HttpRequestHeaders**>
	^self invalidCall: _failureCode!

get_Method: method
	"Private - Get the value of the 'Method' property of the receiver.

		HRESULT __stdcall Method(
			[out, retval]LPWSTR* Method);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_uri: uri
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

headers
	"Answer the <ICoreWebView2HttpRequestHeaders> value of the 'Headers' property of the receiver."

	| answer |
	answer := ICoreWebView2HttpRequestHeaders newPointer.
	self get_Headers: answer.
	^answer asObject!

method
	"Answer the <lpwstr> value of the 'Method' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_Method: answer.
	^answer asObject!

method: method
	"Set the 'Method' property of the receiver to the <lpwstr> value of the argument."

	self put_Method: method asUtf16String!

put_Content: content
	"Private - Set the value of the 'Content' property of the object wrapped by the 
	 receiver to the <IStream*> argument, content.

		HRESULT __stdcall Content(
			[in]IStream* Content);"

	<virtual stdcall: hresult 9 IStream*>
	^self invalidCall: _failureCode!

put_Method: method
	"Private - Set the value of the 'Method' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, method.

		HRESULT __stdcall Method(
			[in]LPWSTR Method);"

	<virtual stdcall: hresult 7 lpwstr>
	^self invalidCall: _failureCode!

put_uri: uri
	"Private - Set the value of the 'uri' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, uri.

		HRESULT __stdcall uri(
			[in]LPWSTR uri);"

	<virtual stdcall: hresult 5 lpwstr>
	^self invalidCall: _failureCode!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_uri: answer.
	^answer asObject!

uri: uri
	"Set the 'uri' property of the receiver to the <lpwstr> value of the argument."

	self put_uri: uri asUtf16String! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #content!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #content:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #get_Content:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequest!private! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #get_Headers:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequest!private! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #get_Method:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequest!private! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #get_uri:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequest!private! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #headers!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #method!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #method:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #put_Content:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequest!private! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #put_Method:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequest!private! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #put_uri:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequest!private! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #uri!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequest categoriesFor: #uri:!**auto generated**!properties!public! !

!WebView2.ICoreWebView2WebResourceRequest class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceRequest'
		ICoreWebView2WebResourceRequest defineTemplate"

	self
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_uri:
			argumentTypes: 'lpwstr';
		defineFunction: #get_Method:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_Method:
			argumentTypes: 'lpwstr';
		defineFunction: #get_Content:
			argumentTypes: 'IStream**';
		defineFunction: #put_Content:
			argumentTypes: 'IStream*';
		defineFunction: #get_Headers:
			argumentTypes: 'ICoreWebView2HttpRequestHeaders**'
! !
!WebView2.ICoreWebView2WebResourceRequest class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

