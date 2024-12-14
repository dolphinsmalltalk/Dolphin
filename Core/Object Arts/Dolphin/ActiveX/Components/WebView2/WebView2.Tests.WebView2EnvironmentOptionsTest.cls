"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'WebView2.Tests.WebView2EnvironmentOptionsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.WebView2EnvironmentOptionsTest guid: (Core.GUID fromString: '{0a7ce017-d187-48bf-9d57-7bdb53a95f91}')!

WebView2.Tests.WebView2EnvironmentOptionsTest comment: ''!

!WebView2.Tests.WebView2EnvironmentOptionsTest methodsFor!

testAdditionalBrowserArguments
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions.
	self assertIsNil: interface additionalBrowserArguments.
	subject additionalBrowserArguments: 'foo'.
	self assert: interface additionalBrowserArguments equals: 'foo'.
	interface additionalBrowserArguments: 'foo bar'.
	self assert: subject additionalBrowserArguments equals: 'foo bar'.
	self assert: interface additionalBrowserArguments equals: 'foo bar'!

testAllowSSO
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions.
	self assert: subject allowSSO.
	self assert: interface allowSingleSignOnUsingOSPrimaryAccount.
	interface allowSingleSignOnUsingOSPrimaryAccount: false.
	self deny: subject allowSSO.
	self deny: interface allowSingleSignOnUsingOSPrimaryAccount.!

testAreBrowserExtensionsEnabled
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions6.
	self deny: subject areBrowserExtensionsEnabled.
	self deny: interface areBrowserExtensionsEnabled.
	interface areBrowserExtensionsEnabled: true.
	self assert: subject areBrowserExtensionsEnabled.
	self assert: interface areBrowserExtensionsEnabled.
	interface areBrowserExtensionsEnabled: false.
	self deny: subject areBrowserExtensionsEnabled!

testChannelSearchKind
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions7.
	self assert: subject channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
	self assert: interface channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
	interface channelSearchKind: COREWEBVIEW2_CHANNEL_SEARCH_KIND_LEAST_STABLE.
	self assert: subject channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_LEAST_STABLE.
	self assert: interface channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_LEAST_STABLE.
	self
		should: [interface channelSearchKind: -1]
		raise: HRESULTError
		matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_INVALID_PARAMETER]!

testCustomSchemeRegistrations
	| subject interface schemes scheme2 scheme1 unknowns |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions4.
	schemes := interface customSchemeRegistrations.
	self assert: schemes equals: #().
	scheme1 := (WebView2CustomSchemeRegistration newScheme: 'foo')
				treatAsSecure: true;
				hasAuthorityComponent: true;
				allowedOrigins: #('https://www.object-arts.com');
				yourself.
	scheme2 := (WebView2CustomSchemeRegistration newScheme: 'bar')
				allowedOrigins: #('https://www.object-arts.com' 'https://www.github.com');
				yourself.
	interface customSchemeRegistrations: { scheme1. scheme2 }.
	schemes := subject customSchemeRegistrations.
	self assert: schemes size equals: 2.
	schemes do: [:each | self assert: each referenceCount equals: 1].
	unknowns := { scheme1 queryInterface: IUnknown. scheme2 queryInterface: IUnknown }.
	schemes do: [:each | self assert: each referenceCount equals: 2].
	self assert: (schemes first isSameCOMObject: unknowns first).
	self assert: (schemes second isSameCOMObject: unknowns second).
	schemes := interface customSchemeRegistrations.
	schemes do: [:each | self assert: each referenceCount equals: 3].
	self assert: (schemes first isSameCOMObject: unknowns first).
	self assert: (schemes second isSameCOMObject: unknowns second).
	"Verify that the call and implementation wrappers correctly implement the fairly complex memory management requirements of the GetAllowedOrigins function"
	self assert: schemes first allowedOrigins equals: scheme1 allowedOrigins.
	self assert: schemes second allowedOrigins equals: scheme2 allowedOrigins.
	"Check the simple properties."
	self assert: schemes first schemeName equals: 'foo'.
	self assert: schemes second schemeName equals: 'bar'.
	self assert: schemes first treatAsSecure.
	self deny: schemes second treatAsSecure.
	self assert: schemes first hasAuthorityComponent.
	self deny: schemes second hasAuthorityComponent.

	"The reference counting is quite involved here, so we check to make sure we've got it right"
	schemes do: [:each | each free].
	subject customSchemeRegistrations do: [:each | self assert: each referenceCount equals: 2].
	unknowns do: [:each | each free].
	subject customSchemeRegistrations do: [:each | self assert: each referenceCount equals: 1].
	self assert: (ObjectStub registry includesKey: scheme1).
	self assert: (ObjectStub registry includesKey: scheme2).
	interface customSchemeRegistrations: #().
	self deny: (ObjectStub registry includesKey: scheme1).
	self deny: (ObjectStub registry includesKey: scheme2)!

