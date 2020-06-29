"Filed out from Dolphin Smalltalk 7"!

TextEdit subclass: #FormattedTextEdit
	instanceVariableNames: 'isFormatting messageBubble format separatorChars placeholderChar'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
FormattedTextEdit guid: (GUID fromString: '{da7e43da-5d5c-4332-a6d6-756996f820ee}')!
FormattedTextEdit comment: ''!
!FormattedTextEdit categoriesForClass!Unclassified! !
!FormattedTextEdit methodsFor!

applyFormat

	| inStream formatStream outStream text |

	inStream := ReadStream on: (self text reject: [ :char | self isSeparator: char]).
	formatStream := ReadStream on: self format.
	outStream := WriteStream on: (Utf16String new: self format size).

	[formatStream atEnd] whileFalse:
		[| char formatChar |
		formatChar := formatStream next.
		(self isSeparator: formatChar)
		ifTrue: 
			[char := formatChar]
		ifFalse:
			[inStream atEnd 
				ifTrue: [char := self placeholderChar]
				ifFalse: [char := inStream next]].
		outStream nextPut: char].

	text := outStream contents.
	self text: text.
	^text
	
!

clearMessageBubble

	self hasMessageBubble ifTrue: 
		[self messageBubble close.
		self messageBubble: nil]!

createMessageBubble

	"Return the new bubble"

	self messageBubble:
		(MessageBubble new
			owner: self;
			position: (self mapPoint: self clientRectangle bottomCenter to: View desktop);
			yourself).

	^self messageBubble!

enUpdate
	"Private - The receiver is about to display altered text.
	Note that this is fired when selecting text in the edit control, 
	as well as when keys are typed, but not when moving the caret 
	i.e. it indicates that the display has been updated."

	self isFormatting ifTrue: [^self].

	self formatDo: 
		[| pos text |
		pos := self caretPosition.
		text := self applyFormat.
		(pos < text size and: [self isSeparator: (text at: pos)]) ifTrue: [pos := pos + 1].
		self
			selectionRange: (pos to: (pos-1));
			invalidateUserInterface]!

errorTextInvalid

	self hasMessageBubble ifTrue: [^self].

	self createMessageBubble
		caption: 'Invalid Value';
		errorMsg: 'Please enter a valid value.'.

	self onModelChanged; tabFocus!

format
	^format!

format: anObject
	format := anObject!

formatDo: aBlock

	[self isFormatting: true.
	aBlock value] ensure: [self isFormatting: false]!

hasMessageBubble

	^self messageBubble notNil!

initialize

	super initialize.
	self isFormatting: false!

isFormatting
	^isFormatting!

isFormatting: anObject
	isFormatting := anObject!

isPlaceholder: aCharacter

	^self placeholderChar == aCharacter!

isSeparator: aCharacter

	^self separatorChars identityIncludes: aCharacter!

isTextValid

	^[self typeconverter convertFromRightToLeft: self displayValue.
	true]
		on: InvalidFormat
		do: [:exception | exception return: false]!

messageBubble
	^messageBubble!

messageBubble: anObject
	messageBubble := anObject!

onKeyPressed: aKeyEvent

	| code pos text |

	self clearMessageBubble.

	code := aKeyEvent code.
	pos := self caretPosition.
	text := self text.

	(code = VK_RIGHT and: [pos < text size and: [self isSeparator: (text at: (pos + 1))]]) ifTrue:
		[self caretPosition: pos + 1].
	
	(code = VK_LEFT and: [pos >1 and: [self isSeparator: (text at: (pos - 1))]]) ifTrue:
		[self caretPosition: pos - 1].

	code = VK_DELETE ifTrue: 
		[self sendMessage: WM_CHAR wParam: (self placeholderChar codePoint).
		^false].

	^super onKeyPressed: aKeyEvent
!

onKeyTyped: aKeyEvent

	| code char pos text range |

	self clearMessageBubble.

	code := aKeyEvent code.
	char := Character value: code.
	pos := self caretPosition.
	text := self text.

	(self isSeparator: char) ifTrue: 
		[| nextPos |
		nextPos := text nextIndexOf: char from: ((pos-1) max: 1) to: text size.
		nextPos > 0 ifTrue: 
			[self caretPosition: nextPos + 1.
			^false]].

	range := self selectionRange.
	code >= 32 ifTrue: [range isEmpty ifTrue: [self selectionRange: (range start to: range start)]].

	(char = Character backspace and: [pos > 1 and: [self isSeparator: (text at: (pos-1))]]) ifTrue: 
		[self caretPosition: (range start - 1)].

	^super onKeyTyped: aKeyEvent
!

onKillFocus

	self clearMessageBubble.

	SessionManager inputState queueDeferredAction: [self invalidate].
	^super onKillFocus!

