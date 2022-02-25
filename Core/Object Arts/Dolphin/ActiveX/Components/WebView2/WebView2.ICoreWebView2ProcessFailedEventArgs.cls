"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventArgs subclass: #ICoreWebView2ProcessFailedEventArgs
	instanceVariableNames: 'handled'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2ProcessFailedEventArgs guid: (OS.COM.IID fromString: '{8155a9a4-1474-4a86-8cae-151b0fa6b8ca}')!
ICoreWebView2ProcessFailedEventArgs comment: '`ICoreWebView2ProcessFailedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessFailedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2ProcessFailedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ProcessFailedEventArgs methodsFor!

get_ProcessFailedKind: processFailedKind
	"Private - Get the value of the 'ProcessFailedKind' property of the receiver.

		HRESULT __stdcall ProcessFailedKind(
			[out, retval]COREWEBVIEW2_PROCESS_FAILED_KIND* ProcessFailedKind);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

handled
	^handled!

handled: anObject
	handled := anObject!

isBrowserProcessExit
	^self processFailedKind = WebView2.COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED!

printableProperties
	^#(#processFailedKind)!

processFailedKind
	"Answer the <sdword> value of the 'ProcessFailedKind' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ProcessFailedKind: answer.
	^answer asObject! !
!ICoreWebView2ProcessFailedEventArgs categoriesForMethods!
get_ProcessFailedKind:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs!private! !
handled!accessing!public! !
handled:!accessing!public! !
isBrowserProcessExit!public!testing! !
printableProperties!development!printing!private! !
processFailedKind!**auto generated**!properties!public! !
!

!ICoreWebView2ProcessFailedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessFailedEventArgs'
		ICoreWebView2ProcessFailedEventArgs defineTemplate"

	self
		defineFunction: #get_ProcessFailedKind:
			argumentTypes: 'sdword*'
! !
!ICoreWebView2ProcessFailedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

