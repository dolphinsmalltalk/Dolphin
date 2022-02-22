"Filed out from Dolphin Smalltalk"!

ICoreWebView2Controller2 subclass: #ICoreWebView2Controller3
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.WebView2Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2Controller3 guid: (OS.COM.IID fromString: '{f9614724-5d2b-41dc-aef7-73d62b51543b}')!
ICoreWebView2Controller3 comment: '`ICoreWebView2Controller3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Controller3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f9614724-5d2b-41dc-aef7-73d62b51543b)
]
interface ICoreWebView2Controller3 : ICoreWebView2Controller2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall RasterizationScale(
		[out, retval]double* scale);
	[id(0x60030000), propput]
	HRESULT __stdcall RasterizationScale(
		[in]double scale);
	[id(0x60030002), propget]
	HRESULT __stdcall ShouldDetectMonitorScaleChanges(
		[out, retval]long* value);
	[id(0x60030002), propput]
	HRESULT __stdcall ShouldDetectMonitorScaleChanges(
		[in]long value);
	[id(0x60030004)]
	HRESULT __stdcall add_RasterizationScaleChanged(
		[in]ICoreWebView2RasterizationScaleChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60030005)]
	HRESULT __stdcall remove_RasterizationScaleChanged(
		[in]EventRegistrationToken token);
	[id(0x60030006), propget]
	HRESULT __stdcall BoundsMode(
		[out, retval]COREWEBVIEW2_BOUNDS_MODE* BoundsMode);
	[id(0x60030006), propput]
	HRESULT __stdcall BoundsMode(
		[in]COREWEBVIEW2_BOUNDS_MODE BoundsMode);
};
```
'!
!ICoreWebView2Controller3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Controller3 methodsFor!

Add_RasterizationScaleChanged: eventHandler token: token
	"Private - Invoke the add_RasterizationScaleChanged() method of the COM object.

		HRESULT __stdcall add_RasterizationScaleChanged(
			[in]ICoreWebView2RasterizationScaleChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 33 ICoreWebView2RasterizationScaleChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

get_BoundsMode: boundsMode
	"Private - Get the value of the 'BoundsMode' property of the receiver.

		HRESULT __stdcall BoundsMode(
			[out, retval]COREWEBVIEW2_BOUNDS_MODE* BoundsMode);"

	<virtual stdcall: hresult 35 sdword*>
	^self invalidCall: _failureCode!

get_RasterizationScale: scale
	"Private - Get the value of the 'RasterizationScale' property of the receiver.

		HRESULT __stdcall RasterizationScale(
			[out, retval]double* scale);"

	<virtual stdcall: hresult 29 double*>
	^self invalidCall: _failureCode!

get_ShouldDetectMonitorScaleChanges: value
	"Private - Get the value of the 'ShouldDetectMonitorScaleChanges' property of the receiver.

		HRESULT __stdcall ShouldDetectMonitorScaleChanges(
			[out, retval]long* value);"

	<virtual stdcall: hresult 31 sdword*>
	^self invalidCall: _failureCode!

put_BoundsMode: boundsMode
	"Private - Set the value of the 'BoundsMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, boundsMode.

		HRESULT __stdcall BoundsMode(
			[in]COREWEBVIEW2_BOUNDS_MODE BoundsMode);"

	<virtual stdcall: hresult 36 sdword>
	^self invalidCall: _failureCode!

put_RasterizationScale: scale
	"Private - Set the value of the 'RasterizationScale' property of the object wrapped by the 
	 receiver to the <double> argument, scale.

		HRESULT __stdcall RasterizationScale(
			[in]double scale);"

	<virtual stdcall: hresult 30 double>
	^self invalidCall: _failureCode!

put_ShouldDetectMonitorScaleChanges: value
	"Private - Set the value of the 'ShouldDetectMonitorScaleChanges' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ShouldDetectMonitorScaleChanges(
			[in]long value);"

	<virtual stdcall: hresult 32 sdword>
	^self invalidCall: _failureCode!

Remove_RasterizationScaleChanged: token
	"Private - Invoke the remove_RasterizationScaleChanged() method of the COM object.

		HRESULT __stdcall remove_RasterizationScaleChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 34 sqword>
	^self invalidCall: _failureCode! !
!ICoreWebView2Controller3 categoriesForMethods!
Add_RasterizationScaleChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
get_BoundsMode:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
get_RasterizationScale:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
get_ShouldDetectMonitorScaleChanges:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
put_BoundsMode:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
put_RasterizationScale:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
put_ShouldDetectMonitorScaleChanges:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
Remove_RasterizationScaleChanged:!**auto generated**!COM Interfaces-ICoreWebView2Controller3!private! !
!

!ICoreWebView2Controller3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Controller3'
		ICoreWebView2Controller3 defineTemplate"

	self
		defineFunction: #get_RasterizationScale:
			argumentTypes: 'double*';
		defineFunction: #put_RasterizationScale:
			argumentTypes: 'double';
		defineFunction: #get_ShouldDetectMonitorScaleChanges:
			argumentTypes: 'sdword*';
		defineFunction: #put_ShouldDetectMonitorScaleChanges:
			argumentTypes: 'sdword';
		defineFunction: #Add_RasterizationScaleChanged:token:
			argumentTypes: 'ICoreWebView2RasterizationScaleChangedEventHandler* sqword*';
		defineFunction: #Remove_RasterizationScaleChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_BoundsMode:
			argumentTypes: 'sdword*';
		defineFunction: #put_BoundsMode:
			argumentTypes: 'sdword'
! !
!ICoreWebView2Controller3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

