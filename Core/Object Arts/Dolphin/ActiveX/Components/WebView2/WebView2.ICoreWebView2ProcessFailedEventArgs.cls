"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2ProcessFailedEventArgs'
	instanceVariableNames: 'handled'
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

exitCode
	"Answer the <sdword> value of the 'ExitCode' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_ExitCode: answer.
	^answer asObject!

frameInfosForFailedProcess
	"Answer the <ICoreWebView2FrameInfoCollection> value of the 'FrameInfosForFailedProcess' property of the receiver."

	| answer |
	answer := ICoreWebView2FrameInfoCollection newPointer.
	self get_FrameInfosForFailedProcess: answer.
	^answer asObject!

get_ExitCode: exitCode
	^E_NOTIMPL!

get_FrameInfosForFailedProcess: frames
	^E_NOTIMPL!

get_ProcessDescription: processDescription
	^E_NOTIMPL!

get_ProcessFailedKind: processFailedKind
	"Private - Get the value of the 'ProcessFailedKind' property of the receiver.

		HRESULT __stdcall ProcessFailedKind(
			[out, retval]COREWEBVIEW2_PROCESS_FAILED_KIND* ProcessFailedKind);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_reason: reason
	^E_NOTIMPL!

handled
	^handled!

handled: anObject
	handled := anObject!

isBrowserProcessExit
	^self processFailedKind = COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED!

printableProperties
	| propertyNames failureKind desc |
	propertyNames := OrderedCollection withAll: #(#processFailedKind).
	propertyNames addLast: #exitCode.
	desc := self processDescription.
	(desc notNil and: [desc notEmpty]) ifTrue: [propertyNames add: #processDescription].
	failureKind := self processFailedKind.
	failureKind = COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED
		ifFalse: [propertyNames add: #reason].
	failureKind = COREWEBVIEW2_PROCESS_FAILED_KIND_FRAME_RENDER_PROCESS_EXITED
		ifTrue: [propertyNames addLast: #frameInfosForFailedProcess].
	^propertyNames!

processDescription
	"Answer the <lpwstr> value of the 'ProcessDescription' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ProcessDescription: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

processFailedKind
	"Answer the <sdword> value of the 'ProcessFailedKind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_ProcessFailedKind: answer.
	^answer asObject!

reason
	"Answer the <sdword> value of the 'reason' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_reason: answer.
	^answer asObject! !
!WebView2.ICoreWebView2ProcessFailedEventArgs categoriesForMethods!
exitCode!properties!public! !
frameInfosForFailedProcess!properties!public! !
get_ExitCode:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
get_FrameInfosForFailedProcess:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
get_ProcessDescription:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
get_ProcessFailedKind:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs!private! !
get_reason:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
handled!accessing!public! !
handled:!accessing!public! !
isBrowserProcessExit!public!testing! !
printableProperties!printing!private! !
processDescription!properties!public! !
processFailedKind!**auto generated**!properties!public! !
reason!properties!public! !
!

!WebView2.ICoreWebView2ProcessFailedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessFailedEventArgs'
		ICoreWebView2ProcessFailedEventArgs defineTemplate"

	self
		defineFunction: #get_ProcessFailedKind:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2ProcessFailedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

