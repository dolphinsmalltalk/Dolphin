"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_18
	subclass: #'WebView2.ICoreWebView2_19'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_19 guid: (OS.COM.IID fromString: '{6921f954-79b0-437f-a997-c85811897c68}')!
WebView2.ICoreWebView2_19 comment: '`ICoreWebView2_19` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_19'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(6921f954-79b0-437f-a997-c85811897c68)
]
interface ICoreWebView2_19 : ICoreWebView2_18
 {
	[id(0x60130000), propget]
	HRESULT __stdcall MemoryUsageTargetLevel(
		[out, retval]COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL* level);
	[id(0x60130000), propput]
	HRESULT __stdcall MemoryUsageTargetLevel(
		[in]COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL level);
};
```
'!
!WebView2.ICoreWebView2_19 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_19 methodsFor!

get_MemoryUsageTargetLevel: level
	"Private - Get the value of the 'MemoryUsageTargetLevel' property of the receiver.

		HRESULT __stdcall MemoryUsageTargetLevel(
			[out, retval]COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL* level);"

	<virtual stdcall: hresult 120 int32*>
	^self invalidCall: _failureCode!

put_MemoryUsageTargetLevel: level
	"Private - Set the value of the 'MemoryUsageTargetLevel' property of the object wrapped by the 
	 receiver to the <int32> argument, level.

		HRESULT __stdcall MemoryUsageTargetLevel(
			[in]COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL level);"

	<virtual stdcall: hresult 121 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_19 categoriesForMethods!
get_MemoryUsageTargetLevel:!**auto generated**!COM Interfaces-ICoreWebView2_19!private! !
put_MemoryUsageTargetLevel:!**auto generated**!COM Interfaces-ICoreWebView2_19!private! !
!

!WebView2.ICoreWebView2_19 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_19'
		ICoreWebView2_19 defineTemplate"

	self
		defineFunction: #get_MemoryUsageTargetLevel:
			argumentTypes: 'int32*';
		defineFunction: #put_MemoryUsageTargetLevel:
			argumentTypes: 'int32'
! !
!WebView2.ICoreWebView2_19 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

