"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.ENHMETARECORD'
	instanceVariableNames: ''
	classVariableNames: 'RecordTypes'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ENHMETARECORD_Size' -> 16r8.
			'_OffsetOf_iType' -> 16r0.
			'_OffsetOf_nSize' -> 16r4.
			'EMR_ABORTPATH' -> 16r44.
			'EMR_ALPHABLEND' -> 16r72.
			'EMR_ANGLEARC' -> 16r29.
			'EMR_ARC' -> 16r2D.
			'EMR_ARCTO' -> 16r37.
			'EMR_BEGINPATH' -> 16r3B.
			'EMR_BITBLT' -> 16r4C.
			'EMR_CHORD' -> 16r2E.
			'EMR_CLOSEFIGURE' -> 16r3D.
			'EMR_COLORCORRECTPALETTE' -> 16r6F.
			'EMR_COLORMATCHTOTARGETW' -> 16r79.
			'EMR_CREATEBRUSHINDIRECT' -> 16r27.
			'EMR_CREATECOLORSPACE' -> 16r63.
			'EMR_CREATECOLORSPACEW' -> 16r7A.
			'EMR_CREATEDIBPATTERNBRUSHPT' -> 16r5E.
			'EMR_CREATEMONOBRUSH' -> 16r5D.
			'EMR_CREATEPALETTE' -> 16r31.
			'EMR_CREATEPEN' -> 16r26.
			'EMR_DELETECOLORSPACE' -> 16r65.
			'EMR_DELETEOBJECT' -> 16r28.
			'EMR_ELLIPSE' -> 16r2A.
			'EMR_ENDPATH' -> 16r3C.
			'EMR_EOF' -> 16rE.
			'EMR_EXCLUDECLIPRECT' -> 16r1D.
			'EMR_EXTCREATEFONTINDIRECTW' -> 16r52.
			'EMR_EXTCREATEPEN' -> 16r5F.
			'EMR_EXTFLOODFILL' -> 16r35.
			'EMR_EXTSELECTCLIPRGN' -> 16r4B.
			'EMR_EXTTEXTOUTA' -> 16r53.
			'EMR_EXTTEXTOUTW' -> 16r54.
			'EMR_FILLPATH' -> 16r3E.
			'EMR_FILLRGN' -> 16r47.
			'EMR_FLATTENPATH' -> 16r41.
			'EMR_FRAMERGN' -> 16r48.
			'EMR_GDICOMMENT' -> 16r46.
			'EMR_GLSBOUNDEDRECORD' -> 16r67.
			'EMR_GLSRECORD' -> 16r66.
			'EMR_GRADIENTFILL' -> 16r76.
			'EMR_HEADER' -> 16r1.
			'EMR_INTERSECTCLIPRECT' -> 16r1E.
			'EMR_INVERTRGN' -> 16r49.
			'EMR_LINETO' -> 16r36.
			'EMR_MASKBLT' -> 16r4E.
			'EMR_MAX' -> 16r7A.
			'EMR_MIN' -> 16r1.
			'EMR_MODIFYWORLDTRANSFORM' -> 16r24.
			'EMR_MOVETOEX' -> 16r1B.
			'EMR_OFFSETCLIPRGN' -> 16r1A.
			'EMR_PAINTRGN' -> 16r4A.
			'EMR_PIE' -> 16r2F.
			'EMR_PIXELFORMAT' -> 16r68.
			'EMR_PLGBLT' -> 16r4F.
			'EMR_POLYBEZIER' -> 16r2.
			'EMR_POLYBEZIER16' -> 16r55.
			'EMR_POLYBEZIERTO' -> 16r5.
			'EMR_POLYBEZIERTO16' -> 16r58.
			'EMR_POLYDRAW' -> 16r38.
			'EMR_POLYDRAW16' -> 16r5C.
			'EMR_POLYGON' -> 16r3.
			'EMR_POLYGON16' -> 16r56.
			'EMR_POLYLINE' -> 16r4.
			'EMR_POLYLINE16' -> 16r57.
			'EMR_POLYLINETO' -> 16r6.
			'EMR_POLYLINETO16' -> 16r59.
			'EMR_POLYPOLYGON' -> 16r8.
			'EMR_POLYPOLYGON16' -> 16r5B.
			'EMR_POLYPOLYLINE' -> 16r7.
			'EMR_POLYPOLYLINE16' -> 16r5A.
			'EMR_POLYTEXTOUTA' -> 16r60.
			'EMR_POLYTEXTOUTW' -> 16r61.
			'EMR_REALIZEPALETTE' -> 16r34.
			'EMR_RECTANGLE' -> 16r2B.
			'EMR_RESERVED_105' -> 16r69.
			'EMR_RESERVED_106' -> 16r6A.
			'EMR_RESERVED_107' -> 16r6B.
			'EMR_RESERVED_108' -> 16r6C.
			'EMR_RESERVED_109' -> 16r6D.
			'EMR_RESERVED_110' -> 16r6E.
			'EMR_RESERVED_117' -> 16r75.
			'EMR_RESERVED_119' -> 16r77.
			'EMR_RESERVED_120' -> 16r78.
			'EMR_RESERVED_69' -> 16r45.
			'EMR_RESIZEPALETTE' -> 16r33.
			'EMR_RESTOREDC' -> 16r22.
			'EMR_ROUNDRECT' -> 16r2C.
			'EMR_SAVEDC' -> 16r21.
			'EMR_SCALEVIEWPORTEXTEX' -> 16r1F.
			'EMR_SCALEWINDOWEXTEX' -> 16r20.
			'EMR_SELECTCLIPPATH' -> 16r43.
			'EMR_SELECTOBJECT' -> 16r25.
			'EMR_SELECTPALETTE' -> 16r30.
			'EMR_SETARCDIRECTION' -> 16r39.
			'EMR_SETBKCOLOR' -> 16r19.
			'EMR_SETBKMODE' -> 16r12.
			'EMR_SETBRUSHORGEX' -> 16rD.
			'EMR_SETCOLORADJUSTMENT' -> 16r17.
			'EMR_SETCOLORSPACE' -> 16r64.
			'EMR_SETDIBITSTODEVICE' -> 16r50.
			'EMR_SETICMMODE' -> 16r62.
			'EMR_SETICMPROFILEA' -> 16r70.
			'EMR_SETICMPROFILEW' -> 16r71.
			'EMR_SETLAYOUT' -> 16r73.
			'EMR_SETMAPMODE' -> 16r11.
			'EMR_SETMAPPERFLAGS' -> 16r10.
			'EMR_SETMETARGN' -> 16r1C.
			'EMR_SETMITERLIMIT' -> 16r3A.
			'EMR_SETPALETTEENTRIES' -> 16r32.
			'EMR_SETPIXELV' -> 16rF.
			'EMR_SETPOLYFILLMODE' -> 16r13.
			'EMR_SETROP2' -> 16r14.
			'EMR_SETSTRETCHBLTMODE' -> 16r15.
			'EMR_SETTEXTALIGN' -> 16r16.
			'EMR_SETTEXTCOLOR' -> 16r18.
			'EMR_SETVIEWPORTEXTEX' -> 16rB.
			'EMR_SETVIEWPORTORGEX' -> 16rC.
			'EMR_SETWINDOWEXTEX' -> 16r9.
			'EMR_SETWINDOWORGEX' -> 16rA.
			'EMR_SETWORLDTRANSFORM' -> 16r23.
			'EMR_STRETCHBLT' -> 16r4D.
			'EMR_STRETCHDIBITS' -> 16r51.
			'EMR_STROKEANDFILLPATH' -> 16r3F.
			'EMR_STROKEPATH' -> 16r40.
			'EMR_TRANSPARENTBLT' -> 16r74.
			'EMR_WIDENPATH' -> 16r42.
			'RecordTypeNames'
				-> #('EMR_HEADER' 'EMR_POLYBEZIER' 'EMR_POLYGON' 'EMR_POLYLINE' 'EMR_POLYBEZIERTO' 'EMR_POLYLINETO' 'EMR_POLYPOLYLINE' 'EMR_POLYPOLYGON' 'EMR_SETWINDOWEXTEX' 'EMR_SETWINDOWORGEX' 'EMR_SETVIEWPORTEXTEX' 'EMR_SETVIEWPORTORGEX' 'EMR_SETBRUSHORGEX' 'EMR_EOF' 'EMR_SETPIXELV' 'EMR_SETMAPPERFLAGS' 'EMR_SETMAPMODE' 'EMR_SETBKMODE' 'EMR_SETPOLYFILLMODE' 'EMR_SETROP2' 'EMR_SETSTRETCHBLTMODE' 'EMR_SETTEXTALIGN' 'EMR_SETCOLORADJUSTMENT' 'EMR_SETTEXTCOLOR' 'EMR_SETBKCOLOR' 'EMR_OFFSETCLIPRGN' 'EMR_MOVETOEX' 'EMR_SETMETARGN' 'EMR_EXCLUDECLIPRECT' 'EMR_INTERSECTCLIPRECT' 'EMR_SCALEVIEWPORTEXTEX' 'EMR_SCALEWINDOWEXTEX' 'EMR_SAVEDC' 'EMR_RESTOREDC' 'EMR_SETWORLDTRANSFORM' 'EMR_MODIFYWORLDTRANSFORM' 'EMR_SELECTOBJECT' 'EMR_CREATEPEN' 'EMR_CREATEBRUSHINDIRECT' 'EMR_DELETEOBJECT' 'EMR_ANGLEARC' 'EMR_ELLIPSE' 'EMR_RECTANGLE' 'EMR_ROUNDRECT' 'EMR_ARC' 'EMR_CHORD' 'EMR_PIE' 'EMR_SELECTPALETTE' 'EMR_CREATEPALETTE' 'EMR_SETPALETTEENTRIES' 'EMR_RESIZEPALETTE' 'EMR_REALIZEPALETTE' 'EMR_EXTFLOODFILL' 'EMR_LINETO' 'EMR_ARCTO' 'EMR_POLYDRAW' 'EMR_SETARCDIRECTION' 'EMR_SETMITERLIMIT' 'EMR_BEGINPATH' 'EMR_ENDPATH' 'EMR_CLOSEFIGURE' 'EMR_FILLPATH' 'EMR_STROKEANDFILLPATH' 'EMR_STROKEPATH' 'EMR_FLATTENPATH' 'EMR_WIDENPATH' 'EMR_SELECTCLIPPATH' 'EMR_ABORTPATH' 'EMR_RESERVED_69' 'EMR_GDICOMMENT' 'EMR_FILLRGN' 'EMR_FRAMERGN' 'EMR_INVERTRGN' 'EMR_PAINTRGN' 'EMR_EXTSELECTCLIPRGN' 'EMR_BITBLT' 'EMR_STRETCHBLT' 'EMR_MASKBLT' 'EMR_PLGBLT' 'EMR_SETDIBITSTODEVICE' 'EMR_STRETCHDIBITS' 'EMR_EXTCREATEFONTINDIRECTW' 'EMR_EXTTEXTOUTA' 'EMR_EXTTEXTOUTW' 'EMR_POLYBEZIER16' 'EMR_POLYGON16' 'EMR_POLYLINE16' 'EMR_POLYBEZIERTO16' 'EMR_POLYLINETO16' 'EMR_POLYPOLYLINE16' 'EMR_POLYPOLYGON16' 'EMR_POLYDRAW16' 'EMR_CREATEMONOBRUSH' 'EMR_CREATEDIBPATTERNBRUSHPT' 'EMR_EXTCREATEPEN' 'EMR_POLYTEXTOUTA' 'EMR_POLYTEXTOUTW' 'EMR_SETICMMODE' 'EMR_CREATECOLORSPACE' 'EMR_SETCOLORSPACE' 'EMR_DELETECOLORSPACE' 'EMR_GLSRECORD' 'EMR_GLSBOUNDEDRECORD' 'EMR_PIXELFORMAT' 'EMR_RESERVED_105' 'EMR_RESERVED_106' 'EMR_RESERVED_107' 'EMR_RESERVED_108' 'EMR_RESERVED_109' 'EMR_RESERVED_110' 'EMR_COLORCORRECTPALETTE' 'EMR_SETICMPROFILEA' 'EMR_SETICMPROFILEW' 'EMR_ALPHABLEND' 'EMR_SETLAYOUT' 'EMR_TRANSPARENTBLT' 'EMR_RESERVED_117' 'EMR_GRADIENTFILL' 'EMR_RESERVED_119' 'EMR_RESERVED_120' 'EMR_COLORMATCHTOTARGETW' 'EMR_MAX')
		}!

