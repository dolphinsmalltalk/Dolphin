"Filed out from Dolphin Smalltalk"!

UI.Scintilla.PropertyDescriptor
	subclass: #'UI.Scintilla.StringPropertyDescriptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.StringPropertyDescriptor guid: (Core.GUID fromString: '{fc6310e8-42ec-4f53-a598-b166926411df}')!
UI.Scintilla.StringPropertyDescriptor comment: '`StringPropertyDescriptor`s are `PropertyDescriptor`s for `ScintillaView` properties defined as being of `string` type in the scintilla.iface definition file.'!
!UI.Scintilla.StringPropertyDescriptor methodsFor!

getAttribute: aScintillaAttribute ofView: aScintillaView
	| text id len |
	id := aScintillaAttribute basicId.
	"First query the length, excluding the null"
	len := aScintillaView sendMessage: getMessage wParam: id.
	len == 0
		ifTrue: [text := self isNullable ifFalse: ['']]
		ifFalse: 
			["Now allocate a buffer and query the text"
			text := Utf8String new: len.
			aScintillaView
				sendMessage: getMessage
				wParam: id
				lpParam: text].
	^self setValueOfAttribute: aScintillaAttribute to: (text = defaultValue ifFalse: [text])!

getValueOfAttribute: aScintillaAttribute
	| value |
	value := aScintillaAttribute perform: getSelector.
	^value ifNotNil: [value asUtf8String]! !
!UI.Scintilla.StringPropertyDescriptor categoriesForMethods!
getAttribute:ofView:!operations!private! !
getValueOfAttribute:!private! !
!

