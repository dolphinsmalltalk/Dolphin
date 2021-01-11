"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'WebView2.WebView2Loader'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.WebView2Loader guid: (Core.GUID fromString: '{7ccf1b3e-522d-4f2a-a0fa-1be7bc5c95b7}')!
WebView2.WebView2Loader comment: ''!
!WebView2.WebView2Loader categoriesForClass!External-Libraries! !
!WebView2.WebView2Loader methodsFor!

createCoreWebView2EnvironmentWith: anICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler
	<stdcall: hresult CreateCoreWebView2EnvironmentWithOptions ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler*>
	^self invalidCall: _failureCode  !

createCoreWebView2EnvironmentWithOptions: browserExecutableFolderString userDataFolder: userDataFolderString environmentOptions: anICoreWebView2EnvironmentOptions environmentCreatedHandler: anICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler
	<stdcall: hresult CreateCoreWebView2EnvironmentWithOptions lpwstr lpwstr ICoreWebView2EnvironmentOptions* ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler*>
	^self invalidCall: _failureCode! !
!WebView2.WebView2Loader categoriesFor: #createCoreWebView2EnvironmentWith:!public! !
!WebView2.WebView2Loader categoriesFor: #createCoreWebView2EnvironmentWithOptions:userDataFolder:environmentOptions:environmentCreatedHandler:!public! !

!WebView2.WebView2Loader class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'WebView2Loader'! !
!WebView2.WebView2Loader class categoriesFor: #fileName!constants!public! !

