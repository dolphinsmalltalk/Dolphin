"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EnvironmentOptions3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2EnvironmentOptions3 guid: (OS.COM.IID fromString: '{4a5c436e-a9e3-4a2e-89c3-910d3513f5cc}')!
WebView2.ICoreWebView2EnvironmentOptions3 comment: '`ICoreWebView2EnvironmentOptions3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4a5c436e-a9e3-4a2e-89c3-910d3513f5cc)
]
interface ICoreWebView2EnvironmentOptions3 : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall IsCustomCrashReportingEnabled(
		[out, retval]long* value);
	[id(0x60010000), propput]
	HRESULT __stdcall IsCustomCrashReportingEnabled(
		[in]long value);
};
```
'!
!WebView2.ICoreWebView2EnvironmentOptions3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2EnvironmentOptions3 methodsFor!

get_IsCustomCrashReportingEnabled: value
	"Private - Get the value of the 'IsCustomCrashReportingEnabled' property of the receiver.

		HRESULT __stdcall IsCustomCrashReportingEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

isCustomCrashReportingEnabled
	"Answer the <boolean> value of the 'IsCustomCrashReportingEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsCustomCrashReportingEnabled: answer.
	^answer value!

isCustomCrashReportingEnabled: value
	"Set the 'IsCustomCrashReportingEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsCustomCrashReportingEnabled: value asParameter!

put_IsCustomCrashReportingEnabled: value
	"Private - Set the value of the 'IsCustomCrashReportingEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsCustomCrashReportingEnabled(
			[in]long value);"

	<virtual stdcall: hresult 5 sdword>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2EnvironmentOptions3 categoriesForMethods!
get_IsCustomCrashReportingEnabled:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions3!private! !
isCustomCrashReportingEnabled!properties!public! !
isCustomCrashReportingEnabled:!properties!public! !
put_IsCustomCrashReportingEnabled:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions3!private! !
!

!WebView2.ICoreWebView2EnvironmentOptions3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions3'
		ICoreWebView2EnvironmentOptions3 defineTemplate"

	self
		defineFunction: #get_IsCustomCrashReportingEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsCustomCrashReportingEnabled:
			argumentTypes: 'sdword'
! !
!WebView2.ICoreWebView2EnvironmentOptions3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

