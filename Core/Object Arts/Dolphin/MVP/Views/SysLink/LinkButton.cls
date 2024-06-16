"Filed out from Dolphin Smalltalk"!

CommandButton subclass: #LinkButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SysLinkConstants'
	classInstanceVariableNames: ''!

LinkButton guid: (GUID fromString: '{d8fcab7f-b566-42da-b183-d925eaa9dc99}')!

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

getWindowText
	"Private - SysLink control seems to have a bug whereby it responds to WM_GETTEXTLENGTH with
	the buffer size (including null terminator), rather than just the number of characters as
	all other controls/windows do."

	"Safer to trim the null, rather than allocate smaller buffer, in case the bug gets fixed."

	^super getWindowText trimNulls!

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

!LinkButton categoriesForMethods!
calculateExtent:!geometry!private! !
getWindowText!accessing!private! !
isEnabled:!accessing!public! !
nmClick:!event handling-win32!private! !
nmReturn:!event handling-win32!private! !
preferredHeight!enquiries!private! !
stripTags:!helpers!private! !
text:!accessing!public! !
!

!LinkButton class methodsFor!

resource_Link_button
	"Answer the literal data from which the 'Link button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Link_button)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.LinkButton) 34 15 nil nil 34 2 8 1140916224 1 416 nil 327686 ##(Smalltalk.Color) #default nil 519 nil nil nil 416 nil 8 1758846304 1180998 4 ##(Smalltalk.CommandDescription) #close 8 'Click to Close' 1 1 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 182 7 0 0 45 0 0 0] 193 448 8 '<a>Click to Close</a>' 416 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysLink'! !

!LinkButton class categoriesForMethods!
resource_Link_button!public!resources-views! !
winClassName!constants!private! !
!

