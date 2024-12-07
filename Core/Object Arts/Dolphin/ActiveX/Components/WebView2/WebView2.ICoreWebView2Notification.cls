"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2Notification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'DirectionNames' -> #(#default #leftToRight #rightToLeft) }!

WebView2.ICoreWebView2Notification guid: (OS.COM.IID fromString: '{b7434d98-6bc8-419d-9da5-fb5a96d4dacd}')!

WebView2.ICoreWebView2Notification comment: '`ICoreWebView2Notification` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Notification'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b7434d98-6bc8-419d-9da5-fb5a96d4dacd)
]
interface ICoreWebView2Notification : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall add_CloseRequested(
		[in]ICoreWebView2NotificationCloseRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010001)]
	HRESULT __stdcall remove_CloseRequested(
		[in]EventRegistrationToken token);
	[id(0x60010002)]
	HRESULT __stdcall ReportShown();
	[id(0x60010003)]
	HRESULT __stdcall ReportClicked();
	[id(0x60010004)]
	HRESULT __stdcall ReportClosed();
	[id(0x60010005), propget]
	HRESULT __stdcall Body(
		[out, retval]LPWSTR* value);
	[id(0x60010006), propget]
	HRESULT __stdcall Direction(
		[out, retval]COREWEBVIEW2_TEXT_DIRECTION_KIND* value);
	[id(0x60010007), propget]
	HRESULT __stdcall Language(
		[out, retval]LPWSTR* value);
	[id(0x60010008), propget]
	HRESULT __stdcall Tag(
		[out, retval]LPWSTR* value);
	[id(0x60010009), propget]
	HRESULT __stdcall IconUri(
		[out, retval]LPWSTR* value);
	[id(0x6001000a), propget]
	HRESULT __stdcall title(
		[out, retval]LPWSTR* value);
	[id(0x6001000b), propget]
	HRESULT __stdcall BadgeUri(
		[out, retval]LPWSTR* value);
	[id(0x6001000c), propget]
	HRESULT __stdcall BodyImageUri(
		[out, retval]LPWSTR* value);
	[id(0x6001000d), propget]
	HRESULT __stdcall ShouldRenotify(
		[out, retval]long* value);
	[id(0x6001000e), propget]
	HRESULT __stdcall RequiresInteraction(
		[out, retval]long* value);
	[id(0x6001000f), propget]
	HRESULT __stdcall IsSilent(
		[out, retval]long* value);
	[id(0x60010010), propget]
	HRESULT __stdcall Timestamp(
		[out, retval]double* value);
	[id(0x60010011)]
	HRESULT __stdcall GetVibrationPattern(
		[out]unsigned int* Count,
		[out]unsigned __int64** vibrationPattern);
};
```
'!

!WebView2.ICoreWebView2Notification categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Notification methodsFor!

Add_CloseRequested: eventHandler token: token
	"Private - Invoke the add_CloseRequested() method of the COM object.

		HRESULT __stdcall add_CloseRequested(
			[in]ICoreWebView2NotificationCloseRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 4 ICoreWebView2NotificationCloseRequestedEventHandler* int64*>
	^self invalidCall: _failureCode!

badgeUri
	"Answer the <lpwstr> value of the 'BadgeUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_BadgeUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

body
	"Answer the <lpwstr> value of the 'Body' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Body: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

bodyImageUri
	"Answer the <lpwstr> value of the 'BodyImageUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_BodyImageUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

direction
	"Answer the <int32> value of the 'Direction' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Direction: answer.
	^answer asObject!

directionName
	^(DirectionNames at: self direction + 1)!

get_BadgeUri: value
	"Private - Get the value of the 'BadgeUri' property of the receiver.

		HRESULT __stdcall BadgeUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 15 lpwstr*>
	^self invalidCall: _failureCode!

get_Body: value
	"Private - Get the value of the 'Body' property of the receiver.

		HRESULT __stdcall Body(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 9 lpwstr*>
	^self invalidCall: _failureCode!

get_BodyImageUri: value
	"Private - Get the value of the 'BodyImageUri' property of the receiver.

		HRESULT __stdcall BodyImageUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 16 lpwstr*>
	^self invalidCall: _failureCode!

get_Direction: value
	"Private - Get the value of the 'Direction' property of the receiver.

		HRESULT __stdcall Direction(
			[out, retval]COREWEBVIEW2_TEXT_DIRECTION_KIND* value);"

	<virtual stdcall: hresult 10 int32*>
	^self invalidCall: _failureCode!

get_IconUri: value
	"Private - Get the value of the 'IconUri' property of the receiver.

		HRESULT __stdcall IconUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 13 lpwstr*>
	^self invalidCall: _failureCode!

get_IsSilent: value
	"Private - Get the value of the 'IsSilent' property of the receiver.

		HRESULT __stdcall IsSilent(
			[out, retval]long* value);"

	<virtual stdcall: hresult 19 int32*>
	^self invalidCall: _failureCode!

get_Language: value
	"Private - Get the value of the 'Language' property of the receiver.

		HRESULT __stdcall Language(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 11 lpwstr*>
	^self invalidCall: _failureCode!

get_RequiresInteraction: value
	"Private - Get the value of the 'RequiresInteraction' property of the receiver.

		HRESULT __stdcall RequiresInteraction(
			[out, retval]long* value);"

	<virtual stdcall: hresult 18 int32*>
	^self invalidCall: _failureCode!

get_ShouldRenotify: value
	"Private - Get the value of the 'ShouldRenotify' property of the receiver.

		HRESULT __stdcall ShouldRenotify(
			[out, retval]long* value);"

	<virtual stdcall: hresult 17 int32*>
	^self invalidCall: _failureCode!

get_Tag: value
	"Private - Get the value of the 'Tag' property of the receiver.

		HRESULT __stdcall Tag(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 12 lpwstr*>
	^self invalidCall: _failureCode!

get_Timestamp: value
	"Private - Get the value of the 'Timestamp' property of the receiver.

		HRESULT __stdcall Timestamp(
			[out, retval]double* value);"

	<virtual stdcall: hresult 20 double*>
	^self invalidCall: _failureCode!

get_title: value
	"Private - Get the value of the 'title' property of the receiver.

		HRESULT __stdcall title(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 14 lpwstr*>
	^self invalidCall: _failureCode!

GetVibrationPattern: count vibrationPattern: vibrationPattern
	"Private - Invoke the GetVibrationPattern() method of the COM object.

		HRESULT __stdcall GetVibrationPattern(
			[out]unsigned int* Count,
			[out]unsigned __int64** vibrationPattern);"

	<virtual stdcall: hresult 21 uint32* uint64**>
	^self invalidCall: _failureCode!

iconUri
	"Answer the <lpwstr> value of the 'IconUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_IconUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

isSilent
	"Answer the <Boolean> value of the 'IsSilent' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsSilent: buf.
	^buf asBoolean!

language
	"Answer the <lpwstr> value of the 'Language' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Language: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printableProperties
	^#(#title #body #directionName #isSilent #requiresInteraction #tag #timestamp)!

Remove_CloseRequested: token
	"Private - Invoke the remove_CloseRequested() method of the COM object.

		HRESULT __stdcall remove_CloseRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 5 int64>
	^self invalidCall: _failureCode!

ReportClicked
	"Private - Invoke the ReportClicked() method of the COM object.

		HRESULT __stdcall ReportClicked();"

	<virtual stdcall: hresult 7>
	^self invalidCall: _failureCode!

ReportClosed
	"Private - Invoke the ReportClosed() method of the COM object.

		HRESULT __stdcall ReportClosed();"

	<virtual stdcall: hresult 8>
	^self invalidCall: _failureCode!

ReportShown
	"Private - Invoke the ReportShown() method of the COM object.

		HRESULT __stdcall ReportShown();"

	<virtual stdcall: hresult 6>
	^self invalidCall: _failureCode!

requiresInteraction
	"Answer the <Boolean> value of the 'RequiresInteraction' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_RequiresInteraction: buf.
	^buf asBoolean!

shouldRenotify
	"Answer the <Boolean> value of the 'ShouldRenotify' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldRenotify: buf.
	^buf asBoolean!

tag
	"Answer the <lpwstr> value of the 'Tag' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Tag: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

timestamp
	"Answer the <DateAndTime> value of the 'Timestamp' property of the receiver. From https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2notification:
		Indicates the time at which a notification is created or applicable (past, present, or future) as the number of milliseconds since the UNIX epoch.
	"

	| buf |
	buf := ByteArray newFixed: 8.
	self get_Timestamp: buf.
	^DateAndTime fromUnixTime: (buf doubleAtOffset: 0) asInteger /1000!

title
	"Answer the <lpwstr> value of the 'title' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_title: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2Notification categoriesForMethods!
Add_CloseRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
badgeUri!properties!public! !
body!properties!public! !
bodyImageUri!properties!public! !
direction!**auto generated**!properties!public! !
directionName!properties!public! !
get_BadgeUri:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_Body:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_BodyImageUri:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_Direction:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_IconUri:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_IsSilent:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_Language:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_RequiresInteraction:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_ShouldRenotify:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_Tag:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_Timestamp:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
get_title:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
GetVibrationPattern:vibrationPattern:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
iconUri!properties!public! !
isSilent!properties!public! !
language!properties!public! !
printableProperties!printing!private! !
Remove_CloseRequested:!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
ReportClicked!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
ReportClosed!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
ReportShown!**auto generated**!COM Interfaces-ICoreWebView2Notification!private! !
requiresInteraction!properties!public! !
shouldRenotify!properties!public! !
tag!properties!public! !
timestamp!properties!public! !
title!properties!public! !
!

!WebView2.ICoreWebView2Notification class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Notification'
		ICoreWebView2Notification defineTemplate"

	self
		defineFunction: #Add_CloseRequested:token:
			argumentTypes: 'ICoreWebView2NotificationCloseRequestedEventHandler* int64*';
		defineFunction: #Remove_CloseRequested:
			argumentTypes: 'int64';
		defineFunction: #ReportShown;
		defineFunction: #ReportClicked;
		defineFunction: #ReportClosed;
		defineFunction: #get_Body:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Direction:
			argumentTypes: 'int32*';
		defineFunction: #get_Language:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Tag:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_IconUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_title:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_BadgeUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_BodyImageUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_ShouldRenotify:
			argumentTypes: 'int32*';
		defineFunction: #get_RequiresInteraction:
			argumentTypes: 'int32*';
		defineFunction: #get_IsSilent:
			argumentTypes: 'int32*';
		defineFunction: #get_Timestamp:
			argumentTypes: 'double*';
		defineFunction: #GetVibrationPattern:vibrationPattern:
			argumentTypes: 'uint32* uint64**'
! !

!WebView2.ICoreWebView2Notification class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

