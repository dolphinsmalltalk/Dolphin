"Filed out from Dolphin Smalltalk 7"!

Graphics.Icon subclass: #'Graphics.Cursor'
	instanceVariableNames: ''
	classVariableNames: 'AppStarting Arrow Cross Current DDCopy DDCopyScroll DDLink DDLinkScroll DDMove DDMoveScroll DDNone Hand Help IBeam No SizeAll SizeNESW SizeNS SizeNWSE SizeWE SplitHorizontal SplitVertical UpArrow Wait'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Cursor guid: (Core.GUID fromString: '{87b4c640-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.Cursor comment: ''!
!Graphics.Cursor categoriesForClass!Graphics-Tools! !
!Graphics.Cursor methodsFor!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_CURSOR!

load: identifierObject fromInstance: hModule extent: aPoint
	"Private - Attempts to load the receiver as a resource from an instance.
	Answers the image's handle, or nil if the image could not be loaded."

	^UserLibrary default
		loadImage: hModule asParameter
		lpszName: identifierObject asResourceId
		uType: self imageType
		cxDesired: aPoint x
		cyDesired: aPoint y
		fuLoad: LR_SHARED!

loadFromInstance: hModule
	"Private - Attempts to load the receiver as a resource from an instance. 
	I would have expected the User32 loadImage function to be capable of this but
	it does not appear to work for instance 0; the system. Hence this method 
	which tries the old way. Answers the loaded handle or nil if the load failed"

	^UserLibrary default loadCursor: hModule asParameter lpCursorName: identifier asResourceId!

makeCurrent
	"Make the receiver become the current global cursor."

	self class current: self!

printOn: aStream
	instanceHandle == 0
		ifTrue: 
			[(##(LookupTable new
				at: IDC_APPSTARTING put: #appStarting;
				at: IDC_ARROW put: #arrow;
				at: IDC_CROSS put: #cross;
				at: IDC_HAND put: #hand;
				at: IDC_HELP put: #help;
				at: IDC_IBEAM put: #iBeam;
				at: IDC_NO put: #no;
				at: IDC_SIZEALL put: #sizeAll;
				at: IDC_SIZENESW put: #sizeNESW;
				at: IDC_SIZENS put: #sizeNS;
				at: IDC_SIZENWSE put: #sizeNWSE;
				at: IDC_SIZEWE put: #sizeWE;
				at: IDC_UPARROW put: #upArrow;
				at: IDC_WAIT put: #wait;
				shrink) lookup: self identifier)
				ifNotNil: 
					[:name |
					aStream
						print: self class;
						space;
						nextPutAll: name.
					^self]].
	super printOn: aStream!

setCursor
	"Private - Set the receiver as the current Windows cursor. Answers the handle of the old
	cursor."

	^UserLibrary default setCursor: self asParameter!

showWhile: aBlock
	"Maintain the wait cursor while aBlock is executed, answering the result of the block.
	The actual cursor which was current is restored (rather than the one we think is Current)."

	| previous actual |
	previous := Current.
	Current := self.
	actual := self setCursor.
	^aBlock ensure: 
			[Current := previous.
			UserLibrary default setCursor: actual]! !
!Graphics.Cursor categoriesFor: #imageType!constants!private! !
!Graphics.Cursor categoriesFor: #load:fromInstance:extent:!private!realizing/unrealizing! !
!Graphics.Cursor categoriesFor: #loadFromInstance:!private!realizing/unrealizing! !
!Graphics.Cursor categoriesFor: #makeCurrent!operations!public! !
!Graphics.Cursor categoriesFor: #printOn:!development!printing!public! !
!Graphics.Cursor categoriesFor: #setCursor!operations!private! !
!Graphics.Cursor categoriesFor: #showWhile:!operations!public! !

!Graphics.Cursor class methodsFor!

appStarting
	"Answer the instance that is the AppStarting cursor."

	AppStarting isNil ifTrue: [AppStarting := self fromSystemId: IDC_APPSTARTING].
	^AppStarting!

arrow
	"Answer the instance that is the Arrow cursor."

	Arrow isNil ifTrue: [Arrow := self fromSystemId: IDC_ARROW].
	^Arrow!

cross
	"Answer the instance that is the Cross cursor."

	Cross isNil ifTrue: [Cross := self fromSystemId: IDC_CROSS].
	^Cross!

current
	"Answers the current global cursor. This may be nil."

	^Current!

