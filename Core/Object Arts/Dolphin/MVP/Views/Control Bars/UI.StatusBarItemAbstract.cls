﻿"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.StatusBarItemAbstract'
	instanceVariableNames: 'style width parentView model'
	classVariableNames: 'BorderStyles'
	imports: #(#{OS.StatusBarConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StatusBarItemAbstract guid: (Core.GUID fromString: '{87b4c4bf-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StatusBarItemAbstract isNonInstantiable: true!
UI.StatusBarItemAbstract comment: '`StatusBarItemAbstract` is an abstract class whose subclasses represent the items held by a `StatusBar` view.

Subclasses should redefine the `#drawItem:bounding:` method to paint in the desired manner.

## Instance Variables:
  `style`		`<integer>` representing the Windows status bar style flags for the item.
  `width`		`<integer>` representing the pixel width of the item. This should be -1 if the item is to occupy the full width of the status bar.
  `parentView`		`StatusBar` holding the item.
  `model`		`<valueModel>` model holding the item''s data.

## Class Variables:
  `BorderStyles`		`IdentityDictionary` mapping border style symbols to style integers.

'!
!UI.StatusBarItemAbstract categoriesForClass!MVP-Views-Support! !
!UI.StatusBarItemAbstract methodsFor!

border
	"Private - Answer the receiver's border flags."

	^style bitAnd: ##(SBT_NOBORDERS|SBT_POPOUT)!

