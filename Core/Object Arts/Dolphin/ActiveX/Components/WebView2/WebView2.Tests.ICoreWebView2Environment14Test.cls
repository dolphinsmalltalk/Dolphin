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
	^ICoreWebView2Environment14!

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
testCreateDirectoryHandle!public! !
testCreateFileHandle!public! !
!

