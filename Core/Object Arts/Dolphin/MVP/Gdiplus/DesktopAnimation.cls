"Filed out from Dolphin Smalltalk 7"!

DesktopDoubleBufferedView subclass: #DesktopAnimation
	instanceVariableNames: 'animationView desktopBitmap stepProcess stepStartTime animations'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DesktopAnimation guid: (GUID fromString: '{bd9e41ef-0b73-476b-895f-a018d06e0fb0}')!
DesktopAnimation comment: ''!
!DesktopAnimation categoriesForClass!MVP-Views! !
!DesktopAnimation methodsFor!

addAnimation: aSymbol duringMs: anIntervalOfInteger 
	animations add: anIntervalOfInteger -> aSymbol!

animationView
	^animationView!

endAnimations
	!

frameRate
	^30!

initialize	
	super initialize.
	animations := OrderedCollection new.!

isRunning
	^stepProcess notNil!

onDestroyed
	self stopStepProcess.
	^super onDestroyed!

onViewCreated
	super onViewCreated.
	animationView := self.
	[self onViewStarted ] postToInputQueue!

onViewStarted
	self saveDesktopBackground.
	self startStepProcess!

processAnimations
	| ms performedAnimation |
	ms := self stepTimeMs.
	performedAnimation := false.
	animations do: 
			[:each | 
			(ms >= each key start and: [ms <= each key stop]) 
				ifTrue: 
					[self perform: each value with: (ms - each key start) / each key size * 100.0.
					performedAnimation := true]].
	performedAnimation ifFalse: [self endAnimations]!

render
	self graphics drawImage: desktopBitmap.
	self processAnimations!

saveDesktopBackground
	desktopBitmap := GdiplusBitmap extent: self extent.
	desktopBitmap graphics doWithCanvas: 
			[:canvas | 
			canvas 
				bitBlt: View desktop canvas
				rectangle: ((self mapPoint: 0 @ 0 to: View desktop) extent: self extent)
				to: 0 @ 0
				rop: SRCCOPY]!

startStepProcess
	self stopStepProcess.
	stepStartTime := Time millisecondClockValue.
	stepProcess := [
			[Processor sleep: 1000 // self frameRate.
			self step] repeat] fork!

step
	self render.
	animationView repaint!

stepTimeMs
	^Time millisecondClockValue-stepStartTime!

stopStepProcess
	self isRunning ifTrue: [
		stepProcess terminate.
		stepProcess := nil ]! !
!DesktopAnimation categoriesFor: #addAnimation:duringMs:!public! !
!DesktopAnimation categoriesFor: #animationView!private! !
!DesktopAnimation categoriesFor: #endAnimations!public! !
!DesktopAnimation categoriesFor: #frameRate!constants!public! !
!DesktopAnimation categoriesFor: #initialize!private! !
!DesktopAnimation categoriesFor: #isRunning!private!testing! !
!DesktopAnimation categoriesFor: #onDestroyed!event handling!private! !
!DesktopAnimation categoriesFor: #onViewCreated!private! !
!DesktopAnimation categoriesFor: #onViewStarted!initializing!private! !
!DesktopAnimation categoriesFor: #processAnimations!private! !
!DesktopAnimation categoriesFor: #render!public! !
!DesktopAnimation categoriesFor: #saveDesktopBackground!private! !
!DesktopAnimation categoriesFor: #startStepProcess!initializing!private! !
!DesktopAnimation categoriesFor: #step!operations!private! !
!DesktopAnimation categoriesFor: #stepTimeMs!public! !
!DesktopAnimation categoriesFor: #stopStepProcess!initializing!private! !

!DesktopAnimation class methodsFor!

forRectangle: aRectangle 
	^(self new create)
		rectangle: aRectangle;
		yourself! !
!DesktopAnimation class categoriesFor: #forRectangle:!instance creation!public! !

