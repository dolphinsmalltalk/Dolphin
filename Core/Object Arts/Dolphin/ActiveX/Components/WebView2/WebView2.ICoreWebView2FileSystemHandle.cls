"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2FileSystemHandle'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FileSystemHandle guid: (OS.COM.IID fromString: '{c65100ac-0de2-5551-a362-23d9bd1d0e1f}')!

WebView2.ICoreWebView2FileSystemHandle comment: '`ICoreWebView2FileSystemHandle` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FileSystemHandle'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c65100ac-0de2-5551-a362-23d9bd1d0e1f)
]
interface ICoreWebView2FileSystemHandle : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_FILE_SYSTEM_HANDLE_KIND* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Path(
		[out, retval]LPWSTR* value);
	[id(0x60010002), propget]
	HRESULT __stdcall Permission(
		[out, retval]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION* value);
};
```
'!

!WebView2.ICoreWebView2FileSystemHandle categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FileSystemHandle methodsFor!

get_Kind: value
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_FILE_SYSTEM_HANDLE_KIND* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_Path: value
	"Private - Get the value of the 'Path' property of the receiver.

		HRESULT __stdcall Path(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_Permission: value
	"Private - Get the value of the 'Permission' property of the receiver.

		HRESULT __stdcall Permission(
			[out, retval]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

kind
	"Answer the <int32> value of the 'Kind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Kind: answer.
	^answer asObject!

path
	"Answer the <lpwstr> value of the 'Path' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Path: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

permission
	"Answer the <int32> value of the 'Permission' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Permission: answer.
	^answer asObject! !

!WebView2.ICoreWebView2FileSystemHandle categoriesForMethods!
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2FileSystemHandle!private! !
get_Path:!**auto generated**!COM Interfaces-ICoreWebView2FileSystemHandle!private! !
get_Permission:!**auto generated**!COM Interfaces-ICoreWebView2FileSystemHandle!private! !
kind!**auto generated**!properties!public! !
path!properties!public! !
permission!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2FileSystemHandle class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FileSystemHandle'
		ICoreWebView2FileSystemHandle defineTemplate"

	self
		defineFunction: #get_Kind:
			argumentTypes: 'int32*';
		defineFunction: #get_Path:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Permission:
			argumentTypes: 'int32*'
! !

!WebView2.ICoreWebView2FileSystemHandle class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

