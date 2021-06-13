"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DisplayMonitorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DisplayMonitorTest guid: (GUID fromString: '{a26059de-9a66-4eea-892a-2cc388096fb2}')!
DisplayMonitorTest comment: ''!
!DisplayMonitorTest categoriesForClass!Unclassified! !
!DisplayMonitorTest methodsFor!

testAllIntersecting
	self assert: (DisplayMonitor allIntersecting: (View desktop rectangle insetBy: 200))
		equals: {DisplayMonitor primary}.
	self
		assert: (DisplayMonitor allIntersecting: (SystemMetrics current virtualScreenOrigin - 100 extent: 50))
		equals: #().
	self assert: (DisplayMonitor allIntersecting: SystemMetrics current virtualScreenRectangle)
		equals: DisplayMonitor desktopMonitors!

testAllPhysicalMonitors
	| all |
	all := DisplayMonitor desktopMonitors.
	self assert: (all count: [:each | each isPrimary]) equals: 1.
	self assert: all size equals: SystemMetrics current monitorCount.
	self assert: (all inject: Rectangle new into: [:sum :each | sum merge: each rectangle])
		equals: SystemMetrics current virtualScreenRectangle!

testComparing
	| all primary |
	all := DisplayMonitor allMonitors.
	primary := all detect: [:each | each isPrimary].
	self assert: primary hash equals: DisplayMonitor primary hash.
	self assert: primary equals: DisplayMonitor primary.
	all size > 1
		ifTrue: 
			[| secondary |
			secondary := all detect: [:each | each isPrimary not].
			self deny: secondary hash equals: primary hash.
			self deny: secondary equals: primary]!

testContainingPoint
	self assert: (DisplayMonitor containingPoint: View desktop rectangle bottomRight - 1)
		equals: DisplayMonitor primary.
	self
		assertIsNil: (DisplayMonitor containingPoint: SystemMetrics current virtualScreenRectangle corner + 1)!

testDeviceName
	self deny: DisplayMonitor primary deviceName equals: ''!

testDisplayingAndNearestView
	| monitor shell hWnd screenRect |
	shell := ShellView show.
	hWnd := shell asParameter.
	screenRect := SystemMetrics current virtualScreenRectangle.
	
	[monitor := shell displayMonitor.
	self assert: (monitor workArea contains: shell rectangle).
	"Move the shell completely off screen so it is not on a monitor at all"
	shell position: screenRect bottomRight + 1.
	monitor := shell displayMonitor.
	self assertIsNil: monitor.
	monitor := DisplayMonitor nearestView: shell]
			ensure: [shell destroy].
	"Depending on the way the monitors are oriented, the nearest view may be any of the monitors. The calculation is relatively complex, and we don't need to test that thoroughly as Windows is doing it. The only thing we could really get wrong is passing the wrong flag, but hopefully we won't have got it wrong in two places."
	self assert: monitor equals: (DisplayMonitor nearestPoint: screenRect bottomRight).
	self assertIsNil: (DisplayMonitor displayingView: shell).
	"Returns the desktop monitor for null handle"
	self assert: (DisplayMonitor nearestView: shell) equals: View desktop displayMonitor.
	self
		should: [DisplayMonitor nearestView: hWnd]
		raise: Win32Error
		matching: [:ex | ex statusCode = Win32Errors.ERROR_INVALID_WINDOW_HANDLE]!

testIntersecting
	| rect |
	rect := View desktop rectangle insetBy: 200.
	self assert: (DisplayMonitor intersecting: rect) equals: DisplayMonitor primary.
	rect := SystemMetrics current virtualScreenOrigin - 100 extent: 50.
	self assertIsNil: (DisplayMonitor intersecting: rect).
	self assert: (DisplayMonitor intersecting: SystemMetrics current virtualScreenRectangle)
		equals: DisplayMonitor primary!

testNearestPoint
	self assert: (DisplayMonitor nearestPoint: View desktop rectangle bottomRight - 1)
		equals: DisplayMonitor primary!

testPrimary
	| primary origin rectangle workArea |
	primary := DisplayMonitor primary.
	self assert: primary isPrimary.
	false
		ifTrue: 
			["Oddly, this does not appear to hold"
			self assert: (primary devices anySatisfy: [:each | each isPrimary])].
	self assert: primary isAttachedToDesktop.
	rectangle := primary rectangle.
	self assert: rectangle isKindOf: Rectangle.
	self assert: rectangle equals: View desktop rectangle.
	workArea := primary workArea.
	self assert: workArea isKindOf: Rectangle.
	self assert: (rectangle contains: workArea).
	origin := primary origin.
	self assert: origin isKindOf: Point.
	"This seems to be true, even if the primary is right of a secondary (secondary then has negative origin)"
	self assert: origin equals: 0 @ 0!

testPrintString
	| all primary |
	all := DisplayMonitor allMonitors.
	primary := all detect: [:each | each isPrimary].
	self assert: primary printString equals: 'a DisplayMonitor(primary: <1p>)' << primary deviceName.
	all size > 1
		ifTrue: 
			[| secondary |
			secondary := all detect: [:each | each isPrimary not].
			self assert: secondary printString equals: 'a DisplayMonitor(<1p>)' << secondary deviceName]! !
!DisplayMonitorTest categoriesFor: #testAllIntersecting!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testAllPhysicalMonitors!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testComparing!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testContainingPoint!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testDeviceName!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testDisplayingAndNearestView!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testIntersecting!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testNearestPoint!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testPrimary!public!unit tests! !
!DisplayMonitorTest categoriesFor: #testPrintString!public!unit tests! !

