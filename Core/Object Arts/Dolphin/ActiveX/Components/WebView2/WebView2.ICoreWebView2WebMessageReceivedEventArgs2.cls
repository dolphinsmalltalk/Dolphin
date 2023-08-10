"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2WebMessageReceivedEventArgs
	subclass: #'WebView2.ICoreWebView2WebMessageReceivedEventArgs2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WebMessageReceivedEventArgs2 guid: (OS.COM.IID fromString: '{06fc7ab7-c90c-4297-9389-33ca01cf6d5e}')!
WebView2.ICoreWebView2WebMessageReceivedEventArgs2 comment: '`ICoreWebView2WebMessageReceivedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebMessageReceivedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(06fc7ab7-c90c-4297-9389-33ca01cf6d5e)
]
interface ICoreWebView2WebMessageReceivedEventArgs2 : ICoreWebView2WebMessageReceivedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall AdditionalObjects(
		[out, retval]ICoreWebView2ObjectCollectionView** value);
};
```
'!
!WebView2.ICoreWebView2WebMessageReceivedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WebMessageReceivedEventArgs2 methodsFor!

get_AdditionalObjects: value
	"Private - Get the value of the 'AdditionalObjects' property of the receiver.

		HRESULT __stdcall AdditionalObjects(
			[out, retval]ICoreWebView2ObjectCollectionView** value);"

	<virtual stdcall: hresult 7 ICoreWebView2ObjectCollectionView**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2WebMessageReceivedEventArgs2 categoriesForMethods!
get_AdditionalObjects:!**auto generated**!COM Interfaces-ICoreWebView2WebMessageReceivedEventArgs2!private! !
!

!WebView2.ICoreWebView2WebMessageReceivedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebMessageReceivedEventArgs2'
		ICoreWebView2WebMessageReceivedEventArgs2 defineTemplate"

	self
		defineFunction: #get_AdditionalObjects:
			argumentTypes: 'ICoreWebView2ObjectCollectionView**'
! !
!WebView2.ICoreWebView2WebMessageReceivedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

