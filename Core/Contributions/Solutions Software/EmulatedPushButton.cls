"Filed out from Dolphin Smalltalk 7"!

TextAndImageButton subclass: #EmulatedPushButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EmulatedPushButton guid: (GUID fromString: '{66e0b0c3-9acd-43db-a3ae-c353958f614b}')!
EmulatedPushButton comment: 'EmulatedPushButtons appear near-identical to standard PushButtons, but their drawing is implemented in Dolphin.
 - allows themed buttons with images on XP (under XP, buttons with images always show non-themed)
 - supports buttons with an image and text side-by-side (standard buttons show image or text)
 - adds a drop-down menu facility
 - example of the OwnerDrawnButton framework

Known issue:
 - text alignment is ignored (text is always centered)'!
!EmulatedPushButton categoriesForClass!Unclassified! !
!EmulatedPushButton methodsFor!

defaultTransitionDurations

	"Use the theme-defined durations to emulate real buttons"

	^self themeTransitionDurations!

drawBackgroundOn: aCanvas

	super drawBackgroundOn: aCanvas.

	self isThemed
	ifTrue: 
		[ThemeLibrary default 
			drawThemeBackground: self theme 
			hdc: aCanvas asParameter 
			iPartId: BP_PUSHBUTTON
			iStateId: self iState 
			pRect: self clientRectangle asParameter 
			pClipRect: nil]
	ifFalse:
		[UserLibrary default 
			drawFrameControl: aCanvas asParameter
			lprc: self clientRectangle asParameter
			uType: DFC_BUTTON 
			uState: self uState]! !
!EmulatedPushButton categoriesFor: #defaultTransitionDurations!accessing!public! !
!EmulatedPushButton categoriesFor: #drawBackgroundOn:!drawing!private! !

