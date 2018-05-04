"Filed out from Dolphin Smalltalk 7"!

AbstractNonReferenceDelegatingView subclass: #ToolButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ToolButton guid: (GUID fromString: '{075420d9-dc3b-4222-b99e-abd8769d41b8}')!
ToolButton comment: ''!
!ToolButton categoriesForClass!MVP-Resources-Buttons!MVP-Resources-Misc! !
!ToolButton methodsFor!

backcolor: aColorOrNil 
	"We need to set the internal toolbar's forecolor to match in order to avoid gradients"

	super backcolor: aColorOrNil.
	self referee forecolor: aColorOrNil!

bitmapSize
	"Answer the size of bitmaps shown in the receiver"

	^self referee bitmapSize!

bitmapSize: aPoint 
	"Set the size of bitmaps shown in the receiver"

	self referee bitmapSize: aPoint.
	self onResize!

buttonSize
	"Answer the size of buttons shown in the receiver"

	^self referee buttonSize!

buttonSize: aPointOrNil 
	"Set the size of buttons shown in the receiver to aPointOrNil.
	If nil then the buttons assume a default size."

	self referee buttonSize: aPointOrNil!

commandDescription
	^self internalButton commandDescription!

commandDescription: aCommandDescription 
	self internalButton commandDescription: aCommandDescription.
	self onResize!

createDelegate
	"Private - Create our internal Toolbar view"

	referee notNil ifTrue: [^self].
	referee := Toolbar new.
	referee
		hasDivider: false;
		hasFlatAppearance: true;
		isTransparent: true;
		isManaged: false.
	self basicAddSubView: referee.
	self bitmapSize: self defaultBitmapSize.
	self createInternalButton.
	self onResize!

createInternalButton
	"Add our internal button to the delegated toolbar"

	referee
		items: (Array with: ToolbarIconButton new);
		hasLabels: true.
	self backcolor: nil!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color face3d!

defaultBitmapSize
	^24@24.!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(96 @ 48)!

fontChanged
	"Private - The receiver's font has been changed, pass on to the internal toolbar"

	self referee font: self font.
	"self onResize"!

hasFlatAppearance
	"Answer whether the receiver has a flat appearance. A flat button draws its buttons without
	outlines, and is also transparent (i.e. its buttons appear to be overlayed over the client
	area of the window underneath the ToolBar)."

	^self referee hasFlatAppearance!

hasFlatAppearance: aBoolean 
	"Sets the receiver to have a flat appearance if aBoolean is true. A flat button draws its
	buttons without outlines, and is also transparent (i.e. its buttons appear to be overlayed
	over the client area of the window underneath the ToolBar). Note that this style is ignored
	if running on WinXP with an application manifest that enables version 6 common controls - in
	that case toolbars are always flat and transparent."

	"Implementation Note: This style cannot be changed without recreating the entire button - MSDN
	suggests that to do otherwise will cause 'redraw problems'"

	self referee hasFlatAppearance: aBoolean!

hasLabels
	"Answer whether labels are to be included in the receiver."

	^self referee hasLabels!

hasLabels: aBoolean 
	"Set whether labels are to be included in a button."

	^self referee hasLabels: aBoolean!

hasListAppearance
	^self referee hasListAppearance!

hasListAppearance: aBoolean 
	self referee hasListAppearance: aBoolean!

internalButton
	self referee items isEmpty ifTrue: [self createInternalButton].
	^self referee items first!

isChecked
	^self internalButton isChecked!

isChecked: aBoolean
	self internalButton isChecked: aBoolean!

isCheckStyle
	^self internalButton isCheckStyle!

isCheckStyle: aBoolean 
	self internalButton isCheckStyle: aBoolean!

isDropDownOnly
	^self internalButton isDropDownOnly!

isDropDownOnly: aBoolean 
	self internalButton isDropDownOnly: aBoolean!

isDropdownStyle
	^self internalButton isDropdownStyle!

isDropdownStyle: aBoolean 
	self internalButton isDropdownStyle: aBoolean!

isEnabled
	"Answer whether the receiver is enabled."

	^self internalButton isEnabled!

isEnabled: aBoolean 
	self isStateRestoring ifFalse: [self internalButton isEnabled: aBoolean]!

isGroupStyle
	^self internalButton isGroupStyle!

isGroupStyle: aBoolean 
	self internalButton isGroupStyle: aBoolean!

isIndeterminate
	^self internalButton isIndeterminate!

isIndeterminate: aBoolean 
	self internalButton isIndeterminate: aBoolean!

isPressed
	^self internalButton isPressed!

isPressed: aBoolean 
	self internalButton isPressed: aBoolean!

onPositionChanged: aPositionEvent 
	"Private - Handler for window position change (move or resize).
	If resized we must invalidate the header so that referee and internal button are resized correctly."

	aPositionEvent isResize ifTrue: [self onResize].
	^super onPositionChanged: aPositionEvent!

