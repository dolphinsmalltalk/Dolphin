"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2NewWindowRequestedEventArgs2
	subclass: #'WebView2.ICoreWebView2NewWindowRequestedEventArgs3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2NewWindowRequestedEventArgs3 guid: (OS.COM.IID fromString: '{842bed3c-6ad6-4dd9-b938-28c96667ad66}')!
WebView2.ICoreWebView2NewWindowRequestedEventArgs3 isEgressOnly: true!
WebView2.ICoreWebView2NewWindowRequestedEventArgs3 comment: '`ICoreWebView2NewWindowRequestedEventArgs3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewWindowRequestedEventArgs3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(842bed3c-6ad6-4dd9-b938-28c96667ad66)
]
interface ICoreWebView2NewWindowRequestedEventArgs3 : ICoreWebView2NewWindowRequestedEventArgs2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall OriginalSourceFrameInfo(
		[out, retval]ICoreWebView2FrameInfo** frameInfo);
};
```
'!
!WebView2.ICoreWebView2NewWindowRequestedEventArgs3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2NewWindowRequestedEventArgs3 methodsFor!

get_OriginalSourceFrameInfo: frameInfo
	"Private - Get the value of the 'OriginalSourceFrameInfo' property of the receiver.

		HRESULT __stdcall OriginalSourceFrameInfo(
			[out, retval]ICoreWebView2FrameInfo** frameInfo);"

	<virtual stdcall: hresult 13 ICoreWebView2FrameInfo**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2NewWindowRequestedEventArgs3 categoriesForMethods!
get_OriginalSourceFrameInfo:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs3!private! !
!

!WebView2.ICoreWebView2NewWindowRequestedEventArgs3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewWindowRequestedEventArgs3'
		ICoreWebView2NewWindowRequestedEventArgs3 defineTemplate"

	self
		defineFunction: #get_OriginalSourceFrameInfo:
			argumentTypes: 'ICoreWebView2FrameInfo**'
! !
!WebView2.ICoreWebView2NewWindowRequestedEventArgs3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

