"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.LayoutPlacement'
	instanceVariableNames: 'view rectangle show'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.LayoutPlacement guid: (Core.GUID fromString: '{a6d52cfe-6403-4ec9-881b-ea5faa78ea9b}')!

UI.LayoutPlacement comment: ''!

!UI.LayoutPlacement methodsFor!

deferWindowPos: aHandle
	^rectangle
		ifNil: 
			[User32
				deferWindowPos: aHandle
				hwnd: view asParameter
				hwndInsertAfter: 0
				x: 0
				y: 0
				cx: 0
				cy: 0
				uFlags: (show
						ifNil: [##(SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOMOVE)]
						ifNotNil: 
							[show
								ifTrue: [##(SWP_SHOWWINDOW | SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOMOVE)]
								ifFalse: [##(SWP_HIDEWINDOW | SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOMOVE)]])]
		ifNotNil: 
			[| rect |
			rect := view adjustRectangle: rectangle.
			User32
				deferWindowPos: aHandle
				hwnd: view asParameter
				hwndInsertAfter: 0
				x: rect left
				y: rect top
				cx: rect width
				cy: rect height
				uFlags: (show
						ifNil: [##(SWP_NOZORDER | SWP_NOACTIVATE)]
						ifNotNil: 
							[show
								ifTrue: [##(SWP_SHOWWINDOW | SWP_NOZORDER | SWP_NOACTIVATE)]
								ifFalse: [##(SWP_HIDEWINDOW | SWP_NOZORDER | SWP_NOACTIVATE)]])]!

hasDeferredChange
	"Does the receiver describe a deferred change of view rectangle or visibility?"

	^(rectangle notNil and: [view getRect ~= rectangle])
		or: [show notNil and: [view hasVisibleStyle ~~ show]]!

isVisible
	^show ifNil: [view hasVisibleStyle]!

rectangle
	^rectangle!

rectangle: aRectangle
	rectangle := aRectangle!

show
	^show!

show: aBoolean
	show := aBoolean!

view
	^view!

view: aView
	view := aView.
	^self!

visibleExtent
	"Answer a <point> representing the extent of the associated view that is expected to be visible after the placement has been applied. This doesn't take into account partial visibility; if the view is to be visible it is assumed the whole extent will be visible. This is intended for use in determining the amount of space that should be reserved for a view as part of a layout calculation."

	self isVisible ifFalse: [^Point.Zero].
	rectangle ifNotNil: [:rect | ^rect extent].
	^view getWindowRect extent! !

!UI.LayoutPlacement categoriesForMethods!
deferWindowPos:!operations!private! !
hasDeferredChange!private!testing! !
isVisible!public!testing! !
rectangle!accessing!public! !
rectangle:!accessing!public! !
show!accessing!public! !
show:!accessing!public! !
view!accessing!public! !
view:!initializing!private! !
visibleExtent!accessing!public! !
!

!UI.LayoutPlacement class methodsFor!

view: aView
	<primitive: 157>
	^self new
		view: aView;
		yourself! !

!UI.LayoutPlacement class categoriesForMethods!
view:!instance creation!public! !
!

