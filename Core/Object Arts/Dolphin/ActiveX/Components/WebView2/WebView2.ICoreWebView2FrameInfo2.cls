"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FrameInfo
	subclass: #'WebView2.ICoreWebView2FrameInfo2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2FrameInfo2 guid: (OS.COM.IID fromString: '{56f85cfa-72c4-11ee-b962-0242ac120002}')!
WebView2.ICoreWebView2FrameInfo2 isEgressOnly: true!
WebView2.ICoreWebView2FrameInfo2 comment: '`ICoreWebView2FrameInfo2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameInfo2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(56f85cfa-72c4-11ee-b962-0242ac120002)
]
interface ICoreWebView2FrameInfo2 : ICoreWebView2FrameInfo
 {
	[id(0x60020000), propget]
	HRESULT __stdcall ParentFrameInfo(
		[out, retval]ICoreWebView2FrameInfo** frameInfo);
	[id(0x60020001), propget]
	HRESULT __stdcall FrameId(
		[out, retval]unsigned int* id);
	[id(0x60020002), propget]
	HRESULT __stdcall FrameKind(
		[out, retval]COREWEBVIEW2_FRAME_KIND* Kind);
};
```
'!
!WebView2.ICoreWebView2FrameInfo2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2FrameInfo2 methodsFor!

get_FrameId: id
	"Private - Get the value of the 'FrameId' property of the receiver.

		HRESULT __stdcall FrameId(
			[out, retval]unsigned int* id);"

	<virtual stdcall: hresult 7 uint32*>
	^self invalidCall: _failureCode!

get_FrameKind: kind
	"Private - Get the value of the 'FrameKind' property of the receiver.

		HRESULT __stdcall FrameKind(
			[out, retval]COREWEBVIEW2_FRAME_KIND* Kind);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

get_ParentFrameInfo: frameInfo
	"Private - Get the value of the 'ParentFrameInfo' property of the receiver.

		HRESULT __stdcall ParentFrameInfo(
			[out, retval]ICoreWebView2FrameInfo** frameInfo);"

	<virtual stdcall: hresult 6 ICoreWebView2FrameInfo**>
	^self invalidCall: _failureCode!

printableProperties
	^#(#frameId #name #kindName #source)! !
!WebView2.ICoreWebView2FrameInfo2 categoriesForMethods!
get_FrameId:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfo2!private! !
get_FrameKind:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfo2!private! !
get_ParentFrameInfo:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfo2!private! !
printableProperties!printing!public! !
!

!WebView2.ICoreWebView2FrameInfo2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameInfo2'
		ICoreWebView2FrameInfo2 defineTemplate"

	self
		defineFunction: #get_ParentFrameInfo:
			argumentTypes: 'ICoreWebView2FrameInfo**';
		defineFunction: #get_FrameId:
			argumentTypes: 'uint32*';
		defineFunction: #get_FrameKind:
			argumentTypes: 'int32*'
! !
!WebView2.ICoreWebView2FrameInfo2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

