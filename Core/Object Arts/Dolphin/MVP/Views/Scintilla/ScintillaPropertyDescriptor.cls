"Filed out from Dolphin Smalltalk"!

Object subclass: #ScintillaPropertyDescriptor
	instanceVariableNames: 'getSelector defaultValue setMessage setSelector getMessage flags'
	classVariableNames: 'AlwaysPrintMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaPropertyDescriptor guid: (GUID fromString: '{49848e62-c4d7-4cba-b9f5-71b0bf864a2a}')!

ScintillaPropertyDescriptor addClassConstant: 'AlwaysPrintMask' value: 16r1!

ScintillaPropertyDescriptor comment: '`ScintillaPropertyDescriptor`s provide metadata for individually settable scalar properties of a `ScintillaView`, e.g. the background colour of a marker.

## Instance Variables:
  `getSelector`		`Symbol`. Accessor message to send to object that represents the composite Scintilla attribute in order to retrieve the property value to send to the control.
  `defaultValue`	`<Object>`. Default value of the Scintilla property as initialized by the control.
  `setMessage`		`<integer>` id of the message to send to the control to set the property value, e.g. SCI_SETMARKERSETBACK
  `setSelector`		`Symbol`. Mutator message to send to object that represents the composite Scintilla attribute in order to set a property value retrieved from the control.
  `setMessage`		`<iInteger>` id of the message to send to the control to get the property value, e.g. SCI_GETMARKERSETBACK
  `flags`			`<integer>`

## Class Variables:
  `AlwaysPrintMask`		`<integer>` flags mask for `alwaysPrint` setting.




'!

!ScintillaPropertyDescriptor categoriesForClass!Kernel-Objects! !

!ScintillaPropertyDescriptor methodsFor!

alwaysPrint
	^flags allMask: AlwaysPrintMask!

alwaysPrint: aBoolean
	flags := flags mask: AlwaysPrintMask set: aBoolean!

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
	flags := 0.
	^self!

isDefaultValue: anObject
	^anObject = defaultValue!

lParamFromAttributeValue: value
	^value asUIntPtr!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: getSelector;
		nextPut: $)!

setAttribute: aScintillaAttribute ofView: aScintillaView initializing: aBoolean
	"Set the property described by the receiver of the attribute, aScintillaAttribute, of the control, aScintillaView.
	If the final boolean parameter is true, then the property is only set if the attribute has a non-default value."

	| value |
	value := aScintillaAttribute perform: getSelector.
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

!ScintillaPropertyDescriptor categoriesForMethods!
alwaysPrint!public!testing! !
alwaysPrint:!accessing!public! !
getAttribute:ofView:!operations!private! !
getAttributeValue:!operations!private! !
getSelector:defaultValue:setMessage:!initializing!private! !
isDefaultValue:!operations!private! !
lParamFromAttributeValue:!helpers!private! !
printOn:!displaying!public! !
setAttribute:ofView:initializing:!helpers!private! !
setSelector:getMessage:!initializing!private! !
valueFromLResult:!helpers!private! !
!

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

!ScintillaPropertyDescriptor class categoriesForMethods!
getSelector:defaultValue:setMessage:!instance creation!public! !
getSelector:defaultValue:setMessage:setSelector:getMessage:!instance creation!public! !
icon!constants!development!public! !
!

