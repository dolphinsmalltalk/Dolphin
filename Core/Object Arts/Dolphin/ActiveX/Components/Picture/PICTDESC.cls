"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #PICTDESC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PICTDESC guid: (GUID fromString: '{a1a65a80-aef9-11d3-b376-080046056106}')!
PICTDESC comment: ''!
!PICTDESC categoriesForClass!Unclassified! !
!PICTDESC methodsFor!

dw1
	"Answer the receiver's dw1 field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dw1: anObject
	"Set the receiver's dw1 field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

dw2
	"Answer the receiver's dw2 field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dw2: anObject
	"Set the receiver's dw2 field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

dwSize: anObject
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

handle
	"Answer the receiver's handle field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

handle: anObject
	"Set the receiver's handle field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

picType
	"Answer the receiver's picType field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

picType: anObject
	"Set the receiver's picType field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject! !
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

icon
	"Answers an Icon that can be used to represent this class"

	^OLEPicture icon! !
!PICTDESC class categoriesFor: #defineFields!initializing!public! !
!PICTDESC class categoriesFor: #icon!constants!public! !