current: aCursorOrNil
	"Private - Set the current cursor to aCursorOrNil.
	Answers the previous current cursor (or nil)."

	| original |
	original := Current.
	Current := aCursorOrNil.
	UserLibrary default setCursor: Current asParameter.
	^original!

ddCopy
	"Answer the instance that is the OLE DROPEFFECT_COPY cursor."

	DDCopy isNil ifTrue: [DDCopy := self fromId: 3 in: (External.ResourceLibrary open: 'ole32')].
	^DDCopy!

ddCopyScroll
	"Answer the instance that is the OLE DROPEFFECT_COPY | DROPEFFECT_SCROLL cursor."

	DDCopyScroll isNil
		ifTrue: [DDCopyScroll := self fromId: 6 in: (External.ResourceLibrary open: 'ole32')].
	^DDCopyScroll!

ddLink
	"Answer the instance that is the OLE DROPEFFECT_LINK cursor."

	DDLink isNil ifTrue: [DDLink := self fromId: 4 in: (External.ResourceLibrary open: 'ole32')].
	^DDLink!

ddLinkScroll
	"Answer the instance that is the OLE DROPEFFECT_LINK | DROPEFFECT_SCROLL cursor."

	DDLinkScroll isNil
		ifTrue: [DDLinkScroll := self fromId: 7 in: (External.ResourceLibrary open: 'ole32')].
	^DDLinkScroll!

ddMove
	"Answer the instance that is the OLE DROPEFFECT_MOVE cursor."

	DDMove isNil ifTrue: [DDMove := self fromId: 2 in: (External.ResourceLibrary open: 'ole32')].
	^DDMove!

ddMoveScroll
	"Answer the instance that is the OLE DROPEFFECT_MOVE | DROPEFFECT_SCROLL cursor."

	DDMoveScroll isNil
		ifTrue: [DDMoveScroll := self fromId: 5 in: (External.ResourceLibrary open: 'ole32')].
	^DDMoveScroll!

ddNone
	"Answer the instance that is the OLE DROPEFFECT_NONE cursor."

	DDNone isNil ifTrue: [DDNone := self fromId: 1 in: (External.ResourceLibrary open: 'ole32')].
	^DDNone!

defaultExtent
	"Answer a Point that gives the dimensions of a standard size cursor."

	^SystemMetrics current cursorExtent!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Cursor Files (*.cur)' '*.cur')!

hand
	"Answer the instance that is the Help cursor."

	Hand isNil ifTrue: [Hand := self fromSystemId: IDC_HAND].
	^Hand!

help
	"Answer the instance that is the Help cursor."

	Help isNil ifTrue: [Help := self fromSystemId: IDC_HELP].
	^Help!

hide
	"Hide the current cursor"

	self show: false!

iBeam
	"Answer the instance that is the IBeam cursor."

	IBeam isNil ifTrue: [IBeam := self fromSystemId: IDC_IBEAM].
	^IBeam!

icon
	"Answers an Icon that can be used to represent this class"

	^self hand!

no
	"Answer the instance that is the No cursor."

	No isNil ifTrue: [No := self fromSystemId: IDC_NO].
	^No!

onPreStripImage
	"Private - The image is about to be stripped. Nil the lazily initialized cursors to allow
	them to be removed (and also perhaps the ref to the resource library)."

	self uninitialize!

position
	"Answer a Point containing the current cursor position in screen co-ordinates."

	| pos |
	pos := POINTL new.
	UserLibrary default getCursorPos: pos.
	^pos asPoint!

reset
	"Clear the global cursor setting. Answers the previous global cursor (or nil if none)."

	^self current: nil!

show
	"Shows the current cursor"

	self show: true!

show: aBoolean
	"Show or hide the current cursor according to aBoolean"

	UserLibrary default showCursor: aBoolean asParameter!

sizeAll
	"Answer the instance that is the SizeAll cursor."

	SizeAll isNil ifTrue: [SizeAll := self fromSystemId: IDC_SIZEALL].
	^SizeAll!

sizeNESW
	"Answer the instance that is the SizeNESW cursor."

	SizeNESW isNil ifTrue: [SizeNESW := self fromSystemId: IDC_SIZENESW].
	^SizeNESW!

sizeNS
	"Answer the instance that is the SizeNS cursor."

	SizeNS isNil ifTrue: [SizeNS := self fromSystemId: IDC_SIZENS].
	^SizeNS!

