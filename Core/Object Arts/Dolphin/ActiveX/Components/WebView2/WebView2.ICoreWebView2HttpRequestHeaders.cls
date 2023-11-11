"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2HttpHeadersCollection
	subclass: #'WebView2.ICoreWebView2HttpRequestHeaders'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2HttpRequestHeaders guid: (OS.COM.IID fromString: '{e86cac0e-5523-465c-b536-8fb9fc8c8c60}')!
WebView2.ICoreWebView2HttpRequestHeaders isEgressOnly: true!
WebView2.ICoreWebView2HttpRequestHeaders comment: '`ICoreWebView2HttpRequestHeaders` is a wrapper class for the COM interface ''WebView2.ICoreWebView2HttpRequestHeaders'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e86cac0e-5523-465c-b536-8fb9fc8c8c60)
]
interface ICoreWebView2HttpRequestHeaders : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetHeader(
		[in]LPWSTR name,
		[out, retval]LPWSTR* value);
	[id(0x60010001)]
	HRESULT __stdcall GetHeaders(
		[in]LPWSTR name,
		[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);
	[id(0x60010002)]
	HRESULT __stdcall Contains(
		[in]LPWSTR name,
		[out, retval]long* Contains);
	[id(0x60010003)]
	HRESULT __stdcall SetHeader(
		[in]LPWSTR name,
		[in]LPWSTR value);
	[id(0x60010004)]
	HRESULT __stdcall RemoveHeader(
		[in]LPWSTR name);
	[id(0x60010005)]
	HRESULT __stdcall GetIterator(
		[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);
};
```
'!
!WebView2.ICoreWebView2HttpRequestHeaders categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2HttpRequestHeaders methodsFor!

at: nameString put: headerString
	"Add or update the named header."

	self SetHeader: nameString asUtf16String value: headerString asUtf16String.
	^headerString!

Contains: name contains: contains
	"Private - Invoke the Contains() method of the COM object.

		HRESULT __stdcall Contains(
			[in]LPWSTR name,
			[out, retval]long* Contains);"

	<virtual stdcall: hresult 6 lpwstr int32*>
	^self invalidCall: _failureCode!

GetHeader: name value: value
	"Private - Invoke the GetHeader() method of the COM object.

		HRESULT __stdcall GetHeader(
			[in]LPWSTR name,
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr lpwstr*>
	^self invalidCall: _failureCode!

GetHeaders: name iterator: iterator
	"Private - Invoke the GetHeaders() method of the COM object.

		HRESULT __stdcall GetHeaders(
			[in]LPWSTR name,
			[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);"

	<virtual stdcall: hresult 5 lpwstr ICoreWebView2HttpHeadersCollectionIterator**>
	^self invalidCall: _failureCode!

GetIterator: iterator
	"Private - Invoke the GetIterator() method of the COM object.

		HRESULT __stdcall GetIterator(
			[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);"

	<virtual stdcall: hresult 9 ICoreWebView2HttpHeadersCollectionIterator**>
	^self invalidCall: _failureCode!

RemoveHeader: name
	"Private - Invoke the RemoveHeader() method of the COM object.

		HRESULT __stdcall RemoveHeader(
			[in]LPWSTR name);"

	<virtual stdcall: hresult 8 lpwstr>
	^self invalidCall: _failureCode!

SetHeader: name value: value
	"Private - Invoke the SetHeader() method of the COM object.

		HRESULT __stdcall SetHeader(
			[in]LPWSTR name,
			[in]LPWSTR value);"

	<virtual stdcall: hresult 7 lpwstr lpwstr>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesForMethods!
at:put:!accessing!public! !
Contains:contains:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
GetHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
GetHeaders:iterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
GetIterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
RemoveHeader:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
SetHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
!

!WebView2.ICoreWebView2HttpRequestHeaders class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2HttpRequestHeaders'
		ICoreWebView2HttpRequestHeaders defineTemplate"

	self
		defineFunction: #GetHeader:value:
			argumentTypes: 'lpwstr lpwstr*';
		defineFunction: #GetHeaders:iterator:
			argumentTypes: 'lpwstr ICoreWebView2HttpHeadersCollectionIterator**';
		defineFunction: #Contains:contains:
			argumentTypes: 'lpwstr sdword*';
		defineFunction: #SetHeader:value:
			argumentTypes: 'lpwstr lpwstr';
		defineFunction: #RemoveHeader:
			argumentTypes: 'lpwstr';
		defineFunction: #GetIterator:
			argumentTypes: 'ICoreWebView2HttpHeadersCollectionIterator**'
! !
!WebView2.ICoreWebView2HttpRequestHeaders class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

