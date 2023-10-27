"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.DisplayMonitor'
	instanceVariableNames: 'handle info devices'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'MONITOR_DEFAULTTONEAREST' -> 16r2.
			'MONITOR_DEFAULTTONULL' -> 16r0.
			'MONITOR_DEFAULTTOPRIMARY' -> 16r1
		}!
UI.DisplayMonitor guid: (Core.GUID fromString: '{2ab65289-2a77-4c76-9ab2-82178699a48c}')!
UI.DisplayMonitor comment: '`UI.DisplayMonitor` is a simple abstraction over the Windows Multiple Display Monitors API. It allows one to enumerate the attached monitors, and to identify:
  - the primary monitor;
  - the monitor on which a point in desktop co-ordinates is displayed; 
  - the monitors that intersect a rectangular region of the desktop, and/or a device context.

Having identified a `DisplayMonitor`, one can then query the desktop co-ordinates of the its display and work areas.

## Instance Variables:
  `handle`		`External.ExternalHandle`. The Windows HMONITOR handle for the monitor.
  `info`		`OS.MONITORINFO`

'!
!UI.DisplayMonitor categoriesForClass!Kernel-Objects! !
!UI.DisplayMonitor methodsFor!

= anObject
	^self == anObject
		or: [anObject species == self species and: [anObject deviceName = self deviceName]]!

adjustPosition: originPoint forExtent: extentPoint
	"Answer the nearest `Point` to originPoint that allows a rectangle with extent, extentPoint, to fit within the receiver's work area.
	If the extent is larger than the work area, then answer the work area's own origin."

	| workArea |
	workArea := self workArea.
	^(originPoint min: workArea bottomRight - extentPoint) max: workArea topLeft!

centerExtent: aPoint
	"Answer the best origin `Point` for a view rectangle expected to be centred over the receiver of the specified extent."

	^self adjustPosition: self workArea center - (aPoint // 2) forExtent: aPoint!

deviceName
	"Answer the Window's device name for the monitor that the receiver represents."

	^self info szDevice!

devices
	^devices
		ifNil: 
			[| stream device i |
			stream := Array writeStream: 1.
			i := 0.
			device := DISPLAY_DEVICEW newBuffer.
			
			[User32
				enumDisplayDevices: self deviceName
				iDevNum: i
				lpDisplayDevice: device
				dwFlags: 0]
					whileTrue: 
						[stream nextPut: device copy.
						i := i + 1].
			devices := stream grabContents]!

handle
	^handle!

handle: anObject
	handle := anObject!

hash
	^self deviceName hash!

info
	^info
		ifNil: 
			[info := MONITORINFOEXW newBuffer.
			(User32 getMonitorInfo: handle lpmi: info) ifFalse: [Win32Error signal].
			info]!

isAttachedToDesktop
	"Answer whether the receiver has any displays attached to the desktop."

	^self devices anySatisfy: [:each | each isAttachedToDesktop]!

isPrimary
	"Answer whether the receiver represents the primary/main monitor."

	^self info isPrimary!

origin
	"Answer a `Point` specifying the origin (top-left corner) of the display represented by the object."

	^self rectangle origin!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	self isPrimary ifTrue: [aStream nextPutAll: 'primary: '].
	aStream
		print: self deviceName;
		nextPut: $)!

rectangle
	"Answer a `Rectangle` which is the desktop area displayed by this monitor. This is in desktop co-ordinates. Note that the origin can be negative for displays other than the primary that are organised to be right of the primary."

	^self info rcMonitor asRectangle!

workArea
	"Answer a `Rectangle` which is the desktop area displayed by this monitor, excluding any areas used by the window manager, such as the taskbar. Note that the origin can be negative for displays other than the primary that are organised to be right of the primary."

	^self info rcWork asRectangle! !
!UI.DisplayMonitor categoriesForMethods!
=!comparing!public! !
adjustPosition:forExtent:!geometry!public! !
centerExtent:!geometry!public! !
deviceName!accessing!public! !
devices!accessing!private! !
handle!accessing!private! !
handle:!accessing!private! !
hash!comparing!public! !
info!accessing!private! !
isAttachedToDesktop!public!testing! !
isPrimary!public!testing! !
origin!accessing!public! !
printOn:!printing!public! !
rectangle!accessing!public! !
workArea!accessing!public! !
!

!UI.DisplayMonitor class methodsFor!

active
	"Answer an instance of the receiver representing the monitor that is most likely to be the one the user might consider active. There is no completely reliable way to determine this, so we use the heuristic that the monitor of the foreground window is to be used if that is a Dolphin window, otherwise the monitor over which the cursor is hovering. The reason for making this distinction is that the foreground window may be some part of the Windows shell if the user clicked on the desktop background or the taskbar, which are always considered as being on the primary monitor only. Up until Windows 11 it was possible to detect this case reasonably well by detecting that the window with focus was the 'Program Manager', but this no longer holds in Windows 11. Therefore we just go for the simpler option of tracking the cursor when the active window is not a Dolphin window."

	^View active
		ifNil: [self containingPoint: Cursor position]
		ifNotNil: [:hWnd | self displayingView: hWnd]!

