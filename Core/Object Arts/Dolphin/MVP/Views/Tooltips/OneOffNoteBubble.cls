"Filed out from Dolphin Smalltalk 7"!

Object subclass: #OneOffNoteBubble
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OneOffNoteBubble guid: (GUID fromString: '{1b63c41e-9df7-4c2c-b128-3fc143dac05a}')!
OneOffNoteBubble comment: ''!
!OneOffNoteBubble categoriesForClass!Kernel-Objects! !
!OneOffNoteBubble class methodsFor!

addPreviouslyViewedNote: aSymbol 
	self previouslyViewedNotes: ((self previouslyViewedNotes)
				add: aSymbol;
				yourself)!

defaultCaption
	^'One-Off Note'!

defaultTimeout
	^5000!

defaultWidth
	^300!

name: aSymbol text: aString 
	"
	self name: #testNote text: 'This is a test'
	"

	self 
		name: aSymbol
		text: aString
		for: nil!

name: aSymbol text: aString for: aView 
	"
	self name: #testNote text: 'This is a test'
	"

	^self 
		name: aSymbol
		text: aString
		for: aView
		timeout: self defaultTimeout + (aString subStrings size * 500)!

name: aSymbol text: aString for: aView timeout: milliseconds 
	"
	self name: #testNote text: 'This is a test'
	"

	| bubble |
	(self previouslyViewedNotes includes: aSymbol) ifTrue: [^self].
	self addPreviouslyViewedNote: aSymbol.
	bubble := (MessageBubble new)
				caption: self defaultCaption;
				maxWidth: self defaultWidth;
				willFade: true;
				timeout: milliseconds.
	aView notNil ifTrue: [bubble position: aView rectangle center].
	bubble notify: aString!

oneOffNotesRegistryKey
	"Private - Answers the <readableString> registry key for the previously viewd notes"

	^'<1s>\<2s>\OneOffNotes' expandMacrosWith: SessionManager current productRegistryKey
		with: SessionManager current applicationShortName!

previouslyViewedNotes
	"Private - Answers the a <Set> of <Symbols> indicating the OneOffNotes that have already been views.

	self previouslyViewedNotes
	"

	| entryValue |
	entryValue := [(RegKey userRoot at: self oneOffNotesRegistryKey) valueAt: ''] on: NotFoundError
				do: [:x | ^Set new].
	entryValue isEmpty ifTrue: [^Set new].
	^Object fromBinaryStoreBytes: entryValue!

previouslyViewedNotes: aSet 
	"Set the previously views notes to aSet of <Symbols>"

	| regKey |
	regKey := RegKey userRoot createKey: self oneOffNotesRegistryKey.
	regKey valueAt: '' put: aSet binaryStoreBytes!

removePreviouslyViewedNote: aSymbol 
	self previouslyViewedNotes: ((self previouslyViewedNotes)
				remove: aSymbol;
				yourself)!

resetPreviouslyViewedNotes
	"
	self resetPreviouslyViewedNotes.
	"
	self previouslyViewedNotes: Set new! !
!OneOffNoteBubble class categoriesFor: #addPreviouslyViewedNote:!private! !
!OneOffNoteBubble class categoriesFor: #defaultCaption!constants!private! !
!OneOffNoteBubble class categoriesFor: #defaultTimeout!constants!private! !
!OneOffNoteBubble class categoriesFor: #defaultWidth!constants!private! !
!OneOffNoteBubble class categoriesFor: #name:text:!instance creation!public! !
!OneOffNoteBubble class categoriesFor: #name:text:for:!instance creation!public! !
!OneOffNoteBubble class categoriesFor: #name:text:for:timeout:!instance creation!public! !
!OneOffNoteBubble class categoriesFor: #oneOffNotesRegistryKey!constants!public! !
!OneOffNoteBubble class categoriesFor: #previouslyViewedNotes!accessing!public! !
!OneOffNoteBubble class categoriesFor: #previouslyViewedNotes:!accessing!public! !
!OneOffNoteBubble class categoriesFor: #removePreviouslyViewedNote:!private! !
!OneOffNoteBubble class categoriesFor: #resetPreviouslyViewedNotes!private! !

