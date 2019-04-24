"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaPropertyDescriptor
	instanceVariableNames: 'getSelector defaultValue setMessage setSelector getMessage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaPropertyDescriptor guid: (GUID fromString: '{49848e62-c4d7-4cba-b9f5-71b0bf864a2a}')!
ScintillaPropertyDescriptor comment: '`ScintillaPropertyDescriptor`s provide metadata for individually settable scalar properties of a `ScintillaView`, e.g. the background colour of a marker.

## Instance Variables:
  `getSelector`		`Symbol`. Accessor message to send to object that represents the composite Scintilla attribute in order to retrieve the property value to send to the control.
  `defaultValue`	`<Object>`. Default value of the Scintilla property as initialized by the control.
  `setMessage`		`<integer>` id of the message to send to the control to set the property value, e.g. SCI_SETMARKERSETBACK
  `setSelector`		`Symbol`. Mutator message to send to object that represents the composite Scintilla attribute in order to set a property value retrieved from the control.
  `setMessage`		`<iInteger>` id of the message to send to the control to get the property value, e.g. SCI_GETMARKERSETBACK


'!
!ScintillaPropertyDescriptor categoriesForClass!Kernel-Objects! !
!ScintillaPropertyDescriptor methodsFor!

getAttribute: aScintillaAttribute ofView: aScintillaView
	| value |
	value := self
				valueFromLResult: (aScintillaView sendMessage: getMessage wParam: aScintillaAttribute basicId).
	^aScintillaAttribute perform: setSelector with: ((self isDefaultValue: value) ifFalse: [value])!

getAttributeValue: aScintillaAttribute
	^aScintillaAttribute perform: getSelector!

getSelector: aSymbol defaultValue: anObject setMessage: anInteger
	getSelector := aSymbol.
	defaultValue := anObject.
	setMessage := anInteger.
	^self!

isDefaultValue: anObject
	^anObject = defaultValue!

lParamFromAttributeValue: value
	^value asUIntPtr!

setAttribute: aScintillaAttribute ofView: aScintillaView initializing: aBoolean
	"Initialize the property described by the receiver of the attribute, aScintillaAttribute, of the control, aScintillaView, but only if it specified as a non-default value."

	| value |
	value := self getAttributeValue: aScintillaAttribute.
	aBoolean
		ifTrue: [(value isNil or: [self isDefaultValue: value]) ifTrue: [^self]]
		ifFalse: [value isNil ifTrue: [value := defaultValue]].
	aScintillaView
		sendMessage: setMessage
		wParam: aScintillaAttribute basicId
		lParam: (self lParamFromAttributeValue: value)!

setSelector: aSymbol getMessage: anInteger
	setSelector := aSymbol.
	getMessage := anInteger.
	^self!

valueFromLResult: anObject 
	^anObject! !
!ScintillaPropertyDescriptor categoriesFor: #getAttribute:ofView:!operations!private! !
!ScintillaPropertyDescriptor categoriesFor: #getAttributeValue:!operations!private! !
!ScintillaPropertyDescriptor categoriesFor: #getSelector:defaultValue:setMessage:!initializing!private! !
!ScintillaPropertyDescriptor categoriesFor: #isDefaultValue:!operations!private! !
!ScintillaPropertyDescriptor categoriesFor: #lParamFromAttributeValue:!helpers!private! !
!ScintillaPropertyDescriptor categoriesFor: #setAttribute:ofView:initializing:!helpers!private! !
!ScintillaPropertyDescriptor categoriesFor: #setSelector:getMessage:!initializing!private! !
!ScintillaPropertyDescriptor categoriesFor: #valueFromLResult:!helpers!private! !

!ScintillaPropertyDescriptor class methodsFor!

getSelector: aSymbol defaultValue: anObject setMessage: anInteger
	^self new
		getSelector: aSymbol
		defaultValue: anObject
		setMessage: anInteger!

getSelector: getSymbol defaultValue: anObject setMessage: setInteger setSelector: setSymbol getMessage: getInteger
	^(self
		getSelector: getSymbol
		defaultValue: anObject
		setMessage: setInteger) setSelector: setSymbol getMessage: getInteger!

icon
	^ScintillaView icon! !
!ScintillaPropertyDescriptor class categoriesFor: #getSelector:defaultValue:setMessage:!instance creation!public! !
!ScintillaPropertyDescriptor class categoriesFor: #getSelector:defaultValue:setMessage:setSelector:getMessage:!instance creation!public! !
!ScintillaPropertyDescriptor class categoriesFor: #icon!constants!development!public! !

