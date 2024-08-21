"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceImplementation
	subclass: #'WebView2.WebView2EnvironmentOptions'
	instanceVariableNames: 'additionalBrowserArguments flags locale browserVersion trackingPreventionLevel channelSearchKind releaseChannels scrollBarStyle'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AllowSSOMask' -> 16r1.
			'BrowseExtensionsEnabledMask' -> 16r8.
			'CustomCrashReportingMask' -> 16r4.
			'ExclusiveUserDataFolderAccessMask' -> 16r2
		}!

WebView2.WebView2EnvironmentOptions guid: (Core.GUID fromString: '{a29cb496-0b83-42f6-b6b1-2670cb4d42fb}')!

WebView2.WebView2EnvironmentOptions comment: ''!

!WebView2.WebView2EnvironmentOptions categoriesForClass!COM-Implementations! !

!WebView2.WebView2EnvironmentOptions methodsFor!

additionalBrowserArguments
	^additionalBrowserArguments!

additionalBrowserArguments: aString
	additionalBrowserArguments := aString!

allowSSO
	^flags allMask: AllowSSOMask!

allowSSO: aBoolean
	flags := flags mask: AllowSSOMask set: aBoolean!

areBrowserExtensionsEnabled
	^flags allMask: BrowseExtensionsEnabledMask!

areBrowserExtensionsEnabled: aBoolean
	flags := flags mask: BrowseExtensionsEnabledMask set: aBoolean!

browserVersion
	^browserVersion!

browserVersion: aString
	browserVersion := aString!

channelSearchKind
	"Answer the <integer> from the COREWEBVIEW2_CHANNEL_SEARCH_KIND enumeration that specifies the channel search order for locating the webview2 runtime to load.
	By default this is COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE (2)."

	^channelSearchKind!

channelSearchKind: value
	(value between: COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE
		and: COREWEBVIEW2_CHANNEL_SEARCH_KIND_LEAST_STABLE)
			ifFalse: 
				[InvalidArgumentError
					signal: 'Channel search kind <1p> not in expected range [<2p>, <3p>}' << {
									value.
									COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
									COREWEBVIEW2_CHANNEL_SEARCH_KIND_LEAST_STABLE
								}
					with: 'value'].
	channelSearchKind := value!

exclusiveUserDataFolderAccess
	^flags allMask: ExclusiveUserDataFolderAccessMask!

exclusiveUserDataFolderAccess: aBoolean
	flags := flags mask: ExclusiveUserDataFolderAccessMask set: aBoolean!

get_AdditionalBrowserArguments: value
	"Private - Get the value of the 'AdditionalBrowserArguments' property of the receiver.

		HRESULT __stdcall AdditionalBrowserArguments(
			[out, retval]LPWSTR* value);"

	value value: (additionalBrowserArguments
				ifNil: [0]
				ifNotNil: [additionalBrowserArguments asUtf16String copyToCOMTaskMemory detach]).
	^S_OK!

get_AllowSingleSignOnUsingOSPrimaryAccount: allow
	"Private - Get the value of the 'AllowSingleSignOnUsingOSPrimaryAccount' property of the receiver.

		HRESULT __stdcall AllowSingleSignOnUsingOSPrimaryAccount(
			[out, retval]long* allow);"

	allow value: self allowSSO asParameter.
	^S_OK!

get_AreBrowserExtensionsEnabled: value
	"Private - Get the value of the 'AreBrowserExtensionsEnabled' property of the receiver.

		HRESULT __stdcall AreBrowserExtensionsEnabled(
			[out, retval]long* value);"

	value value: self areBrowserExtensionsEnabled asParameter.
	^S_OK!

get_ChannelSearchKind: value
	"Private - Get the value of the 'ChannelSearchKind' property of the receiver.

		HRESULT __stdcall ChannelSearchKind(
			[out, retval]COREWEBVIEW2_CHANNEL_SEARCH_KIND* value);"

	value value: self channelSearchKind.
	^S_OK!

get_EnableTrackingPrevention: value
	"Private - Get the value of the 'EnableTrackingPrevention' property of the receiver.

		HRESULT __stdcall EnableTrackingPrevention(
			[out, retval]long* value);"

	value value: self trackingPreventionLevel.
	^S_OK!

get_ExclusiveUserDataFolderAccess: value
	"Private - Get the value of the 'ExclusiveUserDataFolderAccess' property of the receiver.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[out, retval]long* value);"

	value value: self exclusiveUserDataFolderAccess asParameter.
	^S_OK!

