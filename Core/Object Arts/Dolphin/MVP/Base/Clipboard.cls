"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Clipboard
	instanceVariableNames: 'isOpen registeredFormats'
	classVariableNames: 'Current'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Clipboard guid: (GUID fromString: '{87b4c463-026e-11d3-9fd7-00a0cc3e4a32}')!
Clipboard comment: ''!
!Clipboard categoriesForClass!System-Support! !
!Clipboard methodsFor!

apply: operation
        "Private - Evaluate the <niladicBlock> argument, operation, against
	the receiver. If the Clipboard is not currently open, then it is opened
	for the duration of the operation."

	| wasOpen |
	wasOpen := self open.
	^operation ensure: [wasOpen ifFalse: [self close]]
!

availableFormatIds
	"Answer a <collection> containing each of the currently available  
	clipboard format <integer> identifiers."

	| answer lib |
	lib := UserLibrary default.
	answer := OrderedCollection new: lib countClipboardFormats.
	self apply: 
			[| fmt |
			fmt := 0.
			[(fmt := lib enumClipboardFormats: fmt) == 0] whileFalse: [answer addLast: fmt]].
	^answer!

availableFormats
	"Answer a <collection> of the currently available clipboard format 
	<readableString> names. This may not include all formats, as the built-in
	formats are unnamed, and we don't keep an entry for them all in our map."

	| answer |
	answer := OrderedCollection new.
	self availableFormatIds do: [:fmt | | name |
		name := registeredFormats keyAtValue: fmt ifAbsent: [self getFormatName: fmt].
		name isNil ifFalse: [answer addLast: name]].
	^answer!

basicEmpty
	"Private - Empty the clipboard (assumes it is open)."

	UserLibrary default emptyClipboard ifFalse: [Win32Error signal]!

basicFree
        "Private - Close the clipboard.
	We don't treat attempting to close the clipboard when it is not
	open as an exception."

	^UserLibrary default closeClipboard!

basicRealize
        "Open the clipboard."

	isOpen := UserLibrary default openClipboard: nil.
	isOpen ifFalse: [Win32Error signal].!

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
	of evaluating the <niladicValuable> exceptionHandler.
	Note that because the clipboard retains ownership of the bitmap,
	we must immediately copy it."

	^self apply: 
			[| hBitmap |
			hBitmap := UserLibrary default getClipboardData: CF_BITMAP.
			hBitmap isNull 
				ifTrue: [exceptionHandler value]
				ifFalse: [(Bitmap fromHandle: hBitmap) copy]]!

getBytesFormatId: format ifNone: exceptionHandler 
	"Private - Answer a ByteArray of data for <integer> format stored 
	on the clipboard. If no such format is currently available, the answers the
	result of evaluating the <niladicValuable> exceptionHandler."

	^self apply: 
			[| hBytes bytes len |
			hBytes := UserLibrary default getClipboardData: format.
			hBytes isNull ifTrue: [^exceptionHandler value].
			bytes := KernelLibrary default globalLock: hBytes.
			len := ExternalMemory GetSize: bytes.
			bytes := ByteArray fromAddress: bytes length: len.
			KernelLibrary default globalUnlock: hBytes.
			bytes]!

getFormatName: format
        "Answer the <readableString> name of the registered clipboard format 
	identified by the <integer> format, or nil the format is not registered. "
	
	| name len |
	name := String new: 256.
	len := UserLibrary default
			getClipboardFormatName: format
			lpszFormatName: name
			cchMaxCount: name size.
	^len == 0 ifFalse: [name leftString: len]!

