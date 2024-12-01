"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2SaveAsUIShowingEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2SaveAsUIShowingEventArgs guid: (OS.COM.IID fromString: '{55902952-0e0d-5aaa-a7d0-e833cdb34f62}')!

WebView2.ICoreWebView2SaveAsUIShowingEventArgs comment: '`ICoreWebView2SaveAsUIShowingEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SaveAsUIShowingEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(55902952-0e0d-5aaa-a7d0-e833cdb34f62)
]
interface ICoreWebView2SaveAsUIShowingEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ContentMimeType(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propput]
	HRESULT __stdcall Cancel(
		[in]long value);
	[id(0x60010001), propget]
	HRESULT __stdcall Cancel(
		[out, retval]long* value);
	[id(0x60010003), propput]
	HRESULT __stdcall SuppressDefaultDialog(
		[in]long value);
	[id(0x60010003), propget]
	HRESULT __stdcall SuppressDefaultDialog(
		[out, retval]long* value);
	[id(0x60010005)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** value);
	[id(0x60010006), propput]
	HRESULT __stdcall SaveAsFilePath(
		[in]LPWSTR value);
	[id(0x60010006), propget]
	HRESULT __stdcall SaveAsFilePath(
		[out, retval]LPWSTR* value);
	[id(0x60010008), propput]
	HRESULT __stdcall AllowReplace(
		[in]long value);
	[id(0x60010008), propget]
	HRESULT __stdcall AllowReplace(
		[out, retval]long* value);
	[id(0x6001000a), propput]
	HRESULT __stdcall Kind(
		[in]COREWEBVIEW2_SAVE_AS_KIND value);
	[id(0x6001000a), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_SAVE_AS_KIND* value);
};
```
'!

!WebView2.ICoreWebView2SaveAsUIShowingEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2SaveAsUIShowingEventArgs methodsFor!

allowReplace
	"Answer the <boolean> value of the 'AllowReplace' property of the receiver."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_AllowReplace: answer.
	^(answer int32AtOffset: 0) ~~ 0!

allowReplace: aBoolean
	"Set the 'AllowReplace' property of the receiver to the <int32> value of the argument."

	self put_AllowReplace: aBoolean asParameter!

contentMimeType
	"Answer the <lpwstr> value of the 'ContentMimeType' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ContentMimeType: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

get_AllowReplace: value
	"Private - Get the value of the 'AllowReplace' property of the receiver.

		HRESULT __stdcall AllowReplace(
			[out, retval]long* value);"

	<virtual stdcall: hresult 13 int32*>
	^self invalidCall: _failureCode!

get_Cancel: value
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_ContentMimeType: value
	"Private - Get the value of the 'ContentMimeType' property of the receiver.

		HRESULT __stdcall ContentMimeType(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_Kind: value
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_SAVE_AS_KIND* value);"

	<virtual stdcall: hresult 15 int32*>
	^self invalidCall: _failureCode!

get_SaveAsFilePath: value
	"Private - Get the value of the 'SaveAsFilePath' property of the receiver.

		HRESULT __stdcall SaveAsFilePath(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 11 lpwstr*>
	^self invalidCall: _failureCode!

get_SuppressDefaultDialog: value
	"Private - Get the value of the 'SuppressDefaultDialog' property of the receiver.

		HRESULT __stdcall SuppressDefaultDialog(
			[out, retval]long* value);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

GetDeferral: value
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** value);"

	<virtual stdcall: hresult 9 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

kind
	"Answer the <int32> value of the 'Kind' property of the receiver."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_Kind: answer.
	^answer int32AtOffset: 0!

kind: value
	"Set the 'Kind' property of the receiver to the <int32> value of the argument."

	self put_Kind: value!

put_AllowReplace: value
	"Private - Set the value of the 'AllowReplace' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall AllowReplace(
			[in]long value);"

	<virtual stdcall: hresult 12 int32>
	^self invalidCall: _failureCode!

put_Cancel: value
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall Cancel(
			[in]long value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode!

put_Kind: value
	"Private - Set the value of the 'Kind' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall Kind(
			[in]COREWEBVIEW2_SAVE_AS_KIND value);"

	<virtual stdcall: hresult 14 int32>
	^self invalidCall: _failureCode!

put_SaveAsFilePath: value
	"Private - Set the value of the 'SaveAsFilePath' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall SaveAsFilePath(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 10 lpwstr>
	^self invalidCall: _failureCode!

put_SuppressDefaultDialog: value
	"Private - Set the value of the 'SuppressDefaultDialog' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall SuppressDefaultDialog(
			[in]long value);"

	<virtual stdcall: hresult 7 int32>
	^self invalidCall: _failureCode!

saveAsFilePath
	"Answer the <lpwstr> value of the 'SaveAsFilePath' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_SaveAsFilePath: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

saveAsFilePath: value
	"Set the 'SaveAsFilePath' property of the receiver to the <lpwstr> value of the argument."

	self put_SaveAsFilePath: value asUtf16String!

suppressDefaultDialog
	"Answer the <boolean> value of the 'SuppressDefaultDialog' property of the receiver."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_SuppressDefaultDialog: answer.
	^(answer int32AtOffset: 0) ~~ 0!

suppressDefaultDialog: aBoolean
	"Set the 'SuppressDefaultDialog' property of the receiver to the <int32> value of the argument."

	self put_SuppressDefaultDialog: aBoolean asParameter! !

!WebView2.ICoreWebView2SaveAsUIShowingEventArgs categoriesForMethods!
allowReplace!properties!public! !
allowReplace:!properties!public! !
contentMimeType!properties!public! !
get_AllowReplace:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
get_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
get_ContentMimeType:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
get_SaveAsFilePath:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
get_SuppressDefaultDialog:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
kind!properties!public! !
kind:!**auto generated**!properties!public! !
put_AllowReplace:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
put_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
put_Kind:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
put_SaveAsFilePath:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
put_SuppressDefaultDialog:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventArgs!private! !
saveAsFilePath!properties!public! !
saveAsFilePath:!**auto generated**!properties!public! !
suppressDefaultDialog!properties!public! !
suppressDefaultDialog:!properties!public! !
!

!WebView2.ICoreWebView2SaveAsUIShowingEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SaveAsUIShowingEventArgs'
		ICoreWebView2SaveAsUIShowingEventArgs defineTemplate"

	self
		defineFunction: #get_ContentMimeType:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_Cancel:
			argumentTypes: 'int32';
		defineFunction: #get_Cancel:
			argumentTypes: 'int32*';
		defineFunction: #put_SuppressDefaultDialog:
			argumentTypes: 'int32';
		defineFunction: #get_SuppressDefaultDialog:
			argumentTypes: 'int32*';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**';
		defineFunction: #put_SaveAsFilePath:
			argumentTypes: 'lpwstr';
		defineFunction: #get_SaveAsFilePath:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_AllowReplace:
			argumentTypes: 'int32';
		defineFunction: #get_AllowReplace:
			argumentTypes: 'int32*';
		defineFunction: #put_Kind:
			argumentTypes: 'int32';
		defineFunction: #get_Kind:
			argumentTypes: 'int32*'
! !

!WebView2.ICoreWebView2SaveAsUIShowingEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

