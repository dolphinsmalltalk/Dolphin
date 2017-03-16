"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMREXTTEXTOUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMREXTTEXTOUT guid: (GUID fromString: '{2fee36e2-d281-4200-9f3f-7aa01d54e452}')!
EMREXTTEXTOUT comment: ''!
!EMREXTTEXTOUT categoriesForClass!Win32-Structs! !
!EMREXTTEXTOUT methodsFor!

EMRTEXT
	"Answer the receiver's EMRTEXT field as a Smalltalk object."

	^EMRTEXT fromAddress: bytes yourAddress + ##(self offsetOf: #EMRTEXT)!

EMRTEXT: anObject 
	"Set the receiver's EMRTEXT field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #EMRTEXT) + 1)
		to: ##((self offsetOf: #EMRTEXT) + EMRTEXT basicByteSize)
		startingAt: 1!

exScale
	"Answer the receiver's exScale field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #exScale)!

exScale: anObject 
	"Set the receiver's exScale field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #exScale) put: anObject!

eyScale
	"Answer the receiver's eyScale field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eyScale)!

eyScale: anObject 
	"Set the receiver's eyScale field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eyScale) put: anObject!

iGraphicsMode
	"Answer the receiver's iGraphicsMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iGraphicsMode)!

iGraphicsMode: anObject 
	"Set the receiver's iGraphicsMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iGraphicsMode) put: anObject!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: anObject 
	"Set the receiver's rclBounds field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1! !
!EMREXTTEXTOUT categoriesFor: #EMRTEXT!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #EMRTEXT:!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #exScale!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #exScale:!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #eyScale!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #eyScale:!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #iGraphicsMode!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #iGraphicsMode:!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMREXTTEXTOUT categoriesFor: #rclBounds:!**compiled accessors**!public! !

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
!EMREXTTEXTOUT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMREXTTEXTOUT class categoriesFor: #iTypes!constants!public! !