onPaintRequired: aPaintEvent

	"Only sent if we don't want to display contents - so just erase"

	self isEnabled ifFalse: [aPaintEvent canvas backcolor: Color face3d].
	aPaintEvent canvas erase; free!

onSetFocus

	self enUpdate.

	"Defer the selectAll if we have no model so that it will always select all
	(without the defer, if focus was set by a click then the selectAll will be superceeded by moving the cursor to the click pos)"
	self model value isNil 
		ifTrue: [[self selectAll] postToInputQueue]
		ifFalse: [self selectAll].

	^super onSetFocus!

onViewCreated

	super onViewCreated.
	self typeconverter rightNullValue: self format.

	"Reused inst var; clear it out"
	self messageBubble: nil!

placeholderChar
	^placeholderChar!

placeholderChar: anObject
	placeholderChar := anObject!

separatorChars
	^separatorChars!

separatorChars: anObject
	separatorChars := anObject!

updateModel

	| newValue |

	self displayValue = self format
	ifTrue:
		[newValue := nil]
	ifFalse:
		[newValue := [self typeconverter convertFromRightToLeft: self displayValue]
					on: InvalidFormat
					do: [:exception | exception return: #failed]].

	newValue == #failed 
		ifTrue: [self errorTextInvalid]
		ifFalse: [self model value: newValue].

	self invalidateUserInterface!

wmPaint: message wParam: wParam lParam: lParam
	"Private - Controls do their own painting so only allow the default."

	self ensureLayoutValid ifTrue: [^1].
	^(self hasFocus or: [self text ~= self typeconverter rightNullValue])
		ifTrue: [self defaultWindowProcessing: message wParam: wParam lParam: lParam]
		ifFalse: [self basicPaint: message wParam: wParam lParam: lParam]
! !
!FormattedTextEdit categoriesFor: #applyFormat!helpers!private! !
!FormattedTextEdit categoriesFor: #clearMessageBubble!helpers!private! !
!FormattedTextEdit categoriesFor: #createMessageBubble!helpers!private! !
!FormattedTextEdit categoriesFor: #enUpdate!event handling-win32!private! !
!FormattedTextEdit categoriesFor: #errorTextInvalid!helpers!private! !
!FormattedTextEdit categoriesFor: #format!accessing!private! !
!FormattedTextEdit categoriesFor: #format:!accessing!private! !
!FormattedTextEdit categoriesFor: #formatDo:!helpers!private! !
!FormattedTextEdit categoriesFor: #hasMessageBubble!public!testing! !
!FormattedTextEdit categoriesFor: #initialize!initialize/release!public! !
!FormattedTextEdit categoriesFor: #isFormatting!accessing!private! !
!FormattedTextEdit categoriesFor: #isFormatting:!accessing!private! !
!FormattedTextEdit categoriesFor: #isPlaceholder:!public!testing! !
!FormattedTextEdit categoriesFor: #isSeparator:!public!testing! !
!FormattedTextEdit categoriesFor: #isTextValid!private!testing! !
!FormattedTextEdit categoriesFor: #messageBubble!accessing!private! !
!FormattedTextEdit categoriesFor: #messageBubble:!accessing!private! !
!FormattedTextEdit categoriesFor: #onKeyPressed:!event handling!public! !
!FormattedTextEdit categoriesFor: #onKeyTyped:!event handling!public! !
!FormattedTextEdit categoriesFor: #onKillFocus!event handling!private! !
!FormattedTextEdit categoriesFor: #onPaintRequired:!event handling!public! !
!FormattedTextEdit categoriesFor: #onSetFocus!event handling!public! !
!FormattedTextEdit categoriesFor: #onViewCreated!event handling!private! !
!FormattedTextEdit categoriesFor: #placeholderChar!accessing!private! !
!FormattedTextEdit categoriesFor: #placeholderChar:!accessing!private! !
!FormattedTextEdit categoriesFor: #separatorChars!accessing!private! !
!FormattedTextEdit categoriesFor: #separatorChars:!accessing!private! !
!FormattedTextEdit categoriesFor: #updateModel!helpers!private! !
!FormattedTextEdit categoriesFor: #wmPaint:wParam:lParam:!event handling-win32!public! !

!FormattedTextEdit class methodsFor!

stbConvertFrom: anSTBClassFormat

	anSTBClassFormat version <= 20 ifTrue:
		[^[:data || newInstance |
		newInstance := self basicNew.
		1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
		newInstance]].

	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^21! !
!FormattedTextEdit class categoriesFor: #stbConvertFrom:!binary filing!public! !
!FormattedTextEdit class categoriesFor: #stbVersion!binary filing!public! !

