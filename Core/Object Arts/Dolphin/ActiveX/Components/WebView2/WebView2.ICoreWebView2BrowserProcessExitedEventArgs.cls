"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2BrowserProcessExitedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2BrowserProcessExitedEventArgs guid: (OS.COM.IID fromString: '{1f00663f-af8c-4782-9cdd-dd01c52e34cb}')!

WebView2.ICoreWebView2BrowserProcessExitedEventArgs isEgressOnly: true!

WebView2.ICoreWebView2BrowserProcessExitedEventArgs comment: '`ICoreWebView2BrowserProcessExitedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BrowserProcessExitedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(1f00663f-af8c-4782-9cdd-dd01c52e34cb)
]
interface ICoreWebView2BrowserProcessExitedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall BrowserProcessExitKind(
		[out, retval]COREWEBVIEW2_BROWSER_PROCESS_EXIT_KIND* BrowserProcessExitKind);
	[id(0x60010001), propget]
	HRESULT __stdcall BrowserProcessId(
		[out, retval]unsigned int* value);
};
```
'!

!WebView2.ICoreWebView2BrowserProcessExitedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2BrowserProcessExitedEventArgs methodsFor!

browserProcessExitKind
	"Answer the COREWEBVIEW2_BROWSER_PROCESS_EXIT_KIND enumeration value of the 'BrowserProcessExitKind' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_BrowserProcessExitKind: buf.
	^buf asSignedInteger!

browserProcessId
	"Answer the unsigned <integer> value of the 'BrowserProcessId' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_BrowserProcessId: buf.
	^buf asInteger!

get_BrowserProcessExitKind: browserProcessExitKind
	"Private - Get the value of the 'BrowserProcessExitKind' property of the receiver.

		HRESULT __stdcall BrowserProcessExitKind(
			[out, retval]COREWEBVIEW2_BROWSER_PROCESS_EXIT_KIND* BrowserProcessExitKind);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_BrowserProcessId: value
	"Private - Get the value of the 'BrowserProcessId' property of the receiver.

		HRESULT __stdcall BrowserProcessId(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 5 uint32*>
	^self invalidCall: _failureCode!

isNormalExit
	^self browserProcessExitKind == COREWEBVIEW2_BROWSER_PROCESS_EXIT_KIND_NORMAL!

printableProperties
	^#(#browserProcessExitKind #browserProcessId)! !

!WebView2.ICoreWebView2BrowserProcessExitedEventArgs categoriesForMethods!
browserProcessExitKind!properties!public! !
browserProcessId!properties!public! !
get_BrowserProcessExitKind:!**auto generated**!COM Interfaces-ICoreWebView2BrowserProcessExitedEventArgs!private! !
get_BrowserProcessId:!**auto generated**!COM Interfaces-ICoreWebView2BrowserProcessExitedEventArgs!private! !
isNormalExit!properties!public! !
printableProperties!printing!private! !
!

!WebView2.ICoreWebView2BrowserProcessExitedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BrowserProcessExitedEventArgs'
		ICoreWebView2BrowserProcessExitedEventArgs defineTemplate"

	self
		defineFunction: #get_BrowserProcessExitKind:
			argumentTypes: 'sdword*';
		defineFunction: #get_BrowserProcessId:
			argumentTypes: 'dword*'
! !

!WebView2.ICoreWebView2BrowserProcessExitedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

