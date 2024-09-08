"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.OneOffNoteBubble'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.OneOffNoteBubble guid: (Core.GUID fromString: '{1b63c41e-9df7-4c2c-b128-3fc143dac05a}')!

UI.OneOffNoteBubble comment: ''!

!UI.OneOffNoteBubble categoriesForClass!Kernel-Objects! !

!UI.OneOffNoteBubble class methodsFor!

addPreviouslyViewedNote: aSymbol
	self registryKey valueAt: aSymbol put: DateAndTime now printString!

defaultCaption
	^'One-Off Note'!

defaultTimeout
	^SystemMetrics current messageDuration!

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
				timeout: aDuration.
	aView notNil ifTrue: [bubble position: aView rectangle center].
	bubble notify: aString!

previouslyViewedNotes
	"Private - Answer a <Set> of <Symbol>s naming the OneOffNotes that have already been viewed.

	self previouslyViewedNotes
	"

	^(RegKey userRoot at: self registryKeyName ifAbsent: nil)
		ifNil: [Set new]
		ifNotNil: [:regkey | regkey subValues keys collect: [:each | each asSymbol]]!

previouslyViewedNotes: aCollection
	"Set the previously viewed notes to aCollection of <Symbols>"

	| regKey timeStamp |
	self resetPreviouslyViewedNotes.
	regKey := self registryKey.
	timeStamp := DateAndTime now printString.
	aCollection do: [:each | regKey valueAt: each put: timeStamp]!

registryKey
	^RegKey userRoot createKey: self registryKeyName!

registryKeyName
	"Private - Answers the <readableString> registry key for the previously viewed notes"

	^'<1s>\<2s>\OneOffNotes' expandMacrosWithArguments: {SessionManager current productRegistryKey.
				SessionManager current applicationShortName}
		locale: Locale invariant!

removePreviouslyViewedNote: aSymbol
	self registryKey removeSubValue: aSymbol ifAbsent: []!

resetPreviouslyViewedNotes
	"
	self resetPreviouslyViewedNotes.
	"

	RegKey userRoot removeKey: self registryKeyName ifAbsent: nil! !

!UI.OneOffNoteBubble class categoriesForMethods!
addPreviouslyViewedNote:!private! !
defaultCaption!constants!private! !
defaultTimeout!constants!private! !
defaultWidth!constants!private! !
icon!constants!development!public! !
name:text:!instance creation!public! !
name:text:for:!instance creation!public! !
name:text:for:timeout:!instance creation!public! !
previouslyViewedNotes!accessing!public! !
previouslyViewedNotes:!accessing!public! !
registryKey!private! !
registryKeyName!constants!private! !
removePreviouslyViewedNote:!private! !
resetPreviouslyViewedNotes!private! !
!

