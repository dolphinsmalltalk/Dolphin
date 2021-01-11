"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2HttpHeadersCollectionIterator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2HttpHeadersCollectionIterator guid: (OS.COM.IID fromString: '{0702fc30-f43b-47bb-ab52-a42cb552ad9f}')!
WebView2.ICoreWebView2HttpHeadersCollectionIterator comment: '`ICoreWebView2HttpHeadersCollectionIterator` is a wrapper class for the COM interface ''WebView2.ICoreWebView2HttpHeadersCollectionIterator'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0702fc30-f43b-47bb-ab52-a42cb552ad9f)
]
interface ICoreWebView2HttpHeadersCollectionIterator : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetCurrentHeader(
		[out]LPWSTR* name,
		[out]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall HasCurrentHeader(
		[out, retval]long* hasCurrent);
	[id(0x60010002)]
	HRESULT __stdcall MoveNext(
		[out, retval]long* hasNext);
};
```
'!
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator methodsFor!

get_HasCurrentHeader: hasCurrent
	"Private - Get the value of the 'HasCurrentHeader' property of the receiver.

		HRESULT __stdcall HasCurrentHeader(
			[out, retval]long* hasCurrent);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

getCurrentHeader
	"Invoke the GetCurrentHeader() method of the COM object."

	| outputs |
	outputs := {StructurePointer newNull: TaskMemory elementClass: Utf16String.
				StructurePointer newNull: TaskMemory elementClass: Utf16String}.
	self GetCurrentHeader: (outputs basicAt: 1) value: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetCurrentHeader: name value: value
	"Private - Invoke the GetCurrentHeader() method of the COM object.

		HRESULT __stdcall GetCurrentHeader(
			[out]LPWSTR* name,
			[out]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr* lpwstr*>
	^self invalidCall: _failureCode!

hasCurrentHeader
	"Answer the <sdword> value of the 'HasCurrentHeader' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_HasCurrentHeader: answer.
	^answer asObject!

moveNext
	"Answer the <sdword> result of invoking the MoveNext() method of the COM object."

	| answer |
	answer := SDWORD new.
	self MoveNext: answer.
	^answer asObject!

MoveNext: hasNext
	"Private - Invoke the MoveNext() method of the COM object.

		HRESULT __stdcall MoveNext(
			[out, retval]long* hasNext);"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesFor: #get_HasCurrentHeader:!**auto generated**!COM Interfaces-ICoreWebView2HttpHeadersCollectionIterator!private! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesFor: #getCurrentHeader!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesFor: #GetCurrentHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpHeadersCollectionIterator!private! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesFor: #hasCurrentHeader!**auto generated**!properties!public! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesFor: #moveNext!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesFor: #MoveNext:!**auto generated**!COM Interfaces-ICoreWebView2HttpHeadersCollectionIterator!private! !

!WebView2.ICoreWebView2HttpHeadersCollectionIterator class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2HttpHeadersCollectionIterator'
		ICoreWebView2HttpHeadersCollectionIterator defineTemplate"

	self
		defineFunction: #GetCurrentHeader:value:
			argumentTypes: 'lpwstr* lpwstr*';
		defineFunction: #get_HasCurrentHeader:
			argumentTypes: 'sdword*';
		defineFunction: #MoveNext:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