testEnableTrackingPrevention
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions5.
	self assert: subject trackingPreventionLevel equals: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED.
	self assert: interface enableTrackingPrevention.
	interface enableTrackingPrevention: false.
	self deny: subject isTrackingPreventionEnabled.
	self assert: subject trackingPreventionLevel equals: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_NONE.
	interface enableTrackingPrevention: true.
	self assert: subject isTrackingPreventionEnabled.
	self assert: subject trackingPreventionLevel equals: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED.
!

testExclusiveDataFolderAccess
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	self assert: subject exclusiveUserDataFolderAccess.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions2.
	self assert: interface exclusiveUserDataFolderAccess.
	subject exclusiveUserDataFolderAccess: false.
	self deny: interface exclusiveUserDataFolderAccess.
	self deny: subject exclusiveUserDataFolderAccess.
!

testIsCustomCrashReportingEnabled
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions3.
	self deny: subject isCustomCrashReportingEnabled.
	self deny: interface isCustomCrashReportingEnabled.
	interface isCustomCrashReportingEnabled: true.
	self assert: subject isCustomCrashReportingEnabled.
	self assert: interface isCustomCrashReportingEnabled!

testLanguage
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions.
	self assert: subject locale equals: Locale userDefault.
	self assert: interface language equals: Locale userDefault tag.
	interface language: 'fr-CA'.
	self assert: subject locale lcid equals: 3084.
	self assert: interface language equals: 'fr-CA'.
	subject locale: (Locale lcid: 1055).
 	self assert: interface language equals: 'tr-TR'!

testReleaseChannels
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions7.
	self assert: subject releaseChannels equals: COREWEBVIEW2_RELEASE_CHANNELS_STABLE.
	self assert: interface releaseChannels equals: COREWEBVIEW2_RELEASE_CHANNELS_STABLE.
	interface
		releaseChannels: COREWEBVIEW2_RELEASE_CHANNELS_STABLE | COREWEBVIEW2_RELEASE_CHANNELS_DEV.
	self assert: subject releaseChannels
		equals: COREWEBVIEW2_RELEASE_CHANNELS_STABLE | COREWEBVIEW2_RELEASE_CHANNELS_DEV.
	self assert: interface releaseChannels
		equals: COREWEBVIEW2_RELEASE_CHANNELS_STABLE | COREWEBVIEW2_RELEASE_CHANNELS_DEV.
	self
		should: [interface releaseChannels: -1]
		raise: HRESULTError
		matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_INVALID_PARAMETER]!

testScrollbarStyle
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions8.
	self assert: subject scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT.
	self assert: interface scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT.
	interface scrollBarStyle: COREWEBVIEW2_SCROLLBAR_STYLE_FLUENT_OVERLAY.
	self assert: subject scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_FLUENT_OVERLAY.
	self assert: interface scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_FLUENT_OVERLAY.
	self
		should: [interface scrollBarStyle: -1]
		raise: HRESULTError
		matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_INVALID_PARAMETER]!

testStlConvertFromVersion0
	| options |
	options := Object
				fromLiteralStoreArray: #(#'!!STL' 4 1704966 ##(Smalltalk.WebView2EnvironmentOptions) nil 13 8 'fr-FR' 8 '100.0.1185').
	self deny: options allowSSO.
	self assert: options isCustomCrashReportingEnabled.
	self assert: options browserVersion equals: '100.0.1185'.
	self assert: options locale equals: 'fr-FR'.
	self assert: options isTrackingPreventionEnabled.
	self assert: options channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
	self assert: options releaseChannels equals: COREWEBVIEW2_RELEASE_CHANNELS_STABLE.
	self assert: options scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT.
	self assert: options customSchemeRegistrations equals: #()!