allIntersecting: aRectangle
	"Answer a `<collection>` containing instances of the receiver describing all the display monitors with display areas that intersect the specified virtual screen area (i.e. desktop area)."

	^self forCanvas: nil intersecting: aRectangle!

allMonitors
	"Answer a `<collection>` containing instances of the receiver describing all the connected display monitors."

	^self forCanvas: nil intersecting: nil!

containingPoint: aPoint
	"Answer an instance of the receiver describing the monitor on which the specified 'Point' in the screen co-ordinate space would appear. If the View is outside the display area of any of the connected monitors, answer nil.
	Note that there may be areas of the virtual screen area that are not visible, depending on the relative sizes and positioning of the monitors in the Windows display settings, i.e. a Point within the virtual screen area may not actually be displayed on any monitor."

	^(User32 monitorFromPoint: aPoint asParameter dwFlags: MONITOR_DEFAULTTONULL)
		ifNotNil: [:hMonitor | self fromHandle: hMonitor]!

desktopMonitors
	"Answer a `<collection>` containing instances of the receiver describing all the connected display monitors."

	^self allMonitors select: [:each | each isAttachedToDesktop]!

displayingView: aViewOrHandle
	"Answer an instance of the receiver describing the monitor on which the specified `View`/window is (at least mostly) displayed. Note that for the desktop window, the primary monitor will be returned.
	If the window is outside the visible display area, answer nil."

	^(User32 monitorFromWindow: aViewOrHandle asParameter dwFlags: MONITOR_DEFAULTTONULL)
		ifNotNil: [:hMonitor | self fromHandle: hMonitor]!

forCanvas: aCanvas intersecting: aRectangle
	"Answer a `<collection>` containing instances of the receiver describing all the display monitors that are displaying the specified virtual screen area (i.e. desktop area) of the specified device context. The rectangle and device context can be nil.
		aCanvas isNil & aRectangle isNil		- matches all display monitors
		aCanvas isNil & aRectangle notNil		- matches all display monitors that intersect the virtual screen area specified by aRectangle
		aCanvas notNil & aRecangle isNil		- matches all display monitors that intersect the visibile region of aCanvas
		aCanvas notNil & aRectangle notNil 	- all display monitors that intersect the visibile region of aCanvas and the virtual screen area specified by aRectangle"

	| monitors |
	monitors := Array writeStream: 1.
	self
		forCanvas: aCanvas
		intersecting: aRectangle
		do: [:each | monitors nextPut: each].
	^monitors grabContents!

forCanvas: aCanvas intersecting: aRectangle do: aMonadicValuable
	| user32 callback answer |
	user32 := User32.
	callback := External.Callback block: 
					[:hMonitor :hdc :lprect :lparam |
					aMonadicValuable value: (DisplayMonitor fromHandle: hMonitor).
					true]
				descriptor: ##(External.FunctionDescriptor returnType: 'bool'
						argumentTypes: 'handle handle <1p>* uint32' << RECTL).
	answer := user32
				enumDisplayMonitors: aCanvas asParameter
				lprcClip: aRectangle asParameter
				lpfnEnum: callback asParameter
				dwData: 0.
	callback free.
	^answer!

fromHandle: anExternalHandle
	^self new
		handle: anExternalHandle;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

intersecting: aRectangle
	"Answer an instance of the receiver describing the monitor which has the largest intersection with the specified `Rectangle` of the screen co-ordinate space, or nil if there is no intersection."

	^(User32 monitorFromRect: aRectangle asParameter dwFlags: MONITOR_DEFAULTTONULL)
		ifNotNil: [:hMonitor | self fromHandle: hMonitor]!

nearestPoint: aPoint
	"Answer an instance of the receiver describing the monitor to which the specified `Point` (expressing a position in the screen co-ordinate space) is nearest."

	^(User32 monitorFromPoint: aPoint asParameter dwFlags: MONITOR_DEFAULTTONEAREST)
		ifNotNil: [:hMonitor | self fromHandle: hMonitor]
		ifNil: [Win32Error signal]!

nearestView: aView
	"Answer an instance of the receiver describing the monitor on which the specified `View` is either mostly displayed, or, if off-screen, to which it is nearest."

	^(User32 monitorFromWindow: aView asParameter dwFlags: MONITOR_DEFAULTTONEAREST)
		ifNotNil: [:hMonitor | self fromHandle: hMonitor]
		ifNil: [Win32Error signal]!

primary
	"Answer an instance of the receiver describing the primary display monitor."

	^(User32 monitorFromWindow: nil dwFlags: MONITOR_DEFAULTTOPRIMARY)
		ifNil: [Win32Error signal]
		ifNotNil: [:hMonitor | self fromHandle: hMonitor]! !
!UI.DisplayMonitor class categoriesForMethods!
active!instance creation!public! !
allIntersecting:!instance creation!public! !
allMonitors!enumerating!public! !
containingPoint:!instance creation!public! !
desktopMonitors!enumerating!public! !
displayingView:!instance creation!public! !
forCanvas:intersecting:!enumerating!public! !
forCanvas:intersecting:do:!enumerating!private! !
fromHandle:!instance creation!private! !
icon!constants!public! !
intersecting:!instance creation!public! !
nearestPoint:!instance creation!public! !
nearestView:!instance creation!public! !
primary!instance creation!public! !
!

