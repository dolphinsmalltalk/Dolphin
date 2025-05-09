﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Profile
	subclass: #'WebView2.ICoreWebView2Profile2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Profile2 guid: (OS.COM.IID fromString: '{fa740d4b-5eae-4344-a8ad-74be31925397}')!

WebView2.ICoreWebView2Profile2 isEgressOnly: true!

WebView2.ICoreWebView2Profile2 comment: '`ICoreWebView2Profile2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!WebView2.ICoreWebView2Profile2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Profile2 methodsFor!

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
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Profile2 categoriesForMethods!
ClearBrowsingData:handler:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
ClearBrowsingDataAll:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
ClearBrowsingDataInTimeRange:startTime:endTime:handler:!**auto generated**!COM Interfaces-ICoreWebView2Profile2!private! !
!

!WebView2.ICoreWebView2Profile2 class methodsFor!

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

!WebView2.ICoreWebView2Profile2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

