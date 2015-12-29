"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #TRACKMOUSEEVENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TRACKMOUSEEVENT guid: (GUID fromString: '{F8A7C94E-CFF5-4D76-BE3C-2DE4F4F6A4EF}')!
TRACKMOUSEEVENT comment: '<TRACKMOUSEEVENT> is an <ExternalStructure> class to wrap the struct ''Win32.TRACKMOUSEEVENT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Used in conjunction with the TrackMouseEvent function to track when the mouse pointer leaves a window or hovers over a window for a specified amount of time."

IDL definition follows:

typedef [uuid(F8A7C94E-CFF5-4D76-BE3C-2DE4F4F6A4EF), helpstring("Used in conjunction with the TrackMouseEvent function to track when the mouse pointer leaves a window or hovers over a window for a specified amount of time.")]
struct tagTRACKMOUSEEVENT {
	[helpstring("Specifies the size of the TRACKMOUSEEVENT structure.")] DWORD cbSize;
	[helpstring("Specifies the services requested.")] DWORD dwFlags;
	[helpstring("Specifies a handle to the window to track.")] HWND hwndTrack;
	[helpstring("Specifies the hover time-out (if TME_HOVER was specified in dwFlags), in milliseconds.")] DWORD dwHoverTime;
} TRACKMOUSEEVENT;
'!
!TRACKMOUSEEVENT categoriesForClass!Win32-Structs! !
!TRACKMOUSEEVENT methodsFor!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject!

dwHoverTime
	"Answer the receiver's dwHoverTime field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwHoverTime)!

dwHoverTime: anObject 
	"Set the receiver's dwHoverTime field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwHoverTime) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

hwndTrack
	"Answer the receiver's hwndTrack field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hwndTrack)) asExternalHandle!

hwndTrack: anObject 
	"Set the receiver's hwndTrack field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndTrack) put: anObject! !
!TRACKMOUSEEVENT categoriesFor: #dwFlags!**compiled accessors**!public! !
!TRACKMOUSEEVENT categoriesFor: #dwFlags:!**compiled accessors**!public! !
!TRACKMOUSEEVENT categoriesFor: #dwHoverTime!**compiled accessors**!public! !
!TRACKMOUSEEVENT categoriesFor: #dwHoverTime:!**compiled accessors**!public! !
!TRACKMOUSEEVENT categoriesFor: #dwSize:!**compiled accessors**!public! !
!TRACKMOUSEEVENT categoriesFor: #hwndTrack!**compiled accessors**!public! !
!TRACKMOUSEEVENT categoriesFor: #hwndTrack:!**compiled accessors**!public! !

!TRACKMOUSEEVENT class methodsFor!

defineFields
	"Define the fields of the TRACKMOUSEEVENT structure.
		TRACKMOUSEEVENT compileDefinition
	
		typedef [uuid(F8A7C94E-CFF5-4D76-BE3C-2DE4F4F6A4EF), helpstring('Used in conjunction with the TrackMouseEvent function to track when the mouse pointer leaves a window or hovers over a window for a specified amount of time.')]
		struct tagTRACKMOUSEEVENT {
			[helpstring('Specifies the size of the TRACKMOUSEEVENT structure.')] DWORD cbSize;
			[helpstring('Specifies the services requested.')] DWORD dwFlags;
			[helpstring('Specifies a handle to the window to track.')] HWND hwndTrack;
			[helpstring('Specifies the hover time-out (if TME_HOVER was specified in dwFlags), in milliseconds.')] DWORD dwHoverTime;
		} TRACKMOUSEEVENT;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #dwFlags type: DWORDField new;
		defineField: #hwndTrack type: HANDLEField new;
		defineField: #dwHoverTime type: DWORDField new! !
!TRACKMOUSEEVENT class categoriesFor: #defineFields!initializing!public! !

