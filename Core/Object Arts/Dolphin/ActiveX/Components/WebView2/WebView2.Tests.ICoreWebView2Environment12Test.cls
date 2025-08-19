"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment12Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment12Test guid: (Core.GUID fromString: '{e0a28245-4a2e-44a5-872f-04f8f747bb64}')!

WebView2.Tests.ICoreWebView2Environment12Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment12Test methodsFor!

minimumEnvironmentVersion
	"From 1.0.1661.34"

	^ICoreWebView2Environment12!

testControllerOptions2
	| controllerOptions |
	"From 1.0.1661.34"
	controllerOptions := (webviewEnvironment createCoreWebView2ControllerOptions) queryInterface: ICoreWebView2ControllerOptions2 ifNone: [self skip].
	"Script locale"
	self assert: controllerOptions scriptLocale equals: ''.
	controllerOptions scriptLocale: 'fr-FR'.
	self assert: controllerOptions scriptLocale equals: 'fr-FR'!

testCreateAndMapSharedBuffer
	| buf testBytes bytes fv |
	buf := webviewEnvironment createSharedBuffer: 4096.
	testBytes := Object comment asByteArray.
	buf buffer
		replaceFrom: 1
		to: testBytes size
		with: testBytes
		startingAt: 1.
	bytes := buf openStream contents.
	self assert: bytes size equals: 4096.
	self assert: (Utf8String fromByteArray: bytes length: testBytes size) equals: Object comment.
	testBytes := testBytes resize: 4096.
	self assert: buf buffer asByteArray equals: testBytes.
	fv := buf memoryMappedFile mapView.
	self assert: (fv copyFrom: 1 to: 4096) equals: testBytes.
	fv free.
	self assert: buf Close equals: S_OK.
	self
		should: [buf memoryMappedFile]
		raise: HRESULTError
		matching: [:ex | ex hresult asInteger = RO_E_CLOSED].
	buf free!

testCreateEmptySharedBuffer
	self
		should: [webviewEnvironment createSharedBuffer: 0]
		raise: Win32Error
		matching: 
			[:ex |
			| hr |
			hr := ex hresult asInteger.
			hr = E_INVALIDARG or: [hr = E_OUTOFMEMORY]]! !

!WebView2.Tests.ICoreWebView2Environment12Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testControllerOptions2!public! !
testCreateAndMapSharedBuffer!public! !
testCreateEmptySharedBuffer!public! !
!

