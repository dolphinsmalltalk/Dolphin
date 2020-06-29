"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaIndicator
	instanceVariableNames: 'styleName range tag'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScintillaIndicator guid: (GUID fromString: '{d8f9d545-39f0-4f15-b405-d14dfe355b3d}')!
ScintillaIndicator comment: 'ScintillaIndicators represent the indicators displayed as various styles of underlining in a <ScintillaView>.

Instance Variables:
	type	<Integer>. Id, normally in the range 1..3, of the corresponding <ScintillaIndicatorDefinition>.
	range	<Interval> in the text which is so highlighted.
	tag		<Object>. Any user-defined object to be associated with the indicator, e.g. for bubble help.'!
!ScintillaIndicator categoriesForClass!MVP-Views-Support! !
!ScintillaIndicator methodsFor!

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
!ScintillaIndicator categoriesFor: #printOn:!printing!public! !
!ScintillaIndicator categoriesFor: #range!accessing!public! !
!ScintillaIndicator categoriesFor: #setStyleName:range:tag:!initializing!private! !
!ScintillaIndicator categoriesFor: #styleName!public! !
!ScintillaIndicator categoriesFor: #tag!accessing!public! !

!ScintillaIndicator class methodsFor!

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
!ScintillaIndicator class categoriesFor: #icon!constants!development!public! !
!ScintillaIndicator class categoriesFor: #styleName:range:!instance creation!public! !
!ScintillaIndicator class categoriesFor: #styleName:range:tag:!instance creation!public! !

