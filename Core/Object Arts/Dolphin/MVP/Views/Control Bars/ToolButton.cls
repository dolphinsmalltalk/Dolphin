"Filed out from Dolphin Smalltalk"!

AbstractNonReferenceDelegatingView subclass: #ToolButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ToolButton guid: (GUID fromString: '{075420d9-dc3b-4222-b99e-abd8769d41b8}')!

ToolButton comment: ''!

!ToolButton categoriesForClass!MVP-Resources-Buttons!MVP-Resources-Misc! !

!ToolButton methodsFor!

applyFont
	"Private - The receiver's font has been changed, pass on to the internal toolbar"

	self referee font: self font
	"self onResize"!

backcolor: aColorOrNil 
	"We need to set the internal toolbar's forecolor to match in order to avoid gradients"

	super backcolor: aColorOrNil.
	self referee forecolor: aColorOrNil!

bitmapSize
	"Answer the size of bitmaps shown in the receiver"

	#deprecated.
	^self referee bitmapSize!

bitmapSize: aPoint 
	"Set the size of bitmaps shown in the receiver"

	#deprecated.
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
	self imageSize: self defaultImageSize.
	self createInternalButton.
	self onResize!

createInternalButton
	"Add our internal button to the delegated toolbar"

	referee
		items: {ToolbarIconButton new};
		hasLabels: true.
	self backcolor: nil!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color face3d!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^##(96 @ 48)!

defaultImageSize
	^#mediumIcons!

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

imageSize
	"Answer the logical name of the size of image shown in the receiver"

	^self referee imageSize!

imageSize: aSymbol
	"Set the size of images shown in the receiver"

	self referee imageSize: aSymbol.
	self onResize!

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

!ToolButton categoriesForMethods!
applyFont!font!private!updating! !
backcolor:!accessing!public! !
bitmapSize!accessing!geometry!public! !
bitmapSize:!accessing!geometry!public! !
buttonSize!accessing!geometry!public! !
buttonSize:!accessing!geometry!public! !
commandDescription!accessing!public! !
commandDescription:!accessing!public! !
createDelegate!event handling!private! !
createInternalButton!event handling!private! !
defaultBackcolor!private! !
defaultExtent!constants!private! !
defaultImageSize!constants!private! !
hasFlatAppearance!accessing!accessing-styles!public! !
hasFlatAppearance:!accessing!accessing-styles!public! !
hasLabels!accessing!accessing-styles!public! !
hasLabels:!accessing!accessing-styles!public! !
hasListAppearance!accessing!public! !
hasListAppearance:!accessing!public! !
imageSize!accessing!geometry!public! !
imageSize:!accessing!geometry!public! !
internalButton!private! !
isChecked!accessing!public!testing! !
isChecked:!accessing!public!state! !
isCheckStyle!accessing!public! !
isCheckStyle:!accessing!public! !
isDropDownOnly!accessing!public! !
isDropDownOnly:!accessing!public! !
isDropdownStyle!accessing!public! !
isDropdownStyle:!accessing!public! !
isEnabled!accessing!public!testing! !
isEnabled:!accessing!public!state! !
isGroupStyle!accessing!public! !
isGroupStyle:!accessing!public!style! !
isIndeterminate!accessing!public!testing! !
isIndeterminate:!accessing!public!state! !
isPressed!accessing!public!testing! !
isPressed:!accessing!public!state! !
onPositionChanged:!event handling!private! !
onResize!private! !
onTipTextRequired!event handling!public! !
toolTipText!operations!public! !
!

!ToolButton class methodsFor!

icon
	^PushButton icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ToolButton) 34 14 nil nil 34 2 8 1140850688 131073 416 nil nil nil 7 nil nil nil 416 nil 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131137 480 nil nil nil 3 nil nil nil 480 nil 8 1759112192 nil nil nil nil 170 192 34 2 16097 1115206 1 ##(Smalltalk.ToolbarIconButton) 480 1 1180998 4 ##(Smalltalk.CommandDescription) #noCommand 8 'No command' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Object.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 16097 34 1 608 nil nil 11 nil #mediumIcons 328198 ##(Smalltalk.Point) 183 87 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 96 0 0 0 48 0 0 0] 193 512 8 '' 480 3 8 #() 818 193 193 nil 31 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[127 7 0 0 10 0 0 0 223 7 0 0 58 0 0 0] 193 448 8 '' 416 3 34 1 480 818 193 193 nil 27 )! !

!ToolButton class categoriesForMethods!
icon!public! !
resource_Default_view!public!resources-views! !
!

