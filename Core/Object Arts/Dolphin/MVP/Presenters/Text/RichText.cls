"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RichText
	instanceVariableNames: 'rtf'
	classVariableNames: 'Converter'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RichText guid: (GUID fromString: '{87B4C4B2-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	| converter string |
	converter := self class rtfConverter.

	converter rtfText: self rtf.
	string := converter plainText.
	converter setWindowText: ''.

	^string!

copyToClipboard
	"Copy a format of the receiver to the clipboard."

	Clipboard current setText: self format: #RichText!

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
	
	aView richText: self!

storeOn: aStream

	aStream 
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' fromRtf: '.
	rtf storeOn: aStream.
	aStream nextPut: $)! !
!RichText categoriesFor: #=!comparing!public! !
!RichText categoriesFor: #asParameter!converting!public! !
!RichText categoriesFor: #asRichText!converting!public! !
!RichText categoriesFor: #asString!converting!public! !
!RichText categoriesFor: #copyToClipboard!copying!public! !
!RichText categoriesFor: #displayOn:!displaying!public! !
!RichText categoriesFor: #displayString!converting!displaying!public! !
!RichText categoriesFor: #hash!comparing!public! !
!RichText categoriesFor: #isEmpty!public!testing! !
!RichText categoriesFor: #notEmpty!public!testing! !
!RichText categoriesFor: #printOn:!development!printing!public! !
!RichText categoriesFor: #replaceSelectionIn:!double dispatch!public! !
!RichText categoriesFor: #rtf!accessing!private! !
!RichText categoriesFor: #rtf:!accessing!private! !
!RichText categoriesFor: #setTextInto:!double dispatch!private! !
!RichText categoriesFor: #storeOn:!printing!public! !

RichText methodProtocol: #richString attributes: #(#readOnly) selectors: #(#setTextInto:)!

!RichText class methodsFor!

fromRtf: anRtfString
	"Answers an instance of the receiver holding anRtfString"

	^super new rtf: anRtfString; yourself!

fromString: aString
	"Answers an instance of the receiver holding the plain text in aString.
	Note that we no longer use the converter to convert plain text to
	rich text, but just wrap it appropriately."

	^super new rtf: '{\rtf1\ansi ', aString, '
}'!

new
	"Private - Use #fromRtf: or #fromString:"

	^self shouldNotImplement!

onPreStripImage
	"Private - The image is about to be stripped. Nil out the cached converter to (potentially)
	allow RichTextEdit to be stripped."

	self uninitialize!

rtfConverter
	"Private - Answer an instance of RichTextEdit which can be used to convert 
	between RTF and plain text or vice versa"

	(Converter isNil or: [Converter isOpen not]) 
		ifTrue: 
			[Converter := (RichTextEdit new)
						parentView: View desktop;
						create;
						yourself].
	^Converter!

uninitialize
	"Unitialize the receiver before it is uninstalled from the image."

	Converter isNil ifTrue: [^self].
	Converter destroy.
	Converter := nil! !
!RichText class categoriesFor: #fromRtf:!instance creation!public! !
!RichText class categoriesFor: #fromString:!instance creation!public! !
!RichText class categoriesFor: #new!instance creation!private! !
!RichText class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!RichText class categoriesFor: #rtfConverter!accessing!private! !
!RichText class categoriesFor: #uninitialize!class hierarchy-removing!public! !

