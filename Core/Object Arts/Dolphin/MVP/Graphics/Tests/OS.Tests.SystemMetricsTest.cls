﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.SystemMetricsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.SystemMetricsTest guid: (Core.GUID fromString: '{51bd2c01-0ffe-493b-9c70-ace135134663}')!

OS.Tests.SystemMetricsTest comment: ''!

!OS.Tests.SystemMetricsTest methodsFor!

testIconTitleFont
	| font96 fontSys |
	font96 := SystemMetrics default iconTitleFont.
	fontSys := SystemMetrics current iconTitleFont.
	self assert: fontSys equals: font96.
	self assert: fontSys dpi equals: SystemMetrics current dpi.
	self assert: font96 dpi equals: 96!

testLargeIconExtent
	| metrics |
	metrics := SystemMetrics default.
	self assert: metrics largeIconExtent equals: 32@32.

	metrics := SystemMetrics forDpi: 144.
	self assert: metrics largeIconExtent equals: 48@48.
!

testMenuBarHeight
	self assert: (SystemMetrics forDpi: 144) menuBarHeight
		equals: SystemMetrics default menuBarHeight * 1.5!

testMenuImageExtent
	self skipUnless: 
			[| menuFont |
			menuFont := SystemMetrics default menuFont.
			menuFont name = 'Segoe UI' and: [menuFont pointSize = 9]].
	self assert: SystemMetrics default menuImageExtent equals: 16 @ 16.
	self assert: (SystemMetrics forDpi: 120) menuImageExtent equals: 16 @ 16.
	self assert: (SystemMetrics forDpi: 144) menuImageExtent equals: 25 @ 25.
	self assert: (SystemMetrics forDpi: 168) menuImageExtent equals: 30 @ 30.
	self assert: (SystemMetrics forDpi: 192) menuImageExtent equals: 32 @ 32.
	self assert: (SystemMetrics forDpi: 216) menuImageExtent equals: 37 @ 37.
	self assert: (SystemMetrics forDpi: 240) menuImageExtent equals: 41 @ 41.
	self assert: (SystemMetrics forDpi: 288) menuImageExtent equals: 48 @ 48.
	self assert: (SystemMetrics forDpi: 312) menuImageExtent equals: 52 @ 52.
	self assert: (SystemMetrics forDpi: 336) menuImageExtent equals: 57 @ 57.
	self assert: (SystemMetrics forDpi: 384) menuImageExtent equals: 65 @ 65.
	self assert: (SystemMetrics forDpi: 408) menuImageExtent equals: 68 @ 68.
	self assert: (SystemMetrics forDpi: 432) menuImageExtent equals: 72 @ 72.
	self assert: (SystemMetrics forDpi: 480) menuImageExtent equals: 81 @ 81!

testSmallIconExtent
	| metrics |
	metrics := SystemMetrics default.
	self assert: metrics smallIconExtent equals: 16 @ 16.
	metrics := SystemMetrics forDpi: 120.
	self assert: metrics smallIconExtent equals: 20 @ 20! !

!OS.Tests.SystemMetricsTest categoriesForMethods!
testIconTitleFont!public!unit tests! !
testLargeIconExtent!public! !
testMenuBarHeight!public! !
testMenuImageExtent!public! !
testSmallIconExtent!public! !
!

