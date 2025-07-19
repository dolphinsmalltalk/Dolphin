"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment14Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment14Test guid: (Core.GUID fromString: '{dc9b2e4b-8b8c-4a73-95ae-65d828ac6f49}')!

WebView2.Tests.ICoreWebView2Environment14Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment14Test methodsFor!

minimumEnvironmentVersion
	"From 1.0.2651.64"

	^ICoreWebView2Environment14!

testControllerOptions3
	| controllerOptions color |
	"From 1.0.3296.44"
	controllerOptions := webviewEnvironment createCoreWebView2ControllerOptions
				queryInterface: ICoreWebView2ControllerOptions3
				ifNone: [self skip].
	"Default background colour"
	self assert: controllerOptions defaultBackgroundColor equals: Graphics.Color window.
	color := Graphics.Color chartreuse.
	controllerOptions defaultBackgroundColor: color.
	self assert: controllerOptions defaultBackgroundColor equals: color.

	"Partially transparent background colours are not supported."
	color := color alpha: 128.
	self
		should: [controllerOptions defaultBackgroundColor: color]
		raise: HRESULTError
		matching: [:ex | ex hresult = E_INVALIDARG].

	"Can be fully transparent though"
	color := color alpha: 0.
	controllerOptions defaultBackgroundColor: color.
	self assert: controllerOptions defaultBackgroundColor equals: color!

testControllerOptions4
	| controllerOptions |
	"From 1.0.3351.48"
	controllerOptions := webviewEnvironment createCoreWebView2ControllerOptions
				queryInterface: ICoreWebView2ControllerOptions4
				ifNone: [self skip].
	"AllowHostInputProcessing"
	self deny: controllerOptions allowHostInputProcessing.
	controllerOptions allowHostInputProcessing: true.
	self assert: controllerOptions allowHostInputProcessing!

testCreateDirectoryHandle
	| fileHandle tmp |
	tmp := File tempPath.
	fileHandle := webviewEnvironment createWebFileSystemDirectoryHandle: tmp
				permission: COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION_READ_ONLY.
	self assert: fileHandle path equals: tmp.
	self assert: fileHandle permission
		equals: COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION_READ_ONLY.
	self assert: fileHandle kind equals: COREWEBVIEW2_FILE_SYSTEM_HANDLE_KIND_DIRECTORY!

testCreateFileHandle
	| fileHandle tmp |
	tmp := File temporaryFilename.
	fileHandle := webviewEnvironment createWebFileSystemFileHandle: tmp
				permission: COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION_READ_WRITE.
	self assert: fileHandle path equals: tmp.
	self assert: fileHandle permission
		equals: COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION_READ_WRITE.
	self assert: fileHandle kind equals: COREWEBVIEW2_FILE_SYSTEM_HANDLE_KIND_FILE! !

!WebView2.Tests.ICoreWebView2Environment14Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testControllerOptions3!public! !
testControllerOptions4!public! !
testCreateDirectoryHandle!public! !
testCreateFileHandle!public! !
!

