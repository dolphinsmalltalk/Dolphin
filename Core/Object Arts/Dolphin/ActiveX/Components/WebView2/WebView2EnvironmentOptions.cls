"Filed out from Dolphin Smalltalk"!

COMInterfaceImp subclass: #WebView2EnvironmentOptions
	instanceVariableNames: 'additionalBrowserArguments allowSSO locale browserVersion exclusiveUserDataFolderAccess'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebView2EnvironmentOptions guid: (GUID fromString: '{a29cb496-0b83-42f6-b6b1-2670cb4d42fb}')!
WebView2EnvironmentOptions comment: ''!
!WebView2EnvironmentOptions categoriesForClass!COM-Implementations! !
!WebView2EnvironmentOptions methodsFor!

additionalBrowserArguments
	^additionalBrowserArguments!

additionalBrowserArguments: anObject
	additionalBrowserArguments := anObject!

allowSSO
	^allowSSO!

allowSSO: aBoolean
	allowSSO := aBoolean!

browserVersion
	^browserVersion!

browserVersion: anObject
	browserVersion := anObject!

exclusiveUserDataFolderAccess
	^exclusiveUserDataFolderAccess!

exclusiveUserDataFolderAccess: aBoolean 
	exclusiveUserDataFolderAccess := aBoolean!

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

	allow value: allowSSO asParameter.
	^S_OK!

get_ExclusiveUserDataFolderAccess: value
	"Private - Get the value of the 'ExclusiveUserDataFolderAccess' property of the receiver.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[out, retval]long* value);"

	value value: exclusiveUserDataFolderAccess asParameter.
	^S_OK!

get_Language: value
	"Private - Get the value of the 'Language' property of the receiver.

		HRESULT __stdcall Language(
			[out, retval]LPWSTR* value);"

	value value: self locale tag asUtf16String copyToCOMTaskMemory detach.
	^S_OK!

get_TargetCompatibleBrowserVersion: value
	"Private - Get the value of the 'TargetCompatibleBrowserVersion' property of the receiver.

		HRESULT __stdcall TargetCompatibleBrowserVersion(
			[out, retval]LPWSTR* value);"

	value
		value: (browserVersion ifNil: [0] ifNotNil: [browserVersion asUtf16String copyToCOMTaskMemory detach]).
	^S_OK!

initialize
	allowSSO := true.
	exclusiveUserDataFolderAccess := false.
	super initialize!

locale
	^locale ifNil: [Locale userDefault]!

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

	allowSSO := allow asBoolean.
	^S_OK!

put_ExclusiveUserDataFolderAccess: value
	"Private - Set the value of the 'ExclusiveUserDataFolderAccess' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[in]long value);"

	exclusiveUserDataFolderAccess := value asBoolean.
	^S_OK!

put_Language: value
	"Private - Set the value of the 'Language' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall Language(
			[in]LPWSTR value);"

	locale := Locale named: value.
	^S_OK!

put_TargetCompatibleBrowserVersion: value
	"Private - Set the value of the 'TargetCompatibleBrowserVersion' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall TargetCompatibleBrowserVersion(
			[in]LPWSTR value);"

	browserVersion := value.
	^S_OK!

supportedInterfaces
	^{ICoreWebView2EnvironmentOptions. ICoreWebView2EnvironmentOptions2}! !
!WebView2EnvironmentOptions categoriesForMethods!
additionalBrowserArguments!accessing!public! !
additionalBrowserArguments:!accessing!public! !
allowSSO!accessing!public! !
allowSSO:!accessing!public! !
browserVersion!accessing!public! !
browserVersion:!accessing!public! !
exclusiveUserDataFolderAccess!public! !
exclusiveUserDataFolderAccess:!public! !
get_AdditionalBrowserArguments:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
get_AllowSingleSignOnUsingOSPrimaryAccount:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
get_ExclusiveUserDataFolderAccess:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
get_Language:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
get_TargetCompatibleBrowserVersion:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
initialize!initializing!public! !
locale!accessing!public! !
locale:!accessing!public! !
put_AdditionalBrowserArguments:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
put_AllowSingleSignOnUsingOSPrimaryAccount:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
put_ExclusiveUserDataFolderAccess:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
put_Language:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
put_TargetCompatibleBrowserVersion:!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
supportedInterfaces!constants!public! !
!

WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions attributes: #(#readOnly) selectors: #(#get_AdditionalBrowserArguments: #get_AllowSingleSignOnUsingOSPrimaryAccount: #get_Language: #get_TargetCompatibleBrowserVersion: #put_AdditionalBrowserArguments: #put_AllowSingleSignOnUsingOSPrimaryAccount: #put_Language: #put_TargetCompatibleBrowserVersion:)!
WebView2EnvironmentOptions methodProtocol: #ICoreWebView2EnvironmentOptions2 attributes: #(#readOnly) selectors: #(#get_ExclusiveUserDataFolderAccess: #put_ExclusiveUserDataFolderAccess:)!

!WebView2EnvironmentOptions class methodsFor!

icon
	^ICoreWebView2 icon! !
!WebView2EnvironmentOptions class categoriesForMethods!
icon!constants!development!public! !
!