get_IsCustomCrashReportingEnabled: value
	"Private - Get the value of the 'IsCustomCrashReportingEnabled' property of the receiver.

		HRESULT __stdcall IsCustomCrashReportingEnabled(
			[out, retval]long* value);"

	value value: self isCustomCrashReportingEnabled asParameter.
	^S_OK!

get_Language: value
	"Private - Get the value of the 'Language' property of the receiver.

		HRESULT __stdcall Language(
			[out, retval]LPWSTR* value);"

	value value: self locale tag asUtf16String copyToCOMTaskMemory detach.
	^S_OK!

get_ReleaseChannels: value
	"Private - Get the value of the 'ReleaseChannels' property of the receiver.

		HRESULT __stdcall ReleaseChannels(
			[out, retval]COREWEBVIEW2_RELEASE_CHANNELS* value);"

	value value: self releaseChannels.
	^S_OK!

get_ScrollBarStyle: value
	"Private - Get the value of the 'ScrollBarStyle' property of the receiver.

		HRESULT __stdcall ScrollBarStyle(
			[out, retval]COREWEBVIEW2_SCROLLBAR_STYLE* value);"

	value value: self scrollBarStyle.
	^S_OK!

get_TargetCompatibleBrowserVersion: value
	"Private - Get the value of the 'TargetCompatibleBrowserVersion' property of the receiver.

		HRESULT __stdcall TargetCompatibleBrowserVersion(
			[out, retval]LPWSTR* value);"

	value
		value: (browserVersion ifNil: [0] ifNotNil: [browserVersion asUtf16String copyToCOMTaskMemory detach]).
	^S_OK!

GetCustomSchemeRegistrations: count schemeRegistrations: schemeRegistrations
	"Private - Invoke the GetCustomSchemeRegistrations() method of the COM object.

		HRESULT __stdcall GetCustomSchemeRegistrations(
			[out]unsigned int* Count,
			[out]ICoreWebView2CustomSchemeRegistration*** schemeRegistrations);"

	count value: 0.
	schemeRegistrations value: 0.
	^S_OK!

initialize
	super initialize.
	flags := ##(AllowSSOMask | ExclusiveUserDataFolderAccessMask).
	browserVersion := CORE_WEBVIEW_TARGET_PRODUCT_VERSION.
	trackingPreventionLevel := COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED.
	channelSearchKind := COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
	releaseChannels := COREWEBVIEW2_RELEASE_CHANNELS_STABLE.
	scrollBarStyle := COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT!

isCustomCrashReportingEnabled
	^flags allMask: CustomCrashReportingMask!

isCustomCrashReportingEnabled: aBoolean
	flags := flags mask: CustomCrashReportingMask set: aBoolean!

locale
	^locale ?? Locale.UserDefault!

locale: aLocale
	locale := aLocale!

put_AdditionalBrowserArguments: value
	"Private - Set the value of the 'AdditionalBrowserArguments' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall AdditionalBrowserArguments(
			[in]LPWSTR value);"

	additionalBrowserArguments := value.
	^S_OK!

put_AllowSingleSignOnUsingOSPrimaryAccount: allow
	"Private - Set the value of the 'AllowSingleSignOnUsingOSPrimaryAccount' property of the object wrapped by the 
	 receiver to the <sdword> argument, allow.

		HRESULT __stdcall AllowSingleSignOnUsingOSPrimaryAccount(
			[in]long allow);"

	self allowSSO: allow asBoolean.
	^S_OK!

put_AreBrowserExtensionsEnabled: value
	"Private - Set the value of the 'AreBrowserExtensionsEnabled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall AreBrowserExtensionsEnabled(
			[in]long value);"

	self areBrowserExtensionsEnabled: value asBoolean.
	^S_OK!

put_ChannelSearchKind: value
	"Private - Set the value of the 'ChannelSearchKind' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ChannelSearchKind(
			[in]COREWEBVIEW2_CHANNEL_SEARCH_KIND value);"

	^
	[self channelSearchKind: value.
	S_OK] on: Error do: [:ex | ex hresult asInteger]!

put_EnableTrackingPrevention: value
	"Private - Set the value of the 'EnableTrackingPrevention' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall EnableTrackingPrevention(
			[in]long value);"

	self trackingPreventionLevel: value.
	^S_OK!

put_ExclusiveUserDataFolderAccess: value
	"Private - Set the value of the 'ExclusiveUserDataFolderAccess' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[in]long value);"

	self exclusiveUserDataFolderAccess: value asBoolean.
	^S_OK!

put_IsCustomCrashReportingEnabled: value
	"Private - Set the value of the 'IsCustomCrashReportingEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsCustomCrashReportingEnabled(
			[in]long value);"

	self isCustomCrashReportingEnabled: value asBoolean.
	^S_OK!

