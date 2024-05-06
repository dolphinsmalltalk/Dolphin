"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMREXTTEXTOUT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_EMRTEXT _OffsetOf_exScale _OffsetOf_eyScale _OffsetOf_iGraphicsMode _OffsetOf_rclBounds'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMREXTTEXTOUT guid: (GUID fromString: '{2fee36e2-d281-4200-9f3f-7aa01d54e452}')!

EMREXTTEXTOUT isAbstract: true!

EMREXTTEXTOUT addClassConstant: '_OffsetOf_EMRTEXT' value: 16r24!
EMREXTTEXTOUT addClassConstant: '_OffsetOf_exScale' value: 16r1C!
EMREXTTEXTOUT addClassConstant: '_OffsetOf_eyScale' value: 16r20!
EMREXTTEXTOUT addClassConstant: '_OffsetOf_iGraphicsMode' value: 16r18!
EMREXTTEXTOUT addClassConstant: '_OffsetOf_rclBounds' value: 16r8!

EMREXTTEXTOUT comment: ''!

!EMREXTTEXTOUT categoriesForClass!Win32-Structs! !

!EMREXTTEXTOUT methodsFor!

EMRTEXT
	"Answer the <EMRTEXT> value of the receiver's 'EMRTEXT' field."

	^EMRTEXT fromAddress: bytes yourAddress + _OffsetOf_EMRTEXT!

EMRTEXT: anEMRTEXT
	"Set the receiver's 'EMRTEXT' field to the value of the argument, anEMRTEXT"

	anEMRTEXT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_EMRTEXT + 1)
		to: ##(_OffsetOf_EMRTEXT + EMRTEXT basicByteSize)
		startingAt: 1!

exScale
	"Answer the <Float> value of the receiver's 'exScale' field."

	^bytes floatAtOffset: _OffsetOf_exScale!

exScale: aFloat
	"Set the receiver's 'exScale' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_exScale put: aFloat!

eyScale
	"Answer the <Float> value of the receiver's 'eyScale' field."

	^bytes floatAtOffset: _OffsetOf_eyScale!

eyScale: aFloat
	"Set the receiver's 'eyScale' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eyScale put: aFloat!

iGraphicsMode
	"Answer the <Integer> value of the receiver's 'iGraphicsMode' field."

	^bytes dwordAtOffset: _OffsetOf_iGraphicsMode!

iGraphicsMode: anInteger
	"Set the receiver's 'iGraphicsMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iGraphicsMode put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
		startingAt: 1! !

!EMREXTTEXTOUT categoriesForMethods!
EMRTEXT!**compiled accessors**!public! !
EMRTEXT:!**compiled accessors**!public! !
exScale!**compiled accessors**!public! !
exScale:!**compiled accessors**!public! !
eyScale!**compiled accessors**!public! !
eyScale:!**compiled accessors**!public! !
iGraphicsMode!**compiled accessors**!public! !
iGraphicsMode:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!EMREXTTEXTOUT class methodsFor!

defineFields
	"Define the fields of the EMREXTTEXTOUT structure.

	EMREXTTEXTOUT  compileDefinition

		typedef [uuid(897DBF3A-44AD-4594-AE7E-957CB1E28374)]
		struct tagEMREXTTEXTOUT {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Current graphics mode')] DWORD iGraphicsMode;
			[helpstring('X and Y scales from Page units to .01mm units')] float exScale;
			[helpstring('if graphics mode is GM_COMPATIBLE.')] float eyScale;
			[helpstring('This is followed by the string and spacing array')] EMRTEXT EMRTEXT;
		} EMREXTTEXTOUT;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #iGraphicsMode
			type: DWORDField new
			offset: 24;
		defineField: #exScale
			type: FLOATField new
			offset: 28;
		defineField: #eyScale
			type: FLOATField new
			offset: 32;
		defineField: #EMRTEXT
			type: (StructureField type: EMRTEXT)
			offset: 36.
	self byteSize: 76!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^#()! !

!EMREXTTEXTOUT class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
iTypes!constants!public! !
!

