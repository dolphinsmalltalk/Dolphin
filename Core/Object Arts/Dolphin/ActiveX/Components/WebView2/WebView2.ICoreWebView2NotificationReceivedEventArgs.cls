"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2NotificationReceivedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NotificationReceivedEventArgs guid: (OS.COM.IID fromString: '{1512dd5b-5514-4f85-886e-21c3a4c9cfe6}')!

WebView2.ICoreWebView2NotificationReceivedEventArgs comment: '`ICoreWebView2NotificationReceivedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NotificationReceivedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(1512dd5b-5514-4f85-886e-21c3a4c9cfe6)
]
interface ICoreWebView2NotificationReceivedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall SenderOrigin(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Notification(
		[out, retval]ICoreWebView2Notification** value);
	[id(0x60010002), propput]
	HRESULT __stdcall Handled(
		[in]long value);
	[id(0x60010002), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* value);
	[id(0x60010004)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!

!WebView2.ICoreWebView2NotificationReceivedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NotificationReceivedEventArgs methodsFor!

get_Handled: value
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 7 int32*>
	^self invalidCall: _failureCode!

get_Notification: value
	"Private - Get the value of the 'Notification' property of the receiver.

		HRESULT __stdcall Notification(
			[out, retval]ICoreWebView2Notification** value);"

	<virtual stdcall: hresult 5 ICoreWebView2Notification**>
	^self invalidCall: _failureCode!

get_SenderOrigin: value
	"Private - Get the value of the 'SenderOrigin' property of the receiver.

		HRESULT __stdcall SenderOrigin(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 8 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

notification
	"Answer the <ICoreWebView2Notification> value of the 'Notification' property of the receiver."

	| answer |
	answer := ICoreWebView2Notification newPointer.
	self get_Notification: answer.
	^answer asObject!

printableProperties
	^#(#notification #senderOrigin)!

put_Handled: value
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall Handled(
			[in]long value);"

	<virtual stdcall: hresult 6 int32>
	^self invalidCall: _failureCode!

senderOrigin
	"Answer the <lpwstr> value of the 'SenderOrigin' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_SenderOrigin: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2NotificationReceivedEventArgs categoriesForMethods!
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2NotificationReceivedEventArgs!private! !
get_Notification:!**auto generated**!COM Interfaces-ICoreWebView2NotificationReceivedEventArgs!private! !
get_SenderOrigin:!**auto generated**!COM Interfaces-ICoreWebView2NotificationReceivedEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2NotificationReceivedEventArgs!private! !
notification!**auto generated**!properties!public! !
printableProperties!printing!private! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2NotificationReceivedEventArgs!private! !
senderOrigin!properties!public! !
!

!WebView2.ICoreWebView2NotificationReceivedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NotificationReceivedEventArgs'
		ICoreWebView2NotificationReceivedEventArgs defineTemplate"

	self
		defineFunction: #get_SenderOrigin:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Notification:
			argumentTypes: 'ICoreWebView2Notification**';
		defineFunction: #put_Handled:
			argumentTypes: 'int32';
		defineFunction: #get_Handled:
			argumentTypes: 'int32*';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !

!WebView2.ICoreWebView2NotificationReceivedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

