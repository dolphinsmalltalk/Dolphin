﻿"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #SystemMetricsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SystemMetricsTest guid: (GUID fromString: '{51bd2c01-0ffe-493b-9c70-ace135134663}')!

SystemMetricsTest comment: ''!

!SystemMetricsTest categoriesForClass!Unclassified! !

!SystemMetricsTest methodsFor!

testIconTitleFont
	| font96 fontSys |
	font96 := SystemMetrics default iconTitleFont.
	fontSys := SystemMetrics current iconTitleFont.
	self assert: fontSys equals: font96.
	self assert: fontSys dpi equals: UserLibrary default getDpiForSystem.
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
	self assert: SystemMetrics default menuImageExtent equals: 16 @ 16.
	self assert: (SystemMetrics forDpi: 120) menuImageExtent equals: 16 @ 16.
	self assert: (SystemMetrics forDpi: 143) menuImageExtent equals: 16 @ 16.
	self assert: (SystemMetrics forDpi: 144) menuImageExtent equals: 24 @ 24.
	self assert: (SystemMetrics forDpi: 167) menuImageExtent equals: 24 @ 24.
	self assert: (SystemMetrics forDpi: 168) menuImageExtent equals: 24 @ 24.
	self assert: (SystemMetrics forDpi: 191) menuImageExtent equals: 24 @ 24.
	self assert: (SystemMetrics forDpi: 192) menuImageExtent equals: 32 @ 32.
	self assert: (SystemMetrics forDpi: 216) menuImageExtent equals: 32 @ 32.
	self assert: (SystemMetrics forDpi: 240) menuImageExtent equals: 40 @ 40.
	self assert: (SystemMetrics forDpi: 264) menuImageExtent equals: 40 @ 40.
	self assert: (SystemMetrics forDpi: 288) menuImageExtent equals: 48 @ 48.
	self assert: (SystemMetrics forDpi: 336) menuImageExtent equals: 48 @ 48.
	self assert: (SystemMetrics forDpi: 336) menuImageExtent equals: 48 @ 48.
	self assert: (SystemMetrics forDpi: 383) menuImageExtent equals: 48 @ 48.
	self assert: (SystemMetrics forDpi: 384) menuImageExtent equals: 64 @ 64.
	self assert: (SystemMetrics forDpi: 408) menuImageExtent equals: 64 @ 64.
	self assert: (SystemMetrics forDpi: 432) menuImageExtent equals: 64 @ 64.
	self assert: (SystemMetrics forDpi: 480) menuImageExtent equals: 64 @ 64.
	self assert: (SystemMetrics forDpi: 576) menuImageExtent equals: 64 @ 64!

testSmallIconExtent
	| metrics |
	metrics := SystemMetrics default.
	self assert: metrics smallIconExtent equals: 16 @ 16.
	metrics := SystemMetrics forDpi: 120.
	self assert: metrics smallIconExtent equals: 20 @ 20! !

!SystemMetricsTest categoriesForMethods!
testIconTitleFont!public!unit tests! !
testLargeIconExtent!public! !
testMenuBarHeight!public! !
testMenuImageExtent!public! !
testSmallIconExtent!public! !
!
