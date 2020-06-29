"Filed out from Dolphin Smalltalk 7"!

OwnerDrawnButton subclass: #TextAndImageButton
	instanceVariableNames: 'imageExtent imageManager imageIndex dropDownMenu isMenuOpen'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TextAndImageButton guid: (GUID fromString: '{7ab8c439-056d-4b01-a5bf-1b454ec864b5}')!
TextAndImageButton comment: ''!
!TextAndImageButton categoriesForClass!Unclassified! !
!TextAndImageButton methodsFor!

buildImageManager

	self image ifNotNil: [ :img | self imageIndex: (self imageManager addImage: img)]!

contentOffsetOn: aCanvas
	self alignment = #left ifTrue: [^8].
	self alignment = #center ifTrue: [^(self extent x - (self labelWidthOn: aCanvas)) // 2].
	self alignment = #right ifTrue: [^self extent x - 8 - (self labelWidthOn: aCanvas)]!

currentBackcolor

	"Modify the backcolor to reflect the receiver's state"

	| color |

	color := self actualBackcolor.

	self isTransparent ifTrue: 
		[self isHot ifTrue: [^color intensity: 0.8].
		self isPressed ifTrue: [^color intensity: 0.55].
		^color].

	self isHot ifTrue: [^color fadedBy: 2].
	self isPressed ifTrue: [^color intensity: 3/4].

	^color!

drawBackgroundOn: aCanvas

	aCanvas erase: self clientRectangle color: self currentBackcolor!

drawDropDownArrowOn: aCanvas

	| x y |

	x := self clientRectangle left + self extent x + self dropDownOffset x.
	y := self clientRectangle top + self extent y + self dropDownOffset y.

	self isEnabled
		ifTrue: [aCanvas pen: Pen black]
		ifFalse: [aCanvas pen: (Pen color: Color grayText)].

	0 to: 2 do:
		[ :offset |
		aCanvas lineFrom: (x+offset)@(y+offset) to: (x+5-offset)@(y+offset)]!

drawImageOn: aCanvas

	self imageList 
		draw: self imageIndex 
		on: aCanvas 
		at: (self imagePosOn: aCanvas)
		extent: self imageExtent 
		backcolor: nil 
		forecolor: Color shadow3d
		flags: (self isEnabled ifTrue: [ILD_NORMAL] ifFalse: [ILD_BLEND50])!

drawOn: aCanvas

	self drawBackgroundOn: aCanvas.

	self hasText ifTrue: [self drawTextOn: aCanvas].
	self hasImage ifTrue: [self drawImageOn: aCanvas].
	self hasDropDownMenu ifTrue: [self drawDropDownArrowOn: aCanvas].
	(self hasFocus and: [self shouldShowFocusRect]) ifTrue: [UserLibrary default drawFocusRect: aCanvas asParameter lprc: (self clientRectangle insetBy: 3) asParameter]!

drawTextOn: aCanvas
	| textPos textFlags |
	aCanvas font: self actualFont.
	textPos := self textPosOn: aCanvas.
	textFlags := self shouldShowKeyboardAccelerators ifTrue: [0] ifFalse: [DT_HIDEPREFIX].
	self isThemed
		ifTrue: 
			[ThemeLibrary default
				drawThemeText: self theme
				hdc: aCanvas asParameter
				iPartId: BP_PUSHBUTTON
				iStateId: self iState
				pszText: self text asUtf16String
				iCharCount: -1
				dwTextFlags: textFlags
				dwTextFlags2: 0
				pRect: (textPos extent: self extent) asParameter]
		ifFalse: 
			[self isEnabled
				ifTrue: 
					[aCanvas
						formatText: self text
						in: (textPos extent: self extent)
						flags: textFlags]
				ifFalse: 
					[textFlags := self shouldShowKeyboardAccelerators ifTrue: [0] ifFalse: [DSS_HIDEPREFIX].
					aCanvas
						stateText: self text
						at: textPos
						flags: DST_PREFIXTEXT | DSS_DISABLED | textFlags]]!

dropDownMenu
	^dropDownMenu!

dropDownMenu: anObject
	dropDownMenu := anObject!

dropDownOffset

	^-12@-14!

