"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_22
	subclass: #'WebView2.ICoreWebView2_23'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_23 guid: (OS.COM.IID fromString: '{508f0db5-90c4-5872-90a7-267a91377502}')!

WebView2.ICoreWebView2_23 comment: '`ICoreWebView2_23` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_23'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(508f0db5-90c4-5872-90a7-267a91377502)
]
interface ICoreWebView2_23 : ICoreWebView2_22
 {
	[id(0x60170000)]
	HRESULT __stdcall PostWebMessageAsJsonWithAdditionalObjects(
		[in]LPWSTR webMessageAsJson,
		[in]ICoreWebView2ObjectCollectionView* additionalObjects);
};
```
'!

!WebView2.ICoreWebView2_23 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_23 methodsFor!

PostWebMessageAsJsonWithAdditionalObjects: webMessageAsJson additionalObjects: additionalObjects
	"Private - Invoke the PostWebMessageAsJsonWithAdditionalObjects() method of the COM object.

		HRESULT __stdcall PostWebMessageAsJsonWithAdditionalObjects(
			[in]LPWSTR webMessageAsJson,
			[in]ICoreWebView2ObjectCollectionView* additionalObjects);"

	<virtual stdcall: hresult 126 lpwstr ICoreWebView2ObjectCollectionView*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_23 categoriesForMethods!
PostWebMessageAsJsonWithAdditionalObjects:additionalObjects:!**auto generated**!COM Interfaces-ICoreWebView2_23!private! !
!

!WebView2.ICoreWebView2_23 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_23'
		ICoreWebView2_23 defineTemplate"

	self
		defineFunction: #PostWebMessageAsJsonWithAdditionalObjects:additionalObjects:
			argumentTypes: 'lpwstr ICoreWebView2ObjectCollectionView*'
! !

!WebView2.ICoreWebView2_23 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

