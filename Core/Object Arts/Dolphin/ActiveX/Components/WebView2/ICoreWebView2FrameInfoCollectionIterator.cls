"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2FrameInfoCollectionIterator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2FrameInfoCollectionIterator guid: (IID fromString: '{1bf89e2d-1b2b-4629-b28f-05099b41bb03}')!

ICoreWebView2FrameInfoCollectionIterator comment: '`ICoreWebView2FrameInfoCollectionIterator` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameInfoCollectionIterator'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(1bf89e2d-1b2b-4629-b28f-05099b41bb03)
]
interface ICoreWebView2FrameInfoCollectionIterator : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall hasCurrent(
		[out, retval]long* hasCurrent);
	[id(0x60010001)]
	HRESULT __stdcall GetCurrent(
		[out, retval]ICoreWebView2FrameInfo** frameInfo);
	[id(0x60010002)]
	HRESULT __stdcall MoveNext(
		[out, retval]long* hasNext);
};
```
'!

!ICoreWebView2FrameInfoCollectionIterator categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2FrameInfoCollectionIterator methodsFor!

do: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the remaining ICoreWebView2FrameInfo objects in the receiver (i.e. from the current position to the end).
	Note that as the iterator cannot be reset, it can only be enumerated once."

	| notAtEnd |
	notAtEnd := ByteArray new: 4.
	self get_hasCurrent: notAtEnd.
	[(notAtEnd sdwordAtOffset: 0) == 0] whileFalse: 
			[aMonadicValuable value: self getCurrent.
			self MoveNext: notAtEnd]!

get_hasCurrent: hasCurrent
	"Private - Get the value of the 'hasCurrent' property of the receiver.

		HRESULT __stdcall hasCurrent(
			[out, retval]long* hasCurrent);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

getCurrent
	"Answer the <ICoreWebView2FrameInfo> result of invoking the GetCurrent() method of the COM object."

	| answer |
	answer := ICoreWebView2FrameInfo newPointer.
	self GetCurrent: answer.
	^answer asObject!

GetCurrent: frameInfo
	"Private - Invoke the GetCurrent() method of the COM object.

		HRESULT __stdcall GetCurrent(
			[out, retval]ICoreWebView2FrameInfo** frameInfo);"

	<virtual stdcall: hresult 5 ICoreWebView2FrameInfo**>
	^self invalidCall: _failureCode!

hasCurrent
	"Answer the <Boolean> value of the 'hasCurrent' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_hasCurrent: answer.
	^answer asObject!

MoveNext: hasNext
	"Private - Invoke the MoveNext() method of the COM object.

		HRESULT __stdcall MoveNext(
			[out, retval]long* hasNext);"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall: _failureCode! !

!ICoreWebView2FrameInfoCollectionIterator categoriesForMethods!
do:!enumerating!public! !
get_hasCurrent:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfoCollectionIterator!private! !
getCurrent!**auto generated**!methods!public! !
GetCurrent:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfoCollectionIterator!private! !
hasCurrent!properties!public! !
MoveNext:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfoCollectionIterator!private! !
!

!ICoreWebView2FrameInfoCollectionIterator class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameInfoCollectionIterator'
		ICoreWebView2FrameInfoCollectionIterator defineTemplate"

	self
		defineFunction: #get_hasCurrent:
			argumentTypes: 'sdword*';
		defineFunction: #GetCurrent:
			argumentTypes: 'ICoreWebView2FrameInfo**';
		defineFunction: #MoveNext:
			argumentTypes: 'sdword*'
! !

!ICoreWebView2FrameInfoCollectionIterator class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

