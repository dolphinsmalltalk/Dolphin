﻿"Filed out from Dolphin Smalltalk 7"!

ContainerView subclass: #MenuComposerArena
	instanceVariableNames: 'dragImageList dragPoint dragMenuIndex dragSource _unused'
	classVariableNames: ''
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!
MenuComposerArena guid: (GUID fromString: '{14be7036-54a3-4888-9a4a-b0166fd82776}')!
MenuComposerArena comment: 'MenuComposerArena is used by the <MenuComposer> to contain the menus being edited. It''s main function is to support the drag and drop of menu items between the menu views, which are dynamically opened and closed.'!
!MenuComposerArena categoriesForClass!MVP-Views! !
!MenuComposerArena methodsFor!

beginDrag: aMouseEvent of: anInteger in: aMenuComposerView
	(MouseTracker forPresenter: self presenter
		startingAt: aMouseEvent screenPosition)
		origin: aMouseEvent position + aMenuComposerView position;
		startTracking: self.

!

cancelTrackingAt: anObject 
	dragImageList isNil ifTrue: [^self].
	dragImageList
		dragLeave: self;
		endDrag.
	dragImageList := nil.
	dragPoint := nil!

continueTrackingAt: aPoint from: aPreviousPoint 
	"Private - Continue position tracking for the associated view at aPoint when
	the previous tracking position was at aPreviousPoint. Part of the <MouseTracker>
	target protocol. Answers the actual position achieved"

	#todo.	"Display image overlays for move/copy operations"
	Keyboard default isCtrlDown 
		ifTrue: 
			["Set Copy image overlay"
			]
		ifFalse: 
			["Set Move image overlay"
			].
	dragImageList dragMoveTo: aPoint.
	dragPoint := aPoint.
	self managedSubViewsDo: 
			[:view | 
			(view rectangle containsPoint: aPoint) 
				ifTrue: 
					[| index |
					index := view itemAt: aPoint - view position.
					index isZero 
						ifFalse: 
							[self onItemIn: view selectedAtIndex: index.
							^aPoint]]].
	^aPoint!

createDragImageList
	| bitmap hotspot |
	dragMenuIndex := dragSource selectionByIndex.
	hotspot := dragPoint - dragSource position - (dragSource itemRect: dragMenuIndex) origin.
	bitmap := dragSource createDragImage: dragMenuIndex.
	"We must use a device-dependent image list or the text/background may be lost when the icon
	(if any) is painted, depending on the display driver."
	dragImageList := WinImageList 
				newExtent: bitmap extent
				depth: ILC_COLORDB
				masked: false.
	dragImageList addImage: bitmap.
	bitmap free.
	dragImageList 
		beginDragImage: 0
		hotSpotX: hotspot x
		hotSpotY: hotspot y!

endTrackingAt: aPoint 
	"Private - End position tracking for the new position of the receiver.
	Part of the <MouseTracker> target protocol."

	self cancelTrackingAt: nil.
	
	[self managedSubViewsDo: 
			[:view | 
			| index localPoint |
			localPoint := aPoint - view position.
			index := view itemAt: localPoint.
			index isZero 
				ifFalse: 
					[self trigger: #itemFrom:at:droppedBefore:copy:
						withArguments: (Array 
								with: dragSource
								with: dragMenuIndex
								with: (view 
										insertBefore: index
										position: localPoint
										canvas: self canvas)
								with: Keyboard default isCtrlDown).
					^self]]] 
			ensure: [dragMenuIndex := nil]!

hideDragCursor
	"Private - Release the restriction on drawing in the arena."

	dragPoint notNil ifTrue: [dragImageList dragShow: false]!

onItemIn: aMenuComposerView selectedAtIndex: index
	"Private - A menu item has been selected in a menu (either by being clicked
	over or by having another menu item dragger over it - i.e. this is also used
	for drag highlighting)."

	self 
		trigger: #itemIn:selectedAtIndex:
		with: aMenuComposerView
		with: index!

showDragCursor
	"Private - Engage the restriction on drawing in the arena."

	dragPoint notNil ifTrue: [dragImageList dragShow: true]!

startTrackingAt: aPoint
	"Private - Start position tracking for the associated view at aPoint. Part of the 
	<MouseTracker> target protocol. Answers the actual position achieved."

	dragSource := self subViewFromPoint: aPoint.
	dragPoint := aPoint.
	self createDragImageList.
	dragImageList dragEnter: self at: aPoint.
	^aPoint! !
!MenuComposerArena categoriesFor: #beginDrag:of:in:!helpers!private! !
!MenuComposerArena categoriesFor: #cancelTrackingAt:!private!tracking! !
!MenuComposerArena categoriesFor: #continueTrackingAt:from:!private!tracking! !
!MenuComposerArena categoriesFor: #createDragImageList!private!tracking! !
!MenuComposerArena categoriesFor: #endTrackingAt:!private!tracking! !
!MenuComposerArena categoriesFor: #hideDragCursor!modes!private! !
!MenuComposerArena categoriesFor: #onItemIn:selectedAtIndex:!event handling!private! !
!MenuComposerArena categoriesFor: #showDragCursor!modes!private! !
!MenuComposerArena categoriesFor: #startTrackingAt:!private!tracking! !

MenuComposerArena methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!MenuComposerArena class methodsFor!

icon
	"Answers an <Icon> that can be used to represent this class."

	^MenuComposer icon
!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #itemIn:selectedAtIndex:;
		add: #itemFrom:at:droppedBefore:copy:;
		yourself.
! !
!MenuComposerArena class categoriesFor: #icon!constants!public! !
!MenuComposerArena class categoriesFor: #publishedEventsOfInstances!events!public! !

