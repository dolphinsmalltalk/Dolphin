"Filed out from Dolphin Smalltalk"!

ILImage subclass: #ILEditingImage
	instanceVariableNames: 'modified undoStack redoStack undoCollector brushCache'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILEditingImage guid: (GUID fromString: '{b234bbcf-8aaa-471d-9bbb-5463bf4d92be}')!
ILEditingImage comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILEditingImage categoriesForClass!IDB Goodies! !
!ILEditingImage methodsFor!

beModified
	self isModified 
		ifFalse: 
			[modified := true.
			self trigger: #toolbarChanged.
			self trigger: #modifiedDescriptionChanged]!

beNotModified
	self isModified 
		ifTrue: 
			[modified := false.
			self trigger: #toolbarChanged.
			self trigger: #modifiedDescriptionChanged]!

brushFor: aPoint
	^brushCache at: (self imageAt: aPoint)!

canPaste
	^Clipboard current isObjectAvailable!

canRedo
	^redoStack notEmpty!

canUndo
	^undoStack notEmpty | undoCollector notEmpty!

draw: aDyadicBlock location: aRectangle with: anRGB
	| bitmap canvas drawnRectangle |
	self undoCommit.
	bitmap := Bitmap 
				compatible: DesktopView current canvas
				width: aRectangle width + 10
				height: aRectangle height + 10.
	canvas := bitmap canvas.
	canvas
		brush: Brush white;
		pen: Pen black;
		erase.
	drawnRectangle := aDyadicBlock value: canvas value: (Point zero corner: aRectangle extent).
	(self pixelPoints: drawnRectangle) do: 
			[:each | 
			(canvas pixelAt: each) = Color black 
				ifTrue: [self putRGB: anRGB at: each + aRectangle origin - drawnRectangle origin]].
	self undoCommit.
	self notifyChangedRectangle: aRectangle!

draw: aPoint on: aCanvas in: aRectangle
	aCanvas
		brush: (self brushFor: aPoint);
		rectangle: aRectangle!

editCopy: aRectangle
	Clipboard current setObject: (Array with: 'ImageEditor'
				with: ((self pixelPoints: aRectangle) 
						collect: [:each | each - aRectangle origin -> (self getRGBAt: each)]))!

editCut: aRectangle with: anRGB
	self undoCommit.
	self editCopy: aRectangle.
	self fill: aRectangle with: anRGB.
	self notifyChangedRectangle: aRectangle!

editPaste: aRectangle
	| object |
	self canPaste ifFalse: [^self].
	object := Clipboard current getObject.
	(object class == Array and: [object size = 2 and: [(object at: 1) = 'ImageEditor']]) 
		ifFalse: [^self].
	self undoCommit.
	(object at: 2) do: 
			[:each | 
			| pixel |
			pixel := each key + aRectangle origin.
			(aRectangle containsPointInclusive: pixel) ifTrue: [self putRGB: each value at: pixel]].
	self notifyChangedRectangle: aRectangle!

editRedo
	| pixels |
	pixels := redoStack removeFirst.
	undoStack addLast: (pixels collect: [:each | each key -> (self getRGBAt: each key)]).
	pixels do: [:each | super putRGB: each value at: each key].
	self notifyChangedPoints: (pixels collect: [:each | each key])!

editUndo
	| pixels |
	self undoCommit.
	pixels := undoStack removeLast.
	redoStack addFirst: (pixels collect: [:each | each key -> (self getRGBAt: each key)]).
	pixels reverseDo: [:each | super putRGB: each value at: each key].
	self notifyChangedPoints: (pixels collect: [:each | each key])!

ellipse: aRectangle with: anRGB
	self 
		draw: 
			[:canvas :drawRectangle | 
			canvas ellipse: (drawRectangle increaseCornerBy: 1).
			drawRectangle]
		location: aRectangle
		with: anRGB!

fill: aRectangle with: anRGB
	self 
		draw: 
			[:canvas :drawRectangle | 
			canvas fillRectangle: (drawRectangle increaseCornerBy: 1) brush: Brush black.
			drawRectangle]
		location: aRectangle
		with: anRGB!

hotSpot: aPoint
	super hotSpot: aPoint.
	self beModified.
	self trigger: #imageDescriptionChanged!

indexFor: anRGB
	| index |
	index := super indexFor: anRGB.

	"If the brush cache is nil we haven't got to the stage where we need brushes, so don't bother"
	(brushCache notNil and: [index > brushCache size]) 
		ifTrue: [brushCache add: (Brush color: (self rgbFor: index))].
	^index!

isModified
	^modified!

libraryImage
	"Answer an ILmage which is a copy of the receiver suitable for the library"

	^(ILImage extent: extent colors: (image collect: [:each | self rgbFor: each]))
		hotSpot: self hotSpot;
		yourself!

lineTlBr: aRectangle with: anRGB
	self 
		draw: 
			[:canvas :drawRectangle | 
			| rectangle |
			rectangle := drawRectangle increaseCornerBy: 1.
			canvas
				moveTo: rectangle origin;
				lineTo: rectangle corner.
			drawRectangle]
		location: aRectangle
		with: anRGB!

lineTrBl: aRectangle with: anRGB
	self 
		draw: 
			[:canvas :drawRectangle | 
			| rectangle |
			rectangle := drawRectangle increaseCornerBy: 1.
			canvas
				moveTo: rectangle right @ -1;
				lineTo: -1 @ rectangle bottom.
			drawRectangle]
		location: aRectangle
		with: anRGB!

modifiedDescription
	^self isModified ifTrue: [' modified'] ifFalse: [String new]!

notifyChangedPoints: aCollection
	self notifyChangedRectangle: (aCollection inject: (aCollection first extent: 0)
				into: [:rectangle :each | rectangle merge: (each extent: 0)])!

notifyChangedRectangle: aRectangle
	self
		clearBitmapCache;
		beModified;
		trigger: #imageChanged: with: aRectangle!

plot: aPoint with: anRGB
	self putRGB: anRGB at: aPoint.
	self notifyChangedPoints: (OrderedCollection with: aPoint)!

putRGB: anRGB at: aPoint
	self undoAdd: aPoint -> (self getRGBAt: aPoint).
	super putRGB: anRGB at: aPoint!

rectangle: aRectangle with: anRGB
	self 
		draw: 
			[:canvas :drawRectangle | 
			canvas rectangle: (drawRectangle increaseCornerBy: 1).
			drawRectangle]
		location: aRectangle
		with: anRGB!

setExtent: aPoint colors: anArray
	super setExtent: aPoint colors: anArray.
	modified := false.
	brushCache := colorsUsed collect: [:each | Brush color: each].
	undoStack := OrderedCollection new.
	redoStack := OrderedCollection new.
	undoCollector := OrderedCollection new!

text: aRectangle with: anRGB displaying: aString 
	self 
		draw: 
			[:canvas :drawRectangle | 
			| pixelSize |
			pixelSize := 6.
			
			[pixelSize := pixelSize + 1.
			canvas
				erase;
				font: (Font name: 'Arial' pixelSize: pixelSize) beBold;
				text: aString at: Point zero.
			(self usedRectangleIn: canvas within: drawRectangle extent + 10) extent 
				<= drawRectangle extent] 
					whileTrue.
			canvas erase.
			pixelSize = 7 
				ifFalse: 
					[canvas
						font: (Font name: 'Arial' pixelSize: pixelSize - 1) beBold;
						text: aString at: Point zero].
			self usedRectangleIn: canvas within: drawRectangle extent + 10]
		location: aRectangle
		with: anRGB!

undoAdd: anAssociation
	redoStack isNil ifTrue: [^self].
	redoStack notEmpty | undoCollector isEmpty 
		ifTrue: 
			[redoStack := OrderedCollection new.
			self trigger: #toolbarChanged].
	undoCollector addLast: anAssociation!

undoCommit
	undoCollector isEmpty ifTrue: [^self].
	undoStack addLast: undoCollector.
	undoCollector := OrderedCollection new!

usedRectangleIn: aCanvas within: aPoint
	| left right top bottom |
	left := (0 to: aPoint x) 
				detect: [:across | (0 to: aPoint y) anySatisfy: [:down | (aCanvas pixelAt: across @ down) = Color black]].
	right := (aPoint x to: 0 by: -1) 
				detect: [:across | (0 to: aPoint y) anySatisfy: [:down | (aCanvas pixelAt: across @ down) = Color black]].
	top := (0 to: aPoint y) detect: 
					[:down | 
					(0 to: aPoint x) anySatisfy: [:across | (aCanvas pixelAt: across @ down) = Color black]].
	bottom := (aPoint y to: 0 by: -1) detect: 
					[:down | 
					(0 to: aPoint x) anySatisfy: [:across | (aCanvas pixelAt: across @ down) = Color black]].
	^left @ top corner: right @ bottom! !
!ILEditingImage categoriesForMethods!
beModified!accessing!public! !
beNotModified!accessing!public! !
brushFor:!accessing!public! !
canPaste!public!testing! !
canRedo!public!testing! !
canUndo!public!testing! !
draw:location:with:!operations!public! !
draw:on:in:!operations!public! !
editCopy:!operations!public! !
editCut:with:!operations!public! !
editPaste:!operations!public! !
editRedo!operations!public! !
editUndo!operations!public! !
ellipse:with:!operations!public! !
fill:with:!operations!public! !
hotSpot:!accessing!public! !
indexFor:!accessing!public! !
isModified!public!testing! !
libraryImage!converting!public! !
lineTlBr:with:!operations!public! !
lineTrBl:with:!operations!public! !
modifiedDescription!displaying!public! !
notifyChangedPoints:!helpers!public! !
notifyChangedRectangle:!helpers!public! !
plot:with:!operations!public! !
putRGB:at:!accessing!public! !
rectangle:with:!operations!public! !
setExtent:colors:!initializing!public! !
text:with:displaying:!operations!public! !
undoAdd:!operations!public! !
undoCommit!operations!public! !
usedRectangleIn:within:!helpers!public! !
!

