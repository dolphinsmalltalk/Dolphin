"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.LayoutPosition'
	instanceVariableNames: 'view rectangle show'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.LayoutPosition guid: (Core.GUID fromString: '{20f9e2d1-c328-4f0b-9dbf-8b973e199865}')!
UI.LayoutPosition comment: ''!
!UI.LayoutPosition methodsFor!

applyRectangle
	view rectangle: rectangle!

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

hasPositionChange
	^(rectangle notNil and: [rectangle ~= view rectangle])
		or: [show notNil and: [show ~~ view isWindowVisible]]!

rectangle
	^rectangle!

rectangle: anObject
	rectangle := anObject!

show
	^show!

show: aBoolean
	show := aBoolean!

view: aView
	view := aView.
	^self! !
!UI.LayoutPosition categoriesForMethods!
applyRectangle!private!testing! !
deferWindowPos:!operations!private! !
hasPositionChange!private!testing! !
rectangle!accessing!public! !
rectangle:!accessing!public! !
show!accessing!public! !
show:!accessing!public! !
view:!accessing!private! !
!

!UI.LayoutPosition class methodsFor!

view: aView
	<primitive: 157>
	^self new
		view: aView;
		yourself! !
!UI.LayoutPosition class categoriesForMethods!
view:!public! !
!

