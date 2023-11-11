"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment10
	subclass: #'WebView2.ICoreWebView2Environment11'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Environment11 guid: (OS.COM.IID fromString: '{f0913dc6-a0ec-42ef-9805-91dff3a2966a}')!
WebView2.ICoreWebView2Environment11 isEgressOnly: true!
WebView2.ICoreWebView2Environment11 comment: '`ICoreWebView2Environment11` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment11'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f0913dc6-a0ec-42ef-9805-91dff3a2966a)
]
interface ICoreWebView2Environment11 : ICoreWebView2Environment10
 {
	[id(0x600b0000), propget]
	HRESULT __stdcall FailureReportFolderPath(
		[out, retval]LPWSTR* value);
};
```
'!
!WebView2.ICoreWebView2Environment11 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Environment11 methodsFor!

get_FailureReportFolderPath: value
	"Private - Get the value of the 'FailureReportFolderPath' property of the receiver.

		HRESULT __stdcall FailureReportFolderPath(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 24 lpwstr*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Environment11 categoriesForMethods!
get_FailureReportFolderPath:!**auto generated**!COM Interfaces-ICoreWebView2Environment11!private! !
!

!WebView2.ICoreWebView2Environment11 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment11'
		ICoreWebView2Environment11 defineTemplate"

	self
		defineFunction: #get_FailureReportFolderPath:
			argumentTypes: 'lpwstr*'
! !
!WebView2.ICoreWebView2Environment11 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

