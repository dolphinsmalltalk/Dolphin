"Filed out from Dolphin Smalltalk"!

ICoreWebView2Profile subclass: #ICoreWebView2Profile2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2Profile2 guid: (IID fromString: '{fa740d4b-5eae-4344-a8ad-74be31925397}')!
ICoreWebView2Profile2 comment: '`ICoreWebView2Profile2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fa740d4b-5eae-4344-a8ad-74be31925397)
]
interface ICoreWebView2Profile2 : ICoreWebView2Profile
 {
	[id(0x60020000)]
	HRESULT __stdcall ClearBrowsingData(
		[in]COREWEBVIEW2_BROWSING_DATA_KINDS dataKinds,
		[in]ICoreWebView2ClearBrowsingDataCompletedHandler* handler);
	[id(0x60020001)]
	HRESULT __stdcall ClearBrowsingDataInTimeRange(
		[in]COREWEBVIEW2_BROWSING_DATA_KINDS dataKinds,
		[in]double startTime,
		[in]double endTime,
		[in]ICoreWebView2ClearBrowsingDataCompletedHandler* handler);
	[id(0x60020002)]
	HRESULT __stdcall ClearBrowsingDataAll(
		[in]ICoreWebView2ClearBrowsingDataCompletedHandler* handler);
};
```
'!
!ICoreWebView2Profile2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Profile2 methodsFor!

clearBrowsingData: dataKinds from: startTime to: endTime thenDo: aMonadicValuable
	"Clear browsing data of the kinds indicated by the flags in the <integer> dataKinds argument in a range specified by the <DateAndTime> startTime and endTime arguments. When done invoke the <monadicValuable> argument passing an integer HRESULT indicating success/failure."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2ClearBrowsingDataCompletedHandler.
	self
		ClearBrowsingDataInTimeRange: dataKinds
		startTime: startTime asUnixTime asFloat
		endTime: endTime asUnixTime asFloat
		handler: handler.
	handler free!

ClearBrowsingData: dataKinds handler: handler
	"Private - Invoke the ClearBrowsingData() method of the COM object.

		HRESULT __stdcall ClearBrowsingData(
			[in]COREWEBVIEW2_BROWSING_DATA_KINDS dataKinds,
			[in]ICoreWebView2ClearBrowsingDataCompletedHandler* handler);"

	<virtual stdcall: hresult 11 sdword ICoreWebView2ClearBrowsingDataCompletedHandler*>
	^self invalidCall: _failureCode!

clearBrowsingData: dataKinds thenDo: aMonadicValuable
	"Clear browsing data of the kinds indicated by the flags in the <integer> dataKinds argument and when done invoke the <monadicValuable> argument passing an integer HRESULT indicating success/failure."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2ClearBrowsingDataCompletedHandler.
	self ClearBrowsingData: dataKinds handler: handler.
	handler free!

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

	<virtual stdcall: hresult 12 sdword double double ICoreWebView2ClearBrowsingDataCompletedHandler*>
	^self invalidCall: _failureCode!

clearBrowsingDataThenDo: aMonadicValuable
	"Clear all browsing data (history, cookies, etc) and when done invoke the <monadicValuable> argument passing an integer HRESULT indicating success/failure."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2ClearBrowsingDataCompletedHandler.
	self ClearBrowsingDataAll: handler.
	handler free! !
!ICoreWebView2Profile2 categoriesForMethods!
clearBrowsingData:from:to:thenDo:!methods!public! !
ClearBrowsingData:handler:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
clearBrowsingData:thenDo:!methods!public! !
ClearBrowsingDataAll:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
ClearBrowsingDataInTimeRange:startTime:endTime:handler:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
clearBrowsingDataThenDo:!methods!public! !
!

!ICoreWebView2Profile2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile2'
		ICoreWebView2Profile2 defineTemplate"

	self
		defineFunction: #ClearBrowsingData:handler:
			argumentTypes: 'sdword ICoreWebView2ClearBrowsingDataCompletedHandler*';
		defineFunction: #ClearBrowsingDataInTimeRange:startTime:endTime:handler:
			argumentTypes: 'sdword double double ICoreWebView2ClearBrowsingDataCompletedHandler*';
		defineFunction: #ClearBrowsingDataAll:
			argumentTypes: 'ICoreWebView2ClearBrowsingDataCompletedHandler*'
! !
!ICoreWebView2Profile2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

