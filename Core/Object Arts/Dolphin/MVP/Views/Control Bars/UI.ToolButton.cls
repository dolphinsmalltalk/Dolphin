"Filed out from Dolphin Smalltalk"!

UI.AbstractNonReferenceDelegatingView
	subclass: #'UI.ToolButton'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ToolButton guid: (Core.GUID fromString: '{075420d9-dc3b-4222-b99e-abd8769d41b8}')!

UI.ToolButton comment: ''!

!UI.ToolButton categoriesForClass!MVP-Resources-Buttons!MVP-Resources-Misc! !

!UI.ToolButton methodsFor!

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

	^Color.Face3d!

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

!UI.ToolButton categoriesForMethods!
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

!UI.ToolButton class methodsFor!

icon
	^PushButton icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ToolButton} 38 #{Core.Array} 14 nil nil 50 2 8 1140850688 131073 32 nil nil nil 5 nil nil nil 32 nil 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131137 112 nil nil nil 1 nil nil nil 112 nil nil nil nil nil nil nil 50 1 1094 1 #{UI.ToolbarIconButton} 112 1 1350 4 #{UI.CommandDescription} #noCommand 8 'No command' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Object.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil 3 nil 518 #{Graphics.Point} 49 49 402 183 87 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 402 1 1 402 193 97 112 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 0 0 0 48 0 0 0] 8 #() 402 193 193 nil 29 450 50 1 498 #createAt:extent: 50 2 402 6143 21 402 193 97 32 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 95 12 0 0 58 0 0 0] 50 1 112 640 nil 27)! !

!UI.ToolButton class categoriesForMethods!
icon!public! !
resource_Default_view!public!resources-views! !
!

