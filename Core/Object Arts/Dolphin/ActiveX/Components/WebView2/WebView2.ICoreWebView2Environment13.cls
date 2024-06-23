"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment12
	subclass: #'WebView2.ICoreWebView2Environment13'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Environment13 guid: (OS.COM.IID fromString: '{af641f58-72b2-11ee-b962-0242ac120002}')!

WebView2.ICoreWebView2Environment13 isEgressOnly: true!

WebView2.ICoreWebView2Environment13 comment: '`ICoreWebView2Environment13` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment13'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(af641f58-72b2-11ee-b962-0242ac120002)
]
interface ICoreWebView2Environment13 : ICoreWebView2Environment12
 {
	[id(0x600d0000)]
	HRESULT __stdcall GetProcessExtendedInfos(
		[in]ICoreWebView2GetProcessExtendedInfosCompletedHandler* handler);
};
```
'!

!WebView2.ICoreWebView2Environment13 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Environment13 methodsFor!

GetProcessExtendedInfos: handler
	"Invoke the GetProcessExtendedInfos() method of the COM object.

		HRESULT __stdcall GetProcessExtendedInfos(
			[in]ICoreWebView2GetProcessExtendedInfosCompletedHandler* handler);"

	<virtual stdcall: hresult 26 ICoreWebView2GetProcessExtendedInfosCompletedHandler*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Environment13 categoriesForMethods!
GetProcessExtendedInfos:!**auto generated**!COM Interfaces-ICoreWebView2Environment13!public! !
!

!WebView2.ICoreWebView2Environment13 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment13'
		ICoreWebView2Environment13 defineTemplate"

	self
		defineFunction: #GetProcessExtendedInfos:
			argumentTypes: 'ICoreWebView2GetProcessExtendedInfosCompletedHandler*'
! !

!WebView2.ICoreWebView2Environment13 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

