"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.PlimboleCell'
	instanceVariableNames: 'location velocity'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.PlimboleCell guid: (Core.GUID fromString: '{a9d9ae5c-52b6-43b7-9e6c-1bb39ef49f8a}')!

UI.Examples.PlimboleCell comment: ''!

!UI.Examples.PlimboleCell categoriesForClass!Kernel-Objects! !

!UI.Examples.PlimboleCell methodsFor!

direction
	^self velocity degrees truncated!

directionIndex
	^self directions keyAtEqualValue: self velocity ifAbsent: nil!

directions
	^##((Dictionary new)
		at: 0 put: 0 @ -1;
		at: 1 put: 1 @ 0;
		at: 2 put: 0 @ 1;
		at: 3 put: -1 @ 0;
		yourself)!

drawOn: aGraphics inView: aView extent: aPoint pen: aPen
	| rect directionIndex |
	rect := (Rectangle origin: self location * aPoint extent: aPoint)
				insetBy: 2.0 * aView dpi / USER_DEFAULT_SCREEN_DPI.
	directionIndex := self directionIndex.
	aGraphics fillRectangle: rect brush: (aView brushes at: directionIndex + 2).
	rect := rect insetBy: rect extent / 4.0.
	(##({
		
		[:graphics :rect :pen |
		| x |
		x := (rect left + rect right) / 2.0.
		graphics
			drawLineFrom: x @ rect bottom
			to: x @ rect top
			pen: pen].
		
		[:graphics :rect :pen |
		| y |
		y := (rect top + rect bottom) / 2.0.
		graphics
			drawLineFrom: rect left @ y
			to: rect right @ y
			pen: pen].
		
		[:graphics :rect :pen |
		| x |
		x := (rect left + rect right) / 2.0.
		graphics
			drawLineFrom: x @ rect top
			to: x @ rect bottom
			pen: pen].
		
		[:graphics :rect :pen |
		| y |
		y := (rect top + rect bottom) / 2.0.
		graphics
			drawLineFrom: rect right @ y
			to: rect left @ y
			pen: pen]
	}) at: directionIndex + 1)
		value: aGraphics
		value: rect
		value: aPen!

location
	^location!

location: aPoint 
	location := aPoint!

printOn: aStream 
	self basicPrintOn: aStream.
	aStream
		nextPut: $(;
		display: self direction;
		nextPut: $)!

reverse
	self velocity: self velocity negated!

rotate
	| dir newVelocity |
	dir := self direction.
	dir = 0 ifTrue: [newVelocity := 0 @ 1].
	dir = 90 ifTrue: [newVelocity := -1 @ 0].
	dir = 180 ifTrue: [newVelocity := 0 @ -1].
	dir = 270 ifTrue: [newVelocity := 1 @ 0].
	self velocity: newVelocity!

setLocation: aPoint direction: directionIndex 
	location := aPoint.
	velocity := self directions at: directionIndex!

velocity
	^velocity!

velocity: aPoint 
	velocity := aPoint!

x
	^self location x!

y
	^self location y! !

!UI.Examples.PlimboleCell categoriesForMethods!
direction!accessing!public! !
directionIndex!accessing!private! !
directions!constants!private! !
drawOn:inView:extent:pen:!drawing!private! !
location!accessing!public! !
location:!accessing!public! !
printOn:!printing!public! !
reverse!operations!public! !
rotate!operations!public! !
setLocation:direction:!initializing!private! !
velocity!accessing!public! !
velocity:!accessing!public! !
x!accessing!public! !
y!accessing!public! !
!

!UI.Examples.PlimboleCell class methodsFor!

icon
	^Plimbole icon!

location: aLocationPoint direction: directionIndex 
	^(super new)
		setLocation: aLocationPoint direction: directionIndex;
		yourself! !

!UI.Examples.PlimboleCell class categoriesForMethods!
icon!constants!public! !
location:direction:!instance creation!public! !
!

