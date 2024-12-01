"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2BrowserExtension'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2BrowserExtension guid: (OS.COM.IID fromString: '{7ef7ffa0-fac5-462c-b189-3d9edbe575da}')!

WebView2.ICoreWebView2BrowserExtension isEgressOnly: true!

WebView2.ICoreWebView2BrowserExtension comment: '`ICoreWebView2BrowserExtension` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BrowserExtension'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7ef7ffa0-fac5-462c-b189-3d9edbe575da)
]
interface ICoreWebView2BrowserExtension : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall id(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* value);
	[id(0x60010002)]
	HRESULT __stdcall Remove(
		[in]ICoreWebView2BrowserExtensionRemoveCompletedHandler* handler);
	[id(0x60010003), propget]
	HRESULT __stdcall IsEnabled(
		[out, retval]long* value);
	[id(0x60010004)]
	HRESULT __stdcall Enable(
		[in]long IsEnabled,
		[in]ICoreWebView2BrowserExtensionEnableCompletedHandler* handler);
};
```
'!

!WebView2.ICoreWebView2BrowserExtension categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2BrowserExtension methodsFor!

Enable: isEnabled handler: handler
	"Invoke the Enable() method of the COM object.

		HRESULT __stdcall Enable(
			[in]long IsEnabled,
			[in]ICoreWebView2BrowserExtensionEnableCompletedHandler* handler);"

	<virtual stdcall: hresult 8 int32 ICoreWebView2BrowserExtensionEnableCompletedHandler*>
	^self invalidCall: _failureCode!

enable: aBoolean thenDo: aMonadicValuable
	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2BrowserExtensionEnableCompletedHandler.
	self Enable: aBoolean asParameter handler: handler.
	handler free!

get_id: value
	"Private - Get the value of the 'id' property of the receiver.

		HRESULT __stdcall id(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_IsEnabled: value
	"Private - Get the value of the 'IsEnabled' property of the receiver.

		HRESULT __stdcall IsEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 7 int32*>
	^self invalidCall: _failureCode!

get_name: value
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

id
	"Answer the <lpwstr> value of the 'id' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_id: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

isEnabled
	"Answer the <boolean> value of the 'IsEnabled' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsEnabled: buf.
	^buf asBoolean!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printableProperties
	^#(#name #isEnabled)!

Remove: handler
	"Invoke the Remove() method of the COM object.

		HRESULT __stdcall Remove(
			[in]ICoreWebView2BrowserExtensionRemoveCompletedHandler* handler);"

	<virtual stdcall: hresult 6 ICoreWebView2BrowserExtensionRemoveCompletedHandler*>
	^self invalidCall: _failureCode!

removeThenDo: aMonadicValuable
	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2BrowserExtensionRemoveCompletedHandler.
	self Remove: handler.
	handler free! !

!WebView2.ICoreWebView2BrowserExtension categoriesForMethods!
Enable:handler:!**auto generated**!COM Interfaces-ICoreWebView2BrowserExtension!public! !
enable:thenDo:!async requests!public! !
get_id:!**auto generated**!COM Interfaces-ICoreWebView2BrowserExtension!private! !
get_IsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2BrowserExtension!private! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2BrowserExtension!private! !
id!properties!public! !
isEnabled!properties!public! !
name!properties!public! !
printableProperties!printing!private! !
Remove:!**auto generated**!COM Interfaces-ICoreWebView2BrowserExtension!public! !
removeThenDo:!async requests!public! !
!

!WebView2.ICoreWebView2BrowserExtension class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BrowserExtension'
		ICoreWebView2BrowserExtension defineTemplate"

	self
		defineFunction: #get_id:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*';
		defineFunction: #Remove:
			argumentTypes: 'ICoreWebView2BrowserExtensionRemoveCompletedHandler*';
		defineFunction: #get_IsEnabled:
			argumentTypes: 'int32*';
		defineFunction: #Enable:handler:
			argumentTypes: 'int32 ICoreWebView2BrowserExtensionEnableCompletedHandler*'
! !

!WebView2.ICoreWebView2BrowserExtension class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

