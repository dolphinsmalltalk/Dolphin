"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'WebView2.WebView2Loader'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.WebView2Loader guid: (Core.GUID fromString: '{b4b18867-230d-4b18-8048-0f12821bf5e0}')!

WebView2.WebView2Loader comment: ''!

!WebView2.WebView2Loader categoriesForClass!External-Libraries! !

!WebView2.WebView2Loader methodsFor!

compareBrowserVersions: version1 version2: version2 result: result
	<stdcall: hresult CompareBrowserVersions lpwstr lpwstr int32*>
	^self invalidCall: _failureCode!

createCoreWebView2Environment: environmentCreatedHandler
	<stdcall: hresult CreateCoreWebView2Environment ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler*>
	^self invalidCall: _failureCode!

createCoreWebView2EnvironmentWithOptions: browserExecutableFolder userDataFolder: userDataFolder environmentOptions: environmentOptions environmentCreatedHandler: environmentCreatedHandler
	<stdcall: hresult CreateCoreWebView2EnvironmentWithOptions lpwstr lpwstr ICoreWebView2EnvironmentOptions* ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler*>
	^self invalidCall: _failureCode!

getAvailableCoreWebView2BrowserVersionString: browserExecutableFolder
	"
	WebView2Loader default getAvailableCoreWebView2BrowserVersionString: nil
	"

	| ptr versionInfo |
	ptr := Address new.
	self getAvailableCoreWebView2BrowserVersionString: browserExecutableFolder versionInfo: ptr.
	versionInfo := Utf16String fromAddress: ptr.
	Ole32 coTaskMemFree: ptr.
	^versionInfo!

getAvailableCoreWebView2BrowserVersionString: browserExecutableFolder versionInfo: versionInfo
	<stdcall: hresult GetAvailableCoreWebView2BrowserVersionString lpwstr lpwstr*>
	^self invalidCall: _failureCode!

loadFlags
	"Private - Includes VM folder in search"

	^LOAD_LIBRARY_SEARCH_DEFAULT_DIRS! !

!WebView2.WebView2Loader categoriesForMethods!
compareBrowserVersions:version2:result:!public! !
createCoreWebView2Environment:!public! !
createCoreWebView2EnvironmentWithOptions:userDataFolder:environmentOptions:environmentCreatedHandler:!public! !
getAvailableCoreWebView2BrowserVersionString:!enquiries!public! !
getAvailableCoreWebView2BrowserVersionString:versionInfo:!public! !
loadFlags!constants!private! !
!

!WebView2.WebView2Loader class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'WebView2Loader'
! !

!WebView2.WebView2Loader class categoriesForMethods!
fileName!constants!public! !
!

