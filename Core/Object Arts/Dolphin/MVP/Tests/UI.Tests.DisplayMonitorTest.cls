"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.DisplayMonitorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.DisplayMonitorTest guid: (Core.GUID fromString: '{a26059de-9a66-4eea-892a-2cc388096fb2}')!

UI.Tests.DisplayMonitorTest comment: ''!

!UI.Tests.DisplayMonitorTest methodsFor!

testActive
	<skipUnless: #isInForeground>
	| shell primary user32 |
	primary := DisplayMonitor primary.
	shell := ShellView show.
	
	[self skipUnless: 
			["If for some reason the test shell does not open on top, e.g monitors are turned off, the test is not valid"
			View foreground == shell].
	shell position: primary workArea topLeft + 50.
	self assert: DisplayMonitor active equals: primary.
	((DisplayMonitor desktopMonitors reject: [:each | each = primary]) lookup: 1)
		ifNotNil: 
			[:otherMonitor |
			| active |
			shell position: otherMonitor workArea topLeft + 100.
			self assert: shell displayMonitor equals: otherMonitor.
			active := DisplayMonitor active.
			self assert: active equals: otherMonitor.
			self deny: active equals: primary].
	"Simulate transfer of activation to the desktop. Making it the foreground window is equivalent to activating the Windows shell program manager"
	user32 := FakeUserLibrary new.
	user32
		initializeForDesktopActive;
		open.
	"As we have things set up to fake the foreground/active window, sneak in some tests of related View class enquiries."
	self assertIsNil: View activeHandle.
	self assert: View activeOrDesktop isDesktop.
	self assert: DisplayMonitor active equals: (DisplayMonitor containingPoint: Cursor position)]
			ensure: 
				[user32 free.
				shell destroy]!

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
	self assert: (DisplayMonitor containingPoint: 0 @ 0) equals: DisplayMonitor primary.
	self assert: (DisplayMonitor containingPoint: DisplayMonitor primary workArea center)
		equals: DisplayMonitor primary.
	self
		assertIsNil: (DisplayMonitor containingPoint: SystemMetrics current virtualScreenRectangle corner + 1)!

testDesktop
	self assert: View desktop monitor identicalTo: DisplayMonitor active!

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
	self assert: (DisplayMonitor containingPoint: 0 @ 0) equals: DisplayMonitor primary.
	self
		assert: (DisplayMonitor nearestPoint: SystemMetrics current virtualScreenRectangle bottomRight - 1)
		equals: (DisplayMonitor desktopMonitors asSortedCollection: [:a :b | a workArea corner < b workArea corner]) last!

testNearestRectangle
	self assert: (DisplayMonitor nearestRectangle: (0 @ 0 corner: 100 @ 100))
		equals: DisplayMonitor primary!

testPrimary
	| primary origin rectangle workArea |
	primary := DisplayMonitor primary.
	self assert: primary isPrimary.
	self assert: primary isAttachedToDesktop.
	rectangle := primary rectangle.
	self assert: rectangle equals: View desktop rectangle.
	workArea := primary workArea.
	self assert: (rectangle contains: workArea).
	origin := primary origin.
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
			self assert: secondary printString equals: 'a DisplayMonitor(<1p>)' << secondary deviceName]!

testScaleFactor
	DisplayMonitor desktopMonitors
		do: [:each | self assert: each scaleFactor equals: each dpi / Win32Constants.USER_DEFAULT_SCREEN_DPI]! !

!UI.Tests.DisplayMonitorTest categoriesForMethods!
testActive!public!unit tests! !
testAllIntersecting!public!unit tests! !
testAllPhysicalMonitors!public!unit tests! !
testComparing!public!unit tests! !
testContainingPoint!public!unit tests! !
testDesktop!public!unit tests! !
testDeviceName!public!unit tests! !
testDisplayingAndNearestView!public!unit tests! !
testIntersecting!public!unit tests! !
testNearestPoint!public!unit tests! !
testNearestRectangle!public!unit tests! !
testPrimary!public!unit tests! !
testPrintString!public!unit tests! !
testScaleFactor!public!unit tests! !
!

