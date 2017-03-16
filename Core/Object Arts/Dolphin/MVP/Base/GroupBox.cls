"Filed out from Dolphin Smalltalk 7"!

ControlView subclass: #GroupBox
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ButtonConstants'
	classInstanceVariableNames: ''!
GroupBox guid: (GUID fromString: '{87b4c727-026e-11d3-9fd7-00a0cc3e4a32}')!
GroupBox comment: 'GroupBox is the <view> implementing the standard Windows group box control. The actual windows class used is BUTTON, but why Microsoft chose this to implement a group box remains a mystery to this day.

GroupBox is named after the Windows control, but it only "groups" the controls it appears to surround visually; i.e. it is not a container view, just a visual decorator.
'!
!GroupBox categoriesForClass!MVP-Resources-Group Box!MVP-Views! !
!GroupBox methodsFor!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(150 @ 100)!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Implementation Note: We specify WS_EX_TRANSPARENT because
	we turn on WS_CLIPSIBLINGS by default, and in any case, this
	is more correct, so there!! However, this does upset the
	hit-testing."

	^super defaultWindowExStyle bitOr: WS_EX_TRANSPARENT!

defaultWindowStyle
	"Private - Answer a default style to use when creating a group box control."

	^(super defaultWindowStyle maskClear: WS_TABSTOP)	bitOr: BS_GROUPBOX
!

onPositionChanged: aPositionEvent
	"Private - Handle a window position change event (move or resize).
	Implementation Note:  Windows group boxes are partially transparent and do not 
	redraw most of their area, so when they are moved they leave behind traces of their
	former presence. We therefore force the parent to redraw to clear up."

	aPositionEvent isMove ifTrue: [
		self parentView invalidateRect: self rectangle].
	^super onPositionChanged: aPositionEvent! !
!GroupBox categoriesFor: #defaultExtent!constants!private! !
!GroupBox categoriesFor: #defaultWindowExStyle!constants!private! !
!GroupBox categoriesFor: #defaultWindowStyle!constants!private! !
!GroupBox categoriesFor: #onPositionChanged:!event handling!private! !

!GroupBox class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(GroupBox)  98 14 0 0 98 2 8 1140850695 65 416 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294905805 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  1 1 690 301 201 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 150 0 0 0 100 0 0 0] 98 0 690 193 193 0 27 )!

resource_Static_group_box
	"Answer the literal data from which the 'Static group box' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_group_box)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(GroupBox)  98 14 0 0 98 2 8 1140850695 65 416 0 524550 ##(ColorRef)  8 4294967295 0 5 0 0 0 416 0 8 4294906781 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  25 29 690 299 201 416 626 8 #text: 98 1 8 'Text here' 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 14 0 0 0 161 0 0 0 114 0 0 0] 98 0 690 193 193 0 27 )!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver.
	Why Microsoft chose to make the GroupBox a button is a mystery beyond possible
	comprehension"

	^'BUTTON'! !
!GroupBox class categoriesFor: #icon!constants!public! !
!GroupBox class categoriesFor: #resource_Default_view!public!resources-views! !
!GroupBox class categoriesFor: #resource_Static_group_box!public!resources-views! !
!GroupBox class categoriesFor: #winClassName!constants!private! !