sizeNWSE
	"Answer the instance that is the SizeNWSE cursor."

	SizeNWSE isNil ifTrue: [SizeNWSE := self fromSystemId: IDC_SIZENWSE].
	^SizeNWSE!

sizeWE
	"Answer the instance that is the SizeWE cursor."

	SizeWE isNil ifTrue: [SizeWE := self fromSystemId: IDC_SIZEWE].
	^SizeWE!

splitHorizontal
	"Answer the instance that is the SplitHorizontal cursor."

	SplitHorizontal isNil ifTrue: [SplitHorizontal := self fromId: 'HSPLIT' in: VMLibrary default].
	^SplitHorizontal!

splitVertical
	"Answer the instance that is the SplitVertical cursor."

	SplitVertical isNil ifTrue: [SplitVertical := self fromId: 'VSPLIT' in: VMLibrary default].
	^SplitVertical!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	DDCopy := DDCopyScroll := 
		DDLink := DDLinkScroll := 
		DDMove := DDMoveScroll := 
		DDNone := nil.

	AppStarting := Arrow := Cross := Help := IBeam := No := Wait :=
		SizeAll := SizeNESW := SizeNS := SizeNWSE := SizeWE := 
		SplitHorizontal := SplitVertical := UpArrow := nil.

	Current := nil.!

upArrow
	"Answer the instance that is the UpArrow cursor."

	UpArrow isNil ifTrue: [UpArrow := self fromSystemId: IDC_UPARROW].
	^UpArrow!

wait
	"Answer the instance that is the Wait cursor."

	Wait isNil ifTrue: [Wait := self fromSystemId: IDC_WAIT].
	^Wait! !
!Graphics.Cursor class categoriesFor: #appStarting!accessing!public! !
!Graphics.Cursor class categoriesFor: #arrow!instance creation!public! !
!Graphics.Cursor class categoriesFor: #cross!instance creation!public! !
!Graphics.Cursor class categoriesFor: #current!accessing!public! !
!Graphics.Cursor class categoriesFor: #current:!accessing!private! !
!Graphics.Cursor class categoriesFor: #ddCopy!instance creation!public! !
!Graphics.Cursor class categoriesFor: #ddCopyScroll!instance creation!public! !
!Graphics.Cursor class categoriesFor: #ddLink!instance creation!public! !
!Graphics.Cursor class categoriesFor: #ddLinkScroll!instance creation!public! !
!Graphics.Cursor class categoriesFor: #ddMove!instance creation!public! !
!Graphics.Cursor class categoriesFor: #ddMoveScroll!instance creation!public! !
!Graphics.Cursor class categoriesFor: #ddNone!instance creation!public! !
!Graphics.Cursor class categoriesFor: #defaultExtent!constants!public! !
!Graphics.Cursor class categoriesFor: #filesType!constants!private! !
!Graphics.Cursor class categoriesFor: #hand!instance creation!public! !
!Graphics.Cursor class categoriesFor: #help!instance creation!public! !
!Graphics.Cursor class categoriesFor: #hide!operations!public! !
!Graphics.Cursor class categoriesFor: #iBeam!instance creation!public! !
!Graphics.Cursor class categoriesFor: #icon!constants!public! !
!Graphics.Cursor class categoriesFor: #no!instance creation!public! !
!Graphics.Cursor class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Graphics.Cursor class categoriesFor: #position!accessing!public! !
!Graphics.Cursor class categoriesFor: #reset!initializing!public! !
!Graphics.Cursor class categoriesFor: #show!operations!public! !
!Graphics.Cursor class categoriesFor: #show:!operations!public! !
!Graphics.Cursor class categoriesFor: #sizeAll!instance creation!public! !
!Graphics.Cursor class categoriesFor: #sizeNESW!instance creation!public! !
!Graphics.Cursor class categoriesFor: #sizeNS!instance creation!public! !
!Graphics.Cursor class categoriesFor: #sizeNWSE!instance creation!public! !
!Graphics.Cursor class categoriesFor: #sizeWE!instance creation!public! !
!Graphics.Cursor class categoriesFor: #splitHorizontal!instance creation!public! !
!Graphics.Cursor class categoriesFor: #splitVertical!instance creation!public! !
!Graphics.Cursor class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Graphics.Cursor class categoriesFor: #upArrow!instance creation!public! !
!Graphics.Cursor class categoriesFor: #wait!instance creation!public! !

