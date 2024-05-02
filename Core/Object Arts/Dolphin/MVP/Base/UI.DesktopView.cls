"Filed out from Dolphin Smalltalk"!

UI.View
	subclass: #'UI.DesktopView'
	instanceVariableNames: '_dvReserved0 _dvReserved1 _dvReserved2 _dvReserved3'
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.DesktopView guid: (Core.GUID fromString: '{87b4c70e-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.DesktopView comment: 'DesktopView is a <compositeView> representing the Windows desktop. 

Instance Variables:
	resolution	<Point>holding the logical pixels per inch of the Window''s system font.

Class Variables:
	Current	<DesktopView> singleton instance of the desktop.

'!

!UI.DesktopView categoriesForClass!MVP-Views! !

!UI.DesktopView methodsFor!

addCommandHistory: aCommand
	"Private - Provided for protocol compatiblity with Shell presenters.
	DesktopViews do not support command history do do nothing"
!

addSubView: aView
	"Adds aView as a subview of the receiver. Can only be called before aView is realized
	due to a Windows bug where setParent: does not work reliably. The act of adding the 
	view realizes it"

	aView parentView: self.
	aView create.
	self onSubViewAdded: aView.

	^aView.!

adjustPlacementOfShell: aShellView forResolution: aPoint
	"Private - The <ShellView> first argument is being restored from an STBViewProxy (e.g. instantiated from a view resource) on this desktop. Adjust the placement of the window to an appropriate position and/or extent on the target monitor, also scaling any internal measurments to the monitor's DPI from the original resolution specified by the <point> final argument."

	| monitor extent targetDpi |
	monitor := DisplayMonitor active.
	targetDpi := monitor effectiveDpi.
	aPoint = targetDpi ifFalse: [aShellView resolutionScaledBy: targetDpi / aPoint].
	extent := aShellView usePreferredExtent
				ifTrue: [aShellView preferredExtent ifNil: [monitor defaultWindowExtent * targetDpi // monitor dpi]]
				ifFalse: [aShellView extent].
	aShellView rectangle: (monitor
				adjustWindowRect: ((aShellView isInitiallyCentered
						ifTrue: [monitor centerExtent: extent]
						ifFalse: [aShellView position]) extent: extent))!

allParents
	"Answers a <sequencedReadableCollection> of all parents of the receiver including, ultimately,
	the desktop."

	^#()!

ambientBackcolor
	"Private - Answer the background colour that should be inherited by top-level views that
	don't have their own background colour specified. In this case it should be those views own
	default background colour."

	^Color default!

assumeDesktopHandle
	"Ensure the receiver represents the Windows desktop.
	Note that we associate with both the true desktop handle and null."

	self attachHandle: self class desktopHandle.
	SessionManager inputState windowAt: 0 put: self!

basicActualBackcolor
	"Private - Answer the <Color> to be applied as the receiver's background colour."

	^Color default!

buttonRemoved: aPushButton 
	"Private - Informs the receiver that aPushButton has been removed from the child hierachy."

	!

canvas
	"Answer a Canvas for the desktop."

	^Canvas forDesktop!

caption
	"Answers the caption for the receiver.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop."

	^self text!

caption: aString
	"Set the caption for the receiver. Usually sent by a Presenter
	that wishes to display a caption in it's associated view.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We use the same implementation
	as <ShellView>."

	self text: aString.
	self trigger: #captionChanged!

centerExtent: aPoint
	"Private - Answer the origin `Point` for a shell view of the specified extent, centred over the active monitor's work area."

	^DisplayMonitor active centerExtent: aPoint!

childLayoutInvalidated
	"Private - The layout of a child has changed. By default we invalidat our own layout, and pass up the parent chain to that the whole hierarchy has the opportunity to adjust its layout to reflect the change, e.g. to grow or shrink."

	"Nothing to do"!

commandPolicyWithSource: sourceView
	"Answers a <CommandPolicy> object for routing commands originating
	from the <View>, source.
	N.B. This is implemented to complete the <topPresenter> protocol, it is required
	so that commands can be routed for views parented directly by the desktop which
	do not have a shell."

	^CommandPolicy defaultClass commandSource: sourceView!

createShellWindow: aShellView withFunction: aCreateWindow
	| monitor position extent targetDpi |
	"If the position is not specified, we will need to work out a suitable position on the active monitor"
	(aShellView isRestoringFromProxy or: [aCreateWindow hasDefaultPosition])
		ifTrue: 
			["Default position, so should go on the active monitor"
			monitor := DisplayMonitor active.
			targetDpi := monitor effectiveDpi.
			"Now work out the extent to use at the DPI of the active monitor, which is either the specified extent remapped to the active monitor DPI, or if unspecified the monitor default"
			extent := aCreateWindow hasDefaultExtent
						ifTrue: [monitor defaultWindowExtent * targetDpi // monitor dpi]
						ifFalse: [aCreateWindow extent * targetDpi // aCreateWindow dpi].
			position := aShellView isInitiallyCentered
						ifTrue: [monitor centerExtent: extent]
						ifFalse: [monitor nextWindowPosition]]
		ifFalse: 
			["Position was specified. Determine the monitor from that."
			position := aCreateWindow position.
			monitor := DisplayMonitor nearestPoint: position.
			targetDpi := monitor effectiveDpi.
			"Now we can calculate the extent as above"
			extent := aCreateWindow hasDefaultExtent
						ifTrue: [monitor defaultWindowExtent * targetDpi // monitor dpi]
						ifFalse: [aCreateWindow extent * targetDpi // aCreateWindow dpi].
			"If should be initially centered, override the specified position, but keeping to the same monitor"
			position := aShellView isInitiallyCentered
						ifTrue: 
							["Position so as to centre the window at whatever its extent should be"
							monitor centerExtent: extent]
						ifFalse: [position * targetDpi // aCreateWindow dpi]].
	"Set the dpi of the shell to that of the monitor we think it is on, and to which we have scaled it. This will mean that even if we made the wrong choice, and Windows thinks it is placed on another monitor, when it is moved between monitors it should at least rescale correctly. Note that we would at least need to clear any cached DPI, as otherwise the shell will keep getting rescaled from its original DPI. Basically the cached ShellView DPI needs to always be the same as the actual DPI, except during the per-monitor transition process when Windows is sending WM_DPICHANGED_BEFOREPARENT to all the children. In order for the children to rescale correctly, they need to know the DPI to which they were last scaled, which is the primary reason to cache the DPI in ShellView."
	aShellView dpi: targetDpi.
	"Adjust the position to fit on the monitor, if possible"
	aCreateWindow
		position: (monitor adjustPosition: position forExtent: extent)
		extent: extent
		dpi: targetDpi.
	"Finally, create the top-level Window"
	aShellView basicCreateWindow: aCreateWindow!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Desktop'!

dpi
	"Answer the logical dots-per-inch for this Window."

	^self metrics dpi!

ensureSubView: aView rectangleVisible: aRectangle
	"Private - Ensures that the aRectangle area of the receiver's sub-<View>, aView,
	is visible in the receiver if the parent has this level of control."
!

ensureSubViewVisible: aShellView
	"Sending #ensureVisible to a ShellView that is a direct child of the desktop is expected to bring it to the top of the z-order."

	aShellView zOrderTop!

ensureVisible
	"Ensures that the receiver is visible. 
	The desktop is always visible so do nothing"


	!

filerProxyIn: anSTxOutFiler
	"Private - Answer a filer proxy that represents the receiver."

	^STBSingletonProxy forClass: self class!

getActualFont
	"Private - Answer the actual font to be used to paint text in the receiver"

	^self font ifNil: [self iconTitleFont]!

helpId
	"Answer an integer ID used to associate the receicer with pop-up help"

	^-1!

iconTitleFont
	"Answer a <Font> which is that used for icon titles on the desktop."

	^self metrics iconTitleFont!

initialize
	super initialize.
	self assumeDesktopHandle!

invalidateLayout
	"Nothing to do."
!

invalidateRect: aRectangle erase: aBoolean
	"Invalidates the specified desktop rectangle (a RECTL, Rectangle, or nil for the whole client window).
	Set whether to erase the receiver's background before repainting. Answer whether the function succeeds."

	^User32
		invalidate: handle
		lpRect: aRectangle asParameter
		bErase: aBoolean asParameter!

invalidateUserInterface
	"This will may be received when opening a view that is normally a child (i.e. a non-ShellView) directly on the desktop, which would normally only happen for development purposes such as preview. There is nothing to do."!

isDesktop
	"Answer whether the receiver represents the desktop window"

	^true!

isLayoutValid
	"Answer true if the layout of the receiver is currently valid"

	"Implementation Note: We have no control over the desktop's layout."

	^true!

layoutManager: layoutManager
	"Sets the layout manager of the receiver to <layoutManager>. The Windows desktop
	does not support layout managers so we deny the ability to set one."

	^self shouldNotImplement!

metrics
	^SystemMetrics current!

name
	"Answer the name of the receiver in its parent or nil if no name has been set.
	Implementation Note: The receiver has no parent, and therefore no name."

	^nil!

name: aStringOrNil
	"Set the name of the receiver in its parent to aStringOrNil.
	Implementation Note: The receiver has no parent, so this does not make sense."

	^self shouldNotImplement!

name: aView as: aNameStringOrNil 
	self shouldNotImplement!

onAboutToDisplaySystemMenu: hMenu
	"The system menu with <integer> handle, hMenu, is about to be displayed.
	This is our opportunity to update it, e.g. to add our own items.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We use the same implementation
	as <ShellView>."

	self presenter trigger: #aboutToDisplaySystemMenu: with: hMenu.
	^0!

onStartup
	"Make sure the receiver represents the desktop window handle."

	self assumeDesktopHandle!

onViewActivated: anEvent
	"Default handler for window activation.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We accept the default window
	procedures implementation."

	self trigger: #viewActivated.
	^anEvent defaultWindowProcessing!

onViewDeactivated: anEvent
	"Default handler for window de-activation.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We accept the default window
	procedures implementation."

	self trigger: #viewDeactivated.
	^anEvent defaultWindowProcessing!

onViewMinimized: anEvent
	"Default handler for window iconification.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We accept the default window
	procedures implementation."

	self presenter trigger: #viewMinimized.
	^anEvent defaultWindowProcessing!

onViewRestored: anEvent
	"Default handler for window restoration from iconic state.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We use the same implementation
	as <ShellView>."

	self presenter trigger: #viewRestored.
	^anEvent defaultWindowProcessing!

performCommand: aCommand
	"Performs aCommand on the receiver and answer the result.
	Can be overridden by subclasses that wish, perhaps, to add some
	generic undo/redo ability for all commands."

	^aCommand value!

queryContextMenu
	"Answer the context <Menu> that is associated with the receiver, if any.
	We're not in control of the desktop's context menu."

	^nil!

refresh
	"Redraw the entire desktop and all windows (i.e. a complete screen refresh). This will cause
	a lot of flashing!!"

	^User32
		invalidate: nil
		lpRect: nil
		bErase: true!

repositionShell: aShellView
	| activeMonitor |
	activeMonitor := DisplayMonitor active.
	aShellView isInitiallyCentered
		ifTrue: [aShellView centerNear: activeMonitor effectiveWorkArea center atDpi: activeMonitor dpi]
		ifFalse: [aShellView displayOnMonitor: activeMonitor]!

screenRectangle
	"Answer the boundary of the receiver window in screen coordinates"

	^self clientRectangle!

setDefaultButton: button state: setDefault
	"Private - Set aPushButton as being the default button within the receiver according 
	to aBoolean.
	Implementation Note: Required in order to be able to create default buttons in the context
	of the desktop."

	!

setFocus
	^User32 setFocus: handle!

topShell
	"Answer the first <topPresenter> located in the parent chain of the receiver."

	^self!

topView
	^self!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop so do nothing."

	!

withAllParentsDo: aMonadicValuable 
	^aMonadicValuable value: self!

workArea
	"Answer a <Rectangle> which is the desktop area of the primary monitor, excluding that part occupied by the task bar &c."

	^DisplayMonitor primary effectiveWorkArea! !

!UI.DesktopView categoriesForMethods!
addCommandHistory:!accessing!private! !
addSubView:!hierarchy!public!sub views! !
adjustPlacementOfShell:forResolution:!geometry!private! !
allParents!hierarchy!public! !
ambientBackcolor!accessing!private! !
assumeDesktopHandle!accessing!private! !
basicActualBackcolor!accessing!private! !
buttonRemoved:!default button!private! !
canvas!accessing!public! !
caption!accessing!public! !
caption:!accessing!public! !
centerExtent:!geometry!private! !
childLayoutInvalidated!geometry!private! !
commandPolicyWithSource:!commands!public! !
createShellWindow:withFunction:!operations!public! !
displayOn:!displaying!public! !
dpi!accessing!high DPI!public! !
ensureSubView:rectangleVisible:!private!updating! !
ensureSubViewVisible:!public!sub views! !
ensureVisible!accessing!public! !
filerProxyIn:!binary filing!private! !
getActualFont!accessing!private! !
helpId!accessing!public! !
iconTitleFont!geometry!public! !
initialize!initializing!private! !
invalidateLayout!geometry!public! !
invalidateRect:erase:!drawing!public! !
invalidateUserInterface!public! !
isDesktop!public!testing! !
isLayoutValid!geometry!public!testing! !
layoutManager:!geometry!public! !
metrics!public! !
name!accessing!public! !
name:!accessing!public! !
name:as:!hierarchy!public!sub views! !
onAboutToDisplaySystemMenu:!event handling!public! !
onStartup!event handling!public! !
onViewActivated:!event handling!public! !
onViewDeactivated:!event handling!public! !
onViewMinimized:!event handling!public! !
onViewRestored:!event handling!public! !
performCommand:!commands!public! !
queryContextMenu!menus!public! !
refresh!drawing!public! !
repositionShell:!helpers!private! !
screenRectangle!geometry!public! !
setDefaultButton:state:!accessing!default button!private! !
setFocus!operations!public! !
topShell!hierarchy!public! !
topView!hierarchy!public! !
updateCaption!public!updating! !
withAllParentsDo:!hierarchy!public! !
workArea!geometry!public! !
!

UI.DesktopView methodProtocol: #compositeView attributes: #(#readOnly) selectors: #(#addSubView: #allParents #allSubViews #arrangement #arrangement: #backcolor #backcolor: #canAcceptSubViews #canvas #clientExtent #clientHeight #clientRectangle #clientWidth #close #contextMenu #contextMenu: #cursor #cursorPosition #destroy #disable #disableRedraw #enable #enableRedraw #ensureLayoutValid #ensureRectangleVisible: #ensureSubView:rectangleVisible: #ensureSubViewVisible: #ensureVisible #extent #extent: #firstSubView #font #font: #forecolor #forecolor: #hasBorder #hasBorder: #hasClientEdge #hasClientEdge: #hasFocus #hasLayoutManager #hasStaticEdge #hasStaticEdge: #hasVisibleStyle #hasVisibleStyle: #height #height: #hide #invalidate #invalidateCalculatedExtent #invalidateLayout #invalidateRect: #invalidateRect:erase: #invalidateRgn: #invalidateUserInterface #isEnabled: #isGroupStop #isGroupStop: #isLayoutValid #isManaged #isManaged: #isTabStop #isTabStop: #isTopView #isTransparent #isTransparent: #isWindowVisible #layout #layoutExtent: #layoutManager #layoutManager: #managedSubViews #mapPoint:to: #mapRectangle:to: #model #model: #name #name: #nameOf: #needsValidateLayout #nextSiblingView #nonClientCanvas #onAboutToCreate #onBegin:drag: #onCommand: #onCreated: #onDestroyed #onEraseRequired: #onHScroll: #onModelChanged #onPaintRequired: #onSubViewAdded: #onSubViewRemoved: #onViewCreated #onVScroll: #onZOrderChanged #parentView #placement #placement: #plainText #position #position: #preferredExtent #preferredExtent: #presenter #presenter: #presenterConnectionPoint #preTranslateKeyboardInput: #preTranslateMessage: #preTranslateMouseInput: #previousSiblingView #queryContextMenu #recreate #rectangle #rectangle: #refreshContents #removeSubView: #resolution #screenRectangle #screenRectangle: #scrollBy:clip: #scrollBy:scroll:clip: #setCapture #styles #subViewFromPoint: #subViewFromPoint:flags: #subViews #tabFirst #tabNext #text #text: #topView #update #updateModel #usePreferredExtent #usePreferredExtent: #validate #validateLayout #validateRect: #validateUserInterface #viewNamed: #viewNamed:ifNone: #width #width: #withAllParents #withAllSubViews #x #x: #y #y: #zOrderAfter: #zOrderAfter:withFlags: #zOrderBottom #zOrderTop)!
UI.DesktopView methodProtocol: #topPresenter attributes: #(#readOnly) selectors: #(#caption #caption: #commandPolicyWithSource: #ensureVisible #invalidateUserInterface #onAboutToDisplayMenu: #onAboutToDisplaySystemMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewActivated: #onViewClosed #onViewDeactivated: #onViewMinimized: #onViewOpened #onViewRestored: #parentPresenter #performAction #performCommand: #setFocus #show #topShell #updateCaption #view)!

!UI.DesktopView class methodsFor!

current
	"Answers the singleton instance of the receiver."

	^Current!

current: aDesktopView
	"Sets the singleton instance of the receiver."

	Current := aDesktopView!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the DesktopView singleton."

	Current := self basicNew
				initialize;
				yourself!

stbConvertFromVersion9: anArray
	"Private - Perform an STB conversion from a version 9 (or earlier) instance
	of the receiver to version 10,
		10: append iconTitleFont inst. var., and a couple more reserved for future use
	"

	| data size |
	data := super stbConvertFromVersion9: anArray.
	size := data size + 3.
	^(Array new: size)
		replaceFrom: 1
			to: 13
			with: data
			startingAt: 1;
		replaceFrom: 17
			to: size
			with: data
			startingAt: 13;
		yourself!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current isNil ifTrue: [^self].
	SessionManager.Current inputState removeWindowAt: 0.
	Current
		winFinalize;
		handle: nil.
	Current := nil!

winClassName
	^'#32769'! !

!UI.DesktopView class categoriesForMethods!
current!accessing!public! !
current:!accessing!public! !
icon!constants!public! !
initialize!development!initializing!private! !
stbConvertFromVersion9:!binary filing!private! !
uninitialize!class hierarchy-removing!private! !
winClassName!constants!private! !
!

