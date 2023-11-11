"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2HttpHeadersCollectionIterator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2HttpHeadersCollectionIterator guid: (OS.COM.IID fromString: '{0702fc30-f43b-47bb-ab52-a42cb552ad9f}')!
WebView2.ICoreWebView2HttpHeadersCollectionIterator isEgressOnly: true!
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

do: aMonadicValuable
	self keysAndValuesDo: [:eachKey :eachValue | aMonadicValuable value: eachValue]!

get_HasCurrentHeader: hasCurrent
	"Private - Get the value of the 'HasCurrentHeader' property of the receiver.

		HRESULT __stdcall HasCurrentHeader(
			[out, retval]long* hasCurrent);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

GetCurrentHeader: name value: value
	"Private - Invoke the GetCurrentHeader() method of the COM object.

		HRESULT __stdcall GetCurrentHeader(
			[out]LPWSTR* name,
			[out]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr* lpwstr*>
	^self invalidCall: _failureCode!

hasCurrent
	"Answer whether there are any remaining elements in the collection to iterate over."

	| buf |
	buf := UInt32Bytes new.
	self get_HasCurrentHeader: buf.
	^buf asBoolean!

keysAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable> argument for each of the remaining key/valube pairsr in the receiver (i.e. from the current position to the end).
	Note that as the iterator cannot be reset, it can only be enumerated once."

	| namePtr valuePtr notAtEnd |
	namePtr := TaskMemory new
				beUnfinalizable;
				yourself.
	valuePtr := TaskMemory new
				beUnfinalizable;
				yourself.
	notAtEnd := ByteArray new: 4.
	self get_HasCurrentHeader: notAtEnd.
	[(notAtEnd int32AtOffset: 0) == 0] whileFalse: 
			[| name value |
			self GetCurrentHeader: namePtr value: valuePtr.
			name := Utf16String fromAddress: namePtr.
			namePtr basicFree.
			value := Utf16String fromAddress: valuePtr.
			valuePtr basicFree.
			aDyadicValuable value: name value: value.
			self MoveNext: notAtEnd]!

MoveNext: hasNext
	"Private - Invoke the MoveNext() method of the COM object.

		HRESULT __stdcall MoveNext(
			[out, retval]long* hasNext);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2HttpHeadersCollectionIterator categoriesForMethods!
do:!enumerating!public! !
get_HasCurrentHeader:!**auto generated**!COM Interfaces-ICoreWebView2HttpHeadersCollectionIterator!private! !
GetCurrentHeader:value:!**auto generated**!COM Interfaces-ICoreWebView2HttpHeadersCollectionIterator!private! !
hasCurrent!properties!public! !
keysAndValuesDo:!enumerating!public! !
MoveNext:!**auto generated**!COM Interfaces-ICoreWebView2HttpHeadersCollectionIterator!private! !
!

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
!WebView2.ICoreWebView2HttpHeadersCollectionIterator class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

