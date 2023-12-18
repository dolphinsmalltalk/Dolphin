"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Frame4
	subclass: #'WebView2.ICoreWebView2Frame5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Frame5 guid: (OS.COM.IID fromString: '{99d199c4-7305-11ee-b962-0242ac120002}')!
WebView2.ICoreWebView2Frame5 isEgressOnly: true!
WebView2.ICoreWebView2Frame5 comment: '`ICoreWebView2Frame5` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Frame5'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(99d199c4-7305-11ee-b962-0242ac120002)
]
interface ICoreWebView2Frame5 : ICoreWebView2Frame4
 {
	[id(0x60050000), propget]
	HRESULT __stdcall FrameId(
		[out, retval]unsigned int* id);
};
```
'!
!WebView2.ICoreWebView2Frame5 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Frame5 methodsFor!

get_FrameId: id
	"Private - Get the value of the 'FrameId' property of the receiver.

		HRESULT __stdcall FrameId(
			[out, retval]unsigned int* id);"

	<virtual stdcall: hresult 28 uint32*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Frame5 categoriesForMethods!
get_FrameId:!**auto generated**!COM Interfaces-ICoreWebView2Frame5!private! !
!

!WebView2.ICoreWebView2Frame5 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame5'
		ICoreWebView2Frame5 defineTemplate"

	self
		defineFunction: #get_FrameId:
			argumentTypes: 'uint32*'
! !
!WebView2.ICoreWebView2Frame5 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

