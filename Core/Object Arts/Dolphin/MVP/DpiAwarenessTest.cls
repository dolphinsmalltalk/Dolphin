"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #DpiAwarenessTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

DpiAwarenessTest guid: (GUID fromString: '{235e8444-8848-4a7d-8220-bd89dd872ac5}')!

DpiAwarenessTest comment: ''!

!DpiAwarenessTest categoriesForClass!Unclassified! !

!DpiAwarenessTest methodsFor!

allAwarenessContexts
	^{DpiAwareness unaware.
		DpiAwareness gdiScaled.
		DpiAwareness system.
		DpiAwareness system.
		DpiAwareness perMonitor.
		DpiAwareness perMonitorV1.
		DpiAwareness invalid}!

testAwarenessLevel
	#(#unaware 0 #gdiScaled 0 #system 1 #perMonitor 2 #perMonitorV1 2 #invalid -1)
		pairsDo: [:name :level | self assert: (DpiAwareness named: name) awarenessLevel equals: level]!

testComparing
	| all |
	all := self allAwarenessContexts.
	all deepCopy do: 
			[:a |
			all do: 
					[:b |
					(a == b or: [a handle = b handle])
						ifTrue: 
							[self assert: a equals: b.
							self assert: b equals: a.
							self assert: a hash equals: b hash]
						ifFalse: 
							[self deny: a equals: b.
							self deny: b equals: a.
							self deny: a hash equals: b hash]]].
	#(24592 #unaware 36881 #system 34 #perMonitor 18 #perMonitorV1 1073766416 #gdiScaled 32 #invalid)
		pairsDo: 
			[:context :name |
			| subject comperand |
			subject := DpiAwareness named: name.
			comperand := DpiAwareness fromHandle: context.
			self deny: comperand identicalTo: subject.
			self assert: subject equals: comperand.
			self assert: comperand equals: subject.
			self assert: subject hash equals: comperand hash]!

testCreateNamed
	self assert: (DpiAwareness named: #unaware) identicalTo: DpiAwareness.Unaware.
	self assert: (DpiAwareness named: #system) identicalTo: DpiAwareness.System.
	self assert: (DpiAwareness named: #perMonitor) identicalTo: DpiAwareness.PerMonitor.
	self assert: (DpiAwareness named: #perMonitorV1) identicalTo: DpiAwareness.PerMonitorV1.
	self assert: (DpiAwareness named: #gdiScaled) identicalTo: DpiAwareness.GdiScaled.
	self deny: (DpiAwareness named: #invalid) isValid!

testDpi
	#(#unaware 96 #gdiScaled 96 #perMonitor 0 #perMonitorV1 0 #invalid 0)
		pairsDo: [:name :dpi | self assert: (DpiAwareness named: name) dpi equals: dpi].
	DpiAwareness current isUnaware
		ifFalse: [self assert: DpiAwareness system dpi equals: SystemMetrics current dpi]!

testFromHandle
	self assert: (DpiAwareness fromHandle: DPI_AWARENESS_CONTEXT_UNAWARE)
		identicalTo: DpiAwareness.Unaware.
	self assert: (DpiAwareness fromHandle: DPI_AWARENESS_CONTEXT_SYSTEM_AWARE)
		identicalTo: DpiAwareness.System.
	self assert: (DpiAwareness fromHandle: DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2)
		identicalTo: DpiAwareness.PerMonitor.
	self assert: (DpiAwareness fromHandle: DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE)
		identicalTo: DpiAwareness.PerMonitorV1.
	self assert: (DpiAwareness fromHandle: DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED)
		identicalTo: DpiAwareness.GdiScaled.
	self assert: (DpiAwareness fromHandle: 34) name equals: #perMonitor.
	self deny: (DpiAwareness fromHandle: 3688) equals: DpiAwareness perMonitor.
	self deny: (DpiAwareness fromHandle: 32) isValid!

testInContextDo
	| current |
	(self allAwarenessContexts select: [:each | each isValid])
		do: [:each | each inContextDo: [self assert: DpiAwareness current equals: each]].
	"Attempting to set an invalid context has no effect"
	current := DpiAwareness current.
	self assert: current isValid.
	DpiAwareness invalid inContextDo: [self assert: DpiAwareness current equals: current]!

testIsCurrent
	| current wellKnown |
	current := DpiAwareness current.
	self deny: DpiAwareness invalid isCurrent.
	self assert: current isCurrent.
	wellKnown := DpiAwareness named: DpiAwareness current name.
	self assert: (wellKnown handle between: DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED
				and: DPI_AWARENESS_CONTEXT_UNAWARE).
	self deny: wellKnown identicalTo: current.
	self assert: wellKnown equals: current.
	self assert: wellKnown isCurrent!

testIsPerMonitor
	#(#unaware #system #gdiScaled #invalid)
		do: [:each | self deny: (DpiAwareness named: each) isPerMonitor].
	self assert: DpiAwareness perMonitor isPerMonitor.
	self assert: DpiAwareness perMonitorV1 isPerMonitor.
	self assert: (DpiAwareness fromHandle: 34) isPerMonitor.
	self assert: (DpiAwareness fromHandle: 18) isPerMonitor!

testIsSystemAware
	#(#unaware #perMonitor #perMonitorV1 #gdiScaled #invalid)
		do: [:each | self deny: (DpiAwareness named: each) isSystemAware].
	self assert: DpiAwareness system isSystemAware.
	self assert: (DpiAwareness fromHandle: 36881) isSystemAware!

testIsUnaware
	#(#system #perMonitor #perMonitorV1 #invalid)
		do: [:each | self deny: (DpiAwareness named: each) isUnaware].
	self assert: DpiAwareness unaware isUnaware.
	self assert: DpiAwareness gdiScaled isUnaware.
	self assert: (DpiAwareness fromHandle: 24592) isUnaware!

testName
	self assert: (DpiAwareness fromHandle: 24592) name identicalTo: #unaware.
	self assert: (DpiAwareness fromHandle: 36881) name identicalTo: #system.
	self assert: (DpiAwareness fromHandle: 34) name identicalTo: #perMonitor.
	self assert: (DpiAwareness fromHandle: 1073766416) name identicalTo: #gdiScaled.
	self assert: (DpiAwareness fromHandle: 18) name identicalTo: #perMonitorV1.
	self assert: (DpiAwareness fromHandle: 0) name identicalTo: #invalid!

testPrintString
	#(#unaware #system #perMonitor #perMonitorV1 #gdiScaled #invalid)
		do: [:each | self assert: (DpiAwareness named: each) printString equals: 'DpiAwareness <1s>' << each]! !
!DpiAwarenessTest categoriesForMethods!
allAwarenessContexts!constants!private! !
testAwarenessLevel!public!unit tests! !
testComparing!public!unit tests! !
testCreateNamed!public!unit tests! !
testDpi!public!unit tests! !
testFromHandle!public!unit tests! !
testInContextDo!public!unit tests! !
testIsCurrent!public!unit tests! !
testIsPerMonitor!public!unit tests! !
testIsSystemAware!public!unit tests! !
testIsUnaware!public!unit tests! !
testName!public!unit tests! !
testPrintString!public!unit tests! !
!

