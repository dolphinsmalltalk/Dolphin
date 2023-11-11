"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Profile2
	subclass: #'WebView2.ICoreWebView2Profile3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Profile3 guid: (OS.COM.IID fromString: '{b188e659-5685-4e05-bdba-fc640e0f1992}')!
WebView2.ICoreWebView2Profile3 isEgressOnly: true!
WebView2.ICoreWebView2Profile3 comment: '`ICoreWebView2Profile3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b188e659-5685-4e05-bdba-fc640e0f1992)
]
interface ICoreWebView2Profile3 : ICoreWebView2Profile2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall PreferredTrackingPreventionLevel(
		[out, retval]COREWEBVIEW2_TRACKING_PREVENTION_LEVEL* value);
	[id(0x60030000), propput]
	HRESULT __stdcall PreferredTrackingPreventionLevel(
		[in]COREWEBVIEW2_TRACKING_PREVENTION_LEVEL value);
};
```
'!
!WebView2.ICoreWebView2Profile3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Profile3 methodsFor!

get_PreferredTrackingPreventionLevel: value
	"Private - Get the value of the 'PreferredTrackingPreventionLevel' property of the receiver.

		HRESULT __stdcall PreferredTrackingPreventionLevel(
			[out, retval]COREWEBVIEW2_TRACKING_PREVENTION_LEVEL* value);"

	<virtual stdcall: hresult 14 int32*>
	^self invalidCall: _failureCode!

put_PreferredTrackingPreventionLevel: value
	"Private - Set the value of the 'PreferredTrackingPreventionLevel' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall PreferredTrackingPreventionLevel(
			[in]COREWEBVIEW2_TRACKING_PREVENTION_LEVEL value);"

	<virtual stdcall: hresult 15 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Profile3 categoriesForMethods!
get_PreferredTrackingPreventionLevel:!**auto generated**!COM Interfaces-ICoreWebView2Profile3!private! !
put_PreferredTrackingPreventionLevel:!**auto generated**!COM Interfaces-ICoreWebView2Profile3!private! !
!

!WebView2.ICoreWebView2Profile3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile3'
		ICoreWebView2Profile3 defineTemplate"

	self
		defineFunction: #get_PreferredTrackingPreventionLevel:
			argumentTypes: 'int32*';
		defineFunction: #put_PreferredTrackingPreventionLevel:
			argumentTypes: 'int32'
! !
!WebView2.ICoreWebView2Profile3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

