"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment6Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment6Test guid: (Core.GUID fromString: '{5873d4db-0d2c-495d-b4a1-69719622a5c3}')!

WebView2.Tests.ICoreWebView2Environment6Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment6Test methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment6!

testPrintSettings
	| subject value |
	subject := webviewEnvironment createPrintSettings.
	"Collation"
	self assert: subject collationName equals: #default.
	subject collationName: #collated.
	self assert: subject collation equals: COREWEBVIEW2_PRINT_COLLATION_COLLATED.
	"Color Mode"
	self assert: subject colorModeName equals: #default.
	subject colorModeName: #grayscale.
	self assert: subject colorMode equals: COREWEBVIEW2_PRINT_COLOR_MODE_GRAYSCALE.
	"Copies"
	self assert: subject copies equals: 1.
	subject copies: 3.
	self assert: subject copies equals: 3.
	"Duplex mode"
	self assert: subject duplexModeName equals: #default.
	subject duplexModeName: #doubleSidedLongEdge.
	self assert: subject duplex equals: COREWEBVIEW2_PRINT_DUPLEX_TWO_SIDED_LONG_EDGE.
	"Footer URI"
	self assert: subject footerUri equals: ''.
	value := 'https://www.github.com/DolphinSmalltalk'.
	subject footerUri: value.
	self assert: subject footerUri equals: value.
	"Header"
	self assert: subject headerTitle equals: ''.
	value := 'Foo Bar'.
	subject headerTitle: value.
	self assert: subject headerTitle equals: value.
	"Margins"
	value := 0.5 @ 1.25 corner: 0.75 @ 1.05.
	subject margins: value.
	self assert: subject margins equals: value.
	"Media size"
	self assert: subject mediaSizeName equals: #default.
	subject mediaSizeName: #custom.
	self assert: subject mediaSize equals: COREWEBVIEW2_PRINT_MEDIA_SIZE_CUSTOM.
	"Orientation"
	self assert: subject orientationName equals: #portrait.
	subject orientationName: #landscape.
	self assert: subject mediaSize equals: COREWEBVIEW2_PRINT_ORIENTATION_LANDSCAPE.
	"Page size"
	self assert: subject pageSize isKindOf: Graphics.Point.
	value := 5.5 @ 4.5.
	subject pageSize: value.
	self assert: subject pageSize equals: value.
	"Pages per side"
	self assert: subject pagesPerSide equals: 1.
	subject pagesPerSide: 4.
	self assert: subject pagesPerSide equals: 4.
	"Printer name"
	self assert: subject printerName equals: ''.
	"Page ranges"
	self assert: subject pageRanges equals: ''.
	value := '1-2,5-6'.
	subject pageRanges: value.
	self assert: subject pageRanges equals: value.
	"Scale"
	self assert: subject scaleFactor equals: 1.
	subject scaleFactor: 0.85.
	self assert: subject scaleFactor equals: 0.85.
	"Print backgrounds"
	self deny: subject shouldPrintBackgrounds.
	subject shouldPrintBackgrounds: true.
	self assert: subject shouldPrintBackgrounds.
	"Header and Footer"
	self deny: subject shouldPrintHeaderAndFooter.
	subject shouldPrintHeaderAndFooter: true.
	self assert: subject shouldPrintHeaderAndFooter.
	"Selection only"
	self deny: subject shouldPrintSelectionOnly.
	subject shouldPrintSelectionOnly: true.
	self assert: subject shouldPrintSelectionOnly! !

!WebView2.Tests.ICoreWebView2Environment6Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testPrintSettings!public! !
!

