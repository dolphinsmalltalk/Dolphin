"Filed out from Dolphin Smalltalk 7"!

UI.CommandButton subclass: #'UI.LinkButton'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.SysLinkConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.LinkButton guid: (Core.GUID fromString: '{d8fcab7f-b566-42da-b183-d925eaa9dc99}')!
UI.LinkButton comment: 'LinkButton is a <CommandButton> implemented using the Windows "SysLink" control. It has the appearance of a hyperlink, but acts as a <commandSource>.

A LinkButton can contain a single link in its text, delimited by HTML link tags, e.g. ''<a>Press Me</a>''. The button can contain additional text that is not part of the hyperlink, but if the button text is set to a <String> that does not contain a hyperlink, then the text is automatically wrapped with link tags (i.e. the whole of the text is treated as the link). If the link is clicked (or the Enter key is pressed when the LinkButton has focus), then the command associated with the button is fired as if initiated from the button''s parent. Any URL associated with the link with an href attribute is ignored (but see also SysLinkView).

Note: The SysLink control is only available when running under Windows XP and later.

Instance Variables:
	image			<Image> or nil, specifying an image to overlay the button.
	buttonStyle		<integer> Windows style flags for the button.

Class Variables:
	ButtonStyleMap		<IdentityDictionary> mapping <Symbol>ic button style names to the corresponding <Integer> style flags.
	IsDefaultMask		<integer> masks to determine whether a button is a default.

'!
!UI.LinkButton categoriesForClass!MVP-Views! !
!UI.LinkButton methodsFor!

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
!UI.LinkButton categoriesFor: #calculateExtent:!geometry!private! !
!UI.LinkButton categoriesFor: #getWindowText!accessing!private! !
!UI.LinkButton categoriesFor: #isEnabled:!accessing!public! !
!UI.LinkButton categoriesFor: #nmClick:!event handling-win32!private! !
!UI.LinkButton categoriesFor: #nmReturn:!event handling-win32!private! !
!UI.LinkButton categoriesFor: #preferredHeight!enquiries!private! !
!UI.LinkButton categoriesFor: #stripTags:!helpers!private! !
!UI.LinkButton categoriesFor: #text:!accessing!public! !

!UI.LinkButton class methodsFor!

resource_Link_button
	"Answer the literal data from which the 'Link button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Link_button)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.LinkButton) 34 15 nil nil 34 2 8 1140916224 1 416 nil 917510 ##(Graphics.Color) #default nil 519 nil nil nil 416 nil 8 1921159200 1377606 4 ##(UI.CommandDescription) #close 8 'Click to Close' 1 1 nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 690 111 71 416 642 #text: 34 1 8 '<a>Click to Close</a>' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 54 12 0 0 45 0 0 0] 8 #() 690 193 193 nil 27)!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysLink'! !
!UI.LinkButton class categoriesFor: #resource_Link_button!public!resources-views! !
!UI.LinkButton class categoriesFor: #winClassName!constants!private! !

