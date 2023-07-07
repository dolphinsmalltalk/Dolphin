"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.PropertyDescriptor'
	instanceVariableNames: 'key getSelector defaultValue setMessage setSelector getMessage flags printSelector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'AlwaysPrintMask' -> 16r1. 'NonBrowsableMask' -> 16r4. 'NullableMask' -> 16r2 }!
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

defaultValue: anObject
	defaultValue := anObject!

getAttribute: aScintillaAttribute ofView: aScintillaView
	| value |
	value := self
				valueFromLResult: (aScintillaView sendMessage: getMessage wParam: aScintillaAttribute basicId).
	^self setValueOfAttribute: aScintillaAttribute to: (value = defaultValue ifFalse: [value])!

getMessage: anInteger
	getMessage := anInteger!

getPrintString: aSymbol of: aScintillaAttribute
	^printSelector
		ifNil: 
			[(self alwaysPrint or: [self shouldPrint: aScintillaAttribute])
				ifTrue: [(aScintillaAttribute perform: aSymbol) printString]]
		ifNotNil: [aScintillaAttribute perform: printSelector]!

getSelector: aSymbol
	getSelector := aSymbol!

getValueOfAttribute: aScintillaAttribute
	^aScintillaAttribute perform: getSelector!

initialize
	flags := self defaultFlags!

initializeAttribute: aScintillaAttribute ofView: aScintillaView
	"Set the property described by the receiver of the attribute, aScintillaAttribute, of the control, aScintillaView, as if initializing a new view instance. This differs from #setAttribute:ofView: in that the property will only be transferred to the view if it has a non-nil, non-default value."

	| value |
	value := self getValueOfAttribute: aScintillaAttribute.
	(value isNil or: [value = defaultValue]) ifTrue: [^self].
	aScintillaView
		sendMessage: setMessage
		wParam: aScintillaAttribute basicId
		lParam: (self lParamFromAttributeValue: value)!

isNonBrowsable
	^flags allMask: NonBrowsableMask!

isNonBrowsable: aBoolean
	flags := flags mask: NonBrowsableMask set: aBoolean!

isNullable
	^flags allMask: NullableMask!

isNullable: aBoolean
	flags := flags mask: NullableMask set: aBoolean!

key
	^key!

key: aSymbol defaultValue: anObject setMessage: anInteger
	self initialize.
	key := getSelector := aSymbol.
	defaultValue := anObject.
	setMessage := anInteger.
	^self!

lParamFromAttributeValue: value
	^value asUIntPtr!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: getSelector;
		nextPut: $)!

printPropertyOf: aScintillaAttribute on: aStream
	printSelector
		ifNil: 
			[(self alwaysPrint or: [self shouldPrint: aScintillaAttribute]) ifFalse: [^self].
			aStream
				nextPutAll: ', ';
				nextPutAll: key;
				nextPut: $=;
				print: (aScintillaAttribute perform: key)]
		ifNotNil: 
			[(aScintillaAttribute perform: printSelector)
				ifNotNil: 
					[:valueString |
					aStream
						nextPutAll: ', ';
						nextPutAll: key;
						nextPut: $=;
						nextPutAll: valueString]]!

printSelector: aSymbol
	printSelector := aSymbol!

setAttribute: aScintillaAttribute ofView: aScintillaView
	"Set the property described by the receiver of the attribute, aScintillaAttribute, of the control, aScintillaView."

	| value |
	value := (self getValueOfAttribute: aScintillaAttribute) ?? defaultValue.
	value isNil ifTrue: [^self].
	aScintillaView
		sendMessage: setMessage
		wParam: aScintillaAttribute basicId
		lParam: (self lParamFromAttributeValue: value)!

setSelector: aSymbol
	setSelector := aSymbol!

setSelector: aSymbol getMessage: anInteger
	self setSelector: aSymbol.
	self getMessage: anInteger.
	^self!

setValueOfAttribute: aScintillaAttribute to: anObject
	^aScintillaAttribute perform: setSelector with: anObject!

shouldPrint: aScintillaAttribute
	| value |
	value := self getValueOfAttribute: aScintillaAttribute.
	^value notNil and: [value ~= defaultValue]!

valueFromLResult: anObject 
	^anObject! !
!UI.Scintilla.PropertyDescriptor categoriesForMethods!
alwaysPrint!public!testing! !
alwaysPrint:!accessing!public! !
beNullable!modes!public! !
defaultFlags!constants!private! !
defaultValue:!public! !
getAttribute:ofView:!operations!private! !
getMessage:!initializing!public! !
getPrintString:of:!printing!public! !
getSelector:!initializing!public! !
getValueOfAttribute:!private! !
initialize!initializing!private! !
initializeAttribute:ofView:!operations!private! !
isNonBrowsable!modes!public!testing! !
isNonBrowsable:!modes!public! !
isNullable!modes!public!testing! !
isNullable:!modes!public! !
key!accessing!public! !
key:defaultValue:setMessage:!initializing!private! !
lParamFromAttributeValue:!helpers!private! !
printOn:!printing!public! !
printPropertyOf:on:!development!helpers!printing!private! !
printSelector:!initializing!public! !
setAttribute:ofView:!operations!private! !
setSelector:!initializing!public! !
setSelector:getMessage:!initializing!private! !
setValueOfAttribute:to:!private! !
shouldPrint:!printing!private! !
valueFromLResult:!helpers!private! !
!

!UI.Scintilla.PropertyDescriptor class methodsFor!

icon
	^ScintillaView icon!

key: aSymbol defaultValue: anObject setMessage: anInteger
	^self new
		key: aSymbol
		defaultValue: anObject
		setMessage: anInteger! !
!UI.Scintilla.PropertyDescriptor class categoriesForMethods!
icon!constants!development!public! !
key:defaultValue:setMessage:!instance creation!public! !
!

