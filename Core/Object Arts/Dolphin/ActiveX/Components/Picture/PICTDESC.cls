"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #PICTDESC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dw1' -> 16rC.
		'_OffsetOf_dw2' -> 16r10.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_handle' -> 16r8.
		'_OffsetOf_picType' -> 16r4
	}!
PICTDESC guid: (GUID fromString: '{a1a65a80-aef9-11d3-b376-080046056106}')!
PICTDESC comment: ''!
!PICTDESC categoriesForClass!Unclassified! !
!PICTDESC methodsFor!

dw1
	"Answer the <Integer> value of the receiver's 'dw1' field."

	^bytes dwordAtOffset: _OffsetOf_dw1!

dw1: anInteger
	"Set the receiver's 'dw1' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dw1 put: anInteger!

dw2
	"Answer the <Integer> value of the receiver's 'dw2' field."

	^bytes dwordAtOffset: _OffsetOf_dw2!

dw2: anInteger
	"Set the receiver's 'dw2' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dw2 put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

handle
	"Answer the <Integer> value of the receiver's 'handle' field."

	^bytes dwordAtOffset: _OffsetOf_handle!

handle: anInteger
	"Set the receiver's 'handle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_handle put: anInteger!

picType
	"Answer the <Integer> value of the receiver's 'picType' field."

	^bytes dwordAtOffset: _OffsetOf_picType!

picType: anInteger
	"Set the receiver's 'picType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_picType put: anInteger! !
!PICTDESC categoriesFor: #dw1!**compiled accessors**!public! !
!PICTDESC categoriesFor: #dw1:!**compiled accessors**!public! !
!PICTDESC categoriesFor: #dw2!**compiled accessors**!public! !
!PICTDESC categoriesFor: #dw2:!**compiled accessors**!public! !
!PICTDESC categoriesFor: #dwSize:!**compiled accessors**!public! !
!PICTDESC categoriesFor: #handle!**compiled accessors**!public! !
!PICTDESC categoriesFor: #handle:!**compiled accessors**!public! !
!PICTDESC categoriesFor: #picType!**compiled accessors**!public! !
!PICTDESC categoriesFor: #picType:!**compiled accessors**!public! !

!PICTDESC class methodsFor!

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

	self
		defineField: #dwSize type: DWORDField writeOnly;	"Renamed from cbSizeOfStruct"
		defineField: #picType type: DWORDField new;

		"Next version of Dolphin can handle unions, in mean time..."
		defineField: #handle type: DWORDField new;
		defineField: #dw1 type: DWORDField new;
		defineField: #dw2 type: DWORDField new

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

	^OLEPicture icon! !
!PICTDESC class categoriesFor: #defineFields!public!template definition! !
!PICTDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!PICTDESC class categoriesFor: #icon!constants!public! !

