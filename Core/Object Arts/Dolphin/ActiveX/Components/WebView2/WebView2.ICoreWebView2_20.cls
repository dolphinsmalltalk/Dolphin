"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_19
	subclass: #'WebView2.ICoreWebView2_20'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_20 guid: (OS.COM.IID fromString: '{b4bc1926-7305-11ee-b962-0242ac120002}')!
WebView2.ICoreWebView2_20 isEgressOnly: true!
WebView2.ICoreWebView2_20 comment: '`ICoreWebView2_20` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_20'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b4bc1926-7305-11ee-b962-0242ac120002)
]
interface ICoreWebView2_20 : ICoreWebView2_19
 {
	[id(0x60140000), propget]
	HRESULT __stdcall FrameId(
		[out, retval]unsigned int* id);
};
```
'!
!WebView2.ICoreWebView2_20 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_20 methodsFor!

get_FrameId: id
	"Private - Get the value of the 'FrameId' property of the receiver.

		HRESULT __stdcall FrameId(
			[out, retval]unsigned int* id);"

	<virtual stdcall: hresult 122 uint32*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_20 categoriesForMethods!
get_FrameId:!**auto generated**!COM Interfaces-ICoreWebView2_20!private! !
!

!WebView2.ICoreWebView2_20 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_20'
		ICoreWebView2_20 defineTemplate"

	self
		defineFunction: #get_FrameId:
			argumentTypes: 'uint32*'
! !
!WebView2.ICoreWebView2_20 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

