"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'UI.Scintilla.PropertyDescriptor'
	instanceVariableNames: 'getSelector defaultValue setMessage setSelector getMessage flags printSelector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AlwaysPrintMask' -> 16r1.
		'NonBrowsableMask' -> 16r4.
		'NullableMask' -> 16r2
	}!
UI.Scintilla.PropertyDescriptor guid: (Core.GUID fromString: '{49848e62-c4d7-4cba-b9f5-71b0bf864a2a}')!
UI.Scintilla.PropertyDescriptor isNonInstantiable: true!
UI.Scintilla.PropertyDescriptor comment: 'Scintilla `PropertyDescriptor`s provide metadata for individually settable scalar properties of a `ScintillaView`, e.g. the background colour of a marker.

## Instance Variables:
  `getSelector`		`Symbol`. Accessor message to send to object that represents the composite Scintilla attribute in order to retrieve the property value to send to the control.
  `defaultValue`	`<Object>`. Default value of the Scintilla property as initialized by the control.
  `setMessage`		`<integer>` id of the message to send to the control to set the property value, e.g. SCI_SETMARKERSETBACK
  `setSelector`		`Symbol`. Mutator message to send to object that represents the composite Scintilla attribute in order to set a property value retrieved from the control.
  `setMessage`		`<iInteger>` id of the message to send to the control to get the property value, e.g. SCI_GETMARKERSETBACK
  `flags`			`<integer>`
  `printSelector`	`Symbol`

## Class Variables:
  `AlwaysPrintMask`		`<integer>` flags mask for `alwaysPrint` setting.




'!
!UI.Scintilla.PropertyDescriptor categoriesForClass!Kernel-Objects! !
!UI.Scintilla.PropertyDescriptor methodsFor!

alwaysPrint
	^flags allMask: AlwaysPrintMask!

alwaysPrint: aBoolean
	flags := flags mask: AlwaysPrintMask set: aBoolean!

beNullable
	flags := flags bitOr: NullableMask!

defaultFlags
	^0!

getAttribute: aScintillaAttribute ofView: aScintillaView
	| value |
	value := self
				valueFromLResult: (aScintillaView sendMessage: getMessage wParam: aScintillaAttribute basicId).
	^aScintillaAttribute perform: setSelector with: (value = defaultValue ifFalse: [value])!

getPrintString: aSymbol of: aScintillaAttribute
	^printSelector
		ifNil: 
			[(self alwaysPrint or: 
					[| value |
					value := aScintillaAttribute perform: getSelector.
					value notNil and: [value ~= defaultValue]])
				ifTrue: [(aScintillaAttribute perform: aSymbol) printString]]
		ifNotNil: [aScintillaAttribute perform: printSelector]!

getSelector: aSymbol defaultValue: anObject setMessage: anInteger
	self initialize.
	getSelector := aSymbol.
	defaultValue := anObject.
	setMessage := anInteger.
	^self!

initialize
	flags := self defaultFlags!

isNonBrowsable
	^flags allMask: NonBrowsableMask!

isNonBrowsable: aBoolean
	flags := flags mask: NonBrowsableMask set: aBoolean!

isNullable
	^flags allMask: NullableMask!

isNullable: aBoolean
	flags := flags mask: NullableMask set: aBoolean!

lParamFromAttributeValue: value
	^value asUIntPtr!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: getSelector;
		nextPut: $)!

printSelector: aSymbol
	printSelector := aSymbol!

setAttribute: aScintillaAttribute ofView: aScintillaView initializing: aBoolean
	"Set the property described by the receiver of the attribute, aScintillaAttribute, of the control, aScintillaView.
	If the final boolean parameter is true, then the property is only set if the attribute has a non-default value."

	| value |
	value := aScintillaAttribute perform: getSelector.
	aBoolean
		ifTrue: [(value isNil or: [value = defaultValue]) ifTrue: [^self]]
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
!UI.Scintilla.PropertyDescriptor categoriesForMethods!
alwaysPrint!public!testing! !
alwaysPrint:!accessing!public! !
beNullable!modes!public! !
defaultFlags!constants!private! !
getAttribute:ofView:!operations!private! !
getPrintString:of:!helpers!private! !
getSelector:defaultValue:setMessage:!initializing!private! !
initialize!initializing!private! !
isNonBrowsable!modes!public!testing! !
isNonBrowsable:!modes!public! !
isNullable!modes!public!testing! !
isNullable:!modes!public! !
lParamFromAttributeValue:!helpers!private! !
printOn:!displaying!public! !
printSelector:!initializing!public! !
setAttribute:ofView:initializing:!operations!private! !
setSelector:getMessage:!initializing!private! !
valueFromLResult:!helpers!private! !
!

!UI.Scintilla.PropertyDescriptor class methodsFor!

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
!UI.Scintilla.PropertyDescriptor class categoriesForMethods!
getSelector:defaultValue:setMessage:!instance creation!public! !
getSelector:defaultValue:setMessage:setSelector:getMessage:!instance creation!public! !
icon!constants!development!public! !
!

