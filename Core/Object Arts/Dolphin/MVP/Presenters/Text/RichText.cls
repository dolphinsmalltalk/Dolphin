"Filed out from Dolphin Smalltalk"!

Object subclass: #RichText
	instanceVariableNames: 'rtf'
	classVariableNames: 'Converter ConverterMutex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RichText guid: (GUID fromString: '{87b4c4b2-026e-11d3-9fd7-00a0cc3e4a32}')!

RichText comment: ''!

!RichText categoriesForClass!System-Support! !

!RichText methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent.
	RichText objects are considered equal to other rich text objects with the same RTF."

	^(anObject species == self species) and: [anObject rtf = self rtf]!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	library call. In this case we unwrap."

	^self rtf!

asRichText
	"Answers the receiver as RichText"

	^self!

asString
	"Answers the receiver as a String containing plain text"

	^ConverterMutex critical: 
			[| converter string |
			converter := self class rtfConverter.
			converter rtfText: self rtf.
			string := converter plainText.
			converter setWindowText: ''.
			string]!

copyToClipboard
	"Copy a format of the receiver to the clipboard."

	| clipboard |
	clipboard := Clipboard current.
	(clipboard isFormatRegistered: #RichText) ifFalse: [self class registerClipboardFormat].
	clipboard setRegisteredFormat: #RichText data: self!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: self asString!

displayString
	"Answer a String whose characters are a representation of the receiver as a user
	would want to see it"

	^self asString displayString!

hash
	"Answer the <integer> hash value for the receiver."

	^self rtf hash!

isEmpty
	"Answer whether the receiver contains no text."

	^false!

notEmpty
	"Answer whether the receiver contains any text."

	^true!

printOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver 
	as a programmer would want to see it."
	
	aStream 
		basicPrint: self;
		nextPutAll: self rtf!

replaceSelectionIn: aTextEdit
	"Sent as part of a double dispatch from View objects to set their selection text from
	the receiver. The RichText protocol requires that aTextEdit must implement both #selectionPlainText:
	and #selectionRichText: methods."

	aTextEdit selectionRichText: self!

rtf
	"Private - Answers the receiver's RTF contents"

	^rtf!

rtf: anRtfString
	"Private - Sets the receiver to contain the RTF text in anRtfString"

	rtf := anRtfString!

setTextInto: aView
	"Private - Sent as part of a double dispatch from View objects to set their text from
	the receiver. The receiver is assumed to be rich text, so sends the #richText
	message back to aView."
	
	aView richText: self! !

!RichText categoriesForMethods!
=!comparing!public! !
asParameter!converting!public! !
asRichText!converting!public! !
asString!converting!public! !
copyToClipboard!copying!public! !
displayOn:!displaying!public! !
displayString!converting!displaying!public! !
hash!comparing!public! !
isEmpty!public!testing! !
notEmpty!public!testing! !
printOn:!development!printing!public! !
replaceSelectionIn:!double dispatch!public! !
rtf!accessing!private! !
rtf:!accessing!private! !
setTextInto:!double dispatch!private! !
!

RichText methodProtocol: #richString attributes: #(#readOnly) selectors: #(#setTextInto:)!

!RichText class methodsFor!

fromRtf: anRtfString
	"Answers an instance of the receiver holding anRtfString"

	^super new rtf: anRtfString; yourself!

fromString: aString
	"Answers an instance of the receiver holding the plain text in aString."

	^ConverterMutex critical: 
			[| converter richText |
			converter := self rtfConverter.
			converter plainText: aString.
			richText := converter richText.
			converter setWindowText: ''.
			richText]!

initialize
	ConverterMutex := Mutex new.
	^self registerClipboardFormat!

new
	"Private - Use #fromRtf: or #fromString:"

	^self shouldNotImplement!

onPreStripImage
	"Private - The image is about to be stripped. Nil out the cached converter to (potentially)
	allow RichTextEdit to be stripped."

	self uninitialize!

registerClipboardFormat
	| clipboardRtf |
	clipboardRtf := UserLibrary default registerClipboardFormat: 'RTF in UTF8'.
	clipboardRtf == 0 ifTrue: [^Win32Error signal].
	Clipboard current
		addRegisteredFormat: #RichText
		id: clipboardRtf
		converter: (PluggableTypeConverter
				leftToRight: [:richText | ExternalMemory copyBytesToGlobalHeap: richText rtf]
				rightToLeft: [:handle | RichText fromRtf: (Utf8String fromGlobalHandle: handle)])!

rtfConverter
	"Private - Answer an instance of RichTextEdit which can be used to convert 
	between RTF and plain text or vice versa"

	(Converter isNil or: [Converter isOpen not])
		ifTrue: 
			[Converter := RichTextEdit new
						parentView: View desktop;
						create;
						yourself].
	^Converter!

uninitialize
	"Unitialize the receiver before it is uninstalled from the image."

	Converter isNil ifTrue: [^self].
	Converter destroy.
	Converter := nil! !

!RichText class categoriesForMethods!
fromRtf:!instance creation!public! !
fromString:!instance creation!public! !
initialize!class initialization!public! !
new!instance creation!private! !
onPreStripImage!class hierarchy-removing!private! !
registerClipboardFormat!class initialization!private! !
rtfConverter!accessing!private! !
uninitialize!class hierarchy-removing!public! !
!

