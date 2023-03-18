"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2Profile'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Profile guid: (OS.COM.IID fromString: '{79110ad3-cd5d-4373-8bc3-c60658f17a5f}')!
WebView2.ICoreWebView2Profile comment: '`ICoreWebView2Profile` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(79110ad3-cd5d-4373-8bc3-c60658f17a5f)
]
interface ICoreWebView2Profile : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ProfileName(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall IsInPrivateModeEnabled(
		[out, retval]long* value);
	[id(0x60010002), propget]
	HRESULT __stdcall ProfilePath(
		[out, retval]LPWSTR* value);
	[id(0x60010003), propget]
	HRESULT __stdcall DefaultDownloadFolderPath(
		[out, retval]LPWSTR* value);
	[id(0x60010003), propput]
	HRESULT __stdcall DefaultDownloadFolderPath(
		[in]LPWSTR value);
	[id(0x60010005), propget]
	HRESULT __stdcall PreferredColorScheme(
		[out, retval]COREWEBVIEW2_PREFERRED_COLOR_SCHEME* value);
	[id(0x60010005), propput]
	HRESULT __stdcall PreferredColorScheme(
		[in]COREWEBVIEW2_PREFERRED_COLOR_SCHEME value);
};
```
'!
!WebView2.ICoreWebView2Profile categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Profile methodsFor!

ClearBrowsingData: dataKinds handler: handler
	^E_NOTIMPL!

ClearBrowsingDataAll: handler
	^E_NOTIMPL!

ClearBrowsingDataInTimeRange: dataKinds startTime: startTime endTime: endTime handler: handler
	^E_NOTIMPL!

defaultDownloadFolderPath
	"Answer the <readableString> value of the 'DefaultDownloadFolderPath' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_DefaultDownloadFolderPath: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

defaultDownloadFolderPath: value
	"Set the 'DefaultDownloadFolderPath' property of the receiver to the <lpwstr> value of the argument."

	self put_DefaultDownloadFolderPath: value asUtf16String!

downCast
	"Private - Answer the most recent settings interface available on the underlying COM object."

	^self queryInterface: ICoreWebView2Profile2 ifNone: [self]!

get_DefaultDownloadFolderPath: value
	"Private - Get the value of the 'DefaultDownloadFolderPath' property of the receiver.

		HRESULT __stdcall DefaultDownloadFolderPath(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

get_IsInPrivateModeEnabled: value
	"Private - Get the value of the 'IsInPrivateModeEnabled' property of the receiver.

		HRESULT __stdcall IsInPrivateModeEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

get_PreferredColorScheme: value
	"Private - Get the value of the 'PreferredColorScheme' property of the receiver.

		HRESULT __stdcall PreferredColorScheme(
			[out, retval]COREWEBVIEW2_PREFERRED_COLOR_SCHEME* value);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_ProfileName: value
	"Private - Get the value of the 'ProfileName' property of the receiver.

		HRESULT __stdcall ProfileName(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_ProfilePath: value
	"Private - Get the value of the 'ProfilePath' property of the receiver.

		HRESULT __stdcall ProfilePath(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

isInPrivateModeEnabled
	"Answer the <Boolean> value of the 'IsInPrivateModeEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsInPrivateModeEnabled: answer.
	^answer value!

preferredColorScheme
	"Answer the <sdword> value of the 'PreferredColorScheme' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_PreferredColorScheme: answer.
	^answer asObject!

preferredColorScheme: value
	"Set the 'PreferredColorScheme' property of the receiver to the <sdword> value of the argument."

	self put_PreferredColorScheme: value!

printableProperties
	| propertyNames |
	propertyNames := OrderedCollection new.
	self profileName isEmpty ifFalse: [propertyNames addLast: #profileName].
	self preferredColorScheme isZero ifFalse: [propertyNames addLast: #preferredColorScheme].
	self isInPrivateModeEnabled ifTrue: [propertyNames addLast: #isInPrivateModeEnabled].
	propertyNames addAll: #(#profilePath #defaultDownloadFolderPath).
	^propertyNames!

profileName
	"Answer the <readableString> value of the 'ProfileName' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ProfileName: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

profilePath
	"Answer the <readableString> value of the 'ProfilePath' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ProfilePath: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

put_DefaultDownloadFolderPath: value
	"Private - Set the value of the 'DefaultDownloadFolderPath' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall DefaultDownloadFolderPath(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 8 lpwstr>
	^self invalidCall: _failureCode!

put_PreferredColorScheme: value
	"Private - Set the value of the 'PreferredColorScheme' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall PreferredColorScheme(
			[in]COREWEBVIEW2_PREFERRED_COLOR_SCHEME value);"

	<virtual stdcall: hresult 10 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Profile categoriesForMethods!
ClearBrowsingData:handler:!COM Interfaces-ICoreWebView2Profile2!private! !
ClearBrowsingDataAll:!COM Interfaces-ICoreWebView2Profile2!private! !
ClearBrowsingDataInTimeRange:startTime:endTime:handler:!COM Interfaces-ICoreWebView2Profile2!private! !
defaultDownloadFolderPath!properties!public! !
defaultDownloadFolderPath:!**auto generated**!properties!public! !
downCast!properties!public! !
get_DefaultDownloadFolderPath:!**auto generated**!COM Interfaces-ICoreWebView2Profile!private! !
get_IsInPrivateModeEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Profile!private! !
get_PreferredColorScheme:!**auto generated**!COM Interfaces-ICoreWebView2Profile!private! !
get_ProfileName:!**auto generated**!COM Interfaces-ICoreWebView2Profile!private! !
get_ProfilePath:!**auto generated**!COM Interfaces-ICoreWebView2Profile!private! !
isInPrivateModeEnabled!properties!public! !
preferredColorScheme!**auto generated**!properties!public! !
preferredColorScheme:!**auto generated**!properties!public! !
printableProperties!printing!private! !
profileName!properties!public! !
profilePath!properties!public! !
put_DefaultDownloadFolderPath:!**auto generated**!COM Interfaces-ICoreWebView2Profile!private! !
put_PreferredColorScheme:!**auto generated**!COM Interfaces-ICoreWebView2Profile!private! !
!

!WebView2.ICoreWebView2Profile class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile'
		ICoreWebView2Profile defineTemplate"

	self
		defineFunction: #get_ProfileName:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_IsInPrivateModeEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #get_ProfilePath:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_DefaultDownloadFolderPath:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_DefaultDownloadFolderPath:
			argumentTypes: 'lpwstr';
		defineFunction: #get_PreferredColorScheme:
			argumentTypes: 'sdword*';
		defineFunction: #put_PreferredColorScheme:
			argumentTypes: 'sdword'
! !
!WebView2.ICoreWebView2Profile class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