testStlConvertFromVersion0a
	| options |
	options := (Object fromLiteralStoreArray: #(#'!!STL' 6 1286 #{WebView2.WebView2EnvironmentOptions} nil 13 8 'fr-FR' 8 '100.0.1185' 1)).
	self deny: options allowSSO.
	self assert: options isCustomCrashReportingEnabled.
	self assert: options browserVersion equals: '100.0.1185'.
	self assert: options locale equals: 'fr-FR'.
	self deny: options isTrackingPreventionEnabled.
	self assert: options channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
	self assert: options releaseChannels equals: COREWEBVIEW2_RELEASE_CHANNELS_STABLE.
	self assert: options scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT.
	self assert: options customSchemeRegistrations equals: #()!

testStlConvertFromVersion1
	| options |
	options := Object
				fromLiteralStoreArray: #(#'!!STL' 6 2118 1 #{WebView2.WebView2EnvironmentOptions} nil 13 8 'fr-FR' 8 '100.0.1185' 7 3 5 3).
	self deny: options allowSSO.
	self assert: options isCustomCrashReportingEnabled.
	self assert: options browserVersion equals: '100.0.1185'.
	self assert: options locale equals: 'fr-FR'.
	self assert: options isTrackingPreventionEnabled.
	self assert: options channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_LEAST_STABLE.
	self assert: options releaseChannels equals: COREWEBVIEW2_RELEASE_CHANNELS_BETA.
	self assert: options scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_FLUENT_OVERLAY.
	self assert: options customSchemeRegistrations equals: #()!

testStlConvertFromVersion2
	| options scheme |
	options := (Object fromLiteralStoreArray: #(#'!!STL' 6 2374 2 #{WebView2.WebView2EnvironmentOptions} nil 13 8 'fr-FR' 8 '100.0.1185' 5 1 3 1 38 #{Core.Array} 1 774 #{WebView2.WebView2CustomSchemeRegistration} 3 8 'foo' 82 2 8 'https://www.object-arts.com' 8 'https://www.github.com/DolphinSmalltalk')).
	self deny: options allowSSO.
	self assert: options isCustomCrashReportingEnabled.
	self assert: options browserVersion equals: '100.0.1185'.
	self assert: options locale equals: 'fr-FR'.
	self assert: options isTrackingPreventionEnabled.
	self assert: options channelSearchKind equals: COREWEBVIEW2_CHANNEL_SEARCH_KIND_MOST_STABLE.
	self assert: options releaseChannels equals: COREWEBVIEW2_RELEASE_CHANNELS_STABLE.
	self assert: options scrollBarStyle equals: COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT.
	scheme := options customSchemeRegistrations single.
	self assert: scheme schemeName equals: 'foo'.
	self assert: scheme allowedOrigins
		equals: #('https://www.object-arts.com' 'https://www.github.com/DolphinSmalltalk').
	self assert: scheme hasAuthorityComponent.
	self deny: scheme treatAsSecure!

testTargetCompatibleBrowserVersion
	| subject interface version |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions.
	self assert: subject browserVersion equals: CORE_WEBVIEW_TARGET_PRODUCT_VERSION.
	self assert: interface targetCompatibleBrowserVersion equals: CORE_WEBVIEW_TARGET_PRODUCT_VERSION.
	version := '100.0.1185'.
	interface targetCompatibleBrowserVersion: version.
	self assert: subject browserVersion equals: version.
	self assert: interface targetCompatibleBrowserVersion equals: version.
	subject browserVersion: 'foo'.
	self assert: interface targetCompatibleBrowserVersion equals: 'foo'.! !

!WebView2.Tests.WebView2EnvironmentOptionsTest categoriesForMethods!
testAdditionalBrowserArguments!public! !
testAllowSSO!public! !
testAreBrowserExtensionsEnabled!public! !
testChannelSearchKind!public! !
testCustomSchemeRegistrations!public! !
testEnableTrackingPrevention!public! !
testExclusiveDataFolderAccess!public! !
testIsCustomCrashReportingEnabled!public! !
testLanguage!public! !
testReleaseChannels!public! !
testScrollbarStyle!public! !
testStlConvertFromVersion0!public! !
testStlConvertFromVersion0a!public! !
testStlConvertFromVersion1!public! !
testStlConvertFromVersion2!public! !
testTargetCompatibleBrowserVersion!public! !
!

