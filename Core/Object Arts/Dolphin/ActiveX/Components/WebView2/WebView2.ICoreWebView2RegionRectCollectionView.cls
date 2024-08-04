"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Sequence
	subclass: #'WebView2.ICoreWebView2RegionRectCollectionView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2RegionRectCollectionView guid: (OS.COM.IID fromString: '{333353b8-48bf-4449-8fcc-22697faf5753}')!

WebView2.ICoreWebView2RegionRectCollectionView comment: '`ICoreWebView2RegionRectCollectionView` is a wrapper class for the COM interface ''WebView2.ICoreWebView2RegionRectCollectionView'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(333353b8-48bf-4449-8fcc-22697faf5753)
]
interface ICoreWebView2RegionRectCollectionView : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* value);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]RECT* value);
};
```
'!

!WebView2.ICoreWebView2RegionRectCollectionView categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2RegionRectCollectionView methodsFor!

at: anInteger
	| answer |
	answer := self elementClass newBuffer.
	self GetValueAtIndex: anInteger - 1 value: answer.
	^answer!

elementClass
	^RECTL!

GetValueAtIndex: index value: value
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]RECT* value);"

	<virtual stdcall: hresult 5 uint32 RECTL*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2RegionRectCollectionView categoriesForMethods!
at:!accessing!public! !
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2RegionRectCollectionView!private! !
!

!WebView2.ICoreWebView2RegionRectCollectionView class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2RegionRectCollectionView'
		ICoreWebView2RegionRectCollectionView defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'uint32*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'uint32 RECTL*'
! !

!WebView2.ICoreWebView2RegionRectCollectionView class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

