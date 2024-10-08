﻿"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Graphics.Gdiplus.GdiplusError'
	instanceVariableNames: 'win32Error'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ErrorDescriptions'
				-> #('Ok' 'Generic Error' 'Invalid parameter' 'Gdiplus error' 'Object busy' 'Insufficient buffer' 'Not implemented' 'Win32 error' 'Wrong state' 'Aborted' 'File not found' 'Value overflow' 'Access denied' 'Unknown image format' 'Font family not found' 'Font style not found' 'Not a TrueType font' 'Unsupported GDI+ Version' 'GDI+ not initialized' 'Property not found' 'Property not supported')
		}!

Graphics.Gdiplus.GdiplusError guid: (Core.GUID fromString: '{2fdb3661-122f-4b12-b60d-ce33dbab46f6}')!

Graphics.Gdiplus.GdiplusError comment: ''!

!Graphics.Gdiplus.GdiplusError methodsFor!

_descriptionArguments
	"Answer a <sequencedReadableCollection> of the arguments to be substituted
	into the receiver's Win32 description format string when constructing the receiver's
	#description."

	^{self messageText displayString.
		ErrorDescriptions at: self tag + 1 ifAbsent: 'Unknown error'.
		self win32ErrorDescription}!

_descriptionFormat
	"Answer a <readableString> whose contents are a Win32 format string to be used 
	to construct the #description for the receiver.
	By default the format will display only the message text supplied by the signaller,
	but this can (and should) be overridden by subclasses to display something more specific.

	N.B. This is part of the implementation of the ANSI standard message 
	#description and therefore it requires an underscore prefix in order
	to avoid the fragile base class problem where subclasses may 
	inadvertantly override a superclass method."

	^'%1: %2. %3'!

initialize
	super initialize.
	"Gdiplus defines an enum, Status, that creates an ambiguous definition of Win32Error, so we fully qualify it"
	win32Error := OS.Win32Error new!

win32ErrorDescription
	"Private - Answer the win32Error description or the empty string to avoid 
	error messages of the form: 'The error is: the operation was successful;"

	^win32Error statusCode = 0 ifTrue: [''] ifFalse: [win32Error description]! !

!Graphics.Gdiplus.GdiplusError categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
initialize!initializing!public! !
win32ErrorDescription!accessing!private! !
!

!Graphics.Gdiplus.GdiplusError class methodsFor!

initialize
	"
	self initialize
	"

	"Note: The string for the 4th element has been changed from 'Out of memory' to 'Gdiplus error'
	From: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/gdicpp/GDIPlus/GDIPlusReference/Enumerations/Status.asp
		GetLastStatus might return OutOfMemory even though there was plenty
		of memory available to create the object. Several GDI+ constructors set 
		the status to OutOfMemory when they fail regardless of the reason for 
		failure."

	self addClassConstant: 'ErrorDescriptions' value: #('Ok' 'Generic Error' 'Invalid parameter' 'Gdiplus error' 'Object busy' 'Insufficient buffer' 'Not implemented' 'Win32 error' 'Wrong state' 'Aborted' 'File not found' 'Value overflow' 'Access denied' 'Unknown image format' 'Font family not found' 'Font style not found' 'Not a TrueType font' 'Unsupported GDI+ Version' 'GDI+ not initialized' 'Property not found' 'Property not supported')! !

!Graphics.Gdiplus.GdiplusError class categoriesForMethods!
initialize!development!initializing!public! !
!

