"Filed out from Dolphin Smalltalk X6"!

CommandButton subclass: #LinkButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SysLinkConstants'
	classInstanceVariableNames: ''!
LinkButton guid: (GUID fromString: '{D8FCAB7F-B566-42DA-B183-D925EAA9DC99}')!
LinkButton comment: 'LinkButton is a <CommandButton> implemented using the Windows "SysLink" control. It has the appearance of a hyperlink, but acts as a <commandSource>.

A LinkButton can contain a single link in its text, delimited by HTML link tags, e.g. ''<a>Press Me</a>''. The button can contain additional text that is not part of the hyperlink, but if the button text is set to a <String> that does not contain a hyperlink, then the text is automatically wrapped with link tags (i.e. the whole of the text is treated as the link). If the link is clicked (or the Enter key is pressed when the LinkButton has focus), then the command associated with the button is fired as if initiated from the button''s parent. Any URL associated with the link with an href attribute is ignored (but see also SysLinkView).

Note: The SysLink control is only available when running under Windows XP and later.

Instance Variables:
	image			<Image> or nil, specifying an image to overlay the button.
	buttonStyle		<integer> Windows style flags for the button.

Class Variables:
	ButtonStyleMap		<IdentityDictionary> mapping <Symbol>ic button style names to the corresponding <Integer> style flags.
	IsDefaultMask		<integer> masks to determine whether a button is a default.

'!
!LinkButton categoriesForClass!MVP-Views! !
!LinkButton methodsFor!

calculateExtent: aLayoutContext 
	"Private - Calculate an extent for the receiver that would allow it to display all the text
	that it currently contains."

	"Implementation Note: We consider the width to be fixed, and calculate the required height
	(actually the control can do this ourselves), which is the same preferred extent behaviour
	implemented by StaticText when in multiline mode."

	| extent clientExt |
	clientExt := aLayoutContext clientExtentOf: self.
	extent := clientExt x @ self preferredHeight.

	"Now adjust required client extent to window extent"
	^self calcExtentFromClientExtent: extent!

isEnabled: aBoolean 
	"Implmentation Note: Must disable link before view, otherwise attempting to disable the view fails."

	| litem |
	litem := LITEM new.
	litem
		itemIndex: 1;
		isEnabled: aBoolean.
	self 
		sendMessage: LM_SETITEM
		wParam: 0
		lpParam: litem.
	super isEnabled: aBoolean!

nmClick: pNMHDR 
	"Default handler for a NM_CLICK notification message."

	self presenter performAction.
	^0!

nmReturn: pNMHDR 
	"Default handler for a NM_RETURN notification message."

	self presenter performAction.
	^0!

preferredHeight
	"Private - Answer the <integer> number of pels that the control thinks would be its 
	ideal height, given its current width."

	^self sendMessage: LM_GETIDEALHEIGHT!

stripTags: aString 
	| newStream readStream |
	newStream := String writeStream: aString size.
	readStream := aString readStream.
	[readStream atEnd] whileFalse: 
			[newStream nextPutAll: (readStream upTo: $<).
			readStream skipTo: $>].
	^newStream contents!

text: aString 
	"Sets the text of the receiver (and its command description) to aString."

	| text |
	text := ('*<a*>*</a>*' match: aString) ifTrue: [aString] ifFalse: ['<a>' , aString , '</a>'].
	super text: text.
	commandDescription description: (self stripTags: text)! !
!LinkButton categoriesFor: #calculateExtent:!geometry!private! !
!LinkButton categoriesFor: #isEnabled:!accessing!public! !
!LinkButton categoriesFor: #nmClick:!event handling-win32!private! !
!LinkButton categoriesFor: #nmReturn:!event handling-win32!private! !
!LinkButton categoriesFor: #preferredHeight!enquiries!private! !
!LinkButton categoriesFor: #stripTags:!helpers!private! !
!LinkButton categoriesFor: #text:!accessing!public! !

!LinkButton class methodsFor!

resource_Link_button
	"Answer the literal data from which the 'Link button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Link_button)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(LinkButton)  98 15 0 0 98 2 8 1140916224 1 416 0 524550 ##(ColorRef)  8 4278190080 0 517 0 0 0 416 0 8 4294906965 1180998 4 ##(CommandDescription)  8 #close 8 'Click to Close' 1 1 0 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  21 31 754 111 71 416 690 8 #text: 98 1 8 '<a>Click to Close</a>' 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 15 0 0 0 65 0 0 0 50 0 0 0] 98 0 754 193 193 0 27 )!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysLink'! !
!LinkButton class categoriesFor: #resource_Link_button!public!resources-views! !
!LinkButton class categoriesFor: #winClassName!constants!private! !

