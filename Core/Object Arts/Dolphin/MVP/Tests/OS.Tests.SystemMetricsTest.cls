"Filed out from Dolphin Smalltalk"!

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

testSmallIconExtent
	| metrics |
	metrics := SystemMetrics default.
	self assert: metrics smallIconExtent equals: 16 @ 16.
	metrics := SystemMetrics forDpi: 120.
	self assert: metrics smallIconExtent equals: 20 @ 20! !

!OS.Tests.SystemMetricsTest categoriesForMethods!
testLargeIconExtent!public! !
testMenuBarHeight!public! !
testSmallIconExtent!public! !
!

