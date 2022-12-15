"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure subclass: #'Graphics.Gdiplus.GdiplusStartupOutput'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_GdiplusStartupOutput_Size' -> 16r8.
		'_OffsetOf_NotificationHook' -> 16r0.
		'_OffsetOf_NotificationUnhook' -> 16r4
	}!
Graphics.Gdiplus.GdiplusStartupOutput guid: (Core.GUID fromString: '{40bb7e65-cd3b-49aa-b850-f404c6d944fc}')!
Graphics.Gdiplus.GdiplusStartupOutput comment: '<GdiplusStartupOutput> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GdiplusStartupOutput'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains the following helpstring for this struct
	"The 2 fields are NULL if SuppressBackgroundThread is FALSE. Otherwise, they are functions which must be called on the apps main message loop to replace the background thread. "

IDL definition follows:

typedef [uuid(40BB7E65-CD3B-49AA-B850-F404C6D944FC), helpstring("The 2 fields are NULL if SuppressBackgroundThread is FALSE. Otherwise, they are functions which must be called on the apps main message loop to replace the background thread. ")]
struct tagGdiplusStartupOutput {
	[helpstring("''NotificationHook'' should be called before starting the message loop")] void* NotificationHook;
	[helpstring("''NotificationUnhook'' should be called after the message loop ends.")] void* NotificationUnhook;
} GdiplusStartupOutput;
'!
!Graphics.Gdiplus.GdiplusStartupOutput methodsFor!

NotificationHook
	"Answer the <ExternalAddress> value of the receiver's 'NotificationHook' field."

	^(bytes uintPtrAtOffset: _OffsetOf_NotificationHook) asExternalAddress!

NotificationHook: anExternalAddress
	"Set the receiver's 'NotificationHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_NotificationHook put: anExternalAddress!

NotificationUnhook
	"Answer the <ExternalAddress> value of the receiver's 'NotificationUnhook' field."

	^(bytes uintPtrAtOffset: _OffsetOf_NotificationUnhook) asExternalAddress!

NotificationUnhook: anExternalAddress
	"Set the receiver's 'NotificationUnhook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_NotificationUnhook put: anExternalAddress! !
!Graphics.Gdiplus.GdiplusStartupOutput categoriesForMethods!
NotificationHook!**compiled accessors**!public! !
NotificationHook:!**compiled accessors**!public! !
NotificationUnhook!**compiled accessors**!public! !
NotificationUnhook:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.GdiplusStartupOutput class methodsFor!

byteSize
	^_GdiplusStartupOutput_Size!

defineFields
	"Define the fields of the GdiplusStartupOutput structure.
		GdiplusStartupOutput compileDefinition
	
		typedef [uuid(40BB7E65-CD3B-49AA-B850-F404C6D944FC), helpstring('The 2 fields are NULL if SuppressBackgroundThread is FALSE. Otherwise, they are functions which must be called on the apps main message loop to replace the background thread. ')]
		struct tagGdiplusStartupOutput {
			[helpstring(''NotificationHook' should be called before starting the message loop')] void* NotificationHook;
			[helpstring(''NotificationUnhook' should be called after the message loop ends.')] void* NotificationUnhook;
		} GdiplusStartupOutput;
"

	self
		defineField: #NotificationHook
			type: LPVOIDField new
			offset: 0;
		defineField: #NotificationUnhook
			type: LPVOIDField new
			offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#NotificationHook #NotificationUnhook)! !
!Graphics.Gdiplus.GdiplusStartupOutput class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

