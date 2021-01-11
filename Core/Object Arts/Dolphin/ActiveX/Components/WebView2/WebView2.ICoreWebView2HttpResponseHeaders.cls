"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2HttpResponseHeaders'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2HttpResponseHeaders guid: (OS.COM.IID fromString: '{03c5ff5a-9b45-4a88-881c-89a9f328619c}')!
WebView2.ICoreWebView2HttpResponseHeaders comment: '`ICoreWebView2HttpResponseHeaders` is a wrapper class for the COM interface ''WebView2.ICoreWebView2HttpResponseHeaders'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2HttpResponseHeaders categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2HttpResponseHeaders methodsFor!

appendHeader: name value: value
	"Invoke the AppendHeader() method of the COM object."

	^self AppendHeader: name asUtf16String value: value asUtf16String!

AppendHeader: name value: value
	"Private - Invoke the AppendHeader() method of the COM object.

		HRESULT __stdcall AppendHeader(
			[in]LPWSTR name,
			[in]LPWSTR value);"

	<virtual stdcall: hresult 4 lpwstr lpwstr>
	^self invalidCall: _failureCode!

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

	<virtual stdcall: hresult 5 lpwstr sdword*>
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

	<virtual stdcall: hresult 6 lpwstr lpwstr*>
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

	<virtual stdcall: hresult 7 lpwstr ICoreWebView2HttpHeadersCollectionIterator**>
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

	<virtual stdcall: hresult 8 ICoreWebView2HttpHeadersCollectionIterator**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #appendHeader:value:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #AppendHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #contains:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #Contains:contains:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #getHeader:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #GetHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #getHeaders:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #GetHeaders:iterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #getIterator!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpResponseHeaders categoriesFor: #GetIterator:!**auto generated**!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !

!WebView2.ICoreWebView2HttpResponseHeaders class methodsFor!

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
!WebView2.ICoreWebView2HttpResponseHeaders class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

