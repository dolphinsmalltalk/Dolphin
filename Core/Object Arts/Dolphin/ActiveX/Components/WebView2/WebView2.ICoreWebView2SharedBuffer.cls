"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2SharedBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2SharedBuffer guid: (OS.COM.IID fromString: '{b747a495-0c6f-449e-97b8-2f81e9d6ab43}')!
WebView2.ICoreWebView2SharedBuffer comment: '`ICoreWebView2SharedBuffer` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SharedBuffer'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b747a495-0c6f-449e-97b8-2f81e9d6ab43)
]
interface ICoreWebView2SharedBuffer : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Size(
		[out, retval]unsigned __int64* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Buffer(
		[out, retval]BYTE** value);
	[id(0x60010002)]
	HRESULT __stdcall OpenStream(
		[out, retval]IStream** value);
	[id(0x60010003), propget]
	HRESULT __stdcall FileMappingHandle(
		[out, retval]void** value);
	[id(0x60010004)]
	HRESULT __stdcall Close();
};
```
'!
!WebView2.ICoreWebView2SharedBuffer categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2SharedBuffer methodsFor!

buffer
	"Answer the buffer."

	| answer |
	answer := External.Address new.
	self get_Buffer: answer.
	^ExternalArray fromAddress: answer length: self size!

Close
	"Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 8>
	^self invalidCall: _failureCode!

fileMappingHandle
	"Answer the <External.Handle> value of the 'FileMappingHandle' property of the receiver."

	| answer |
	answer := External.Handle new.
	self get_FileMappingHandle: answer.
	^answer asObject!

get_Buffer: value
	"Private - Get the value of the 'Buffer' property of the receiver.

		HRESULT __stdcall Buffer(
			[out, retval]BYTE** value);"

	<virtual stdcall: hresult 5 uint8**>
	^self invalidCall: _failureCode!

get_FileMappingHandle: value
	"Private - Get the value of the 'FileMappingHandle' property of the receiver.

		HRESULT __stdcall FileMappingHandle(
			[out, retval]HANDLE* value);"

	<virtual stdcall: hresult 7 handle*>
	^self invalidCall: _failureCode!

get_Size: value
	"Private - Get the value of the 'Size' property of the receiver.

		HRESULT __stdcall Size(
			[out, retval]unsigned __int64* value);"

	<virtual stdcall: hresult 4 uint64*>
	^self invalidCall: _failureCode!

memoryMappedFile
	"Answer a <MemoryMappedFile> on the backing file."

	^MemoryMappedFile fromHandle: self fileMappingHandle!

openStream
	"Answer the <IStream> result of invoking the OpenStream() method of the COM object."

	| answer |
	answer := IStream newPointer.
	self OpenStream: answer.
	^answer asObject!

OpenStream: value
	"Private - Invoke the OpenStream() method of the COM object.

		HRESULT __stdcall OpenStream(
			[out, retval]IStream** value);"

	<virtual stdcall: hresult 6 IStream**>
	^self invalidCall: _failureCode!

size
	"Answer the <uint64> value of the 'Size' property of the receiver."

	| answer |
	answer := UInt64Bytes new.
	self get_Size: answer.
	^answer asInteger! !
!WebView2.ICoreWebView2SharedBuffer categoriesForMethods!
buffer!properties!public! !
Close!**auto generated**!COM Interfaces-ICoreWebView2SharedBuffer!public! !
fileMappingHandle!properties!public! !
get_Buffer:!**auto generated**!COM Interfaces-ICoreWebView2SharedBuffer!private! !
get_FileMappingHandle:!**auto generated**!COM Interfaces-ICoreWebView2SharedBuffer!private! !
get_Size:!**auto generated**!COM Interfaces-ICoreWebView2SharedBuffer!private! !
memoryMappedFile!properties!public! !
openStream!**auto generated**!methods!public! !
OpenStream:!**auto generated**!COM Interfaces-ICoreWebView2SharedBuffer!private! !
size!properties!public! !
!

!WebView2.ICoreWebView2SharedBuffer class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SharedBuffer'
		ICoreWebView2SharedBuffer defineTemplate"

	self
		defineFunction: #get_Size:
			argumentTypes: 'uint64*';
		defineFunction: #get_Buffer:
			argumentTypes: 'uint8**';
		defineFunction: #OpenStream:
			argumentTypes: 'IStream**';
		defineFunction: #get_FileMappingHandle:
			argumentTypes: 'handle*';
		defineFunction: #Close
! !
!WebView2.ICoreWebView2SharedBuffer class categoriesForMethods!
defineFunctions!initializing!public! !
!

