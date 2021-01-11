"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2HttpRequestHeaders'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2HttpRequestHeaders guid: (OS.COM.IID fromString: '{e86cac0e-5523-465c-b536-8fb9fc8c8c60}')!
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

contains: name
	"Answer the <sdword> result of invoking the Contains() method of the COM object."

	| answer |
	answer := SDWORD new.
	self Contains: name asUtf16String contains: answer.
	^answer asObject!

Contains: name contains: contains
	"Private - Invoke the Contains() method of the COM object.

		HRESULT __stdcall Contains(
			[in]LPWSTR name,
			[out, retval]long* Contains);"

	<virtual stdcall: hresult 6 lpwstr sdword*>
	^self invalidCall: _failureCode!

getHeader: name
	"Answer the <lpwstr> result of invoking the GetHeader() method of the COM object."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self GetHeader: name asUtf16String value: answer.
	^answer asObject!

GetHeader: name value: value
	"Private - Invoke the GetHeader() method of the COM object.

		HRESULT __stdcall GetHeader(
			[in]LPWSTR name,
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr lpwstr*>
	^self invalidCall: _failureCode!

getHeaders: name
	"Answer the <ICoreWebView2HttpHeadersCollectionIterator> result of invoking the GetHeaders() method of the COM object."

	| answer |
	answer := ICoreWebView2HttpHeadersCollectionIterator newPointer.
	self GetHeaders: name asUtf16String iterator: answer.
	^answer asObject!

GetHeaders: name iterator: iterator
	"Private - Invoke the GetHeaders() method of the COM object.

		HRESULT __stdcall GetHeaders(
			[in]LPWSTR name,
			[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);"

	<virtual stdcall: hresult 5 lpwstr ICoreWebView2HttpHeadersCollectionIterator**>
	^self invalidCall: _failureCode!

getIterator
	"Answer the <ICoreWebView2HttpHeadersCollectionIterator> result of invoking the GetIterator() method of the COM object."

	| answer |
	answer := ICoreWebView2HttpHeadersCollectionIterator newPointer.
	self GetIterator: answer.
	^answer asObject!

GetIterator: iterator
	"Private - Invoke the GetIterator() method of the COM object.

		HRESULT __stdcall GetIterator(
			[out, retval]ICoreWebView2HttpHeadersCollectionIterator** iterator);"

	<virtual stdcall: hresult 9 ICoreWebView2HttpHeadersCollectionIterator**>
	^self invalidCall: _failureCode!

removeHeader: name
	"Invoke the RemoveHeader() method of the COM object."

	^self RemoveHeader: name asUtf16String!

RemoveHeader: name
	"Private - Invoke the RemoveHeader() method of the COM object.

		HRESULT __stdcall RemoveHeader(
			[in]LPWSTR name);"

	<virtual stdcall: hresult 8 lpwstr>
	^self invalidCall: _failureCode!

setHeader: name value: value
	"Invoke the SetHeader() method of the COM object."

	^self SetHeader: name asUtf16String value: value asUtf16String!

SetHeader: name value: value
	"Private - Invoke the SetHeader() method of the COM object.

		HRESULT __stdcall SetHeader(
			[in]LPWSTR name,
			[in]LPWSTR value);"

	<virtual stdcall: hresult 7 lpwstr lpwstr>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #contains:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #Contains:contains:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #getHeader:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #GetHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #getHeaders:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #GetHeaders:iterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #getIterator!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #GetIterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #removeHeader:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #RemoveHeader:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #setHeader:value:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpRequestHeaders categoriesFor: #SetHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !

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
!WebView2.ICoreWebView2HttpRequestHeaders class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