onResize
	(self referee)
		extent: self extent-(50@50);
		buttonSize: self extent-5!

onTipTextRequired
	"Tool-tip text is required for the receiver. We give the first <commandTarget>
	on the command route which is prepared to accept the command the opportunity to
	dynamically supply the tip text, otherwise just use that associated with the receiver."

	^self internalButton onTipTextRequired!

toolTipText
	"Answer a String suitable for displaying in a Tool tip control."

	^self commandDescription toolTipText! !
!ToolButton categoriesFor: #backcolor:!accessing!public! !
!ToolButton categoriesFor: #bitmapSize!accessing!geometry!public! !
!ToolButton categoriesFor: #bitmapSize:!accessing!geometry!public! !
!ToolButton categoriesFor: #buttonSize!accessing!geometry!public! !
!ToolButton categoriesFor: #buttonSize:!accessing!geometry!public! !
!ToolButton categoriesFor: #commandDescription!accessing!public! !
!ToolButton categoriesFor: #commandDescription:!accessing!public! !
!ToolButton categoriesFor: #createDelegate!event handling!private! !
!ToolButton categoriesFor: #createInternalButton!event handling!private! !
!ToolButton categoriesFor: #defaultBackcolor!private! !
!ToolButton categoriesFor: #defaultBitmapSize!constants!private! !
!ToolButton categoriesFor: #defaultExtent!constants!private! !
!ToolButton categoriesFor: #fontChanged!private!updating! !
!ToolButton categoriesFor: #hasFlatAppearance!accessing!accessing-styles!public! !
!ToolButton categoriesFor: #hasFlatAppearance:!accessing!accessing-styles!public! !
!ToolButton categoriesFor: #hasLabels!accessing!accessing-styles!public! !
!ToolButton categoriesFor: #hasLabels:!accessing!accessing-styles!public! !
!ToolButton categoriesFor: #hasListAppearance!accessing!public! !
!ToolButton categoriesFor: #hasListAppearance:!accessing!public! !
!ToolButton categoriesFor: #internalButton!private! !
!ToolButton categoriesFor: #isChecked!accessing!public!testing! !
!ToolButton categoriesFor: #isChecked:!accessing!public!state! !
!ToolButton categoriesFor: #isCheckStyle!accessing!public! !
!ToolButton categoriesFor: #isCheckStyle:!accessing!public! !
!ToolButton categoriesFor: #isDropDownOnly!accessing!public! !
!ToolButton categoriesFor: #isDropDownOnly:!accessing!public! !
!ToolButton categoriesFor: #isDropdownStyle!accessing!public! !
!ToolButton categoriesFor: #isDropdownStyle:!accessing!public! !
!ToolButton categoriesFor: #isEnabled!accessing!public!testing! !
!ToolButton categoriesFor: #isEnabled:!accessing!public!state! !
!ToolButton categoriesFor: #isGroupStyle!accessing!public! !
!ToolButton categoriesFor: #isGroupStyle:!accessing!public!style! !
!ToolButton categoriesFor: #isIndeterminate!accessing!public!testing! !
!ToolButton categoriesFor: #isIndeterminate:!accessing!public!state! !
!ToolButton categoriesFor: #isPressed!accessing!public!testing! !
!ToolButton categoriesFor: #isPressed:!accessing!public!state! !
!ToolButton categoriesFor: #onPositionChanged:!event handling!private! !
!ToolButton categoriesFor: #onResize!private! !
!ToolButton categoriesFor: #onTipTextRequired!event handling!public! !
!ToolButton categoriesFor: #toolTipText!operations!public! !

!ToolButton class methodsFor!

icon
	^PushButton icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ToolButton)  98 14 0 0 98 2 8 1140850688 131073 416 0 0 0 5 0 0 0 416 0 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140853580 131137 496 0 0 0 1 0 0 0 496 0 8 4294906841 0 234 256 98 2 26647 1115910 ##(Smalltalk.ToolbarIconButton)  26647 0 496 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #noCommand 8 'No command' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'Object.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 3 328198 ##(Smalltalk.Point)  49 49 1 98 1 640 234 240 98 6 864 5 850 0 16 0 0 0 0 3 882 49 49 1 850 0 16 0 0 0 0 3 882 49 49 3 0 3 0 882 49 49 882 183 87 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 882 1 1 882 93 1 496 1122 8 #updateSize 98 0 496 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 46 0 0 0 0 0 0 0] 98 0 882 193 193 0 27 1058 202 208 98 1 1122 1152 98 2 882 1 1 882 193 97 416 1266 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 0 0 0 48 0 0 0] 98 1 496 1328 0 27 )! !
!ToolButton class categoriesFor: #icon!public! !
!ToolButton class categoriesFor: #resource_Default_view!public!resources-views! !

