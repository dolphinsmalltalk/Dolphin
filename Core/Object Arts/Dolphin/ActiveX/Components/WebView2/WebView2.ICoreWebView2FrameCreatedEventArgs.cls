﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2FrameCreatedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameCreatedEventArgs guid: (OS.COM.IID fromString: '{4d6e7b5e-9baa-11eb-a8b3-0242ac130003}')!

WebView2.ICoreWebView2FrameCreatedEventArgs isEgressOnly: true!

WebView2.ICoreWebView2FrameCreatedEventArgs comment: '`ICoreWebView2FrameCreatedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameCreatedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4d6e7b5e-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameCreatedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Frame(
		[out, retval]ICoreWebView2Frame** Frame);
};
```
'!

!WebView2.ICoreWebView2FrameCreatedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameCreatedEventArgs methodsFor!

frame
	"Answer the <ICoreWebView2Frame> value of the 'Frame' property of the receiver."

	| answer |
	answer := ICoreWebView2Frame newPointer.
	self get_Frame: answer.
	^answer downCast!

get_Frame: frame
	"Private - Get the value of the 'Frame' property of the receiver.

		HRESULT __stdcall Frame(
			[out, retval]ICoreWebView2Frame** Frame);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame**>
	^self invalidCall: _failureCode!

printableProperties
	^#(#frame)! !

!WebView2.ICoreWebView2FrameCreatedEventArgs categoriesForMethods!
frame!properties!public! !
get_Frame:!**auto generated**!COM Interfaces-ICoreWebView2FrameCreatedEventArgs!private! !
printableProperties!printing!private! !
!

!WebView2.ICoreWebView2FrameCreatedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameCreatedEventArgs'
		ICoreWebView2FrameCreatedEventArgs defineTemplate"

	self
		defineFunction: #get_Frame:
			argumentTypes: 'ICoreWebView2Frame**'
! !

!WebView2.ICoreWebView2FrameCreatedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

