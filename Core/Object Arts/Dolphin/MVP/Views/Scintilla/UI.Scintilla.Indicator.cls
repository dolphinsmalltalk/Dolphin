"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.Indicator'
	instanceVariableNames: 'typeName range tag'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Indicator guid: (Core.GUID fromString: '{d8f9d545-39f0-4f15-b405-d14dfe355b3d}')!
UI.Scintilla.Indicator comment: '`Scintilla.Indicator`s represent the indicators displayed as various styles of underlining in a `ScintillaView`.

Instance Variables:
	typeName	`Symbol` | `Integer`. Normally the type name of the corresponding <Scintilla.IndicatorDefinition>, but can be the id of a built-in indicator type.
	range		`Interval` in the text which is so highlighted.
	tag			`Object`. Any user-defined object to be associated with the indicator, e.g. for bubble help.'!
!UI.Scintilla.Indicator categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.Indicator methodsFor!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(;
		display: self typeName;
		nextPutAll: ': ';
		display: self range;
		nextPut: $)!

range
	"Answer the <Interval> of text highlighted by this indicator."

	^range!

setTypeName: aSymbolOrInteger range: anInterval tag: anObject
	typeName := aSymbolOrInteger.
	range := anInterval.
	tag := anObject!

tag
	"Answer a user-defined <Object> associated with the indicator. This could be used, for example, to provide bubble help explaining the indicator."

	^tag!

typeName
	"Answer the symbolic name of the type of indicator to be used to represent the receiver in the <ScintillaView>. It is expected that the view will have a <Scintilla.IndicatorDefinition>defined of the same type name that specifies the style of indicator drawn, it's colour, etc. If there is no such indicator definition, then the standard indicator 0 is used. The name could also be an integer id from 0 to 7 if identifying one of the indicator styles reserved for use by lexers, in which case no corresponding indicator need be defined in the view."

	^typeName! !
!UI.Scintilla.Indicator categoriesForMethods!
printOn:!printing!public! !
range!accessing!public! !
setTypeName:range:tag:!initializing!private! !
tag!accessing!public! !
typeName!accessing!public! !
!

!UI.Scintilla.Indicator class methodsFor!

icon
	^ScintillaView icon!

typeName: aSymbolOrInteger range: anInterval 
	^self 
		typeName: aSymbolOrInteger
		range: anInterval
		tag: nil!

typeName: aSymbolOrInteger range: anInterval tag: anObject 
"	<primitive: 157>"
	^(self new)
		setTypeName: aSymbolOrInteger
			range: anInterval
			tag: anObject;
		yourself! !
!UI.Scintilla.Indicator class categoriesForMethods!
icon!constants!development!public! !
typeName:range:!instance creation!public! !
typeName:range:tag:!instance creation!public! !
!

