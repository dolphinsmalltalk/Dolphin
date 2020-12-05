"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'MSXML.DOMParseError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.DOMParseError guid: (Core.GUID fromString: '{80a8e9d9-c230-4610-8994-72021cfdadcb}')!
MSXML.DOMParseError comment: 'DOMParseError is an <Exception> class to wrap the IXMLDOMParseError interface from the Microsoft XML DOM. 

Note that these exceptions are not raised automatically when the parsing of an XML document fails, e.g. in a call to IXMLDOMDocument>>load:, but must be raised (if desired) when the method returns false to indicate a failure.'!
!MSXML.DOMParseError categoriesForClass!Unclassified! !
!MSXML.DOMParseError methodsFor!

_descriptionArguments
	"Answer a <sequencedReadableCollection> of the  arguments to be substitued 
	into the receiver's Win32 description format string when constructing the receivers 
	#description.
	By default the arguments to the message formatting are the message text and 
	the tag supplied by the exception signaller, but if additional fields are available,
	then this should be overridden.

	N.B. This is part of the implementation of the ANSI standard message 
	#description and therefore it requires an underscore prefix in order
	to avoid the fragile base class problem where subclasses may 
	inadvertantly override a superclass method."

	| reason url |
	reason := tag reason.
	reason := reason isNil 
		ifTrue: ['<unknown>']
		ifFalse: [reason lines first].
	url := tag url.
	url isNil ifTrue: [url := '<unknown>'].
	^(OrderedCollection new: 6)
		add: self messageText displayString; 	"...just in case the messageText is not a String"
		add: tag errorCode;
		add: reason;
		add: tag line;
		add: tag linepos;
		add: url;
		yourself!

_descriptionFormat
	"Private - Answer a string which is the message format for the receiver's description."

	^'%1 - ''%3'' at %4!!d!!, %5!!d!!'! !
!MSXML.DOMParseError categoriesFor: #_descriptionArguments!displaying!public! !
!MSXML.DOMParseError categoriesFor: #_descriptionFormat!displaying!private! !