border: anInteger
	"Private - Set the receiver's border flags."

	style := (style bitAnd: ##((SBT_NOBORDERS | SBT_POPOUT) bitInvert)) bitOr: anInteger.
	self update!

borderStyle
	"Answer a symbol describing the border style of the receiver"

	^BorderStyles keyAtValue: self border!

borderStyle: aSymbol
	"Set the border of the receiver to the style dictated by aSymbol. This can be one of:

	#noBorder
	#sunkenBorder
	#raisedBorder.

	Note that with themes applied, there is no visible distinction between raised and sunken borders."

	self border: (BorderStyles at: aSymbol)
!

drawItem: aCanvas bounding: aRectangle 
	^self subclassResponsibility!

extent: aPoint
	"Set the receiver's extent (the height is ignored)."

	self width: aPoint x!

getText
	"Private - Answer the text for this item."

	^model isNil
		ifTrue: ['']
		ifFalse: [model value displayString]!

getTipText
	"Private - Answer the tool-tip text for this item.
	Implementation Note: Use the same text as the content."

	^self getText!

hasBorder
	"Answer whether receiver has some kind of border, or is borderless."

	^self border allMask: SBT_NOBORDERS!

hasParentView
	"Private - Answer whether a valid parentView has been set for the receiver."

	^parentView notNil!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	style := SBT_OWNERDRAW.
	width := -1!

invalidate
	"Invalidate the entire client area so that it will be re-painted"

	parentView invalidateRect: self rectangle!

isAutoResize
	"Answer true if the receiver will attempt to share the available width in it's parent <StatusBar> with other auto-resize items"

	^width == -1!

isAutoResize: aBoolean
	"Set whether the receiver will attempt to share the available width in it's parent <StatusBar> with other auto-resize items"

	self width: (aBoolean
				ifTrue: [-1]
				ifFalse: 
					[self hasParentView
						ifTrue: 
							["Maintain existing width"
							self rectangle width]
						ifFalse: 
							["An entirely arbitrary choice"
							150]])!

isOwnerDrawn
	"Answer whether the item should be owner drawn (i.e. WM_DRAWITEM is sent to the parent of the status bar, which Dolphin reflects back to the bar to draw).
	By default this is on, and there is little obvious reason to disable it since the result will not offer images."

	^style allMask: SBT_OWNERDRAW!

isOwnerDrawn: aBoolean
	"Set whether the item should be owner drawn (i.e. WM_DRAWITEM is sent to the parent of the status bar, which Dolphin reflects back to the bar to draw)."

	style := style mask: SBT_OWNERDRAW set: aBoolean!

model
	"Answer the model (if any) for the receiver"
	
	^model!

model: aValueModel
	"Set model for the receiver. Overridden by subclasses that wish to connect
	to specific update events generated by the model"
	
	model := aValueModel.
	aValueModel when: #valueChanged send: #onValueChanged to: self.
	self refreshContents
!

name
	"Answer the name of the receiver in its parent or nil if no
	name has been set"

	^parentView nameOf: self!

name: aStringOrNil
	"Set the name of the receiver in its parent to aStringOrNil"

	^parentView name: self as: aStringOrNil!

onClick: aPoint 
	"This item was left-clicked at the specified <Point>."

	self trigger: #clicked: with: aPoint!

onDoubleClick: aPoint 
	"This item was left double-clicked at the specified <Point>."

	self trigger: #doubleClicked: with: aPoint!

onRightClick: aPoint 
	"This item was right-clicked at the specified <Point>."

	self trigger: #rightClicked: with: aPoint!

onTipTextRequired
	"Private - Answer the tool-tip text for the receiver. Answer nil if none, in which case no tip is shown."

	^self toolTipText!

onValueChanged
	"The model held by the receiver has changed so refresh the parentView. The
	default is to invalidate the receiver and cause it to repaint."

	self refreshContents
!

onViewOpened
	"Handler for view opened"
!

parentView
	"Private - Answer the Status view which the receiver is attached to
	or nil if it is not attached."

	^parentView!

parentView: aStatus
	"Private - Set the receivers parentView."

	parentView := aStatus!

presenter: aPresenter
	"Sets the presenter associated with the receiver (ignore this request)."
!

presenterConnectionPoint
	"Answer the view within the receiver to which a same named presenter should connect.
	Normally this is the receiver itself. Some views that wish to direct the presenter
	to connect to another view may override this method however"

	^self!

rectangle
	"Answer the rectangle of the receiver in its parentView coordinates."

	^parentView rectangleOfItem: self!

refreshContents
	"The model held by the receiver has changed so refresh the display of the receiver in the parentView. 
	For owner-drawn items (the normal case) we need only invalidate the relevant area of the status bar to cause it to re-paint. We don't need to udpate the tip-text either, as this is requested when required for owner-drawn items."

	self hasParentView ifFalse: [^self].
	self isOwnerDrawn
		ifTrue: [self invalidate]
		ifFalse: 
			[self
				update;
				updateTipText]!

style
	"Answer the <integer> style flags to be used when displaying the receiver."

	^style!

style: anInteger
	"Set the <integer> style flags to be used when displaying the receiver."

	style := anInteger!

toolTipText
	"Private - Tool-tip text is required for the receiver."

	^self getTipText
		!

update
	"Private - Update the parentView common controls knowledge of the receiver."

	parentView notNil ifTrue: [parentView updateItem: self]!

updateTipText
	"Private - Update the receiver's tool tip text.
	This is only necessary when the item is not owner-drawn (so not normally necessary in Dolphin)."

	parentView setItem: self tipText: self getTipText!

width
	"Answer the width in pixels of the receiver, or -1 if the receiver is auto-resized to fill available space in the parentView."

	^width!

width: widthInteger
	"Set the width in pixels."

	width = widthInteger ifTrue: [^self].
	width := widthInteger.
	self update! !
!UI.StatusBarItemAbstract categoriesFor: #border!accessing!private! !
!UI.StatusBarItemAbstract categoriesFor: #border:!accessing!private! !
!UI.StatusBarItemAbstract categoriesFor: #borderStyle!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #borderStyle:!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #drawItem:bounding:!drawing!private! !
!UI.StatusBarItemAbstract categoriesFor: #extent:!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #getText!private!updating! !
!UI.StatusBarItemAbstract categoriesFor: #getTipText!private!updating! !
!UI.StatusBarItemAbstract categoriesFor: #hasBorder!public!testing! !
!UI.StatusBarItemAbstract categoriesFor: #hasParentView!private!testing!views! !
!UI.StatusBarItemAbstract categoriesFor: #initialize!initializing!private! !
!UI.StatusBarItemAbstract categoriesFor: #invalidate!drawing!public! !
!UI.StatusBarItemAbstract categoriesFor: #isAutoResize!public!testing! !
!UI.StatusBarItemAbstract categoriesFor: #isAutoResize:!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #isOwnerDrawn!public!testing! !
!UI.StatusBarItemAbstract categoriesFor: #isOwnerDrawn:!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #model!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #model:!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #name!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #name:!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #onClick:!event handling!public! !
!UI.StatusBarItemAbstract categoriesFor: #onDoubleClick:!event handling!public! !
!UI.StatusBarItemAbstract categoriesFor: #onRightClick:!event handling!public! !
!UI.StatusBarItemAbstract categoriesFor: #onTipTextRequired!event handling!private! !
!UI.StatusBarItemAbstract categoriesFor: #onValueChanged!event handling!public! !
!UI.StatusBarItemAbstract categoriesFor: #onViewOpened!event handling!public! !
!UI.StatusBarItemAbstract categoriesFor: #parentView!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #parentView:!initializing!private! !
!UI.StatusBarItemAbstract categoriesFor: #presenter:!initializing!public! !
!UI.StatusBarItemAbstract categoriesFor: #presenterConnectionPoint!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #rectangle!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #refreshContents!public!updating! !
!UI.StatusBarItemAbstract categoriesFor: #style!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #style:!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #toolTipText!event handling!private! !
!UI.StatusBarItemAbstract categoriesFor: #update!private!updating! !
!UI.StatusBarItemAbstract categoriesFor: #updateTipText!private!updating! !
!UI.StatusBarItemAbstract categoriesFor: #width!accessing!public! !
!UI.StatusBarItemAbstract categoriesFor: #width:!accessing!public! !

!UI.StatusBarItemAbstract class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^StatusBar icon!

initialize
	"Private - Initialize the receiver.

	self initialize.
"

	BorderStyles := ##(IdentityDictionary new
				at: #noBorder put: SBT_NOBORDERS;
				at: #sunkenBorder put: 0;
				at: #raisedBorder put: SBT_POPOUT;
				yourself)!

new
	"Answer a new initialize instance of the receiver."

	^super new initialize!

separator: width
	"Answer a new instance of the receiver which appears blank."

	^self new
		width: width;
		borderStyle: #noBorder;
		yourself!

stbConvertFrom: anSTBClassFormat
	"Private -
	Version Changes:
		1: border inst var becomes style."

	^
	[:data |
	| instance |
	instance := self basicNew.
	1 to: data size do: [:i | instance instVarAt: i put: (data at: i)].
	instance style: (instance style bitOr: SBT_OWNERDRAW).
	instance]!

stbVersion
	^1! !
!UI.StatusBarItemAbstract class categoriesFor: #icon!constants!public! !
!UI.StatusBarItemAbstract class categoriesFor: #initialize!development!initializing!private! !
!UI.StatusBarItemAbstract class categoriesFor: #new!instance creation!public! !
!UI.StatusBarItemAbstract class categoriesFor: #separator:!instance creation!public! !
!UI.StatusBarItemAbstract class categoriesFor: #stbConvertFrom:!binary filing!private! !
!UI.StatusBarItemAbstract class categoriesFor: #stbVersion!binary filing!private! !