durationOfTransition: aSymbol

	"An open menu prevents animation callbacks being handled, therefore default to non-animated"

	^self isMenuOpen 
		ifTrue: [0]
		ifFalse: [super durationOfTransition: aSymbol]!

filerProxy
	| savedManager proxy |
	savedManager := imageManager.
	imageManager := nil.
	proxy := super filerProxy.
	imageManager := savedManager.
	^proxy!

hasDropDownMenu

	^self dropDownMenu notNil!

hasImage

	^self image notNil!

hasText

	^self text 
		ifNil: [false]
		ifNotNil: [ :txt | txt isEmpty not]!

image: anImage

	super image: anImage.
	self rebuildImageManager!

imageExtent

	"Set explicitly to force e.g. use of small icons for images"

	^imageExtent ifNil: [self image ifNotNil: [ :img | img extent]]!

imageExtent: anObject

	"Set explicitly to force e.g. use of small icons for images"

	imageExtent := anObject!

imageGap

	^(self hasImage and: [self hasText])
		ifTrue: [4]
		ifFalse: [0]!

imageIndex
	^imageIndex!

imageIndex: anObject
	imageIndex := anObject!

imageList

	^self imageManager imageListWithExtent: self imageExtent!

imageManager
	^imageManager!

imageManager: anObject
	imageManager := anObject!

imagePosOn: aCanvas
	| xPos yPos |
	xPos := self contentOffsetOn: aCanvas.
	(self hasText and: [self isImageFirst not])
		ifTrue: [xPos := xPos + (self textExtentOn: aCanvas) x + self imageGap].
	yPos := (self extent y - self imageExtent y) // 2.
	^self clientRectangle topLeft + (xPos @ yPos max: 0 @ 0)!

isImageFirst

	"Use the BS_RIGHTBUTTON style (makes a bit of sense if you consider the image to be the buttony-bit)"

	^self isRightButton not!

isMenuOpen
	^isMenuOpen ifNil: [false]!

isMenuOpen: anObject
	isMenuOpen := anObject!

labelWidthOn: aCanvas
	| imageWidth textWidth |
	imageWidth := self hasImage ifTrue: [self imageExtent x] ifFalse: [0].
	textWidth := self hasText ifTrue: [(self textExtentOn: aCanvas) x] ifFalse: [0].
	^imageWidth + self imageGap + textWidth!

preTranslateKeyboardInput: aMSG

	| key |

	key := aMSG wParam.

	(self hasDropDownMenu and: [aMSG message = WM_KEYDOWN and: [key = VK_DOWN]]) ifTrue:
		[[self trackMenu] postToInputQueue.
		^true].

	^super preTranslateKeyboardInput: aMSG!

rebuildImageManager

	self imageManager
		ifNil: [self imageManager: ImageManager new]
		ifNotNil: [ :mgr | mgr purge].

	self buildImageManager!

standardTransitionDurations

	"Use the theme-defined durations"

	| durations lookups |

	durations := Dictionary new.
	lookups := 
		##(Dictionary new
			at: #hot put: ##(Array with: PBS_NORMAL with: PBS_HOT);
			at: #cold put: ##(Array with: PBS_HOT with: PBS_NORMAL);
			at: #pressed put: ##(Array with: PBS_NORMAL with: PBS_PRESSED);
			at: #released put: ##(Array with: PBS_PRESSED with: PBS_NORMAL);
			at: #disabled put: ##(Array with: PBS_NORMAL with: PBS_DISABLED);
			at: #enabled put: ##(Array with: PBS_DISABLED with: PBS_NORMAL);
			yourself).

	lookups keysAndValuesDo: 
		[ :transition :iStates || pdwDuration |
		pdwDuration := SDWORD new.
		ThemeLibrary default getThemeTransitionDuration: self theme asParameter iPartId: BP_PUSHBUTTON iStateIdFrom: iStates first iStateIdTo: iStates last iPropId: 6000 "TMT_TRANSITIONDURATIONS" pdwDuration: pdwDuration.
		durations at: transition put: pdwDuration value].

	^durations!

textExtentOn: aCanvas
	^aCanvas
		textExtent: self text
		width: 0
		flags: DT_SINGLELINE!

