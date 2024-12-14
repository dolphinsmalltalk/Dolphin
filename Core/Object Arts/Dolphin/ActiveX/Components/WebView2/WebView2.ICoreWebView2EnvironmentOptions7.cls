"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EnvironmentOptions7'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EnvironmentOptions7 guid: (OS.COM.IID fromString: '{c48d539f-e39f-441c-ae68-1f66e570bdc5}')!

WebView2.ICoreWebView2EnvironmentOptions7 comment: '`ICoreWebView2EnvironmentOptions7` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions7'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c48d539f-e39f-441c-ae68-1f66e570bdc5)
]
interface ICoreWebView2EnvironmentOptions7 : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ChannelSearchKind(
		[out, retval]COREWEBVIEW2_CHANNEL_SEARCH_KIND* value);
	[id(0x60010000), propput]
	HRESULT __stdcall ChannelSearchKind(
		[in]COREWEBVIEW2_CHANNEL_SEARCH_KIND value);
	[id(0x60010002), propget]
	HRESULT __stdcall ReleaseChannels(
		[out, retval]COREWEBVIEW2_RELEASE_CHANNELS* value);
	[id(0x60010002), propput]
	HRESULT __stdcall ReleaseChannels(
		[in]COREWEBVIEW2_RELEASE_CHANNELS value);
};
```
'!

!WebView2.ICoreWebView2EnvironmentOptions7 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2EnvironmentOptions7 methodsFor!

channelSearchKind
	"Answer the <int32> value of the 'ChannelSearchKind' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ChannelSearchKind: buf.
	^buf asSignedInteger!

channelSearchKind: value
	"Set the 'ChannelSearchKind' property of the receiver to the <int32> value of the argument."

	self put_ChannelSearchKind: value!

get_ChannelSearchKind: value
	"Private - Get the value of the 'ChannelSearchKind' property of the receiver.

		HRESULT __stdcall ChannelSearchKind(
			[out, retval]COREWEBVIEW2_CHANNEL_SEARCH_KIND* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_ReleaseChannels: value
	"Private - Get the value of the 'ReleaseChannels' property of the receiver.

		HRESULT __stdcall ReleaseChannels(
			[out, retval]COREWEBVIEW2_RELEASE_CHANNELS* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

put_ChannelSearchKind: value
	"Private - Set the value of the 'ChannelSearchKind' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ChannelSearchKind(
			[in]COREWEBVIEW2_CHANNEL_SEARCH_KIND value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode!

put_ReleaseChannels: value
	"Private - Set the value of the 'ReleaseChannels' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ReleaseChannels(
			[in]COREWEBVIEW2_RELEASE_CHANNELS value);"

	<virtual stdcall: hresult 7 int32>
	^self invalidCall: _failureCode!

releaseChannels
	"Answer the <int32> value of the 'ReleaseChannels' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ReleaseChannels: buf.
	^buf asSignedInteger!

releaseChannels: value
	"Set the 'ReleaseChannels' property of the receiver to the <int32> value of the argument."

	self put_ReleaseChannels: value! !

!WebView2.ICoreWebView2EnvironmentOptions7 categoriesForMethods!
channelSearchKind!properties!public! !
channelSearchKind:!**auto generated**!properties!public! !
get_ChannelSearchKind:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
get_ReleaseChannels:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
put_ChannelSearchKind:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
put_ReleaseChannels:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
releaseChannels!properties!public! !
releaseChannels:!**auto generated**!properties!public! !
!

WebView2.ICoreWebView2EnvironmentOptions7 methodProtocol: #ICoreWebView2EnvironmentOptions7 attributes: #(#readOnly) selectors: #(#get_ChannelSearchKind: #get_ReleaseChannels: #put_ChannelSearchKind: #put_ReleaseChannels:)!

!WebView2.ICoreWebView2EnvironmentOptions7 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions7'
		ICoreWebView2EnvironmentOptions7 defineTemplate"

	self
		defineFunction: #get_ChannelSearchKind:
			argumentTypes: 'int32*';
		defineFunction: #put_ChannelSearchKind:
			argumentTypes: 'int32';
		defineFunction: #get_ReleaseChannels:
			argumentTypes: 'int32*';
		defineFunction: #put_ReleaseChannels:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2EnvironmentOptions7 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

