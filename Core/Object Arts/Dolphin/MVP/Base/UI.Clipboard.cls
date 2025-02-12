﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Clipboard'
	instanceVariableNames: 'isOpen registeredFormats idToName'
	classVariableNames: 'Current'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Clipboard guid: (Core.GUID fromString: '{87b4c463-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Clipboard comment: ''!

!UI.Clipboard categoriesForClass!System-Support! !

!UI.Clipboard methodsFor!

addRegisteredFormat: formatName id: id converter: aTypeConverter
	registeredFormats at: formatName put: {id. aTypeConverter}.
	idToName at: id put: formatName.
	^id!

apply: operation
        "Private - Evaluate the <niladicBlock> argument, operation, against
	the receiver. If the Clipboard is not currently open, then it is opened
	for the duration of the operation."

	| wasOpen |
	wasOpen := self open.
	^operation ensure: [wasOpen ifFalse: [self close]]
!

availableFormatIds
	"Answer a <sequencedReadableCollection> containing each of the currently available clipboard format <integer> identifiers.
	The actual formats on the clipboard appear first in the collection, with converted formats following."

	| answer |
	answer := Array writeStream: User32 countClipboardFormats.
	self apply: 
			[| fmt |
			fmt := 0.
			[(fmt := User32 enumClipboardFormats: fmt) == 0] whileFalse: [answer nextPut: fmt]].
	^answer grabContents!

availableFormats
	"Answer a <collection> of the currently available clipboard format <readableString> names. This may not include all formats, as the built-in formats are unnamed, and we don't keep an entry for them all in our map."

	| availableIds names |
	availableIds := self availableFormatIds.
	names := Array writeStream: availableIds size.
	availableIds do: 
			[:fmt |
			| name |
			name := idToName at: fmt ifAbsent: [self getFormatName: fmt].
			name isNil ifFalse: [names nextPut: name]].
	^names grabContents!

basicEmpty
	"Private - Empty the clipboard (assumes it is open)."

	User32 emptyClipboard ifFalse: [Win32Error signal]!

basicFree
	"Private - Close the clipboard.
	We don't treat attempting to close the clipboard when it is not
	open as an exception."

	^User32 closeClipboard!

basicRealize
	"Open the clipboard."

	isOpen := User32 openClipboard: nil.
	isOpen ifFalse: [Win32Error signal]!

close
        "Close the clipboard."

	self free!

empty
        "Empty the clipboard."

	self apply: [self basicEmpty]!

errorFormatNotAvailable: format
	"Raise an error to the effect that the clipboard does not contain any data
	of the format identified by the specified symbolic format."

	^self error: 'Clipboard format #', format, ' not available'!

free
	"Release any external resources owned by the receiver."

	isOpen ifFalse: [^self].
	isOpen := false.
	self basicFree!

getBitmap
	"Answer a Bitmap copied from the clipboard, or raise an 
	exception if no Bitmap is available."

	^self getBitmapIfNone: [self errorFormatNotAvailable: #Bitmap]!

getBitmapIfNone: exceptionHandler
	"Answer a Bitmap copied from the clipboard, or if none the result
	of evaluating the <niladicValuable> exceptionHandler."

	^self getRegisteredFormat: #Bitmap ifNone: exceptionHandler!

getDIBSection
	"Answer a Bitmap copied from the clipboard, or raise an 
	exception if no Bitmap is available."

	^self getDIBSectionIfNone: [self errorFormatNotAvailable: #DIBSection]!

getDIBSectionIfNone: exceptionHandler
	"Answer a <DIBSection> copied from the clipboard, or if none the result
	of evaluating the <niladicValuable> exceptionHandler."

	^self getRegisteredFormat: #DIBSection ifNone: exceptionHandler!

getFormatName: format
	"Answer the <readableString> name of the registered clipboard format 
	identified by the <integer> format, or nil the format is not registered. "

	| name len |
	name := Utf16String newFixed: 256.
	len := User32
				getClipboardFormatName: format
				lpszFormatName: name
				cchMaxCount: name size.
	^len == 0 ifFalse: [(name resize: len) asUtf8String]!

getRegisteredFormat: name ifNone: exceptionHandler
	"Answer an <Object> representing the contents of the clipboard of the named pre-registered format translated to an appropriate Smalltalk object using the right-to-left conversion of the type converter registered for that format. If the format is not currently available or the data cannot be read, then answers the result of evaluating the <niladicValuable> exceptionHandler."

	| formatId |
	formatId := registeredFormats at: name.
	^self apply: 
			[| handle |
			handle := User32 getClipboardData: formatId first.
			handle isNull ifTrue: [^exceptionHandler value].
			[formatId second rightToLeft: handle] on: Error do: [:ex | exceptionHandler value]]!

getText
	"Answer a <readableString> containing the CF_UNICODETEXT contents 
	of the clipboard. If no text is currently available, raise an exception."

	^self getTextIfNone: [self errorFormatNotAvailable: #String]!

getTextIfNone: exceptionHandler
	"Answer a <readableString> containing the CF_UNICODETEXT contents of the clipboard. If no text is currently available, then answers the result of evaluating the <niladicValuable> exceptionHandler."

	^self getRegisteredFormat: #String ifNone: exceptionHandler!

getTextOrEmpty
	^self getTextIfNone: ['']!

initialize
	"Private - Initialize the receiver's instance variables.
	Answer the receiver.
		Clipboard current initialize
	"

	| nullConversion |
	isOpen := false.
	registeredFormats := IdentityDictionary new.
	idToName := IdentityDictionary new.
	nullConversion := NullConverter new.
	self
		addRegisteredFormat: #String
			id: CF_UNICODETEXT
			converter: (PluggableTypeConverter
					leftToRight: [:obj | External.Memory copyBytesToGlobalHeap: obj asUtf16String]
					rightToLeft: [:handle | Utf16String fromGlobalHandle: handle]);
		addRegisteredFormat: #Bitmap
			id: CF_BITMAP
			converter: (PluggableTypeConverter leftToRight: [:bmp | bmp copy detachHandle]
					rightToLeft: 
						[:hBitmap |
						"Note that because the clipboard retains ownership of the bitmap, we must immediately copy it."
						(Bitmap fromHandle: hBitmap) copy]);
		addRegisteredFormat: #Palette
			id: CF_PALETTE
			converter: nullConversion;
		addRegisteredFormat: #DIBSection
			id: CF_DIB
			converter: (PluggableTypeConverter leftToRight: [:ds | ds copyToGlobalHeap]
					rightToLeft: [:handle | DIBSection fromGlobalHandle: handle])!

isBitmapAvailable
	"Answer whether the clipboard contains a bitmap."

	^self isFormatIdAvailable: CF_BITMAP!

isDIBAvailable
	"Answer whether the clipboard contains a DIBSection."

	^self isFormatIdAvailable: CF_DIB!

isFormatAvailable: aString
	"Answer whether the clipboard contains data in the named format (e.g. #String)."

	| formatInfo |
	^(formatInfo := registeredFormats lookup: aString) notNil
		and: [self isFormatIdAvailable: formatInfo first]!

isFormatIdAvailable: dwFormat
	"Private - Answer whether the clipboard contains the specified
	registered <integer> clipboard format."

	^User32 isClipboardFormatAvailable: dwFormat!

isFormatRegistered: aString
	^registeredFormats includesKey: aString!

isObjectAvailable
	"Answer whether the clipboard contains an object."

	^self isFormatAvailable: #Object!

isTextAvailable
	"Answer whether the clipboard contains text data (i.e. CF_UNICODETEXT). Note that because of the Clipboards auto-format conversion, this will always be true if CF_TEXT is available too, and vice versa."

	^self isFormatIdAvailable: CF_UNICODETEXT!

open
        "Open the clipboard."

	| wasOpen |
	(wasOpen := isOpen) ifFalse: [self basicRealize].
	^wasOpen!

registerFormat: formatName
	"Register the <readableString> formatName as a user-defined 
	clipboard format. Answer the format identifier."

	^self registerFormat: formatName converter: NullConverter new!

registerFormat: formatName converter: aTypeConverter
	"Register the <readableString> formatName as a user-defined clipboard format. Answer the format identifier. 
	The type converter needs to convert objects to suitable handles as its left-to-right conversion, and from global memory handles to objects for its right-to-left."

	| id |
	id := User32 registerClipboardFormat: formatName.
	id == 0 ifTrue: [^Win32Error signal].
	^self
		addRegisteredFormat: formatName
		id: id
		converter: aTypeConverter!

setBitmap: aBitmap
        "Transfer the specified bitmap to the clipboard."
	
	self setBitmap: aBitmap format: aBitmap class name
!

setBitmap: bmp format: formatName
	"Copy the specified bitmap to the clipboard as an entry
	of the specified format name."

	| hBitmap |
	hBitmap := self setRegisteredFormat: formatName data: bmp.
	hBitmap isNull ifTrue: [Win32Error signal]!

setData: handle formatId: formatId
	"Private - Copy the data with the specified handle to the clipboard with the specified
	<integer> format. If the clipboard is not currently open, then it is opened and emptied, and
	then closed after setting the data. If the clipboard is already open, then the data is
	simply copied to the clipboard without emptying or closing it. This is to allow the copying
	of multiple-formats for the same object, and also to prevent lots of opening and closing."

	| wasOpen |
	wasOpen := self open.
	^
	[wasOpen ifFalse: [self basicEmpty].
	User32 setClipboardData: formatId hMem: handle]
			ensure: [wasOpen ifFalse: [self close]]!

setObject: anObject
	"Transfers anObject to the clipboard."

	self apply: 
			[self setRegisteredFormat: #Object data: anObject.
			self setRegisteredFormat: #ObjectClass data: anObject class]!

setRegisteredFormat: aString data: anObject
	"Copy the specified object to the clipboard after translation to the named clipboard format
	using the left-to-right conversion of the type converter registered for the format.."

	| format |
	format := registeredFormats at: aString.
	^self setData: (format last leftToRight: anObject) formatId: format first!

setText: text
	"Copy the <String> text to the clipboard as an entry in CF_UNICODETEXT format. Note that
	although Dolphin's Strings can contain embedded null characters, if such a string is copied
	to the clipboard the text is considered to terminate at the first null character."

	self setRegisteredFormat: #String data: text! !

!UI.Clipboard categoriesForMethods!
addRegisteredFormat:id:converter:!operations!public! !
apply:!operations!private! !
availableFormatIds!enquiries!public! !
availableFormats!enquiries!public! !
basicEmpty!operations!private! !
basicFree!private!realizing/unrealizing! !
basicRealize!public!realizing/unrealizing! !
close!public!realizing/unrealizing! !
empty!operations!public! !
errorFormatNotAvailable:!exceptions!public! !
free!public!realizing/unrealizing! !
getBitmap!accessing!public! !
getBitmapIfNone:!accessing!public! !
getDIBSection!accessing!public! !
getDIBSectionIfNone:!accessing!public! !
getFormatName:!accessing!public! !
getRegisteredFormat:ifNone:!accessing!public! !
getText!accessing!public! !
getTextIfNone:!accessing!public! !
getTextOrEmpty!accessing!public! !
initialize!initializing!private! !
isBitmapAvailable!public!testing! !
isDIBAvailable!public!testing! !
isFormatAvailable:!public!testing! !
isFormatIdAvailable:!private!testing! !
isFormatRegistered:!public!testing! !
isObjectAvailable!public!testing! !
isTextAvailable!public!testing! !
open!public!realizing/unrealizing! !
registerFormat:!operations!public! !
registerFormat:converter:!operations!public! !
setBitmap:!accessing!public! !
setBitmap:format:!accessing!public! !
setData:formatId:!accessing!private! !
setObject:!accessing!public! !
setRegisteredFormat:data:!accessing!public! !
setText:!accessing!public! !
!

!UI.Clipboard class methodsFor!

current
	"Answer the singleton instance of the receiver."

	Current isNil ifTrue: [Current := super new initialize].
	^Current!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"The receiver is a singleton, use #current."

	^self shouldNotImplement!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	Current := nil!

onStartup
	"Private - The system is starting, perform any necessary
	initialization."

	Current := nil! !

!UI.Clipboard class categoriesForMethods!
current!instance creation!public! !
icon!constants!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
onStartup!event handling!private! !
!

