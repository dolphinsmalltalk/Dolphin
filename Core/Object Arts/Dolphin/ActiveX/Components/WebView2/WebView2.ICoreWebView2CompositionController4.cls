"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompositionController3
	subclass: #'WebView2.ICoreWebView2CompositionController4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2CompositionController4 guid: (OS.COM.IID fromString: '{7c367b9b-3d2b-450f-9e58-d61a20f486aa}')!

WebView2.ICoreWebView2CompositionController4 comment: '`ICoreWebView2CompositionController4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CompositionController4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7c367b9b-3d2b-450f-9e58-d61a20f486aa)
]
interface ICoreWebView2CompositionController4 : ICoreWebView2CompositionController3
 {
	[id(0x60040000)]
	HRESULT __stdcall GetNonClientRegionAtPoint(
		[in]POINT point,
		[out, retval]COREWEBVIEW2_NON_CLIENT_REGION_KIND* value);
	[id(0x60040001)]
	HRESULT __stdcall QueryNonClientRegion(
		[in]COREWEBVIEW2_NON_CLIENT_REGION_KIND Kind,
		[out, retval]ICoreWebView2RegionRectCollectionView** rects);
	[id(0x60040002)]
	HRESULT __stdcall add_NonClientRegionChanged(
		[in]ICoreWebView2NonClientRegionChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60040003)]
	HRESULT __stdcall remove_NonClientRegionChanged(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2CompositionController4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2CompositionController4 methodsFor!

Add_NonClientRegionChanged: eventHandler token: token
	"Private - Invoke the add_NonClientRegionChanged() method of the COM object.

		HRESULT __stdcall add_NonClientRegionChanged(
			[in]ICoreWebView2NonClientRegionChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 19 ICoreWebView2NonClientRegionChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

getNonClientRegionAtPoint: point
	"Answer the <int32> result of invoking the GetNonClientRegionAtPoint() method of the COM object."

	| answer |
	answer := Int32 new.
	self GetNonClientRegionAtPoint: point value: answer.
	^answer asObject!

GetNonClientRegionAtPoint: point value: value
	"Private - Invoke the GetNonClientRegionAtPoint() method of the COM object.

		HRESULT __stdcall GetNonClientRegionAtPoint(
			[in]POINT point,
			[out, retval]COREWEBVIEW2_NON_CLIENT_REGION_KIND* value);"

	<virtual stdcall: hresult 17 POINTL int32*>
	^self invalidCall: _failureCode!

queryNonClientRegion: kind
	"Answer the <ICoreWebView2RegionRectCollectionView> result of invoking the QueryNonClientRegion() method of the COM object."

	| answer |
	answer := ICoreWebView2RegionRectCollectionView newPointer.
	self QueryNonClientRegion: kind rects: answer.
	^answer asObject!

QueryNonClientRegion: kind rects: rects
	"Private - Invoke the QueryNonClientRegion() method of the COM object.

		HRESULT __stdcall QueryNonClientRegion(
			[in]COREWEBVIEW2_NON_CLIENT_REGION_KIND Kind,
			[out, retval]ICoreWebView2RegionRectCollectionView** rects);"

	<virtual stdcall: hresult 18 int32 ICoreWebView2RegionRectCollectionView**>
	^self invalidCall: _failureCode!

Remove_NonClientRegionChanged: token
	"Private - Invoke the remove_NonClientRegionChanged() method of the COM object.

		HRESULT __stdcall remove_NonClientRegionChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 20 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2CompositionController4 categoriesForMethods!
Add_NonClientRegionChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController4!events!private! !
getNonClientRegionAtPoint:!**auto generated**!methods!public! !
GetNonClientRegionAtPoint:value:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController4!private! !
queryNonClientRegion:!**auto generated**!methods!public! !
QueryNonClientRegion:rects:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController4!private! !
Remove_NonClientRegionChanged:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController4!events!private! !
!

!WebView2.ICoreWebView2CompositionController4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CompositionController4'
		ICoreWebView2CompositionController4 defineTemplate"

	self
		defineFunction: #GetNonClientRegionAtPoint:value:
			argumentTypes: 'POINTL int32*';
		defineFunction: #QueryNonClientRegion:rects:
			argumentTypes: 'int32 ICoreWebView2RegionRectCollectionView**';
		defineFunction: #Add_NonClientRegionChanged:token:
			argumentTypes: 'ICoreWebView2NonClientRegionChangedEventHandler* int64*';
		defineFunction: #Remove_NonClientRegionChanged:
			argumentTypes: 'int64'
! !

!WebView2.ICoreWebView2CompositionController4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

