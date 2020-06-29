"Filed out from Dolphin Smalltalk 7"!

Object subclass: #OneOffNoteBubble
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
OneOffNoteBubble guid: (GUID fromString: '{1b63c41e-9df7-4c2c-b128-3fc143dac05a}')!
OneOffNoteBubble comment: ''!
!OneOffNoteBubble categoriesForClass!Kernel-Objects! !
!OneOffNoteBubble class methodsFor!

addPreviouslyViewedNote: aSymbol
	self registryKey valueAt: aSymbol put: DateAndTime now printString!

defaultCaption
	^'One-Off Note'!

defaultTimeout
	^5 seconds!

defaultWidth
	^300!

icon
	^Tooltip icon!

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
		timeout: self defaultTimeout + (aString subStrings size * 500) milliseconds!

name: aSymbol text: aString for: aView timeout: aDuration
	"
	self name: #testNote text: 'This is a test'
	"

	| bubble |
	(self previouslyViewedNotes includes: aSymbol) ifTrue: [^self].
	self addPreviouslyViewedNote: aSymbol.
	bubble := MessageBubble new
				caption: self defaultCaption;
				maxWidth: self defaultWidth;
				willFade: true;
				timeout: aDuration.
	aView notNil ifTrue: [bubble position: aView rectangle center].
	bubble notify: aString!

previouslyViewedNotes
	"Private - Answer a <Set> of <Symbol>s naming the OneOffNotes that have already been viewed.

	self previouslyViewedNotes
	"

	^(RegKey userRoot at: self registryKeyName ifAbsent: [])
		ifNil: [Set new]
		ifNotNil: [:regkey | regkey subValues keys collect: [:each | each asSymbol]]!

previouslyViewedNotes: aCollection
	"Set the previously views notes to aCollection of <Symbols>"

	| regKey timeStamp |
	self resetPreviouslyViewedNotes.
	regKey := self registryKey.
	timeStamp := DateAndTime now printString.
	aCollection do: [:each | regKey valueAt: each put: timeStamp]!

registryKey
	^RegKey userRoot createKey: self registryKeyName!

registryKeyName
	"Private - Answers the <readableString> registry key for the previously viewed notes"

	^'<1s>\<2s>\OneOffNotes' expandMacrosWith: SessionManager current productRegistryKey
		with: SessionManager current applicationShortName!

removePreviouslyViewedNote: aSymbol
	self registryKey removeSubValue: aSymbol ifAbsent: []!

resetPreviouslyViewedNotes
	"
	self resetPreviouslyViewedNotes.
	"

	RegKey userRoot removeKey: self registryKeyName ifAbsent: []! !
!OneOffNoteBubble class categoriesFor: #addPreviouslyViewedNote:!private! !
!OneOffNoteBubble class categoriesFor: #defaultCaption!constants!private! !
!OneOffNoteBubble class categoriesFor: #defaultTimeout!constants!private! !
!OneOffNoteBubble class categoriesFor: #defaultWidth!constants!private! !
!OneOffNoteBubble class categoriesFor: #icon!constants!development!public! !
!OneOffNoteBubble class categoriesFor: #name:text:!instance creation!public! !
!OneOffNoteBubble class categoriesFor: #name:text:for:!instance creation!public! !
!OneOffNoteBubble class categoriesFor: #name:text:for:timeout:!instance creation!public! !
!OneOffNoteBubble class categoriesFor: #previouslyViewedNotes!accessing!public! !
!OneOffNoteBubble class categoriesFor: #previouslyViewedNotes:!accessing!public! !
!OneOffNoteBubble class categoriesFor: #registryKey!private! !
!OneOffNoteBubble class categoriesFor: #registryKeyName!constants!private! !
!OneOffNoteBubble class categoriesFor: #removePreviouslyViewedNote:!private! !
!OneOffNoteBubble class categoriesFor: #resetPreviouslyViewedNotes!private! !

