"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MOUSEINPUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MOUSEINPUT guid: (GUID fromString: '{29DC41B0-4E25-4B44-8090-99BB142811D1}')!
MOUSEINPUT comment: '<MOUSEINPUT> is an <ExternalStructure> class to wrap the struct ''Win32.MOUSEINPUT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Contains information about a simulated mouse event."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(29DC41B0-4E25-4B44-8090-99BB142811D1), helpstring("Contains information about a simulated mouse event.")]
struct tagMOUSEINPUT {
	[helpstring("The absolute x-position of the mouse, or the amount of motion since the last event")] long dx;
	[helpstring("The absolute y-position of the mouse, or the amount of motion since the last event")] long dy;
	[helpstring("Extra data depending on the event type, e.g. mouse wheel movement")] DWORD mouseData;
	[helpstring("A set of bit flags from the MOUSEEVENTF enumeration that specify various aspects of mouse motion and button clicks.")] DWORD dwFlags;
	[helpstring("Time stamp for the event, in milliseconds, or 0 if the system is to generate it")] DWORD time;
	[helpstring("Extra data associated with the mouse event that the application can call GetMessageExtraInfo to retrieve")] ULONG dwExtraInfo;
} MOUSEINPUT;
'!
!MOUSEINPUT categoriesForClass!Win32-Structs! !
!MOUSEINPUT methodsFor!

dwExtraInfo
	"Answer the receiver's dwExtraInfo field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

dwExtraInfo: anObject
	"Set the receiver's dwExtraInfo field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwFlags: anObject
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

dx
	"Answer the receiver's dx field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

dx: anObject
	"Set the receiver's dx field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

dy
	"Answer the receiver's dy field as a Smalltalk object."

	^(bytes sdwordAtOffset: 4)!

dy: anObject
	"Set the receiver's dy field to the value of anObject."

	bytes sdwordAtOffset: 4 put: anObject!

mouseData
	"Answer the receiver's mouseData field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

mouseData: anObject
	"Set the receiver's mouseData field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

time
	"Answer the receiver's time field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

time: anObject
	"Set the receiver's time field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject! !
!MOUSEINPUT categoriesFor: #dwExtraInfo!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dwExtraInfo:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dwFlags!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dwFlags:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dx!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dx:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dy!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dy:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #mouseData!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #mouseData:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #time!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #time:!**compiled accessors**!public! !

!MOUSEINPUT class methodsFor!

defineFields
	"Define the fields of the MOUSEINPUT structure.

	MOUSEINPUT  compileDefinition

		typedef [uuid(29DC41B0-4E25-4B44-8090-99BB142811D1), helpstring('Contains information about a simulated mouse event.')]
		struct tagMOUSEINPUT {
			[helpstring('The absolute x-position of the mouse, or the amount of motion since the last event')] long dx;
			[helpstring('The absolute y-position of the mouse, or the amount of motion since the last event')] long dy;
			[helpstring('Extra data depending on the event type, e.g. mouse wheel movement')] DWORD mouseData;
			[helpstring('A set of bit flags from the MOUSEEVENTF enumeration that specify various aspects of mouse motion and button clicks.')] DWORD dwFlags;
			[helpstring('Time stamp for the event, in milliseconds, or 0 if the system is to generate it')] DWORD time;
			[helpstring('Extra data associated with the mouse event that the application can call GetMessageExtraInfo to retrieve')] ULONG dwExtraInfo;
		} MOUSEINPUT;
"

	self
		defineField: #dx type: SDWORDField new offset: 0;
		defineField: #dy type: SDWORDField new offset: 4;
		defineField: #mouseData type: DWORDField new offset: 8;
		defineField: #dwFlags type: DWORDField new offset: 12;
		defineField: #time type: DWORDField new offset: 16;
		defineField: #dwExtraInfo type: DWORDField new offset: 20.
	self byteSize: 24! !
!MOUSEINPUT class categoriesFor: #defineFields!**auto generated**!initializing!public! !

