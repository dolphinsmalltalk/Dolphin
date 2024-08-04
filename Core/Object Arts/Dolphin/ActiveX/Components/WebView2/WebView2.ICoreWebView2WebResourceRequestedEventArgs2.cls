"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2WebResourceRequestedEventArgs
	subclass: #'WebView2.ICoreWebView2WebResourceRequestedEventArgs2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2WebResourceRequestedEventArgs2 guid: (OS.COM.IID fromString: '{9c562c24-b219-4d7f-92f6-b187fbbadd56}')!

WebView2.ICoreWebView2WebResourceRequestedEventArgs2 comment: '`ICoreWebView2WebResourceRequestedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceRequestedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9c562c24-b219-4d7f-92f6-b187fbbadd56)
]
interface ICoreWebView2WebResourceRequestedEventArgs2 : ICoreWebView2WebResourceRequestedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall RequestedSourceKind(
		[out, retval]COREWEBVIEW2_WEB_RESOURCE_REQUEST_SOURCE_KINDS* RequestedSourceKind);
};
```
'!

!WebView2.ICoreWebView2WebResourceRequestedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2WebResourceRequestedEventArgs2 methodsFor!

get_RequestedSourceKind: requestedSourceKind
	"Private - Get the value of the 'RequestedSourceKind' property of the receiver.

		HRESULT __stdcall RequestedSourceKind(
			[out, retval]COREWEBVIEW2_WEB_RESOURCE_REQUEST_SOURCE_KINDS* RequestedSourceKind);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

printableProperties
	^super printableProperties , #(#requestedSourceKind)! !

!WebView2.ICoreWebView2WebResourceRequestedEventArgs2 categoriesForMethods!
get_RequestedSourceKind:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventArgs2!private! !
printableProperties!printing!private! !
!

!WebView2.ICoreWebView2WebResourceRequestedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceRequestedEventArgs2'
		ICoreWebView2WebResourceRequestedEventArgs2 defineTemplate"

	self
		defineFunction: #get_RequestedSourceKind:
			argumentTypes: 'int32*'
! !

!WebView2.ICoreWebView2WebResourceRequestedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