OS.ENHMETARECORD guid: (Core.GUID fromString: '{5a360b92-6a3d-40d5-9d88-972ffd1416e6}')!

OS.ENHMETARECORD comment: '<ENHMETARECORD> is an <ExternalStructure> class to wrap the base struct for all the Enhanced Metafile record structs.'!

!OS.ENHMETARECORD categoriesForClass!Win32-Structs! !

!OS.ENHMETARECORD methodsFor!

getField: fieldNameString
	"Private - Answer the value of the named field of the receiver,
	or if there is no such field then raise an exception."

	| selector |
	selector := fieldNameString asSymbol.
	selector == #iType ifTrue: [^RecordTypeNames at: self iType ifAbsent: [self iType printString]].
	^self perform: selector!

iType
	"Answer the <Integer> value of the receiver's 'iType' field."

	^bytes uint32AtOffset: _OffsetOf_iType!

iType: anInteger
	"Set the receiver's 'iType' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iType put: anInteger!

nSize
	"Answer the <Integer> value of the receiver's 'nSize' field."

	^bytes uint32AtOffset: _OffsetOf_nSize!

nSize: anInteger
	"Set the receiver's 'nSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nSize put: anInteger! !

!OS.ENHMETARECORD categoriesForMethods!
getField:!accessing!private! !
iType!**compiled accessors**!public! !
iType:!**compiled accessors**!public! !
nSize!**compiled accessors**!public! !
nSize:!**compiled accessors**!public! !
!

