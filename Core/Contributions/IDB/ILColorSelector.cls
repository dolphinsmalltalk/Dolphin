"Filed out from Dolphin Smalltalk"!

View subclass: #ILColorSelector
	instanceVariableNames: 'colorTable dum2 dum3 dum4 dum5'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILColorSelector guid: (GUID fromString: '{98275153-d23a-4a14-a9f2-1ff232b7dc14}')!

ILColorSelector comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILColorSelector categoriesForClass!IDB Goodies! !

!ILColorSelector methodsFor!

colorsAcross
	^8!

colorsDown
	^self colorTable size / self colorsAcross!

colorsSize
	"The size of the square that displays each colour"

	^16!

colorTable
	"Lazily initialize the colour table that the images all use"

	colorTable isNil 
		ifTrue: 
			[colorTable := (DeviceIndependentBitmap colorTableForDepth: 8) 
						collect: [:each | each asColor]].
	^colorTable!

indexOf: aPoint
	"Answers the number, 1..256, of the color in the colour table displayed at 
	position aPoint or nil if aPoint is outside the colour area"

	| location |
	location := (aPoint - self margin) // self colorsSize.
	(location x between: 0 and: self colorsAcross - 1) 
		& (location y between: 0 and: self colorsDown - 1) ifFalse: [^nil].
	^location y * self colorsAcross + location x + 1!

indexOfRGB: anRGB
	"Answers the index in the colour table for anRGB (1..256)"

	^self colorTable indexOf: anRGB!

margin
	"The size of the margin surrounding the colour display"

	^4!

onLeftButtonPressed: aMouseEvent
	"Convert the mouse location into a colour and, if not nil, tell any interested parties"

	| index |
	(index := self indexOf: aMouseEvent position) isNil ifTrue: [^self].
	self trigger: #selectRGB: with: (self colorTable at: index)!

onPaintRequired: aPaintEvent 
	"Paint the color table in the view. No point in any fancy caching of brushes as this will
	only need painting  when the editor's model changes or it is resized"

	| canvas |
	canvas := aPaintEvent canvas.
	0 to: self colorsAcross - 1
		do: 
			[:across | 
			0 to: self colorsDown - 1
				do: 
					[:down | 
					canvas 
						fillRectangle: (across @ down * self colorsSize + self margin extent: self colorsSize)
						brush: (Brush color: (self colorTable at: down * self colorsAcross + across + 1))]]!

preferredExtent
	"Answer the preferred extent of the view. If this answers the correct size then 
	the parent view, a ScrollingContainer, will be able to layout the scroll bars correctly"

	^self colorsAcross @ self colorsDown * self colorsSize + (self margin * 2)! !

!ILColorSelector categoriesForMethods!
colorsAcross!constants!public! !
colorsDown!constants!public! !
colorsSize!constants!public! !
colorTable!accessing!public! !
indexOf:!helpers!public! !
indexOfRGB:!accessing!helpers!public! !
margin!constants!public! !
onLeftButtonPressed:!event handling!public! !
onPaintRequired:!event handling!public! !
preferredExtent!geometry!public! !
!

!ILColorSelector class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (LiteralResourceIdentifier class: self name name: 'Default view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ILColorSelector)  98 17 0 0 98 2 8 1140850688 1 416 0 524550 ##(ColorRef)  8 4278190080 0 519 0 0 0 416 98 256 196934 1 ##(RGB)  1 562 16777217 562 65537 562 16842753 562 257 562 16777473 562 65793 562 25264513 562 16843009 562 33423361 562 130561 562 33553921 562 511 562 33423871 562 131071 562 33554431 562 1 562 6553601 562 13238273 562 19922945 562 26607617 562 33292289 562 25601 562 6579201 562 13263873 562 19948545 562 26633217 562 33317889 562 51713 562 6605313 562 13289985 562 19974657 562 26659329 562 33344001 562 77825 562 6631425 562 13316097 562 20000769 562 26685441 562 33370113 562 103937 562 6657537 562 13342209 562 20026881 562 26711553 562 33396225 562 130049 562 6683649 562 13368321 562 20052993 562 26737665 562 33422337 562 101 562 6553701 562 13238373 562 19923045 562 26607717 562 33292389 562 25701 562 6579301 562 13263973 562 19948645 562 26633317 562 33317989 562 51813 562 6605413 562 13290085 562 19974757 562 26659429 562 33344101 562 77925 562 6631525 562 13316197 562 20000869 562 26685541 562 33370213 562 104037 562 6657637 562 13342309 562 20026981 562 26711653 562 33396325 562 130149 562 6683749 562 13368421 562 20053093 562 26737765 562 33422437 562 203 562 6553803 562 13238475 562 19923147 562 26607819 562 33292491 562 25803 562 6579403 562 13264075 562 19948747 562 26633419 562 33318091 562 51915 562 6605515 562 13290187 562 19974859 562 26659531 562 33344203 562 78027 562 6631627 562 13316299 562 20000971 562 26685643 562 33370315 562 104139 562 6657739 562 13342411 562 20027083 562 26711755 562 33396427 562 130251 562 6683851 562 13368523 562 20053195 562 26737867 562 33422539 562 305 562 6553905 562 13238577 562 19923249 562 26607921 562 33292593 562 25905 562 6579505 562 13264177 562 19948849 562 26633521 562 33318193 562 52017 562 6605617 562 13290289 562 19974961 562 26659633 562 33344305 562 78129 562 6631729 562 13316401 562 20001073 562 26685745 562 33370417 562 104241 562 6657841 562 13342513 562 20027185 562 26711857 562 33396529 562 130353 562 6683953 562 13368625 562 20053297 562 26737969 562 33422641 562 407 562 6554007 562 13238679 562 19923351 562 26608023 562 33292695 562 26007 562 6579607 562 13264279 562 19948951 562 26633623 562 33318295 562 52119 562 6605719 562 13290391 562 19975063 562 26659735 562 33344407 562 78231 562 6631831 562 13316503 562 20001175 562 26685847 562 33370519 562 104343 562 6657943 562 13342615 562 20027287 562 26711959 562 33396631 562 130455 562 6684055 562 13368727 562 20053399 562 26738071 562 33422743 562 509 562 6554109 562 13238781 562 19923453 562 26608125 562 33292797 562 26109 562 6579709 562 13264381 562 19949053 562 26633725 562 33318397 562 52221 562 6605821 562 13290493 562 19975165 562 26659837 562 33344509 562 78333 562 6631933 562 13316605 562 20001277 562 26685949 562 33370621 562 104445 562 6658045 562 13342717 562 20027389 562 26712061 562 33396733 562 130557 562 6684157 562 13368829 562 20053501 562 26738173 562 33422845 562 1 562 1447447 562 2894893 562 4342339 562 5789785 562 7237231 562 8684677 562 10132123 562 11579569 562 13027015 562 14474461 562 15921907 562 17369353 562 18816799 562 20264245 562 21711691 562 23159137 562 24606583 562 26054029 562 27501475 562 28948921 562 30396367 562 31843813 562 33554431 0 0 0 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 4802 225 201 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 117 0 0 0 105 0 0 0] 98 0 4802 193 193 0 27 )! !

!ILColorSelector class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

