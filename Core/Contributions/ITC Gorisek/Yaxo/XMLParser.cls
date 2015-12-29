"Filed out from Dolphin Smalltalk X6.2"!

XMLTokenizer subclass: #XMLParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XMLParser guid: (GUID fromString: '{BE04633B-820F-4CFE-B0B1-9545388C6DE8}')!
XMLParser comment: ''!
!XMLParser categoriesForClass!XML-Parser! !
!XMLParser methodsFor!

attribute: aSymbol value: aString
	"This method is called for each attribute/value pair in a start tag"

	^self subclassResponsibility!

beginStartTag: aSymbol asPI: aBoolean
	"This method is called for at the beginning of a start tag.
	The asPI parameter defines whether or not the tag is a 'processing
	instruction' rather than a 'normal' tag."

	^self subclassResponsibility!

endStartTag: aSymbol
	"This method is called at the end of the start tag after all of the
	attributes have been processed"

	^self subclassResponsibility!

endTag: aSymbol
	"This method is called when the parser encounters either an
	end tag or the end of a unary tag"

	^self subclassResponsibility!

handleCData: aString
	self text: aString!

handleEndTag: aString
	self endTag: aString!

handlePCData: aString
	self text: aString!

handleStartTag: tagName attributes: attributes
	self beginStartTag: tagName asPI: false.
	attributes keysAndValuesDo: [:key :value |
		self attribute: key value: value].
	self endStartTag: tagName!

text: aString
	"This method is called for the blocks of text between tags.
	It preserves whitespace, but has all of the enclosed entities expanded"

	^self subclassResponsibility! !
!XMLParser categoriesFor: #attribute:value:!callbacks!public! !
!XMLParser categoriesFor: #beginStartTag:asPI:!callbacks!public! !
!XMLParser categoriesFor: #endStartTag:!callbacks!public! !
!XMLParser categoriesFor: #endTag:!callbacks!public! !
!XMLParser categoriesFor: #handleCData:!handling tokens!public! !
!XMLParser categoriesFor: #handleEndTag:!handling tokens!public! !
!XMLParser categoriesFor: #handlePCData:!handling tokens!public! !
!XMLParser categoriesFor: #handleStartTag:attributes:!handling tokens!public! !
!XMLParser categoriesFor: #text:!callbacks!public! !

