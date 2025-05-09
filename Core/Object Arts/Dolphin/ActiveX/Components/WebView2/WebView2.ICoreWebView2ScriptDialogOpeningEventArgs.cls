﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2ScriptDialogOpeningEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ScriptDialogOpeningEventArgs guid: (OS.COM.IID fromString: '{7390bb70-abe0-4843-9529-f143b31b03d6}')!

WebView2.ICoreWebView2ScriptDialogOpeningEventArgs isEgressOnly: true!

WebView2.ICoreWebView2ScriptDialogOpeningEventArgs comment: '`ICoreWebView2ScriptDialogOpeningEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ScriptDialogOpeningEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7390bb70-abe0-4843-9529-f143b31b03d6)
]
interface ICoreWebView2ScriptDialogOpeningEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* uri);
	[id(0x60010001), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_SCRIPT_DIALOG_KIND* Kind);
	[id(0x60010002), propget]
	HRESULT __stdcall Message(
		[out, retval]LPWSTR* Message);
	[id(0x60010003)]
	HRESULT __stdcall Accept();
	[id(0x60010004), propget]
	HRESULT __stdcall DefaultText(
		[out, retval]LPWSTR* DefaultText);
	[id(0x60010005), propget]
	HRESULT __stdcall ResultText(
		[out, retval]LPWSTR* ResultText);
	[id(0x60010005), propput]
	HRESULT __stdcall ResultText(
		[in]LPWSTR ResultText);
	[id(0x60010007)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!

!WebView2.ICoreWebView2ScriptDialogOpeningEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ScriptDialogOpeningEventArgs methodsFor!

accept
	"Invoke the Accept() method of the COM object."

	^self Accept!

Accept
	"Private - Invoke the Accept() method of the COM object.

		HRESULT __stdcall Accept();"

	<virtual stdcall: hresult 7>
	^self invalidCall: _failureCode!

defaultText
	"Answer the <lpwstr> value of the 'DefaultText' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_DefaultText: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

get_DefaultText: defaultText
	"Private - Get the value of the 'DefaultText' property of the receiver.

		HRESULT __stdcall DefaultText(
			[out, retval]LPWSTR* DefaultText);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

get_Kind: kind
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_SCRIPT_DIALOG_KIND* Kind);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

get_Message: message
	"Private - Get the value of the 'Message' property of the receiver.

		HRESULT __stdcall Message(
			[out, retval]LPWSTR* Message);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_ResultText: resultText
	"Private - Get the value of the 'ResultText' property of the receiver.

		HRESULT __stdcall ResultText(
			[out, retval]LPWSTR* ResultText);"

	<virtual stdcall: hresult 9 lpwstr*>
	^self invalidCall: _failureCode!

get_uri: uri
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 11 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

kind
	"Answer the COREWEBVIEW2_SCRIPT_DIALOG_KIND enum value of the 'Kind' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_Kind: buf.
	^buf asSignedInteger!

message
	"Answer the <lpwstr> value of the 'Message' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Message: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

put_ResultText: resultText
	"Private - Set the value of the 'ResultText' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, resultText.

		HRESULT __stdcall ResultText(
			[in]LPWSTR ResultText);"

	<virtual stdcall: hresult 10 lpwstr>
	^self invalidCall: _failureCode!

resultText
	"Answer the <lpwstr> value of the 'ResultText' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ResultText: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

resultText: resultText
	"Set the 'ResultText' property of the receiver to the <lpwstr> value of the argument."

	self put_ResultText: resultText asUtf16String!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2ScriptDialogOpeningEventArgs categoriesForMethods!
accept!**auto generated**!methods!public! !
Accept!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
defaultText!properties!public! !
get_DefaultText:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
get_Message:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
get_ResultText:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
kind!properties!public! !
message!properties!public! !
put_ResultText:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventArgs!private! !
resultText!properties!public! !
resultText:!**auto generated**!properties!public! !
uri!properties!public! !
!

!WebView2.ICoreWebView2ScriptDialogOpeningEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ScriptDialogOpeningEventArgs'
		ICoreWebView2ScriptDialogOpeningEventArgs defineTemplate"

	self
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Kind:
			argumentTypes: 'sdword*';
		defineFunction: #get_Message:
			argumentTypes: 'lpwstr*';
		defineFunction: #Accept;
		defineFunction: #get_DefaultText:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_ResultText:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_ResultText:
			argumentTypes: 'lpwstr';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !

!WebView2.ICoreWebView2ScriptDialogOpeningEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

