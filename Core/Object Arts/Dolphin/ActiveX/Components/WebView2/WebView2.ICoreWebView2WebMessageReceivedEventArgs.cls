"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2WebMessageReceivedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WebMessageReceivedEventArgs guid: (OS.COM.IID fromString: '{0f99a40c-e962-4207-9e92-e3d542eff849}')!
WebView2.ICoreWebView2WebMessageReceivedEventArgs comment: '`ICoreWebView2WebMessageReceivedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebMessageReceivedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0f99a40c-e962-4207-9e92-e3d542eff849)
]
interface ICoreWebView2WebMessageReceivedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Source(
		[out, retval]LPWSTR* Source);
	[id(0x60010001), propget]
	HRESULT __stdcall webMessageAsJson(
		[out, retval]LPWSTR* webMessageAsJson);
	[id(0x60010002)]
	HRESULT __stdcall TryGetWebMessageAsString(
		[out, retval]LPWSTR* webMessageAsString);
};
```
'!
!WebView2.ICoreWebView2WebMessageReceivedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WebMessageReceivedEventArgs methodsFor!

additionalObjects
	"Answer the <ICoreWebView2ObjectCollectionView> value of the 'AdditionalObjects' property of the receiver."

	| answer |
	answer := ICoreWebView2ObjectCollectionView newPointer.
	self get_AdditionalObjects: answer.
	^answer asObject!

get_AdditionalObjects: value
	"Private - Get the value of the 'AdditionalObjects' property of the receiver.

		HRESULT __stdcall AdditionalObjects(
			[out, retval]ICoreWebView2ObjectCollectionView** value);"

	^E_NOTIMPL!

get_Source: source
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]LPWSTR* Source);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_webMessageAsJson: webMessageAsJson
	"Private - Get the value of the 'webMessageAsJson' property of the receiver.

		HRESULT __stdcall webMessageAsJson(
			[out, retval]LPWSTR* webMessageAsJson);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

source
	"Answer the <lpwstr> value of the 'Source' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Source: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

tryGetWebMessageAsString
	"Answer the <Utf16String> result of invoking the TryGetWebMessageAsString() method of the COM object."

	| ptr answer |
	ptr := TaskMemory new.
	self TryGetWebMessageAsString: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

TryGetWebMessageAsString: webMessageAsString
	"Private - Invoke the TryGetWebMessageAsString() method of the COM object.

		HRESULT __stdcall TryGetWebMessageAsString(
			[out, retval]LPWSTR* webMessageAsString);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

webMessageAsJson
	"Answer the <lpwstr> value of the 'webMessageAsJson' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_webMessageAsJson: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!WebView2.ICoreWebView2WebMessageReceivedEventArgs categoriesForMethods!
additionalObjects!properties!public! !
get_AdditionalObjects:!COM Interfaces-ICoreWebView2WebMessageReceivedEventArgs2!private! !
get_Source:!**auto generated**!COM Interfaces-ICoreWebView2WebMessageReceivedEventArgs!private! !
get_webMessageAsJson:!**auto generated**!COM Interfaces-ICoreWebView2WebMessageReceivedEventArgs!private! !
source!properties!public! !
tryGetWebMessageAsString!methods!public! !
TryGetWebMessageAsString:!**auto generated**!COM Interfaces-ICoreWebView2WebMessageReceivedEventArgs!private! !
webMessageAsJson!properties!public! !
!

!WebView2.ICoreWebView2WebMessageReceivedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebMessageReceivedEventArgs'
		ICoreWebView2WebMessageReceivedEventArgs defineTemplate"

	self
		defineFunction: #get_Source:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_webMessageAsJson:
			argumentTypes: 'lpwstr*';
		defineFunction: #TryGetWebMessageAsString:
			argumentTypes: 'lpwstr*'
! !
!WebView2.ICoreWebView2WebMessageReceivedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

