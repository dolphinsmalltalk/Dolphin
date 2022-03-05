"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2ProcessInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2ProcessInfo guid: (IID fromString: '{84fa7612-3f3d-4fbf-889d-fad000492d72}')!
ICoreWebView2ProcessInfo comment: '`ICoreWebView2ProcessInfo` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessInfo'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(84fa7612-3f3d-4fbf-889d-fad000492d72)
]
interface ICoreWebView2ProcessInfo : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ProcessId(
		[out, retval]int* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_PROCESS_KIND* Kind);
};
```
'!
!ICoreWebView2ProcessInfo categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ProcessInfo methodsFor!

get_Kind: kind
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_PROCESS_KIND* Kind);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

get_ProcessId: value
	"Private - Get the value of the 'ProcessId' property of the receiver.

		HRESULT __stdcall ProcessId(
			[out, retval]int* value);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

kind
	"Answer the <sdword> value of the 'Kind' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Kind: answer.
	^answer asObject!

printableProperties
	^#(#kind #processId)!

processId
	"Answer the <sdword> value of the 'ProcessId' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ProcessId: answer.
	^answer asObject! !
!ICoreWebView2ProcessInfo categoriesForMethods!
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2ProcessInfo!private! !
get_ProcessId:!**auto generated**!COM Interfaces-ICoreWebView2ProcessInfo!private! !
kind!**auto generated**!properties!public! !
printableProperties!printing!private! !
processId!**auto generated**!properties!public! !
!

!ICoreWebView2ProcessInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessInfo'
		ICoreWebView2ProcessInfo defineTemplate"

	self
		defineFunction: #get_ProcessId:
			argumentTypes: 'sdword*';
		defineFunction: #get_Kind:
			argumentTypes: 'sdword*'
! !
!ICoreWebView2ProcessInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

