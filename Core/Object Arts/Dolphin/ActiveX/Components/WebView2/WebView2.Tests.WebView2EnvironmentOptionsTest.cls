﻿"Filed out from Dolphin Smalltalk"!

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

testEnableTrackingPrevention
	| subject interface |
	subject := WebView2EnvironmentOptions new.
	interface := subject queryInterface: ICoreWebView2EnvironmentOptions5.
	self assert: subject trackingPreventionLevel equals: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED.
	self assert: interface enableTrackingPrevention
		equals: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED.
	interface enableTrackingPrevention: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_STRICT.
	self assert: subject trackingPreventionLevel equals: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_STRICT.
	self assert: interface enableTrackingPrevention
		equals: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_STRICT!

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
testEnableTrackingPrevention!public! !
testExclusiveDataFolderAccess!public! !
testIsCustomCrashReportingEnabled!public! !
testLanguage!public! !
testTargetCompatibleBrowserVersion!public! !
!

