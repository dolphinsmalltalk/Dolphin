"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2DownloadOperation'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2DownloadOperation guid: (OS.COM.IID fromString: '{3d6b6cf2-afe1-44c7-a995-c65117714336}')!

WebView2.ICoreWebView2DownloadOperation isEgressOnly: true!

WebView2.ICoreWebView2DownloadOperation comment: '`ICoreWebView2DownloadOperation` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DownloadOperation'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3d6b6cf2-afe1-44c7-a995-c65117714336)
]
interface ICoreWebView2DownloadOperation : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall add_BytesReceivedChanged(
		[in]ICoreWebView2BytesReceivedChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010001)]
	HRESULT __stdcall remove_BytesReceivedChanged(
		[in]EventRegistrationToken token);
	[id(0x60010002)]
	HRESULT __stdcall add_EstimatedEndTimeChanged(
		[in]ICoreWebView2EstimatedEndTimeChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010003)]
	HRESULT __stdcall remove_EstimatedEndTimeChanged(
		[in]EventRegistrationToken token);
	[id(0x60010004)]
	HRESULT __stdcall add_StateChanged(
		[in]ICoreWebView2StateChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010005)]
	HRESULT __stdcall remove_StateChanged(
		[in]EventRegistrationToken token);
	[id(0x60010006), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* uri);
	[id(0x60010007), propget]
	HRESULT __stdcall ContentDisposition(
		[out, retval]LPWSTR* ContentDisposition);
	[id(0x60010008), propget]
	HRESULT __stdcall MimeType(
		[out, retval]LPWSTR* MimeType);
	[id(0x60010009), propget]
	HRESULT __stdcall TotalBytesToReceive(
		[out, retval]__int64* TotalBytesToReceive);
	[id(0x6001000a), propget]
	HRESULT __stdcall BytesReceived(
		[out, retval]__int64* BytesReceived);
	[id(0x6001000b), propget]
	HRESULT __stdcall EstimatedEndTime(
		[out, retval]LPWSTR* EstimatedEndTime);
	[id(0x6001000c), propget]
	HRESULT __stdcall ResultFilePath(
		[out, retval]LPWSTR* ResultFilePath);
	[id(0x6001000d), propget]
	HRESULT __stdcall State(
		[out, retval]COREWEBVIEW2_DOWNLOAD_STATE* downloadState);
	[id(0x6001000e), propget]
	HRESULT __stdcall InterruptReason(
		[out, retval]COREWEBVIEW2_DOWNLOAD_INTERRUPT_REASON* InterruptReason);
	[id(0x6001000f)]
	HRESULT __stdcall Cancel();
	[id(0x60010010)]
	HRESULT __stdcall Pause();
	[id(0x60010011)]
	HRESULT __stdcall Resume();
	[id(0x60010012), propget]
	HRESULT __stdcall CanResume(
		[out, retval]long* CanResume);
};
```
'!

!WebView2.ICoreWebView2DownloadOperation categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2DownloadOperation methodsFor!

Add_BytesReceivedChanged: eventHandler token: token
	"Private - Invoke the add_BytesReceivedChanged() method of the COM object.

		HRESULT __stdcall add_BytesReceivedChanged(
			[in]ICoreWebView2BytesReceivedChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 4 ICoreWebView2BytesReceivedChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

Add_EstimatedEndTimeChanged: eventHandler token: token
	"Private - Invoke the add_EstimatedEndTimeChanged() method of the COM object.

		HRESULT __stdcall add_EstimatedEndTimeChanged(
			[in]ICoreWebView2EstimatedEndTimeChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 6 ICoreWebView2EstimatedEndTimeChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

Add_StateChanged: eventHandler token: token
	"Private - Invoke the add_StateChanged() method of the COM object.

		HRESULT __stdcall add_StateChanged(
			[in]ICoreWebView2StateChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 8 ICoreWebView2StateChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

bytesReceived
	"Answer the <integer> value of the 'BytesReceived' property of the receiver."

	| buf |
	buf := UInt64Bytes new.
	self get_BytesReceived: buf.
	^buf asSignedInteger!

cancel
	"Invoke the Cancel() method of the COM object."

	^self Cancel!

Cancel
	"Private - Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 19>
	^self invalidCall: _failureCode!

canResume
	"Answer the <Boolean> value of the 'CanResume' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_CanResume: buf.
	^buf asBoolean!

contentDisposition
	"Answer the <lpwstr> value of the 'ContentDisposition' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ContentDisposition: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

estimatedEndTime
	"Answer the <DateAndTime> value of the 'EstimatedEndTime' property of the receiver."

	| ptr etc |
	ptr := TaskMemory new.
	self get_EstimatedEndTime: ptr.
	etc := Utf16String fromAddress: ptr.
	ptr free.
	^DateAndTime fromString: etc!

get_BytesReceived: bytesReceived
	"Private - Get the value of the 'BytesReceived' property of the receiver.

		HRESULT __stdcall BytesReceived(
			[out, retval]__int64* BytesReceived);"

	<virtual stdcall: hresult 14 int64*>
	^self invalidCall: _failureCode!

get_CanResume: canResume
	"Private - Get the value of the 'CanResume' property of the receiver.

		HRESULT __stdcall CanResume(
			[out, retval]long* CanResume);"

	<virtual stdcall: hresult 22 int32*>
	^self invalidCall: _failureCode!

get_ContentDisposition: contentDisposition
	"Private - Get the value of the 'ContentDisposition' property of the receiver.

		HRESULT __stdcall ContentDisposition(
			[out, retval]LPWSTR* ContentDisposition);"

	<virtual stdcall: hresult 11 lpwstr*>
	^self invalidCall: _failureCode!

get_EstimatedEndTime: estimatedEndTime
	"Private - Get the value of the 'EstimatedEndTime' property of the receiver.

		HRESULT __stdcall EstimatedEndTime(
			[out, retval]LPWSTR* EstimatedEndTime);"

	<virtual stdcall: hresult 15 lpwstr*>
	^self invalidCall: _failureCode!

get_InterruptReason: interruptReason
	"Private - Get the value of the 'InterruptReason' property of the receiver.

		HRESULT __stdcall InterruptReason(
			[out, retval]COREWEBVIEW2_DOWNLOAD_INTERRUPT_REASON* InterruptReason);"

	<virtual stdcall: hresult 18 int32*>
	^self invalidCall: _failureCode!

get_MimeType: mimeType
	"Private - Get the value of the 'MimeType' property of the receiver.

		HRESULT __stdcall MimeType(
			[out, retval]LPWSTR* MimeType);"

	<virtual stdcall: hresult 12 lpwstr*>
	^self invalidCall: _failureCode!

get_ResultFilePath: resultFilePath
	"Private - Get the value of the 'ResultFilePath' property of the receiver.

		HRESULT __stdcall ResultFilePath(
			[out, retval]LPWSTR* ResultFilePath);"

	<virtual stdcall: hresult 16 lpwstr*>
	^self invalidCall: _failureCode!

get_State: downloadState
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]COREWEBVIEW2_DOWNLOAD_STATE* downloadState);"

	<virtual stdcall: hresult 17 int32*>
	^self invalidCall: _failureCode!

get_TotalBytesToReceive: totalBytesToReceive
	"Private - Get the value of the 'TotalBytesToReceive' property of the receiver.

		HRESULT __stdcall TotalBytesToReceive(
			[out, retval]__int64* TotalBytesToReceive);"

	<virtual stdcall: hresult 13 int64*>
	^self invalidCall: _failureCode!

get_uri: uri
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 10 lpwstr*>
	^self invalidCall: _failureCode!

hasPrintableProperties
	^true!

interruptReason
	"Answer the COREWEBVIEW2_DOWNLOAD_INTERRUPT_REASON enum value of the 'InterruptReason' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_InterruptReason: buf.
	^buf asSignedInteger!

interruptReasonName
	^(#('None' 'FileFailed' 'FileAccessDenied' 'FileNoSpace' 'FileNameTooLong' 'FileTooLarge' 'FileMalicious' 'FileTransientError' 'FileBlockedByPolicy' 'FileSecurityCheckFailed' 'FileTooShort' 'FileHashMismatch' 'NetworkFailed' 'NetworkTimeout' 'NetworkDisconnected' 'NetworkServerDown' 'NetworkInvalidRequest' 'ServerFailed' 'ServerNoRange' 'ServerBadContent' 'ServerUnauthorized' 'ServerCertificateProblem' 'ServerForbidden' 'ServerUnexpectedResponse' 'ServerContentLengthMismatch' 'ServerCrossOriginRedirect' 'UserCanceled' 'UserShutdown' 'UserPaused' 'DownloadProcessCrashed')
		lookup: self interruptReason + 1) ?? 'Unknown'!

isFinished
	| state |
	state := self state.
	^state == COREWEBVIEW2_DOWNLOAD_STATE_COMPLETED
		or: [state == COREWEBVIEW2_DOWNLOAD_STATE_INTERRUPTED and: [self canResume not]]!

mimeType
	"Answer the <lpwstr> value of the 'MimeType' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_MimeType: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

pause
	"Invoke the Pause() method of the COM object."

	^self Pause!

Pause
	"Private - Invoke the Pause() method of the COM object.

		HRESULT __stdcall Pause();"

	<virtual stdcall: hresult 20>
	^self invalidCall: _failureCode!

percentComplete
	| total |
	total := self totalBytesToReceive.
	^total == 0 ifTrue: [0] ifFalse: [(self bytesReceived / total * 100) rounded]!

printableProperties
	| propertyNames state |
	propertyNames := OrderedCollection
				withAll: #(#stateName #mimeType #contentDisposition #bytesReceived).
	state := self state.
	state == COREWEBVIEW2_DOWNLOAD_STATE_INTERRUPTED
		ifTrue: 
			[self totalBytesToReceive = 0 ifFalse: [propertyNames add: #percentComplete].
			propertyNames addAll: #(#interruptReasonName #canResume)]
		ifFalse: 
			[state == COREWEBVIEW2_DOWNLOAD_STATE_COMPLETED
				ifTrue: [propertyNames addAll: #(#resultFilePath)]
				ifFalse: 
					[self totalBytesToReceive = 0 ifFalse: [propertyNames add: #percentComplete].
					propertyNames add: #estimatedEndTime]].
	^propertyNames!

Remove_BytesReceivedChanged: token
	"Private - Invoke the remove_BytesReceivedChanged() method of the COM object.

		HRESULT __stdcall remove_BytesReceivedChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 5 int64>
	^self invalidCall: _failureCode!

Remove_EstimatedEndTimeChanged: token
	"Private - Invoke the remove_EstimatedEndTimeChanged() method of the COM object.

		HRESULT __stdcall remove_EstimatedEndTimeChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 7 int64>
	^self invalidCall: _failureCode!

Remove_StateChanged: token
	"Private - Invoke the remove_StateChanged() method of the COM object.

		HRESULT __stdcall remove_StateChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 9 int64>
	^self invalidCall: _failureCode!

resultFilePath
	"Answer the <lpwstr> value of the 'ResultFilePath' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ResultFilePath: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

resume
	"Invoke the Resume() method of the COM object."

	^self Resume!

Resume
	"Private - Invoke the Resume() method of the COM object.

		HRESULT __stdcall Resume();"

	<virtual stdcall: hresult 21>
	^self invalidCall: _failureCode!

state
	"Answer the COREWEBVIEW2_DOWNLOAD_STATE enum value of the 'State' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_State: buf.
	^buf asSignedInteger!

stateName
	^(#('In-progress' 'Interrupted' 'Completed') lookup: self state + 1) ?? 'Unknown'!

totalBytesToReceive
	"Answer the <integer> value of the 'TotalBytesToReceive' property of the receiver."

	| buf |
	buf := UInt64Bytes new.
	self get_TotalBytesToReceive: buf.
	^buf asSignedInteger!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2DownloadOperation categoriesForMethods!
Add_BytesReceivedChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
Add_EstimatedEndTimeChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
Add_StateChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
bytesReceived!properties!public! !
cancel!**auto generated**!methods!public! !
Cancel!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
canResume!properties!public! !
contentDisposition!properties!public! !
estimatedEndTime!properties!public! !
get_BytesReceived:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_CanResume:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_ContentDisposition:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_EstimatedEndTime:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_InterruptReason:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_MimeType:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_ResultFilePath:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_State:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_TotalBytesToReceive:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
hasPrintableProperties!printing!private!testing! !
interruptReason!properties!public! !
interruptReasonName!accessing!public! !
isFinished!public!testing! !
mimeType!properties!public! !
pause!**auto generated**!methods!public! !
Pause!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
percentComplete!accessing!public! !
printableProperties!printing!private! !
Remove_BytesReceivedChanged:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
Remove_EstimatedEndTimeChanged:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
Remove_StateChanged:!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
resultFilePath!properties!public! !
resume!**auto generated**!methods!public! !
Resume!**auto generated**!COM Interfaces-ICoreWebView2DownloadOperation!private! !
state!properties!public! !
stateName!accessing!public! !
totalBytesToReceive!properties!public! !
uri!properties!public! !
!

!WebView2.ICoreWebView2DownloadOperation class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DownloadOperation'
		ICoreWebView2DownloadOperation defineTemplate"

	self
		defineFunction: #Add_BytesReceivedChanged:token:
			argumentTypes: 'ICoreWebView2BytesReceivedChangedEventHandler* sqword*';
		defineFunction: #Remove_BytesReceivedChanged:
			argumentTypes: 'sqword';
		defineFunction: #Add_EstimatedEndTimeChanged:token:
			argumentTypes: 'ICoreWebView2EstimatedEndTimeChangedEventHandler* sqword*';
		defineFunction: #Remove_EstimatedEndTimeChanged:
			argumentTypes: 'sqword';
		defineFunction: #Add_StateChanged:token:
			argumentTypes: 'ICoreWebView2StateChangedEventHandler* sqword*';
		defineFunction: #Remove_StateChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_ContentDisposition:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_MimeType:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_TotalBytesToReceive:
			argumentTypes: 'sqword*';
		defineFunction: #get_BytesReceived:
			argumentTypes: 'sqword*';
		defineFunction: #get_EstimatedEndTime:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_ResultFilePath:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #get_InterruptReason:
			argumentTypes: 'sdword*';
		defineFunction: #Cancel;
		defineFunction: #Pause;
		defineFunction: #Resume;
		defineFunction: #get_CanResume:
			argumentTypes: 'sdword*'
! !

!WebView2.ICoreWebView2DownloadOperation class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

