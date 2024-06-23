"Filed out from Dolphin Smalltalk"!

XMLTokenizer subclass: #XMLParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XMLParser guid: (GUID fromString: '{be04633b-820f-4cfe-b0b1-9545388c6de8}')!

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

!XMLParser categoriesForMethods!
attribute:value:!callbacks!public! !
beginStartTag:asPI:!callbacks!public! !
endStartTag:!callbacks!public! !
endTag:!callbacks!public! !
handleCData:!handling tokens!public! !
handleEndTag:!handling tokens!public! !
handlePCData:!handling tokens!public! !
handleStartTag:attributes:!handling tokens!public! !
text:!callbacks!public! !
!

