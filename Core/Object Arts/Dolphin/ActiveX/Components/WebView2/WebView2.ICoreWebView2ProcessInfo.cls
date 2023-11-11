"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2ProcessInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'KindNames'
				-> #('BROWSER' 'RENDERER' 'UTILITY' 'SANDBOX_HELPER' 'GPU' 'PPAPI_PLUGIN' 'PPAPI_BROKER')
		}!
WebView2.ICoreWebView2ProcessInfo guid: (OS.COM.IID fromString: '{84fa7612-3f3d-4fbf-889d-fad000492d72}')!
WebView2.ICoreWebView2ProcessInfo isEgressOnly: true!
WebView2.ICoreWebView2ProcessInfo comment: '`ICoreWebView2ProcessInfo` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessInfo'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(84fa7612-3f3d-4fbf-889d-fad000492d72)
]
interface ICoreWebView2ProcessInfo : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ProcessId(
		[out, retval]int* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_PROCESS_KIND* Kind);
};
```
'!
!WebView2.ICoreWebView2ProcessInfo categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ProcessInfo methodsFor!

ClearBrowsingData: dataKinds handler: handler
	"Private - Invoke the ClearBrowsingData() method of the COM object.

		HRESULT __stdcall ClearBrowsingData(
			[in]COREWEBVIEW2_BROWSING_DATA_KINDS dataKinds,
			[in]ICoreWebView2ClearBrowsingDataCompletedHandler* handler);"

	<virtual stdcall: hresult 11 int32 ICoreWebView2ClearBrowsingDataCompletedHandler*>
	^self invalidCall: _failureCode!

ClearBrowsingDataAll: handler
	"Private - Invoke the ClearBrowsingDataAll() method of the COM object.

		HRESULT __stdcall ClearBrowsingDataAll(
			[in]ICoreWebView2ClearBrowsingDataCompletedHandler* handler);"

	<virtual stdcall: hresult 13 ICoreWebView2ClearBrowsingDataCompletedHandler*>
	^self invalidCall: _failureCode!

ClearBrowsingDataInTimeRange: dataKinds startTime: startTime endTime: endTime handler: handler
	"Private - Invoke the ClearBrowsingDataInTimeRange() method of the COM object.

		HRESULT __stdcall ClearBrowsingDataInTimeRange(
			[in]COREWEBVIEW2_BROWSING_DATA_KINDS dataKinds,
			[in]double startTime,
			[in]double endTime,
			[in]ICoreWebView2ClearBrowsingDataCompletedHandler* handler);"

	<virtual stdcall: hresult 12 int32 double double ICoreWebView2ClearBrowsingDataCompletedHandler*>
	^self invalidCall: _failureCode!

get_Kind: kind
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_PROCESS_KIND* Kind);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

get_ProcessId: value
	"Private - Get the value of the 'ProcessId' property of the receiver.

		HRESULT __stdcall ProcessId(
			[out, retval]int* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

kind
	"Answer the <sdword> value of the 'Kind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Kind: answer.
	^answer asObject!

kindName
	^(KindNames lookup: self kind + 1) ?? '(Unknown process kind)'!

printableProperties
	^#(#kindName #processId)!

processId
	"Answer the <sdword> value of the 'ProcessId' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_ProcessId: answer.
	^answer asObject! !
!WebView2.ICoreWebView2ProcessInfo categoriesForMethods!
ClearBrowsingData:handler:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
ClearBrowsingDataAll:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
ClearBrowsingDataInTimeRange:startTime:endTime:handler:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2ProcessInfo!private! !
get_ProcessId:!**auto generated**!COM Interfaces-ICoreWebView2ProcessInfo!private! !
kind!**auto generated**!properties!public! !
kindName!properties!public! !
printableProperties!printing!private! !
processId!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2ProcessInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessInfo'
		ICoreWebView2ProcessInfo defineTemplate"

	self
		defineFunction: #get_ProcessId:
			argumentTypes: 'sdword*';
		defineFunction: #get_Kind:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2ProcessInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