textPosOn: aCanvas
	| xPos yPos |
	xPos := self contentOffsetOn: aCanvas.
	(self hasImage and: [self isImageFirst])
		ifTrue: [xPos := xPos + self imageExtent x + self imageGap].
	yPos := (self extent y - (self textExtentOn: aCanvas) y) // 2.
	^self clientRectangle topLeft + (xPos @ yPos max: 0 @ 0)!

trackMenu

	self isMenuOpen: true.
	self dropDownMenu 
		queryAllFromView: self;
		showIn: self topShell view position: (self mapPoint: 1 @ (self extent y - 1) to: View desktop).
	
	[self isMenuOpen: false] postToInputQueue!

wmLButtonDown: message wParam: wParam lParam: lParam

	| event |

	self hasDropDownMenu ifFalse: [^super wmLButtonDown: message wParam: wParam lParam: lParam].

	event := 
		MouseEvent 
			window: self
			message: message
			wParam: wParam
			lParam: lParam.

	(self hasDropDownMenu and: [event x > (self extent x + self dropDownOffset x - 4)]) ifTrue:
 		[self isMenuOpen ifFalse: 
			[[self hasFocus ifFalse: [self setFocus].
			self trackMenu] postToInputQueue].
		"Suppress further processing"
		^0].

	^super wmLButtonDown: message wParam: wParam lParam: lParam! !
!TextAndImageButton categoriesFor: #buildImageManager!operations!private! !
!TextAndImageButton categoriesFor: #contentOffsetOn:!calculating!private! !
!TextAndImageButton categoriesFor: #currentBackcolor!accessing!public! !
!TextAndImageButton categoriesFor: #drawBackgroundOn:!drawing!private! !
!TextAndImageButton categoriesFor: #drawDropDownArrowOn:!drawing!private! !
!TextAndImageButton categoriesFor: #drawImageOn:!drawing!private! !
!TextAndImageButton categoriesFor: #drawOn:!drawing!private! !
!TextAndImageButton categoriesFor: #drawTextOn:!drawing!private! !
!TextAndImageButton categoriesFor: #dropDownMenu!accessing!public! !
!TextAndImageButton categoriesFor: #dropDownMenu:!accessing!public! !
!TextAndImageButton categoriesFor: #dropDownOffset!accessing!public! !
!TextAndImageButton categoriesFor: #durationOfTransition:!accessing!public! !
!TextAndImageButton categoriesFor: #filerProxy!accessing!public! !
!TextAndImageButton categoriesFor: #hasDropDownMenu!public!testing! !
!TextAndImageButton categoriesFor: #hasImage!public!testing! !
!TextAndImageButton categoriesFor: #hasText!public!testing! !
!TextAndImageButton categoriesFor: #image:!accessing!public! !
!TextAndImageButton categoriesFor: #imageExtent!accessing!public! !
!TextAndImageButton categoriesFor: #imageExtent:!accessing!public! !
!TextAndImageButton categoriesFor: #imageGap!accessing!calculating!private! !
!TextAndImageButton categoriesFor: #imageIndex!accessing!private! !
!TextAndImageButton categoriesFor: #imageIndex:!accessing!private! !
!TextAndImageButton categoriesFor: #imageList!accessing!private! !
!TextAndImageButton categoriesFor: #imageManager!accessing!private! !
!TextAndImageButton categoriesFor: #imageManager:!accessing!private! !
!TextAndImageButton categoriesFor: #imagePosOn:!calculating!private! !
!TextAndImageButton categoriesFor: #isImageFirst!public!testing! !
!TextAndImageButton categoriesFor: #isMenuOpen!accessing!private! !
!TextAndImageButton categoriesFor: #isMenuOpen:!accessing!private! !
!TextAndImageButton categoriesFor: #labelWidthOn:!calculating!private! !
!TextAndImageButton categoriesFor: #preTranslateKeyboardInput:!event handling!private! !
!TextAndImageButton categoriesFor: #rebuildImageManager!operations!private! !
!TextAndImageButton categoriesFor: #standardTransitionDurations!accessing!public! !
!TextAndImageButton categoriesFor: #textExtentOn:!calculating!public! !
!TextAndImageButton categoriesFor: #textPosOn:!calculating!private! !
!TextAndImageButton categoriesFor: #trackMenu!operations!private! !
!TextAndImageButton categoriesFor: #wmLButtonDown:wParam:lParam:!event handling-win32!private! !

