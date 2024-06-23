"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2PermissionSetting'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'PermissionNames'
				-> #('Microphone' 'Camera' 'Geolocation' 'Notifications' 'OtherSensors' 'ClipboardRead' 'MultipleAutomaticDownloads' 'FileReadWrite' 'Autoplay' 'LocalFonts' 'MidiSystemExclusiveMessages' 'WindowManagement')
		}!

WebView2.ICoreWebView2PermissionSetting guid: (OS.COM.IID fromString: '{792b6eca-5576-421c-9119-74ebb3a4ffb3}')!

WebView2.ICoreWebView2PermissionSetting isEgressOnly: true!

WebView2.ICoreWebView2PermissionSetting comment: '`ICoreWebView2PermissionSetting` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PermissionSetting'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(792b6eca-5576-421c-9119-74ebb3a4ffb3)
]
interface ICoreWebView2PermissionSetting : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall PermissionKind(
		[out, retval]COREWEBVIEW2_PERMISSION_KIND* value);
	[id(0x60010001), propget]
	HRESULT __stdcall PermissionOrigin(
		[out, retval]LPWSTR* value);
	[id(0x60010002), propget]
	HRESULT __stdcall PermissionState(
		[out, retval]COREWEBVIEW2_PERMISSION_STATE* value);
};
```
'!

!WebView2.ICoreWebView2PermissionSetting categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2PermissionSetting methodsFor!

get_PermissionKind: value
	"Private - Get the value of the 'PermissionKind' property of the receiver.

		HRESULT __stdcall PermissionKind(
			[out, retval]COREWEBVIEW2_PERMISSION_KIND* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_PermissionOrigin: value
	"Private - Get the value of the 'PermissionOrigin' property of the receiver.

		HRESULT __stdcall PermissionOrigin(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_PermissionState: value
	"Private - Get the value of the 'PermissionState' property of the receiver.

		HRESULT __stdcall PermissionState(
			[out, retval]COREWEBVIEW2_PERMISSION_STATE* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

permissionKind
	"Answer the <int32> value of the 'PermissionKind' property of the receiver."

	| answer |
	answer := ByteArray new: 4.
	self get_PermissionKind: answer.
	^answer int32AtOffset: 0!

permissionName
	"Answer a <String> identifying the permission requested."

	^(PermissionNames lookup: self permissionKind) ?? 'UnknownPermission'!

permissionOrigin
	"Answer the <lpwstr> value of the 'PermissionOrigin' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_PermissionOrigin: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

permissionState
	"Answer a 3-state <boolean>|nil value (i.e. true|false|nil) that is the state of the represented permission.
		- If the permission is explicitly allowed, the answer is true.
		- If the permission is explicity denied, the answer is false.
		- If the permission has no explicit setting (i.e. it is the default) the answer is nil, indicating it is not set."

	| state |
	state := ByteArray new: 4.
	self get_PermissionState: state.
	state := state int32AtOffset: 0.
	^state == 0 ifFalse: [(state - 1) asBoolean]!

printableProperties
	^#(#permissionName #permissionOrigin #permissionState)! !

!WebView2.ICoreWebView2PermissionSetting categoriesForMethods!
get_PermissionKind:!**auto generated**!COM Interfaces-ICoreWebView2PermissionSetting!private! !
get_PermissionOrigin:!**auto generated**!COM Interfaces-ICoreWebView2PermissionSetting!private! !
get_PermissionState:!**auto generated**!COM Interfaces-ICoreWebView2PermissionSetting!private! !
permissionKind!properties!public! !
permissionName!properties!public! !
permissionOrigin!properties!public! !
permissionState!properties!public! !
printableProperties!printing!private! !
!

!WebView2.ICoreWebView2PermissionSetting class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PermissionSetting'
		ICoreWebView2PermissionSetting defineTemplate"

	self
		defineFunction: #get_PermissionKind:
			argumentTypes: 'int32*';
		defineFunction: #get_PermissionOrigin:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_PermissionState:
			argumentTypes: 'int32*'
! !

!WebView2.ICoreWebView2PermissionSetting class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

