"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #ENHMETAHEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ENHMETAHEADER guid: (GUID fromString: '{11d9bf3d-7ee0-4ace-8c78-d192e7518fdf}')!
ENHMETAHEADER comment: '<ENHMETAHEADER> is an <ExternalStructure> class to wrap the struct ''Win32.ENHMETAHEADER''.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

		typedef [uuid(11D9BF3D-7EE0-4ACE-8C78-D192E7518FDF)]
		struct tagENHMETAHEADER {
			[helpstring(''Record type EMR_HEADER'')] DWORD iType;
			[helpstring(''Record size in bytes.  This may be greater than the sizeof(ENHMETAHEADER).'')] DWORD nSize;
			[helpstring(''Inclusive-inclusive bounds in device units'')] RECTL rclBounds;
			[helpstring(''Inclusive-inclusive Picture Frame of metafile in .01 mm units'')] RECTL rclFrame;
			[helpstring(''Signature.  Must be ENHMETA_SIGNATURE.'')] DWORD dSignature;
			[helpstring(''Version number'')] DWORD nVersion;
			[helpstring(''Size of the metafile in bytes'')] DWORD nBytes;
			[helpstring(''Number of records in the metafile'')] DWORD nRecords;
			[helpstring(''Number of handles in the handle table. Handle index zero is reserved.'')] WORD nHandles;
			[helpstring(''Reserved.  Must be zero.'')] WORD sReserved;
			[helpstring(''Number of chars in the unicode description string, this is 0 if there is no description string'')] DWORD nDescription;
			[helpstring(''Offset to the metafile description record. This is 0 if there is no description string'')] DWORD offDescription;
			[helpstring(''Number of entries in the metafile palette.'')] DWORD nPalEntries;
			[helpstring(''Size of the reference device in pels'')] SIZEL szlDevice;
			[helpstring(''Size of the reference device in millimeters'')] SIZEL szlMillimeters;
			[helpstring(''Size of PIXELFORMATDESCRIPTOR information, or 0 if no pixel format is set'')] DWORD cbPixelFormat;
			[helpstring(''Offset to PIXELFORMATDESCRIPTOR, or 0 if no pixel format is set'')] DWORD offPixelFormat;
			[helpstring(''TRUE if OpenGL commands are present in the metafile, otherwise FALSE'')] DWORD bOpenGL;
			[helpstring(''Size of the reference device in micrometers'')] SIZEL szlMicrometers;
		} ENHMETAHEADER;
'!
!ENHMETAHEADER categoriesForClass!Win32-Structs! !
!ENHMETAHEADER methodsFor!

bOpenGL
	"Answer the <Integer> value of the receiver's 'bOpenGL' field."

	^bytes dwordAtOffset: ##(self offsetOf: #bOpenGL)!

bOpenGL: anInteger
	"Set the receiver's 'bOpenGL' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #bOpenGL) put: anInteger!

cbPixelFormat
	"Answer the <Integer> value of the receiver's 'cbPixelFormat' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbPixelFormat)!

cbPixelFormat: anInteger
	"Set the receiver's 'cbPixelFormat' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbPixelFormat) put: anInteger!

dSignature
	"Answer the <Integer> value of the receiver's 'dSignature' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dSignature)!

dSignature: anInteger
	"Set the receiver's 'dSignature' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dSignature) put: anInteger!

nBytes
	"Answer the <Integer> value of the receiver's 'nBytes' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nBytes)!

nBytes: anInteger
	"Set the receiver's 'nBytes' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nBytes) put: anInteger!

nDescription
	"Answer the <Integer> value of the receiver's 'nDescription' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nDescription)!

nDescription: anInteger
	"Set the receiver's 'nDescription' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nDescription) put: anInteger!

nHandles
	"Answer the <Integer> value of the receiver's 'nHandles' field."

	^bytes wordAtOffset: ##(self offsetOf: #nHandles)!

nHandles: anInteger
	"Set the receiver's 'nHandles' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #nHandles) put: anInteger!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nPalEntries)!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nPalEntries) put: anInteger!

nRecords
	"Answer the <Integer> value of the receiver's 'nRecords' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nRecords)!

nRecords: anInteger
	"Set the receiver's 'nRecords' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nRecords) put: anInteger!

nVersion
	"Answer the <Integer> value of the receiver's 'nVersion' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nVersion)!

nVersion: anInteger
	"Set the receiver's 'nVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nVersion) put: anInteger!

offDescription
	"Answer the <Integer> value of the receiver's 'offDescription' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offDescription)!

offDescription: anInteger
	"Set the receiver's 'offDescription' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offDescription) put: anInteger!

offPixelFormat
	"Answer the <Integer> value of the receiver's 'offPixelFormat' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offPixelFormat)!

offPixelFormat: anInteger
	"Set the receiver's 'offPixelFormat' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offPixelFormat) put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1!

rclFrame
	"Answer the <RECT> value of the receiver's 'rclFrame' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclFrame)!

rclFrame: aRECT
	"Set the receiver's 'rclFrame' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclFrame) + 1)
		to: ##((self offsetOf: #rclFrame) + RECT basicByteSize)
		startingAt: 1!

szlDevice
	"Answer the <SIZE> value of the receiver's 'szlDevice' field."

	^SIZE fromAddress: bytes yourAddress + ##(self offsetOf: #szlDevice)!

szlDevice: aSIZE
	"Set the receiver's 'szlDevice' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szlDevice) + 1)
		to: ##((self offsetOf: #szlDevice) + SIZE basicByteSize)
		startingAt: 1!

