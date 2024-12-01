"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs guid: (OS.COM.IID fromString: '{cf4ff1d1-5a67-5660-8d63-ef699881ea65}')!

WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs comment: '`ICoreWebView2SaveFileSecurityCheckStartingEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(cf4ff1d1-5a67-5660-8d63-ef699881ea65)
]
interface ICoreWebView2SaveFileSecurityCheckStartingEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall CancelSave(
		[out, retval]long* value);
	[id(0x60010000), propput]
	HRESULT __stdcall CancelSave(
		[in]long value);
	[id(0x60010002), propget]
	HRESULT __stdcall DocumentOriginUri(
		[out, retval]LPWSTR* value);
	[id(0x60010003), propget]
	HRESULT __stdcall FileExtension(
		[out, retval]LPWSTR* value);
	[id(0x60010004), propget]
	HRESULT __stdcall FilePath(
		[out, retval]LPWSTR* value);
	[id(0x60010005), propget]
	HRESULT __stdcall SuppressDefaultPolicy(
		[out, retval]long* value);
	[id(0x60010005), propput]
	HRESULT __stdcall SuppressDefaultPolicy(
		[in]long value);
	[id(0x60010007)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** value);
};
```
'!

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs methodsFor!

cancelSave
	"Answer the <boolean> value of the 'CancelSave' property of the receiver."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_CancelSave: answer.
	^(answer int32AtOffset: 0) ~~ 0!

cancelSave: value
	"Set the 'CancelSave' property of the receiver to the <int32> value of the argument."

	self put_CancelSave: value asParameter!

documentOriginUri
	"Answer the <lpwstr> value of the 'DocumentOriginUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_DocumentOriginUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

fileExtension
	"Answer the <lpwstr> value of the 'FileExtension' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_FileExtension: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

filePath
	"Answer the <lpwstr> value of the 'FilePath' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_FilePath: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

get_CancelSave: value
	"Private - Get the value of the 'CancelSave' property of the receiver.

		HRESULT __stdcall CancelSave(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_DocumentOriginUri: value
	"Private - Get the value of the 'DocumentOriginUri' property of the receiver.

		HRESULT __stdcall DocumentOriginUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_FileExtension: value
	"Private - Get the value of the 'FileExtension' property of the receiver.

		HRESULT __stdcall FileExtension(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

get_FilePath: value
	"Private - Get the value of the 'FilePath' property of the receiver.

		HRESULT __stdcall FilePath(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

get_SuppressDefaultPolicy: value
	"Private - Get the value of the 'SuppressDefaultPolicy' property of the receiver.

		HRESULT __stdcall SuppressDefaultPolicy(
			[out, retval]long* value);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

GetDeferral: value
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** value);"

	<virtual stdcall: hresult 11 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

put_CancelSave: value
	"Private - Set the value of the 'CancelSave' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall CancelSave(
			[in]long value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode!

put_SuppressDefaultPolicy: value
	"Private - Set the value of the 'SuppressDefaultPolicy' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall SuppressDefaultPolicy(
			[in]long value);"

	<virtual stdcall: hresult 10 int32>
	^self invalidCall: _failureCode!

suppressDefaultPolicy
	"Answer the <int32> value of the 'SuppressDefaultPolicy' property of the receiver."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_SuppressDefaultPolicy: answer.
	^(answer int32AtOffset: 0) ~~ 0!

suppressDefaultPolicy: value
	"Set the 'SuppressDefaultPolicy' property of the receiver to the <int32> value of the argument."

	self put_SuppressDefaultPolicy: value asParameter! !

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs categoriesForMethods!
cancelSave!properties!public! !
cancelSave:!properties!public! !
documentOriginUri!properties!public! !
fileExtension!properties!public! !
filePath!properties!public! !
get_CancelSave:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
get_DocumentOriginUri:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
get_FileExtension:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
get_FilePath:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
get_SuppressDefaultPolicy:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
put_CancelSave:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
put_SuppressDefaultPolicy:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventArgs!private! !
suppressDefaultPolicy!properties!public! !
suppressDefaultPolicy:!properties!public! !
!

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs'
		ICoreWebView2SaveFileSecurityCheckStartingEventArgs defineTemplate"

	self
		defineFunction: #get_CancelSave:
			argumentTypes: 'int32*';
		defineFunction: #put_CancelSave:
			argumentTypes: 'int32';
		defineFunction: #get_DocumentOriginUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_FileExtension:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_FilePath:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_SuppressDefaultPolicy:
			argumentTypes: 'int32*';
		defineFunction: #put_SuppressDefaultPolicy:
			argumentTypes: 'int32';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