put_Language: value
	"Private - Set the value of the 'Language' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall Language(
			[in]LPWSTR value);"

	locale := Locale named: value.
	^S_OK!

put_ReleaseChannels: value
	"Private - Set the value of the 'ReleaseChannels' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ReleaseChannels(
			[in]COREWEBVIEW2_RELEASE_CHANNELS value);"

	^
	[self releaseChannels: value.
	S_OK] on: Error do: [:ex | ex hresult asInteger]!

put_ScrollBarStyle: value
	"Private - Set the value of the 'ScrollBarStyle' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ScrollBarStyle(
			[in]COREWEBVIEW2_SCROLLBAR_STYLE value);"

	^
	[self scrollBarStyle: value.
	S_OK] on: Error do: [:ex | ex hresult asInteger]!

put_TargetCompatibleBrowserVersion: value
	"Private - Set the value of the 'TargetCompatibleBrowserVersion' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall TargetCompatibleBrowserVersion(
			[in]LPWSTR value);"

	browserVersion := value.
	^S_OK!

releaseChannels
	"Answer the <integer> flags from the COREWEBVIEW2_RELEASE_CHANNELS flags enumeration specifying the webview2 release channels to search to locate the webview2 runtime to load.
	By default this is COREWEBVIEW2_RELEASE_CHANNELS_STABLE (1)."

	^releaseChannels!

releaseChannels: value
	(value
		maskClear: ##(COREWEBVIEW2_RELEASE_CHANNELS_NONE | COREWEBVIEW2_RELEASE_CHANNELS_STABLE
				| COREWEBVIEW2_RELEASE_CHANNELS_BETA | COREWEBVIEW2_RELEASE_CHANNELS_DEV
				| COREWEBVIEW2_RELEASE_CHANNELS_CANARY))
			~~ 0
			ifTrue: 
				[InvalidArgumentError signal: 'Release channels flags <1p> is not valid' << { value }
					with: 'value'].
	releaseChannels := value!

scrollBarStyle
	"Answer the <integer> from the COREWEBVIEW2_SCROLLBAR_STYLE enumeration that specifies the style of scrollbar to use in the webview.
	By default this is COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT (0)."

	^scrollBarStyle!

scrollBarStyle: value
	(value between: COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT
		and: COREWEBVIEW2_SCROLLBAR_STYLE_FLUENT_OVERLAY)
			ifFalse: 
				[InvalidArgumentError signal: 'Scrollbar style <1p> not in expected range [<2p>, <3p>}'
							<< { value. COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT. COREWEBVIEW2_SCROLLBAR_STYLE_FLUENT_OVERLAY }
					with: 'value'].
	scrollBarStyle := value!

SetCustomSchemeRegistrations: count schemeRegistrations: schemeRegistrations
	"Private - Invoke the SetCustomSchemeRegistrations() method of the COM object.

		HRESULT __stdcall SetCustomSchemeRegistrations(
			[in]unsigned int Count,
			[in]ICoreWebView2CustomSchemeRegistration** schemeRegistrations);"

	^E_NOTIMPL!

supportedInterfaces
	^##({
		IUnknown.
		ICoreWebView2EnvironmentOptions.
		ICoreWebView2EnvironmentOptions2.
		ICoreWebView2EnvironmentOptions3.
		ICoreWebView2EnvironmentOptions4.
		ICoreWebView2EnvironmentOptions5.
		ICoreWebView2EnvironmentOptions6.
		ICoreWebView2EnvironmentOptions7.
		ICoreWebView2EnvironmentOptions8
	})!

trackingPreventionLevel
	"Answer the <integer> from the COREWEBVIEW2_TRACKING_PREVENTION_LEVEL enumeration that specifies the tracking prevention level to be configured for WebView2's created in the environment.
	By default this is COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED (2)."

	^trackingPreventionLevel!

trackingPreventionLevel: value
	(value between: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_NONE
		and: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_STRICT)
			ifFalse: 
				[InvalidArgumentError
					signal: 'Tracking prevention level <1p> not in expected range [<2p>, <3p>}' << {
									value.
									COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_NONE.
									COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_STRICT
								}
					with: 'value'].
	trackingPreventionLevel := value! !

