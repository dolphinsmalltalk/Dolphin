"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2ProcessFailedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ProcessFailedEventArgs guid: (OS.COM.IID fromString: '{8155a9a4-1474-4a86-8cae-151b0fa6b8ca}')!
WebView2.ICoreWebView2ProcessFailedEventArgs comment: '`ICoreWebView2ProcessFailedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessFailedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(8155a9a4-1474-4a86-8cae-151b0fa6b8ca)
]
interface ICoreWebView2ProcessFailedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ProcessFailedKind(
		[out, retval]COREWEBVIEW2_PROCESS_FAILED_KIND* ProcessFailedKind);
};
```
'!
!WebView2.ICoreWebView2ProcessFailedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ProcessFailedEventArgs methodsFor!

get_ProcessFailedKind: processFailedKind
	"Private - Get the value of the 'ProcessFailedKind' property of the receiver.

		HRESULT __stdcall ProcessFailedKind(
			[out, retval]COREWEBVIEW2_PROCESS_FAILED_KIND* ProcessFailedKind);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

processFailedKind
	"Answer the <sdword> value of the 'ProcessFailedKind' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ProcessFailedKind: answer.
	^answer asObject! !
!WebView2.ICoreWebView2ProcessFailedEventArgs categoriesFor: #get_ProcessFailedKind:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs!private! !
!WebView2.ICoreWebView2ProcessFailedEventArgs categoriesFor: #processFailedKind!**auto generated**!properties!public! !

!WebView2.ICoreWebView2ProcessFailedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessFailedEventArgs'
		ICoreWebView2ProcessFailedEventArgs defineTemplate"

	self
		defineFunction: #get_ProcessFailedKind:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2ProcessFailedEventArgs class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

