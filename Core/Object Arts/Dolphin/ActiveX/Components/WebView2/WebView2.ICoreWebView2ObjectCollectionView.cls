"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Sequence
	subclass: #'WebView2.ICoreWebView2ObjectCollectionView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ObjectCollectionView guid: (OS.COM.IID fromString: '{0f36fd87-4f69-4415-98da-888f89fb9a33}')!
WebView2.ICoreWebView2ObjectCollectionView comment: '`ICoreWebView2ObjectCollectionView` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ObjectCollectionView'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0f36fd87-4f69-4415-98da-888f89fb9a33)
]
interface ICoreWebView2ObjectCollectionView : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* value);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]IUnknown** value);
};
```
'!
!WebView2.ICoreWebView2ObjectCollectionView categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ObjectCollectionView methodsFor!

elementClass
	^IUnknown!

GetValueAtIndex: index value: value
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]IUnknown** value);"

	<virtual stdcall: hresult 5 uint32 IUnknown**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ObjectCollectionView categoriesForMethods!
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ObjectCollectionView!private! !
!

!WebView2.ICoreWebView2ObjectCollectionView class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ObjectCollectionView'
		ICoreWebView2ObjectCollectionView defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'uint32*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'uint32 IUnknown**'
! !
!WebView2.ICoreWebView2ObjectCollectionView class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

