"Filed out from Dolphin Smalltalk"!

Presenter subclass: #ILEditorWorkspacePresenter
	instanceVariableNames: 'dum1 dum2 dum3 dum4 dum5'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILEditorWorkspacePresenter guid: (GUID fromString: '{d015ffbd-130b-4c43-92b1-541993e215e7}')!

ILEditorWorkspacePresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILEditorWorkspacePresenter categoriesForClass!IDB Goodies! !

!ILEditorWorkspacePresenter methodsFor!

backcolor: anRGB
	self view backcolor: anRGB!

canDraw
	^self view isZoomed & self view hasZone!

canEdit
	^self view isZoomed!

canFillAll
	^self view isZoomed!

defaultBackcolor
	^Color white!

defaultZoom
	^16!

locationDescription
	^self view locationDescription!

onViewOpened
	super onViewOpened.
	self zoom: self defaultZoom.
	self backcolor: self defaultBackcolor!

zoneDescription
	^self view zoneDescription!

zoneRectangle
	^self view zoneRectangle!

zoom: anInteger
	self view zoom: anInteger!

zoomBy: anInteger
	self view zoomBy: anInteger!

zoomDescription
	^self view zoomDescription! !

!ILEditorWorkspacePresenter categoriesForMethods!
backcolor:!accessing!public! !
canDraw!public!testing! !
canEdit!public!testing! !
canFillAll!public!testing! !
defaultBackcolor!constants!event handling!public! !
defaultZoom!constants!event handling!public! !
locationDescription!accessing!public! !
onViewOpened!event handling!public! !
zoneDescription!accessing!public! !
zoneRectangle!accessing!public! !
zoom:!accessing!public! !
zoomBy:!accessing!public! !
zoomDescription!accessing!public! !
!

!ILEditorWorkspacePresenter class methodsFor!

defaultModel
	^ILImage extent: 16 @ 16!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (LiteralResourceIdentifier class: self name name: 'Default view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ILEditorWorkspace)  98 16 0 0 98 2 8 1140850688 1 416 0 524550 ##(ColorRef)  8 4278190080 0 519 0 0 0 416 0 0 0 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 674 225 201 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 117 0 0 0 105 0 0 0] 98 0 674 193 193 0 27 )! !

!ILEditorWorkspacePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

