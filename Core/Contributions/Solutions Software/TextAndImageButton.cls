"Filed out from Dolphin Smalltalk 7"!

OwnerDrawnButton subclass: #TextAndImageButton
	instanceVariableNames: 'imageExtent imageManager imageIndex dropDownMenu isMenuOpen'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TextAndImageButton guid: (GUID fromString: '{7ab8c439-056d-4b01-a5bf-1b454ec864b5}')!
TextAndImageButton comment: ''!
!TextAndImageButton categoriesForClass!Unclassified! !
!TextAndImageButton methodsFor!

currentBackcolor

	"Modify the backcolor to reflect the receiver's state"

	| color |

	color := self actualBackcolor.

	self isEnabled ifFalse: [^color fadedBy: 4].
	self isHot ifTrue: [^color fadedBy: 2].
	self isPressed ifTrue: [^color intensity: 3/4].

	^color!

drawBackgroundOn: aCanvas

	aCanvas erase: self clientRectangle color: self currentBackcolor!

drawDropDownArrowOn: aCanvas

	| x y |

	x := self extent x + self dropDownOffset x.
	y := self extent y + self dropDownOffset y.

	self isEnabled
		ifTrue: [aCanvas pen: Pen black]
		ifFalse: [aCanvas pen: (Pen color: Color grayText)].

	0 to: 2 do:
		[ :offset |
		aCanvas lineFrom: (x+offset)@(y+offset) to: (x+5-offset)@(y+offset)]!

drawImageOn: aCanvas

	| imagePos |

	imagePos := self imagePosOn: aCanvas.

	self isThemed
	ifTrue: 
		[self imageList 
			draw: self imageIndex 
			on: aCanvas 
			at: imagePos
			extent: self imageExtent 
			backcolor: nil 
			forecolor: Color buttonShadow 
			flags: (self isEnabled ifTrue: [ILD_NORMAL] ifFalse: [ILD_BLEND50])]
	ifFalse:
		[self isEnabled
			ifTrue:  [self image drawOn: aCanvas at: imagePos extent: self imageExtent]
			ifFalse: [self image drawDisabledOn: aCanvas at: imagePos extent: self imageExtent]]!

drawOn: aCanvas

	self drawBackgroundOn: aCanvas.

	self hasText ifTrue: [self drawTextOn: aCanvas].
	self hasImage ifTrue: [self drawImageOn: aCanvas].
	self hasDropDownMenu ifTrue: [self drawDropDownArrowOn: aCanvas].
	(self hasFocus and: [self shouldShowFocusRect]) ifTrue: [UserLibrary default drawFocusRect: aCanvas asParameter lprc: (self clientRectangle insetBy: 3) asParameter]!

drawTextOn: aCanvas

	| textPos |

	aCanvas font: self actualFont.
	textPos := self textPosOn: aCanvas.

	self isThemed
	ifTrue:
		[ThemeLibrary default 
			drawThemeText: self theme 
			hdc: aCanvas asParameter 
			iPartId: BP_PUSHBUTTON
			iStateId: self iState 
			pszText: self displayText asUnicodeString 
			iCharCount: -1 dwTextFlags: 0 dwTextFlags2: 0 
			pRect: (textPos extent: self extent) asParameter]
	ifFalse:
		[self isEnabled
			ifTrue: [aCanvas prefixTextTransparent: self displayText at: textPos]
			ifFalse: [aCanvas prefixTextDisabled: self displayText at: textPos]]!

dropDownMenu
	^dropDownMenu!

dropDownMenu: anObject
	dropDownMenu := anObject!

dropDownOffset

	^-12@-14!

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

	^((self extent - ((self labelWidthOn: aCanvas) @ (self imageExtent y))) // 2) max: 0@0!

isMenuOpen
	^isMenuOpen ifNil: [false]!

isMenuOpen: anObject
	isMenuOpen := anObject!

labelWidthOn: aCanvas

	| imageWidth textWidth|

	imageWidth := 0.
	textWidth := 0.

	self hasImage 
		ifTrue: [imageWidth := self imageExtent x]
		ifFalse: [imageWidth := 0].

	self hasText 
		ifTrue: [textWidth := (aCanvas textExtent: self unadornedText) x]
		ifFalse: [textWidth := 0].

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

	self image ifNotNil: [ :img | self imageIndex: (self imageManager addImage: img)]!

textPosOn: aCanvas

	| textExtent imageWidth |

	textExtent := aCanvas textExtent: self unadornedText.

	self hasImage
		ifTrue: [imageWidth := self imageExtent x + self imageGap]
		ifFalse: [imageWidth := 0].

	^(((self extent - (textExtent + (imageWidth@0))) // 2) + (imageWidth@0)) max: 0@0!

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
			message: message
			handle: handle
			wParam: wParam
			lParam: lParam.

	(self hasDropDownMenu and: [event x > (self extent x + self dropDownOffset x - 4)]) ifTrue:
 		[self isMenuOpen ifFalse: 
			[[self hasFocus ifFalse: [self setFocus].
			self trackMenu] postToInputQueue].
		"Suppress further processing"
		^0].

	^super wmLButtonDown: message wParam: wParam lParam: lParam! !
!TextAndImageButton categoriesFor: #currentBackcolor!accessing!public! !
!TextAndImageButton categoriesFor: #drawBackgroundOn:!operations!private! !
!TextAndImageButton categoriesFor: #drawDropDownArrowOn:!operations!private! !
!TextAndImageButton categoriesFor: #drawImageOn:!operations!private! !
!TextAndImageButton categoriesFor: #drawOn:!operations!private! !
!TextAndImageButton categoriesFor: #drawTextOn:!operations!private! !
!TextAndImageButton categoriesFor: #dropDownMenu!accessing!public! !
!TextAndImageButton categoriesFor: #dropDownMenu:!accessing!public! !
!TextAndImageButton categoriesFor: #dropDownOffset!accessing!public! !
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
!TextAndImageButton categoriesFor: #isMenuOpen!accessing!private! !
!TextAndImageButton categoriesFor: #isMenuOpen:!accessing!private! !
!TextAndImageButton categoriesFor: #labelWidthOn:!calculating!private! !
!TextAndImageButton categoriesFor: #preTranslateKeyboardInput:!event handling!private! !
!TextAndImageButton categoriesFor: #rebuildImageManager!operations!private! !
!TextAndImageButton categoriesFor: #textPosOn:!calculating!private! !
!TextAndImageButton categoriesFor: #trackMenu!operations!private! !
!TextAndImageButton categoriesFor: #wmLButtonDown:wParam:lParam:!event handling-win32!private! !

