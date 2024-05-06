"Filed out from Dolphin Smalltalk"!

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

!GroupBox categoriesForMethods!
defaultExtent!constants!private! !
defaultWindowExStyle!constants!private! !
defaultWindowStyle!constants!private! !
onPositionChanged:!event handling!private! !
!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.GroupBox) 34 14 nil nil 34 2 8 1140850695 65 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903885040 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 642 301 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 21 8 0 0 110 0 0 0] 8 #() 642 193 193 nil 27 )!

resource_Static_group_box
	"Answer the literal data from which the 'Static group box' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_group_box)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.GroupBox) 34 14 nil nil 34 2 8 1140850695 65 416 nil 327686 ##(Smalltalk.Color) #transparent nil 7 nil nil nil 416 nil 8 1903885040 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 642 299 201 416 594 #text: 34 1 8 'Text here' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 20 8 0 0 110 0 0 0] 8 #() 642 193 193 nil 27 )!

themePartName
	^'BUTTON'!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver.
	Why Microsoft chose to make the GroupBox a button is a mystery beyond possible
	comprehension"

	^'BUTTON'! !

!GroupBox class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Static_group_box!public!resources-views! !
themePartName!constants!public!theming! !
winClassName!constants!private! !
!

