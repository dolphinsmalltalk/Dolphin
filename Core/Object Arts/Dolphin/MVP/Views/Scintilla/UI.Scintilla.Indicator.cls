"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.Scintilla.Indicator'
	instanceVariableNames: 'styleName range tag'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Indicator guid: (Core.GUID fromString: '{d8f9d545-39f0-4f15-b405-d14dfe355b3d}')!
UI.Scintilla.Indicator comment: 'ScintillaIndicators represent the indicators displayed as various styles of underlining in a <ScintillaView>.

Instance Variables:
	type	<Integer>. Id, normally in the range 1..3, of the corresponding <ScintillaIndicatorDefinition>.
	range	<Interval> in the text which is so highlighted.
	tag		<Object>. Any user-defined object to be associated with the indicator, e.g. for bubble help.'!
!UI.Scintilla.Indicator categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.Indicator methodsFor!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(;
		display: self styleName;
		nextPutAll: ': ';
		display: self range;
		nextPut: $)!

range
	"Answer the <Interval> of text highlighted by this indicator."

	^range!

setStyleName: aSymbolOrInteger range: anInterval tag: anObject 
	styleName := aSymbolOrInteger.
	range := anInterval.
	tag := anObject!

styleName
	"Answer the symbolic name of the style of indicator to be used to represent the receiver in
	the <ScintillaView>. It is expected that the view will have a <ScintillaIndicatorStyle>
	defined of the same name that specifies the style of indicator drawn, it's colour, etc. If
	there is no such indicator style, then the standard indicator 0 is used. The name could also
	be an integer id from 0 to 7 if identifying one of the styles reserved for use by lexers, in
	which case no corresponding style need be defined in the view."

	^styleName!

tag
	"Answer a user-defined <Object> associated with the indicator. This could be used, for
	example, to provide bubble help explaining the indicator."

	^tag! !
!UI.Scintilla.Indicator categoriesFor: #printOn:!printing!public! !
!UI.Scintilla.Indicator categoriesFor: #range!accessing!public! !
!UI.Scintilla.Indicator categoriesFor: #setStyleName:range:tag:!initializing!private! !
!UI.Scintilla.Indicator categoriesFor: #styleName!public! !
!UI.Scintilla.Indicator categoriesFor: #tag!accessing!public! !

!UI.Scintilla.Indicator class methodsFor!

icon
	^ScintillaView icon!

styleName: aSymbolOrInteger range: anInterval 
	^self 
		styleName: aSymbolOrInteger
		range: anInterval
		tag: nil!

styleName: aSymbolOrInteger range: anInterval tag: anObject 
	<primitive: 157>
	^(self new)
		setStyleName: aSymbolOrInteger
			range: anInterval
			tag: anObject;
		yourself! !
!UI.Scintilla.Indicator class categoriesFor: #icon!constants!development!public! !
!UI.Scintilla.Indicator class categoriesFor: #styleName:range:!instance creation!public! !
!UI.Scintilla.Indicator class categoriesFor: #styleName:range:tag:!instance creation!public! !