!OS.ENHMETARECORD class methodsFor!

byteSize
	^_ENHMETARECORD_Size!

defineFields
	"Define the fields of the EMR structure.

	self  compileDefinition

		typedef [uuid(5A360B92-6A3D-40D5-9D88-972FFD1416E6)]
		struct tagEMR {
			[helpstring('Enhanced metafile record type')] DWORD iType;
			[helpstring('Length of the record in bytes. This must be a multiple of 4.')] DWORD nSize;
		} EMR;
"

	self
		defineField: #iType
			type: UInt32Field new
			offset: 0;
		defineField: #nSize
			type: UInt32Field new
			offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#iType #nSize)!

initialize
	| recordTypeNames |
	RecordTypes := Array new: EMR_MAX.
	recordTypeNames := Array new: EMR_MAX withAll: 'EMR_UNKNOWN'.
	self classConstants
		do: [:each | (each key beginsWith: 'EMR_') ifTrue: [recordTypeNames at: each value put: each key]].
	self addClassConstant: 'RecordTypeNames' value: recordTypeNames!

initializeAfterLoad
	"Perform any post-load initialisation for the class.
	In this case we set up the function table now to avoid overhead of lazy init. test
	init. on every virtual function callback."

	super initializeAfterLoad.
	"Record any newly loaded subclass in the record types table"
	self == ##(self) ifFalse: [self registerRecordTypes]!

iTypes
	"Answer a collection of the integer enhanced metafile record type ids that this class can represent."

	^{EMR_ABORTPATH. EMR_BEGINPATH. EMR_ENDPATH. EMR_CLOSEFIGURE. EMR_FLATTENPATH}
		, {EMR_WIDENPATH. EMR_SETMETARGN. EMR_SAVEDC. EMR_REALIZEPALETTE}!

registerRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: self]!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class."

	self unregisterRecordTypes.
	super uninitializeBeforeRemove!

unregisterRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: nil]! !

!OS.ENHMETARECORD class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!public! !
initializeAfterLoad!initializing!public! !
iTypes!constants!public! !
registerRecordTypes!initializing!private! !
uninitializeBeforeRemove!class hierarchy-removing!public! !
unregisterRecordTypes!accessing!private! !
!

