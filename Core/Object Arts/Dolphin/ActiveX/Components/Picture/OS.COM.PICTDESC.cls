﻿"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.COM.PICTDESC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_dw1' -> 16rC.
			'_OffsetOf_dw2' -> 16r10.
			'_OffsetOf_handle' -> 16r8.
			'_OffsetOf_picType' -> 16r4.
			'_PICTDESC_Size' -> 16r14
		}!

OS.COM.PICTDESC guid: (Core.GUID fromString: '{a1a65a80-aef9-11d3-b376-080046056106}')!

OS.COM.PICTDESC comment: ''!

!OS.COM.PICTDESC methodsFor!

dw1
	"Answer the <Integer> value of the receiver's 'dw1' field."

	^bytes uint32AtOffset: _OffsetOf_dw1!

dw1: anInteger
	"Set the receiver's 'dw1' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dw1 put: anInteger!

dw2
	"Answer the <Integer> value of the receiver's 'dw2' field."

	^bytes uint32AtOffset: _OffsetOf_dw2!

dw2: anInteger
	"Set the receiver's 'dw2' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dw2 put: anInteger!

handle
	"Answer the <Integer> value of the receiver's 'handle' field."

	^bytes uint32AtOffset: _OffsetOf_handle!

handle: anInteger
	"Set the receiver's 'handle' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_handle put: anInteger!

picType
	"Answer the <Integer> value of the receiver's 'picType' field."

	^bytes uint32AtOffset: _OffsetOf_picType!

picType: anInteger
	"Set the receiver's 'picType' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_picType put: anInteger! !

!OS.COM.PICTDESC categoriesForMethods!
dw1!**compiled accessors**!public! !
dw1:!**compiled accessors**!public! !
dw2!**compiled accessors**!public! !
dw2:!**compiled accessors**!public! !
handle!**compiled accessors**!public! !
handle:!**compiled accessors**!public! !
picType!**compiled accessors**!public! !
picType:!**compiled accessors**!public! !
!

!OS.COM.PICTDESC class methodsFor!

byteSize
	^_PICTDESC_Size!

defineFields
	"Define the fields of the PICTDESC structure.

		PICTDESC compileDefinition.

		typedef struct tagPICTDESC
		{
			UINT cbSizeofstruct;
			UINT picType;
			union
			{
				struct
				{
					HBITMAP   hbitmap;        // Bitmap
					HPALETTE  hpal;           // Accompanying palette
				} bmp;
				struct
				{
					HMETAFILE hmeta;          // Metafile
					int       xExt;
					int       yExt;           // Extent
				} wmf;
				struct
				{
					HICON hicon;              // Icon
				} icon;
		#ifdef _WIN32
				struct
				{
					HENHMETAFILE hemf;        // Enhanced Metafile
				} emf;
		#endif
			};
		} PICTDESC, FAR* LPPICTDESC;
	"

	super defineFields.
	self
		defineField: #picType type: UInt32Field new;

		"Next version of Dolphin can handle unions, in mean time..."
		defineField: #handle type: UInt32Field new;
		defineField: #dw1 type: UInt32Field new;
		defineField: #dw2 type: UInt32Field new

		"Definition for next version"
"		defineField: #hbitmap type: HANDLEField new offset: 8;
		defineField: #hpacl type: HANDLEField new offset: 12;
		defineField: #hmeta type: HANDLEField new offset: 8;
		defineField: #xExt type: HANDLEField new offset: 12;
		defineField: #yExt type: HANDLEField new offset: 16;
		defineField: #hicon type: HANDLEField new offset: 8;
		defineField: #hemf type: HANDLEField new offset: 8
"!

getFieldNames
	^#(#dwSize #picType #handle #dw1 #dw2)!

icon
	"Answers an Icon that can be used to represent this class"

	^Picture icon! !

!OS.COM.PICTDESC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
icon!constants!public! !
!

