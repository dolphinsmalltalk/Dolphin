"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2FrameInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'KindNames' -> #('UNKNOWN' 'MAIN_FRAME' 'IFRAME' 'EMBED' 'OBJECT') }!

WebView2.ICoreWebView2FrameInfo guid: (OS.COM.IID fromString: '{da86b8a1-bdf3-4f11-9955-528cefa59727}')!

WebView2.ICoreWebView2FrameInfo isEgressOnly: true!

WebView2.ICoreWebView2FrameInfo comment: '`ICoreWebView2FrameInfo` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameInfo'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(da86b8a1-bdf3-4f11-9955-528cefa59727)
]
interface ICoreWebView2FrameInfo : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* name);
	[id(0x60010001), propget]
	HRESULT __stdcall Source(
		[out, retval]LPWSTR* Source);
};
```
'!

!WebView2.ICoreWebView2FrameInfo categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameInfo methodsFor!

frameId
	"Answer the <uint32> value of the 'FrameId' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_FrameId: buf.
	^buf asInteger!

frameKind
	"Answer the <int32> value of the 'FrameKind' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_FrameKind: buf.
	^buf asSignedInteger!

get_FrameId: id
	"Private - Get the value of the 'FrameId' property of the receiver.

		HRESULT __stdcall FrameId(
			[out, retval]unsigned int* id);"

	^E_NOTIMPL!

get_FrameKind: kind
	"Private - Get the value of the 'FrameKind' property of the receiver.

		HRESULT __stdcall FrameKind(
			[out, retval]COREWEBVIEW2_FRAME_KIND* Kind);"

	kind value: COREWEBVIEW2_FRAME_KIND_UNKNOWN.
	^E_NOTIMPL!

get_name: name
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* name);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_ParentFrameInfo: frameInfo
	"Private - Get the value of the 'ParentFrameInfo' property of the receiver.

		HRESULT __stdcall ParentFrameInfo(
			[out, retval]ICoreWebView2FrameInfo** frameInfo);"

	^E_NOTIMPL!

get_Source: source
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]LPWSTR* Source);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

kindName
	^(KindNames lookup: self frameKind + 1) ?? '(Invalid frame kind)'!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

parentFrameInfo
	"Answer the <ICoreWebView2FrameInfo> value of the 'ParentFrameInfo' property of the receiver."

	| answer |
	answer := ICoreWebView2FrameInfo newPointer.
	self get_ParentFrameInfo: answer.
	^answer asObject!

printableProperties
	^#(#name #source)!

source
	"Answer the <lpwstr> value of the 'Source' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Source: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2FrameInfo categoriesForMethods!
frameId!properties!public! !
frameKind!properties!public! !
get_FrameId:!COM Interfaces-ICoreWebView2FrameInfo2!private! !
get_FrameKind:!COM Interfaces-ICoreWebView2FrameInfo2!private! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfo!private! !
get_ParentFrameInfo:!COM Interfaces-ICoreWebView2FrameInfo2!private! !
get_Source:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfo!private! !
kindName!properties!public! !
name!properties!public! !
parentFrameInfo!properties!public! !
printableProperties!printing!public! !
source!properties!public! !
!

!WebView2.ICoreWebView2FrameInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameInfo'
		ICoreWebView2FrameInfo defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Source:
			argumentTypes: 'lpwstr*'
!

latestDerivation
	^##(super latestDerivation)! !

!WebView2.ICoreWebView2FrameInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
latestDerivation!enquiries!public! !
!