getObject
        "Answer the <Object> stored on the clipboard or raise an error if none."

	^self getObjectIfNone: [self errorFormatNotAvailable: #Object]!

getObjectBinaryStoreBytes
        "Answer the STB binary store bytes for the <object> stored on the the clipboard, 
	or raise an exception if none is available."

	^self getObjectBinaryStoreBytesIfNone: [self errorFormatNotAvailable: #Object]!

getObjectBinaryStoreBytesIfNone: exceptionHandler
        "Answer the STB binary store bytes for an <object> stored 
	on the clipboard. If no object is currently available, the answers the
	result of evaluating the <niladicValuable> exceptionHandler."

	^self getBytesFormatId: self objectFormatId ifNone: exceptionHandler.!

getObjectClass
        "Answer the <Class> for the <Object> stored on the clipboard or 
	raise an error if there is none."

	^self getObjectClassIfNone: [self errorFormatNotAvailable: #ObjectClass]!

getObjectClassIfNone: exceptionHandler
	"Answer the <Class> of the <Object> stored on the clipboard. 
	If no object is currently available, the answers the result of 
	evaluating the <niladicValuable> exceptionHandler."

	^Object fromBinaryStoreBytes: (self getBytesFormatId: self objectClassFormatId
				ifNone: [^exceptionHandler value])!

getObjectIfNone: exceptionHandler
        "Answer the <object> stored on the clipboard. 
	If no object is currently available, the answers the result of 
	evaluating the <niladicValuable> exceptionHandler."

	^Object fromBinaryStoreBytes: (self getObjectBinaryStoreBytesIfNone: [^exceptionHandler value]).!

getRegisteredFormat: name ifNone: exceptionHandler 
	^self getTextFormat: (registeredFormats at: name) ifNone: exceptionHandler!

getRichText
        "Answer a <RichText> containing the the Rich Text contents 
	of the clipboard. If no rich text is currently available, raise 
	an exception."

	^self getRichTextIfNone: [self errorFormatNotAvailable: #RichText]!

getText
        "Answer a <readableString> containing the the CF_TEXT contents 
	of the clipboard. If no text is currently available, raise an exception."

	^self getTextIfNone: [self errorFormatNotAvailable: #String]!

getTextFormat: formatId ifNone: exceptionHandler 
	"Private - Answer a <readableString> containing the text contents
	of the clipboard of the specified format. If the format is not currently 
	available, the answers the result of evaluating the <niladicValuable> 
	exceptionHandler.
	N.B. It is not checked that formatId is actually a text format."

	^self apply: 
			[| hText pText text |
			hText := UserLibrary default getClipboardData: formatId.
			hText isNull ifTrue: [^exceptionHandler value].
			pText := KernelLibrary default globalLock: hText.
			text := String fromAddress: pText.
			KernelLibrary default globalUnlock: hText.
			text]!

getTextIfNone: exceptionHandler
        "Answer a <readableString> containing the the CF_TEXT contents 
	of the clipboard. If no text is currently available, the answers the
	result of evaluating the <niladicValuable> exceptionHandler."

	^self getTextFormat: CF_TEXT ifNone: exceptionHandler!

getTextOrEmpty
	^self getTextIfNone: ['']!

initialize
	"Private - Initialize the receiver's instance variables.
	Answer the receiver."

	| rtfFormat objectFormat objectClassFormat |
	isOpen := false.

	registeredFormats := LookupTable new.
	rtfFormat := UserLibrary default registerClipboardFormat: 'Rich Text Format'.
	objectFormat := UserLibrary default registerClipboardFormat: 'Smalltalk Object Format'.
	objectClassFormat := UserLibrary default registerClipboardFormat: 'Smalltalk Object Class Format'.
	registeredFormats
		at: #RichText put: rtfFormat;
		at: #String put: CF_TEXT;
		at: #UnicodeString put: CF_UNICODETEXT;
		at: #Bitmap put: CF_BITMAP;
		"at: #DIBSection put: CF_DIB;"	"Don't know how to do these at present"
		at: #Palette put: CF_PALETTE;
		at: #Object put: objectFormat;
		at: #ObjectClass put: objectClassFormat
!

isBitmapAvailable
	"Answer whether the clipboard contains a bitmap."

	^self isFormatIdAvailable: CF_BITMAP!

isFormatAvailable: format
        "Answer whether the clipboard contains data in the specified
	<integer> format (e.g. CF_TEXT)."

	^self isFormatIdAvailable: (registeredFormats at: format ifAbsent: [^false])!

isFormatIdAvailable: dwFormat
	"Private - Answer whether the clipboard contains the specified
	registered <integer> clipboard format."

	^UserLibrary default isClipboardFormatAvailable: dwFormat!

isObjectAvailable
	"Answer whether the clipboard contains an object."

	^self isFormatAvailable: #Object!

isTextAvailable
        "Answer whether the clipboard contains text data (i.e. CF_TEXT)."

	^self isFormatIdAvailable: CF_TEXT!

objectClassFormatId
	"Private - Answer the registered id for Smalltalk <Class> objects."

	^registeredFormats at: #ObjectClass!

objectFormatId
	"Private - Answer the registered id for Smalltalk objects."

	^registeredFormats at: #Object!

open
        "Open the clipboard."

	| wasOpen |
	(wasOpen := isOpen) ifFalse: [self basicRealize].
	^wasOpen!

registerFormat: formatName
        "Register the <readableString> formatName as a user-defined 
	clipboard format. Answer the format identifier."

	| id |
	id := UserLibrary default registerClipboardFormat: formatName asParameter.
	id == 0 ifTrue: [^Win32Error signal].
	registeredFormats at: formatName put: id.
	^id!

rtfFormatId
	"Private - Answer the registered id for rich text."

	^registeredFormats at: #RichText!

setBitmap: aBitmap
        "Transfer the specified bitmap to the clipboard."
	
	self setBitmap: aBitmap format: aBitmap class name
!

setBitmap: bmp format: formatName
        "Copy the specified bitmap to the clipboard as an entry
	of the specified format name."

	self setBitmap: bmp formatId: (registeredFormats at: formatName)!

setBitmap: aBitmap formatId: formatId
        "Private - Transfer the specified bitmap to the clipboard - note that
	this is destructive with respect to the bitmap, since it loses ownership
	of its external resource."
	
	| hBitmap |
	hBitmap := self setData: aBitmap detachHandle formatId: formatId.
	hBitmap  isNull ifTrue: [^Win32Error signal]!

setBytes: aByteArray formatId: format 
	"Private - Transfers aByteArray to the clipboard as data the <integer> format"

	| hMem pMem len kernel |
	kernel := KernelLibrary default.
	len := aByteArray basicSize.	"want size in bytes"
	hMem := kernel globalAlloc: ##(GHND | GMEM_DDESHARE) dwBytes: len + 1.
	pMem := kernel globalLock: hMem.
	pMem 
		replaceFrom: 1
		to: len
		with: aByteArray
		startingAt: 1.
	kernel globalUnlock: hMem.
	self setData: hMem formatId: format!

setData: handle formatId: formatId
	"Private - Copy the data with the specified handle to the clipboard
	with the specified <integer> format. If the clipboard is not currently
	open, then it is opened and emptied, and then closed after setting
	the data. If the clipboard is already open, then the data is simply
	copied to the clipboard without emptying or closing it. This is to
	allow the copying of multiple-formats for the same object, and also
	to prevent lots of opening and closing."

	| wasOpen |
	wasOpen := self open.
	^
	[wasOpen ifFalse: [self basicEmpty].
	UserLibrary default setClipboardData: formatId hMem: handle] 
			ensure: [wasOpen ifFalse: [self close]]!

setDIB: aDIBSection
        "Transfer the specified DIBSection bitmap to the clipboard."

	self setBitmap: aDIBSection format: CF_DIB!

setObject: anObject
        "Transfers anObject to the clipboard."

	self setObjectBinaryStoreBytes: anObject binaryStoreBytes class: anObject class!

setObjectBinaryStoreBytes: aByteArray class: aClass
        "Private - Transfers aByteArray to the clipboard as the
	binary store bytes of an object of aClass"

	self apply: [
		self setBytes: aByteArray formatId: self objectFormatId.
		self setBytes: aClass binaryStoreBytes formatId: self objectClassFormatId ]!

setText: text
        "Private - Copy the <String> text to the clipboard as an entry
	in CF_TEXT format."

	self setText: text format: text class name!

setText: text format: formatName
        "Copy the <readableString> text to the clipboard as an entry
	of the specified format name."

	self setText: text formatId: (registeredFormats at: formatName)!

setText: textObject formatId: formatId 
	"Private - Copy the <readableString> text to the clipboard as an entry
	of the specified <integer> format."

	| hMem pMem len kernel text |
	kernel := KernelLibrary default.
	text := textObject asParameter.
	len := text basicSize.	"want size in bytes"
	hMem := kernel globalAlloc: ##(GHND | GMEM_DDESHARE) dwBytes: len + 1.
	pMem := kernel globalLock: hMem.
	pMem 
		replaceFrom: 1
		to: len
		with: text
		startingAt: 1.
	kernel globalUnlock: hMem.
	self setData: hMem formatId: formatId! !
!Clipboard categoriesFor: #apply:!operations!private! !
!Clipboard categoriesFor: #availableFormatIds!enquiries!public! !
!Clipboard categoriesFor: #availableFormats!enquiries!public! !
!Clipboard categoriesFor: #basicEmpty!operations!private! !
!Clipboard categoriesFor: #basicFree!private!realizing/unrealizing! !
!Clipboard categoriesFor: #basicRealize!public!realizing/unrealizing! !
!Clipboard categoriesFor: #close!public!realizing/unrealizing! !
!Clipboard categoriesFor: #empty!operations!public! !
!Clipboard categoriesFor: #errorFormatNotAvailable:!exceptions!public! !
!Clipboard categoriesFor: #free!public!realizing/unrealizing! !
!Clipboard categoriesFor: #getBitmap!accessing!public! !
!Clipboard categoriesFor: #getBitmapIfNone:!accessing!public! !
!Clipboard categoriesFor: #getBytesFormatId:ifNone:!accessing!private! !
!Clipboard categoriesFor: #getFormatName:!accessing!public! !
!Clipboard categoriesFor: #getObject!accessing!public! !
!Clipboard categoriesFor: #getObjectBinaryStoreBytes!accessing!public! !
!Clipboard categoriesFor: #getObjectBinaryStoreBytesIfNone:!accessing!public! !
!Clipboard categoriesFor: #getObjectClass!accessing!public! !
!Clipboard categoriesFor: #getObjectClassIfNone:!accessing!public! !
!Clipboard categoriesFor: #getObjectIfNone:!accessing!public! !
!Clipboard categoriesFor: #getRegisteredFormat:ifNone:!accessing!public! !
!Clipboard categoriesFor: #getRichText!accessing!public! !
!Clipboard categoriesFor: #getText!accessing!public! !
!Clipboard categoriesFor: #getTextFormat:ifNone:!accessing!private! !
!Clipboard categoriesFor: #getTextIfNone:!accessing!public! !
!Clipboard categoriesFor: #getTextOrEmpty!accessing!public! !
!Clipboard categoriesFor: #initialize!initializing!private! !
!Clipboard categoriesFor: #isBitmapAvailable!public!testing! !
!Clipboard categoriesFor: #isFormatAvailable:!public!testing! !
!Clipboard categoriesFor: #isFormatIdAvailable:!private!testing! !
!Clipboard categoriesFor: #isObjectAvailable!public!testing! !
!Clipboard categoriesFor: #isTextAvailable!public!testing! !
!Clipboard categoriesFor: #objectClassFormatId!constants!private! !
!Clipboard categoriesFor: #objectFormatId!constants!private! !
!Clipboard categoriesFor: #open!public!realizing/unrealizing! !
!Clipboard categoriesFor: #registerFormat:!operations!public! !
!Clipboard categoriesFor: #rtfFormatId!constants!private! !
!Clipboard categoriesFor: #setBitmap:!accessing!public! !
!Clipboard categoriesFor: #setBitmap:format:!accessing!public! !
!Clipboard categoriesFor: #setBitmap:formatId:!accessing!private! !
!Clipboard categoriesFor: #setBytes:formatId:!accessing!private! !
!Clipboard categoriesFor: #setData:formatId:!accessing!private! !
!Clipboard categoriesFor: #setDIB:!accessing!public! !
!Clipboard categoriesFor: #setObject:!accessing!public! !
!Clipboard categoriesFor: #setObjectBinaryStoreBytes:class:!accessing!public! !
!Clipboard categoriesFor: #setText:!accessing!private! !
!Clipboard categoriesFor: #setText:format:!accessing!public! !
!Clipboard categoriesFor: #setText:formatId:!accessing!private! !

!Clipboard class methodsFor!

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
!Clipboard class categoriesFor: #current!instance creation!public! !
!Clipboard class categoriesFor: #icon!constants!public! !
!Clipboard class categoriesFor: #new!instance creation!public! !
!Clipboard class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Clipboard class categoriesFor: #onStartup!event handling!private! !

