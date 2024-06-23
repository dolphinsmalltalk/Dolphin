"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.StringFormatInitializer
	subclass: #'Graphics.Gdiplus.StringFormatGenericInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.StringFormatGenericInitializer guid: (Core.GUID fromString: '{acf75353-2f30-4d26-95da-4e507476c2f7}')!

Graphics.Gdiplus.StringFormatGenericInitializer isNonInstantiable: true!

Graphics.Gdiplus.StringFormatGenericInitializer comment: ''!

!Graphics.Gdiplus.StringFormatGenericInitializer methodsFor!

alignmentOf: aStringFormat set: aStringAlignmentConstant
	(self copyGenericInstance: aStringFormat) alignmentOf: aStringFormat set: aStringAlignmentConstant!

copyGenericInstance: aStringFormat
	"Private - Gdiplus has singleton generic default and typographic instances, but they are modifiable so we must be careful not to have side effects on these.
	If an attempt is made to modify a generic instance, we make a non-generic copy and modify that."

	| newInitializer |
	newInitializer := StringFormatFromFlagsInitializer fromHandle: aStringFormat handle.
	aStringFormat initializer: newInitializer.
	aStringFormat clearCached.
	^newInitializer!

digitSubstitutionOf: aStringFormat set: aStringDigitSubstituteConstant
	(self copyGenericInstance: aStringFormat) digitSubstitutionOf: aStringFormat
		set: aStringDigitSubstituteConstant!

flagsOf: aStringFormat set: anInteger
	(self copyGenericInstance: aStringFormat) flagsOf: aStringFormat set: anInteger!

hotkeyPrefixOf: aStringFormat set: aHotkeyPrefixConstant
	(self copyGenericInstance: aStringFormat) hotkeyPrefixOf: aStringFormat set: aHotkeyPrefixConstant!

isSelfEvaluating
	^true!

lineAlignmentOf: aStringFormat set: aStringAlignmentConstant
	(self copyGenericInstance: aStringFormat) lineAlignmentOf: aStringFormat
		set: aStringAlignmentConstant!

measurableCharacterRangesOf: aGdiplusStringFormat set: aCollectionOfIntervals
	(self copyGenericInstance: aGdiplusStringFormat) measurableCharacterRangesOf: aGdiplusStringFormat
		set: aCollectionOfIntervals!

tabOffsetsOf: aGdiplusStringFormat set: aFLOATArray
	(self copyGenericInstance: aGdiplusStringFormat) tabOffsetsOf: aGdiplusStringFormat set: aFLOATArray!

trimmingOf: aStringFormat set: aStringTrimmingConstant
	(self copyGenericInstance: aStringFormat) trimmingOf: aStringFormat set: aStringTrimmingConstant! !

!Graphics.Gdiplus.StringFormatGenericInitializer categoriesForMethods!
alignmentOf:set:!attributes!public! !
copyGenericInstance:!helpers!private! !
digitSubstitutionOf:set:!attributes!public! !
flagsOf:set:!attributes!public! !
hotkeyPrefixOf:set:!attributes!public! !
isSelfEvaluating!public!testing! !
lineAlignmentOf:set:!attributes!public! !
measurableCharacterRangesOf:set:!accessing!public! !
tabOffsetsOf:set:!accessing!public! !
trimmingOf:set:!attributes!public! !
!

