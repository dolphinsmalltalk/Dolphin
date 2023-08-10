"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2NavigationStartingEventArgs2
	subclass: #'WebView2.ICoreWebView2NavigationStartingEventArgs3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2NavigationStartingEventArgs3 guid: (OS.COM.IID fromString: '{ddffe494-4942-4bd2-ab73-35b8ff40e19f}')!
WebView2.ICoreWebView2NavigationStartingEventArgs3 comment: '`ICoreWebView2NavigationStartingEventArgs3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationStartingEventArgs3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ddffe494-4942-4bd2-ab73-35b8ff40e19f)
]
interface ICoreWebView2NavigationStartingEventArgs3 : ICoreWebView2NavigationStartingEventArgs2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall NavigationKind(
		[out, retval]COREWEBVIEW2_NAVIGATION_KIND* navigation_kind);
};
```
'!
!WebView2.ICoreWebView2NavigationStartingEventArgs3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2NavigationStartingEventArgs3 methodsFor!

get_NavigationKind: navigation_kind
	"Private - Get the value of the 'NavigationKind' property of the receiver.

		HRESULT __stdcall NavigationKind(
			[out, retval]COREWEBVIEW2_NAVIGATION_KIND* navigation_kind);"

	<virtual stdcall: hresult 13 int32*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2NavigationStartingEventArgs3 categoriesForMethods!
get_NavigationKind:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs3!private! !
!

!WebView2.ICoreWebView2NavigationStartingEventArgs3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationStartingEventArgs3'
		ICoreWebView2NavigationStartingEventArgs3 defineTemplate"

	self
		defineFunction: #get_NavigationKind:
			argumentTypes: 'int32*'
! !
!WebView2.ICoreWebView2NavigationStartingEventArgs3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

