"Filed out from Dolphin Smalltalk"!

ICoreWebView2HttpHeadersCollection subclass: #ICoreWebView2HttpResponseHeaders
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2HttpResponseHeaders guid: (IID fromString: '{03c5ff5a-9b45-4a88-881c-89a9f328619c}')!

ICoreWebView2HttpResponseHeaders comment: '`ICoreWebView2HttpResponseHeaders` is a wrapper class for the COM interface ''WebView2.ICoreWebView2HttpResponseHeaders'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(03c5ff5a-9b45-4a88-881c-89a9f328619c)
]
interface ICoreWebView2HttpResponseHeaders : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall AppendHeader(
		[in]LPWSTR name,
		[in]LPWSTR value);
	[id(0x60010001)]
	HRESULT __stdcall Contains(
		[in]LPWSTR name,
		[out, retval]long* Contains);
	[id(0x60010002)]
	HRESULT __stdcall GetHeader(
		[in]LPWSTR name,
		[out, retval]LPWSTR* value);
	[id(0x60010003)]
	HRESULT __stdcall GetHeaders(
		[in]LPWSTR name,
		[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);
	[id(0x60010004)]
	HRESULT __stdcall GetIterator(
		[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);
};
```
'!

!ICoreWebView2HttpResponseHeaders categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2HttpResponseHeaders methodsFor!

AppendHeader: name value: value
	"Private - Invoke the AppendHeader() method of the COM object.

		HRESULT __stdcall AppendHeader(
			[in]LPWSTR name,
			[in]LPWSTR value);"

	<virtual stdcall: hresult 4 lpwstr lpwstr>
	^self invalidCall: _failureCode!

at: nameString put: headerString
	"Add a new named header. Note attempting to modify an existing header will just add a new header line with the same name."

	self AppendHeader: nameString asUtf16String value: headerString asUtf16String.
	^headerString!

Contains: name contains: contains
	"Private - Invoke the Contains() method of the COM object.

		HRESULT __stdcall Contains(
			[in]LPWSTR name,
			[out, retval]long* Contains);"

	<virtual stdcall: hresult 5 lpwstr sdword*>
	^self invalidCall: _failureCode!

GetHeader: name value: value
	"Private - Invoke the GetHeader() method of the COM object.

		HRESULT __stdcall GetHeader(
			[in]LPWSTR name,
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 6 lpwstr lpwstr*>
	^self invalidCall: _failureCode!

GetHeaders: name iterator: iterator
	"Private - Invoke the GetHeaders() method of the COM object.

		HRESULT __stdcall GetHeaders(
			[in]LPWSTR name,
			[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);"

	<virtual stdcall: hresult 7 lpwstr ICoreWebView2HttpHeadersCollectionIterator**>
	^self invalidCall: _failureCode!

GetIterator: iterator
	"Private - Invoke the GetIterator() method of the COM object.

		HRESULT __stdcall GetIterator(
			[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);"

	<virtual stdcall: hresult 8 ICoreWebView2HttpHeadersCollectionIterator**>
	^self invalidCall: _failureCode!

RemoveHeader: name
	"Headers cannot be removed."

	self shouldNotImplement! !

!ICoreWebView2HttpResponseHeaders categoriesForMethods!
AppendHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
at:put:!accessing!public! !
Contains:contains:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
GetHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
GetHeaders:iterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
GetIterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
RemoveHeader:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
!

!ICoreWebView2HttpResponseHeaders class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2HttpResponseHeaders'
		ICoreWebView2HttpResponseHeaders defineTemplate"

	self
		defineFunction: #AppendHeader:value:
			argumentTypes: 'lpwstr lpwstr';
		defineFunction: #Contains:contains:
			argumentTypes: 'lpwstr sdword*';
		defineFunction: #GetHeader:value:
			argumentTypes: 'lpwstr lpwstr*';
		defineFunction: #GetHeaders:iterator:
			argumentTypes: 'lpwstr ICoreWebView2HttpHeadersCollectionIterator**';
		defineFunction: #GetIterator:
			argumentTypes: 'ICoreWebView2HttpHeadersCollectionIterator**'
! !

!ICoreWebView2HttpResponseHeaders class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

