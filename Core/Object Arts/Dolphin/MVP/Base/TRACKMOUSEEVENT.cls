"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TRACKMOUSEEVENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TRACKMOUSEEVENT guid: (GUID fromString: '{f8a7c94e-cff5-4d76-be3c-2de4f4f6a4ef}')!
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
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anInteger!

dwHoverTime
	"Answer the <Integer> value of the receiver's 'dwHoverTime' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwHoverTime)!

dwHoverTime: anInteger
	"Set the receiver's 'dwHoverTime' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwHoverTime) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

hwndTrack
	"Answer the <ExternalHandle> value of the receiver's 'hwndTrack' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hwndTrack)) asExternalHandle!

hwndTrack: anExternalHandle
	"Set the receiver's 'hwndTrack' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndTrack) put: anExternalHandle! !
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
		defineField: #dwHoverTime type: DWORDField new!

getFieldNames
	^#(#dwSize #dwFlags #hwndTrack #dwHoverTime)! !
!TRACKMOUSEEVENT class categoriesFor: #defineFields!initializing!public! !
!TRACKMOUSEEVENT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

