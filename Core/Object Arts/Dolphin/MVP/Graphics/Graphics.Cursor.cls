"Filed out from Dolphin Smalltalk"!

Graphics.Icon
	subclass: #'Graphics.Cursor'
	instanceVariableNames: ''
	classVariableNames: 'AppStarting Arrow Cross Current DDCopy DDCopyScroll DDLink DDLinkScroll DDMove DDMoveScroll DDNone DefaultExtent Hand Help IBeam No SizeAll SizeNESW SizeNS SizeNWSE SizeWE UpArrow Wait'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Cursor guid: (Core.GUID fromString: '{87b4c640-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.Cursor comment: ''!

!Graphics.Cursor categoriesForClass!Graphics-Tools! !

!Graphics.Cursor methodsFor!

loadFromSystem: anInteger extent: aPoint
	^User32
		loadImage: 0
		lpszName: anInteger
		uType: IMAGE_CURSOR
		cxDesired: aPoint x
		cyDesired: aPoint y
		fuLoad: (aPoint = Point.Zero
				ifTrue: [##(LR_DEFAULTSIZE | LR_SHARED | LR_DEFAULTCOLOR)]
				ifFalse: [##(LR_SHARED | LR_DEFAULTCOLOR)])!

loadResource: identifierObject fromModule: moduleObject extent: aPoint flags: anInteger
	"Private - Override back to Image implementation as we don't want to use Icon specific loading functions for cursors."

	^User32
		loadImage: moduleObject asParameter
		lpszName: identifierObject asResourceId
		uType: IMAGE_CURSOR
		cxDesired: aPoint x
		cyDesired: aPoint y
		fuLoad: (aPoint = Point.Zero ifTrue: [anInteger bitOr: LR_DEFAULTSIZE] ifFalse: [anInteger])! !

!Graphics.Cursor categoriesForMethods!
loadFromSystem:extent:!private!realizing/unrealizing! !
loadResource:fromModule:extent:flags:!private!realizing/unrealizing! !
!

!Graphics.Cursor class methodsFor!

appStarting
	"Answer the instance that is the AppStarting cursor."

	^AppStarting ifNil: [AppStarting := self fromSystemId: IDC_APPSTARTING]!

arrow
	"Answer the instance that is the Arrow cursor."

	^Arrow ifNil: [Arrow := self fromSystemId: IDC_ARROW]!

cacheSystemMetrics
	DefaultExtent := SystemMetrics current cursorExtent
!

cross
	"Answer the instance that is the Cross cursor."

	^Cross ifNil: [Cross := self fromSystemId: IDC_CROSS]!

current
	"Answers the current global cursor. This may be nil."

	^Current!

current: aCursorOrNil
	"Private - Set the current cursor to aCursorOrNil.
	Answers the previous current cursor (or nil)."

	| original |
	original := Current.
	Current := aCursorOrNil.
	User32 setCursor: Current asParameter.
	^original!

ddCopy
	"Answer the instance that is the OLE DROPEFFECT_COPY cursor."

	^DDCopy ifNil: [DDCopy := self fromId: 3 in: (External.ResourceLibrary open: 'ole32')]!

ddCopyScroll
	"Answer the instance that is the OLE DROPEFFECT_COPY | DROPEFFECT_SCROLL cursor."

	^DDCopyScroll ifNil: [DDCopyScroll := self fromId: 6 in: (External.ResourceLibrary open: 'ole32')]!

ddLink
	"Answer the instance that is the OLE DROPEFFECT_LINK cursor."

	^DDLink ifNil: [DDLink := self fromId: 4 in: (External.ResourceLibrary open: 'ole32')]!

ddLinkScroll
	"Answer the instance that is the OLE DROPEFFECT_LINK | DROPEFFECT_SCROLL cursor."

	^DDLinkScroll ifNil: [DDLinkScroll := self fromId: 7 in: (External.ResourceLibrary open: 'ole32')]!

ddMove
	"Answer the instance that is the OLE DROPEFFECT_MOVE cursor."

	^DDMove ifNil: [DDMove := self fromId: 2 in: (External.ResourceLibrary open: 'ole32')]!

ddMoveScroll
	"Answer the instance that is the OLE DROPEFFECT_MOVE | DROPEFFECT_SCROLL cursor."

	^DDMoveScroll ifNil: [DDMoveScroll := self fromId: 5 in: (External.ResourceLibrary open: 'ole32')]!

ddNone
	"Answer the instance that is the OLE DROPEFFECT_NONE cursor."

	^DDNone ifNil: [DDNone := self fromId: 1 in: (External.ResourceLibrary open: 'ole32')]!

default
	^self arrow
!

defaultExtent
	"Answer a Point that gives the dimensions of a standard size cursor at the current system DPI."

	"Note that these days this is a logical size, and seems to always be the same on Windows 11. See the comment in SystemMetrics>>#cursorExtent for further details."

	^DefaultExtent!

defaultLoadFlags
	^LR_DEFAULTCOLOR!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Cursor Files (*.cur)' '*.cur')!

freeHandle: anExternalHandle
	User32 destroyCursor: anExternalHandle!

hand
	"Answer the instance that is the Help cursor."

	^Hand ifNil: [Hand := self fromSystemId: IDC_HAND]!

help
	"Answer the instance that is the Help cursor."

	^Help ifNil: [Help := self fromSystemId: IDC_HELP]!

hide
	"Hide the current cursor"

	self show: false!

iBeam
	"Answer the instance that is the IBeam cursor."

	^IBeam ifNil: [IBeam := self fromSystemId: IDC_IBEAM]!

icon
	"Answers an Icon that can be used to represent this class"

	^self hand!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_CURSOR!

initialize
	"Private - "

	SessionManager current
		when: #settingChanged:
		send: #onSettingChanged:
		to: self!

no
	"Answer the instance that is the No cursor."

	^No ifNil: [No := self fromSystemId: IDC_NO]!

onPreStripImage
	"Private - The image is about to be stripped. Nil the lazily initialized cursors to allow
	them to be removed (and also perhaps the ref to the resource library)."

	self uninitialize!

onStartup2
	"Private - Perform system startup processing for all subclasses."

	self clearCached!

person
	"Answer an instance of the Window person cursor."

	^self fromSystemId: IDC_PERSON!

pin
	"Answer an instance of the Window pin cursor."

	^self fromSystemId: IDC_PIN!

position
	"Answer a Point containing the current cursor position in screen co-ordinates."

	| pos |
	pos := POINTL newBuffer.
	User32 getCursorPos: pos.
	^pos asPoint!

position: aPoint
	"Move the mouse cursor (if permitted) to the Point specified in screen co-ordinates."

	^(User32 setCursorPosX: aPoint x y: aPoint y) ~~ 0!

reset
	"Clear the global cursor setting. Answers the previous global cursor (or nil if none)."

	^self current: nil!

resetSystemInstances
	AppStarting := Arrow := Cross := Help := IBeam := No := Wait := SizeAll := SizeNESW := SizeNS := SizeNWSE := SizeWE := UpArrow := nil!

show
	"Shows the current cursor"

	self show: true!

show: aBoolean
	"Show or hide the current cursor according to aBoolean"

	User32 showCursor: aBoolean asParameter!

sizeAll
	"Answer the instance that is the SizeAll cursor."

	^SizeAll ifNil: [SizeAll := self fromSystemId: IDC_SIZEALL]!

sizeNESW
	"Answer the instance that is the SizeNESW cursor."

	^SizeNESW ifNil: [SizeNESW := self fromSystemId: IDC_SIZENESW]!

sizeNS
	"Answer the instance that is the SizeNS cursor."

	^SizeNS ifNil: [SizeNS := self fromSystemId: IDC_SIZENS]!

sizeNWSE
	"Answer the instance that is the SizeNWSE cursor."

	^SizeNWSE ifNil: [SizeNWSE := self fromSystemId: IDC_SIZENWSE]!

sizeWE
	"Answer the instance that is the SizeWE cursor."

	^SizeWE ifNil: [SizeWE := self fromSystemId: IDC_SIZEWE]!

systemNames
	^##(LookupTable withAll: {
				IDC_APPSTARTING -> 'appStarting'.
				IDC_ARROW -> 'arrow'.
				IDC_CROSS -> 'cross'.
				IDC_HAND -> 'hand'.
				IDC_HELP -> 'help'.
				IDC_IBEAM -> 'iBeam'.
				IDC_NO -> 'no'.
				IDC_SIZEALL -> 'sizeAll'.
				IDC_SIZENESW -> 'sizeNESW'.
				IDC_SIZENS -> 'sizeNS'.
				IDC_SIZENWSE -> 'sizeNWSE'.
				IDC_SIZEWE -> 'sizeWE'.
				IDC_UPARROW -> 'upArrow'.
				IDC_WAIT -> 'wait'
			})!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	DDCopy := DDCopyScroll := DDLink := DDLinkScroll := DDMove := DDMoveScroll := DDNone := nil.
	self resetSystemInstances.
	Current := nil!

upArrow
	"Answer the instance that is the UpArrow cursor."

	^UpArrow ifNil: [UpArrow := self fromSystemId: IDC_UPARROW]!

wait
	"Answer the instance that is the Wait cursor."

	^Wait ifNil: [Wait := self fromSystemId: IDC_WAIT]! !

!Graphics.Cursor class categoriesForMethods!
appStarting!accessing!public! !
arrow!instance creation!public! !
cacheSystemMetrics!helpers!private! !
cross!instance creation!public! !
current!accessing!public! !
current:!accessing!private! !
ddCopy!instance creation!public! !
ddCopyScroll!instance creation!public! !
ddLink!instance creation!public! !
ddLinkScroll!instance creation!public! !
ddMove!instance creation!public! !
ddMoveScroll!instance creation!public! !
ddNone!instance creation!public! !
default!public!realizing/unrealizing! !
defaultExtent!constants!public! !
defaultLoadFlags!constants!private! !
filesType!constants!private! !
freeHandle:!private!realizing/unrealizing! !
hand!instance creation!public! !
help!instance creation!public! !
hide!operations!private! !
iBeam!instance creation!public! !
icon!constants!public! !
imageType!constants!private! !
initialize!class hierarchy-removing!private! !
no!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
onStartup2!event handling!private! !
person!instance creation!public! !
pin!instance creation!public! !
position!accessing!public! !
position:!accessing!public! !
reset!initializing!public! !
resetSystemInstances!helpers!private! !
show!operations!private! !
show:!operations!private! !
sizeAll!instance creation!public! !
sizeNESW!instance creation!public! !
sizeNS!instance creation!public! !
sizeNWSE!instance creation!public! !
sizeWE!instance creation!public! !
systemNames!constants!public! !
uninitialize!class hierarchy-removing!private! !
upArrow!instance creation!public! !
wait!instance creation!public! !
!