!WebView2.WebView2EnvironmentOptions categoriesForMethods!
additionalBrowserArguments!accessing!public! !
additionalBrowserArguments:!accessing!public! !
allowSSO!accessing!public! !
allowSSO:!accessing!public! !
areBrowserExtensionsEnabled!accessing!public! !
areBrowserExtensionsEnabled:!accessing!public! !
browserVersion!accessing!public! !
browserVersion:!accessing!public! !
channelSearchKind!accessing!public! !
channelSearchKind:!accessing!public! !
exclusiveUserDataFolderAccess!accessing!public! !
exclusiveUserDataFolderAccess:!accessing!public! !
get_AdditionalBrowserArguments:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
get_AllowSingleSignOnUsingOSPrimaryAccount:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
get_AreBrowserExtensionsEnabled:!COM Interfaces-ICoreWebView2EnvironmentOptions6!private! !
get_ChannelSearchKind:!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
get_EnableTrackingPrevention:!COM Interfaces-ICoreWebView2EnvironmentOptions5!private! !
get_ExclusiveUserDataFolderAccess:!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
get_IsCustomCrashReportingEnabled:!COM Interfaces-ICoreWebView2EnvironmentOptions3!private! !
get_Language:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
get_ReleaseChannels:!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
get_ScrollBarStyle:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions8!private! !
get_TargetCompatibleBrowserVersion:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
GetCustomSchemeRegistrations:schemeRegistrations:!COM Interfaces-ICoreWebView2EnvironmentOptions4!private! !
initialize!initializing!public! !
isCustomCrashReportingEnabled!accessing!public! !
isCustomCrashReportingEnabled:!accessing!public! !
locale!accessing!public! !
locale:!accessing!public! !
put_AdditionalBrowserArguments:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
put_AllowSingleSignOnUsingOSPrimaryAccount:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
put_AreBrowserExtensionsEnabled:!COM Interfaces-ICoreWebView2EnvironmentOptions6!private! !
put_ChannelSearchKind:!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
put_EnableTrackingPrevention:!COM Interfaces-ICoreWebView2EnvironmentOptions5!private! !
put_ExclusiveUserDataFolderAccess:!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
put_IsCustomCrashReportingEnabled:!COM Interfaces-ICoreWebView2EnvironmentOptions3!private! !
put_Language:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
put_ReleaseChannels:!COM Interfaces-ICoreWebView2EnvironmentOptions7!private! !
put_ScrollBarStyle:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions8!private! !
put_TargetCompatibleBrowserVersion:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
releaseChannels!accessing!public! !
releaseChannels:!accessing!public! !
scrollBarStyle!accessing!public! !
scrollBarStyle:!accessing!public! !
SetCustomSchemeRegistrations:schemeRegistrations:!COM Interfaces-ICoreWebView2EnvironmentOptions4!private! !
supportedInterfaces!constants!public! !
trackingPreventionLevel!accessing!public! !
trackingPreventionLevel:!accessing!public! !
!

WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions attributes: #(#readOnly) selectors: #(#get_AdditionalBrowserArguments: #get_AllowSingleSignOnUsingOSPrimaryAccount: #get_Language: #get_TargetCompatibleBrowserVersion: #put_AdditionalBrowserArguments: #put_AllowSingleSignOnUsingOSPrimaryAccount: #put_Language: #put_TargetCompatibleBrowserVersion:)!
WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions2 attributes: #(#readOnly) selectors: #(#get_ExclusiveUserDataFolderAccess: #put_ExclusiveUserDataFolderAccess:)!
WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions3 attributes: #(#readOnly) selectors: #(#get_IsCustomCrashReportingEnabled: #put_IsCustomCrashReportingEnabled:)!
WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions4 attributes: #(#readOnly) selectors: #(#GetCustomSchemeRegistrations:schemeRegistrations: #SetCustomSchemeRegistrations:schemeRegistrations:)!
WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions5 attributes: #(#readOnly) selectors: #(#get_EnableTrackingPrevention: #put_EnableTrackingPrevention:)!
WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions6 attributes: #(#readOnly) selectors: #(#get_AreBrowserExtensionsEnabled: #put_AreBrowserExtensionsEnabled:)!
WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions7 attributes: #(#readOnly) selectors: #(#get_ChannelSearchKind: #get_ReleaseChannels: #put_ChannelSearchKind: #put_ReleaseChannels:)!
WebView2.WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions8 attributes: #(#readOnly) selectors: #(#get_ScrollBarStyle: #put_ScrollBarStyle:)!

!WebView2.WebView2EnvironmentOptions class methodsFor!

icon
	^ICoreWebView2 icon!

stbConvertFrom: anSTBClassFormat
	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			data , {
						COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
						COREWEBVIEW2_RELEASE_CHANNELS_STABLE.
						COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT
					}
				becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^1! !

!WebView2.WebView2EnvironmentOptions class categoriesForMethods!
icon!constants!development!public! !
stbConvertFrom:!public! !
stbVersion!binary filing!public! !
!

