"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2FrameInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
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

get_name: name
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* name);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_Source: source
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]LPWSTR* Source);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

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
get_name:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfo!private! !
get_Source:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfo!private! !
name!properties!public! !
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
! !
!WebView2.ICoreWebView2FrameInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

