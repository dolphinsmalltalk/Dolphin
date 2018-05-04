"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BITMAPFILEHEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BITMAPFILEHEADER guid: (GUID fromString: '{48f23680-5426-11d3-998b-bca753d3b065}')!
BITMAPFILEHEADER comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!BITMAPFILEHEADER categoriesForClass!External-Data-Structured-Win32!IDB Goodies! !
!BITMAPFILEHEADER class methodsFor!

defineFields
	"Define the Win32 BITMAPFILEHEADER structure

		typedef struct tagBITMAPFILEHEADER {  // bmfh 
			   WORD   bfType; 
			   DWORD   bfSize; 
			   WORD   bfReserved1; 
			   WORD   bfReserved2; 
			   DWORD   bfOffBits; 
		} BITMAPFILEHEADER;"

	self
		defineField: #bfType type: WORDField new;
		defineField: #bfSize type: DWORDField new;
		defineField: #bfReserved1 type: WORDField new;
		defineField: #bfReserved2 type: WORDField new;
		defineField: #bfOffBits type: DWORDField new!

packing
	"Answer the default packing for instances of the receiver. 
	BITMAPFILEHEADER is unusual for a Windows structure in being packed to 
	1-byte boundaries - probably a 16-bit inheritance."

	^1! !
!BITMAPFILEHEADER class categoriesFor: #defineFields!initializing!public! !
!BITMAPFILEHEADER class categoriesFor: #packing!constants!public! !