szlMicrometers
	"Answer the <SIZE> value of the receiver's 'szlMicrometers' field."

	^SIZE fromAddress: bytes yourAddress + ##(self offsetOf: #szlMicrometers)!

szlMicrometers: aSIZE
	"Set the receiver's 'szlMicrometers' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szlMicrometers) + 1)
		to: ##((self offsetOf: #szlMicrometers) + SIZE basicByteSize)
		startingAt: 1!

szlMillimeters
	"Answer the <SIZE> value of the receiver's 'szlMillimeters' field."

	^SIZE fromAddress: bytes yourAddress + ##(self offsetOf: #szlMillimeters)!

szlMillimeters: aSIZE
	"Set the receiver's 'szlMillimeters' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szlMillimeters) + 1)
		to: ##((self offsetOf: #szlMillimeters) + SIZE basicByteSize)
		startingAt: 1! !
!ENHMETAHEADER categoriesFor: #bOpenGL!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #bOpenGL:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #cbPixelFormat!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #cbPixelFormat:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #dSignature!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #dSignature:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nBytes!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nBytes:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nDescription!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nDescription:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nHandles!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nHandles:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nPalEntries!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nPalEntries:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nRecords!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nRecords:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nVersion!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #nVersion:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #offDescription!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #offDescription:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #offPixelFormat!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #offPixelFormat:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #rclBounds!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #rclBounds:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #rclFrame!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #rclFrame:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #szlDevice!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #szlDevice:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #szlMicrometers!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #szlMicrometers:!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #szlMillimeters!**compiled accessors**!public! !
!ENHMETAHEADER categoriesFor: #szlMillimeters:!**compiled accessors**!public! !

!ENHMETAHEADER class methodsFor!

defineFields
	"Define the fields of the ENHMETAHEADER structure.

	ENHMETAHEADER  compileDefinition

		typedef [uuid(11D9BF3D-7EE0-4ACE-8C78-D192E7518FDF)]
		struct tagENHMETAHEADER {
			[helpstring('Record type EMR_HEADER')] DWORD iType;
			[helpstring('Record size in bytes.  This may be greater than the sizeof(ENHMETAHEADER).')] DWORD nSize;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Inclusive-inclusive Picture Frame of metafile in .01 mm units')] RECTL rclFrame;
			[helpstring('Signature.  Must be ENHMETA_SIGNATURE.')] DWORD dSignature;
			[helpstring('Version number')] DWORD nVersion;
			[helpstring('Size of the metafile in bytes')] DWORD nBytes;
			[helpstring('Number of records in the metafile')] DWORD nRecords;
			[helpstring('Number of handles in the handle table. Handle index zero is reserved.')] WORD nHandles;
			[helpstring('Reserved.  Must be zero.')] WORD sReserved;
			[helpstring('Number of chars in the unicode description string, this is 0 if there is no description string')] DWORD nDescription;
			[helpstring('Offset to the metafile description record. This is 0 if there is no description string')] DWORD offDescription;
			[helpstring('Number of entries in the metafile palette.')] DWORD nPalEntries;
			[helpstring('Size of the reference device in pels')] SIZEL szlDevice;
			[helpstring('Size of the reference device in millimeters')] SIZEL szlMillimeters;
			[helpstring('Size of PIXELFORMATDESCRIPTOR information, or 0 if no pixel format is set')] DWORD cbPixelFormat;
			[helpstring('Offset to PIXELFORMATDESCRIPTOR, or 0 if no pixel format is set')] DWORD offPixelFormat;
			[helpstring('TRUE if OpenGL commands are present in the metafile, otherwise FALSE')] DWORD bOpenGL;
			[helpstring('Size of the reference device in micrometers')] SIZEL szlMicrometers;
		} ENHMETAHEADER;
"

	super defineFields.
	self
		defineField: #rclBounds type: (StructureField type: RECT) offset: 8;
		defineField: #rclFrame type: (StructureField type: RECT) offset: 24;
		defineField: #dSignature type: DWORDField new offset: 40;
		defineField: #nVersion type: DWORDField new offset: 44;
		defineField: #nBytes type: DWORDField new offset: 48;
		defineField: #nRecords type: DWORDField new offset: 52;
		defineField: #nHandles type: WORDField new offset: 56;
		defineField: #sReserved type: WORDField filler offset: 58;
		defineField: #nDescription type: DWORDField new offset: 60;
		defineField: #offDescription type: DWORDField new offset: 64;
		defineField: #nPalEntries type: DWORDField new offset: 68;
		defineField: #szlDevice type: (StructureField type: SIZE) offset: 72;
		defineField: #szlMillimeters type: (StructureField type: SIZE) offset: 80;
		defineField: #cbPixelFormat type: DWORDField new offset: 88;
		defineField: #offPixelFormat type: DWORDField new offset: 92;
		defineField: #bOpenGL type: DWORDField new offset: 96;
		defineField: #szlMicrometers type: (StructureField type: SIZE) offset: 100.
	self byteSize: 108!

getFieldNames
	^#(#iType #nSize #rclBounds #rclFrame #dSignature #nVersion #nBytes #nRecords #nHandles #nDescription #offDescription #nPalEntries #szlDevice #szlMillimeters #cbPixelFormat #offPixelFormat #bOpenGL #szlMicrometers)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_HEADER! !
!ENHMETAHEADER class categoriesFor: #defineFields!initializing!public! !
!ENHMETAHEADER class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!ENHMETAHEADER class categoriesFor: #iTypes!constants!public! !

