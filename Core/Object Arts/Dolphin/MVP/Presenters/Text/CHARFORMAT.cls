"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #CHARFORMAT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants RichEditConstants'
	classInstanceVariableNames: ''!
CHARFORMAT guid: (GUID fromString: '{87b4c5cf-026e-11d3-9fd7-00a0cc3e4a32}')!
CHARFORMAT comment: 'CHARFORMAT is an <ExternalStructure> class to represent the Win32 structure of the same name.

The CHARFORMAT structure contains information about character formatting in a rich edit control.'!
!CHARFORMAT categoriesForClass!External-Data-Structured-Win32! !
!CHARFORMAT methodsFor!

bCharSet
	"Answer the receiver's bCharSet field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bCharSet)!

bCharSet: anObject 
	"Set the receiver's bCharSet field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #bCharSet) put: anObject!

beBold
	"Set the character bold effect on."

	self isBold: true!

beItalic
	"Set the character italic effect on."

	self isItalic: true!

beNotBold
	"Set the character bold effect off."

	self isBold: false!

beNotItalic
	"Set the character italic effect off."

	self isItalic: false!

beNotUnderlined
	"Set the character underline effect off."

	self isUnderlined: false!

bePlain
	"Remove all text effects (such as bold, italic, etc)"

	self maskIn: ##(CFM_BOLD|CFM_ITALIC|CFM_UNDERLINE|CFM_STRIKEOUT).
	self dwEffects: 0!

beUnderlined
	"Set the character underline effect on."

	self isUnderlined: true!

bPitchAndFamily
	"Answer the receiver's bPitchAndFamily field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bPitchAndFamily)!

bPitchAndFamily: anObject 
	"Set the receiver's bPitchAndFamily field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #bPitchAndFamily) put: anObject!

characterSet
	^(self maskAny: CFM_CHARSET) ifTrue: [self bCharSet]!

characterSet: anIntegerOrNil 
	"Set the desired character set (permitted values of lfCharSet member of LOGFONT on MSDN)."

	self maskIn: CFM_CHARSET.
	self bCharSet: anIntegerOrNil!

color
	"Answer the character colour."

	^Color fromInteger: self crTextColor!

color: aColor 
	"Set the character colour."

	self maskIn: CFM_COLOR.
	self crTextColor: (aColor ifNil: [Color windowText]) asColorRef asParameter!

crTextColor
	"Answer the receiver's crTextColor field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #crTextColor)!

crTextColor: anObject 
	"Set the receiver's crTextColor field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #crTextColor) put: anObject!

dwEffects
	"Answer the receiver's dwEffects field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwEffects)!

dwEffects: anObject 
	"Set the receiver's dwEffects field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwEffects) put: anObject!

dwMask
	"Answer the receiver's dwMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwMask)!

dwMask: anObject 
	"Set the receiver's dwMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwMask) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

effectsAny: anInteger
	"Private - Answer true if the effects member contains the bit flags represented by anInteger."

	^self dwEffects anyMask: anInteger!

faceName: aString
	"Set the character face name.
	Note that the szFaceName member is an embedded string, rather than a pointer,
	and there is, therefore, no need to save down a reference to aString."

	self maskIn: CFM_FACE.
	self szFaceName: aString!

font
	^Font fromLogFont: self logFont!

font: aFont 
	"Set the character font."

	| lf |
	lf := aFont logFont.
	self
		faceName: aFont name;
		pointSize: aFont pointSize;
		characterSet: lf lfCharSet;
		bPitchAndFamily: lf lfPitchAndFamily;
		isBold: aFont isBold;
		isItalic: aFont isItalic;
		isUnderlined: aFont isUnderlined;
		isStruckThrough: aFont isStruckThrough!

height: aNumber
	"Set the receiver's height field to anInteger (N.B.
	the height is specified in half points)."

	self maskIn: CFM_SIZE.
	self yHeight: aNumber asInteger!

isBold
	"Answer the character bold effect."

	^(self maskAny: CFM_BOLD) and: [self effectsAny: CFE_BOLD].
!

isBold: aBoolean
	"Set the character bold effect."

	self setEffect: CFE_BOLD mask: CFM_BOLD set: aBoolean!

isItalic
	"Answer the character italic effect."

	^(self maskAny: CFM_ITALIC) and: [self effectsAny: CFE_ITALIC].
!

isItalic: aBoolean
	"Set the character italic effect."

	self setEffect: CFE_ITALIC mask: CFM_ITALIC set: aBoolean!

isStruckThrough
	"Answer whether the strike-out effect is set."

	^(self maskAny: CFM_STRIKEOUT) and: [self effectsAny: CFE_STRIKEOUT].
!

isStruckThrough: aBoolean
	"Set the struck out character effect."

	self setEffect: CFE_STRIKEOUT mask: CFM_STRIKEOUT set: aBoolean
!

isUnderlined
	"Answer the character underline effect."

	^(self maskAny: CFM_UNDERLINE) and: [self effectsAny: CFE_UNDERLINE].
!

isUnderlined: aBoolean
	"Set the character underline effect."

	self setEffect: CFE_UNDERLINE mask: CFM_UNDERLINE set: aBoolean!

logFont
	"Answer a <LOGFONTW> configured with the font settings from the receiver. The display resolution is assumed in converting from the point size to font height."

	| answer |
	answer := LOGFONTW new.
	answer faceName: self szFaceName.
	answer lfHeight: (self pointSize * Canvas desktopResolution y / 72) rounded negated.
	answer lfWeight: (self isBold ifTrue: [FW_BOLD] ifFalse: [FW_NORMAL]).
	answer lfItalic: self isItalic asParameter.
	answer lfUnderline: self isUnderlined asParameter.
	answer lfStrikeOut: self isStruckThrough asParameter.
	self characterSet ifNotNil: [:script | answer lfCharSet: script].
	^answer!

maskAny: anInteger
	"Private - Answer true if the mask member contains the bit flags represented by anInteger."

	^self dwMask anyMask: anInteger!

maskIn: anInteger
	"Private - OR in to contents mask member the bit flags represented by anInteger.
	Answer the receiver."

	self dwMask: (self dwMask bitOr: anInteger)!

maskOut: anInteger 
	self dwMask: (self dwMask maskClear: anInteger)!

pointSize
	"Answer the receiver's height field in points (N.B. the answer may be
	a Fraction if the, for example, the size if 10.5 points)."

	^self yHeight / 20!

pointSize: aNumber
	"Set the receiver's height field to  aNumber points (aNumber 
	need not be integral)."

	self height: aNumber * 20!

populateChooseFont: aCHOOSEFONT 
	"Private - Set up the CHOOSEFONT argument appropriately for the <FontDialog> to modify the
	character format settings in the receiver. The receiver's mask tells us which settings are
	consistent across the entire selection range, so we set up the dialog so that this is clear
	to the user (e.g. there will be no selections for values which are not common)."

	| flags mask |
	flags := aCHOOSEFONT flags.
	aCHOOSEFONT logFont: self logFont.
	mask := self dwMask.
	(mask allMask: CFM_FACE) ifFalse: [flags := flags bitOr: CF_NOFACESEL].
	"Only enables effects portion of the dialog if colour and other effects are consistent"
	(mask allMask: ##(CFM_STRIKEOUT | CFM_UNDERLINE | CFM_COLOR)) 
		ifTrue: [flags := flags bitOr: CF_EFFECTS].
	(mask allMask: ##(CFM_BOLD | CFM_ITALIC | CFM_UNDERLINE)) 
		ifFalse: [flags := flags bitOr: CF_NOSTYLESEL].
	(mask allMask: CFM_SIZE) ifFalse: [flags := flags bitOr: CF_NOSIZESEL].
	(mask allMask: CFM_CHARSET) ifFalse: [flags := flags bitOr: CF_NOSCRIPTSEL].
	aCHOOSEFONT flags: flags.
	aCHOOSEFONT color: self color!

populateFromChooseFont: aCHOOSEFONT 
	| lf flags |
	flags := aCHOOSEFONT flags.
	lf := aCHOOSEFONT lpLogFont.
	"Did the user select a font face?"
	(flags allMask: CF_NOFACESEL) ifFalse: [self faceName: lf lfFaceName].
	"Did the user select a script/charset?"
	(flags allMask: CF_NOSCRIPTSEL) ifFalse: [self characterSet: lf lfCharSet].
	"Did the user select a point size?"
	(flags allMask: CF_NOSIZESEL) ifFalse: [self pointSize: aCHOOSEFONT iPointSize / 10].
	"Did the user make a style selection?"
	(flags allMask: CF_NOSTYLESEL) 
		ifFalse: 
			[self
				isBold: lf lfWeight >= FW_BOLD;
				isItalic: lf lfItalic asBoolean].
	(flags allMask: CF_EFFECTS) ifFalse: [^self].
	self isUnderlined: lf lfUnderline asBoolean.
			self isStruckThrough: lf lfStrikeOut asBoolean.
	self color: aCHOOSEFONT color!

setEffect: effectFlag mask: effectMask set: aBoolean
	"Private - Set/reset an effect such as underlined, bold, etc."

	self maskIn: effectMask.
	self dwEffects: (self dwEffects mask: effectFlag set: aBoolean)
!

size: twips
	"Set the character size."

	self maskIn: CFM_SIZE.
	self yHeight: twips
!

szFaceName
	"Answer the receiver's szFaceName field as a Smalltalk object."

	^String fromAddress: bytes yourAddress + ##(self offsetOf: #szFaceName)!

szFaceName: anObject 
	"Set the receiver's szFaceName field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: 31.
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szFaceName) + 1)
		to: ##(self offsetOf: #szFaceName) + size
		startingAt: 1.
	bytes byteAtOffset: ##(self offsetOf: #szFaceName) + size put: 0!

yHeight
	"Answer the receiver's yHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #yHeight)!

yHeight: anObject 
	"Set the receiver's yHeight field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #yHeight) put: anObject! !
!CHARFORMAT categoriesFor: #bCharSet!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #bCharSet:!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #beBold!accessing!public! !
!CHARFORMAT categoriesFor: #beItalic!accessing!public! !
!CHARFORMAT categoriesFor: #beNotBold!accessing!public! !
!CHARFORMAT categoriesFor: #beNotItalic!accessing!public! !
!CHARFORMAT categoriesFor: #beNotUnderlined!accessing!public! !
!CHARFORMAT categoriesFor: #bePlain!modes!public! !
!CHARFORMAT categoriesFor: #beUnderlined!accessing!public! !
!CHARFORMAT categoriesFor: #bPitchAndFamily!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #bPitchAndFamily:!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #characterSet!public! !
!CHARFORMAT categoriesFor: #characterSet:!accessing!public! !
!CHARFORMAT categoriesFor: #color!accessing!public! !
!CHARFORMAT categoriesFor: #color:!accessing!public! !
!CHARFORMAT categoriesFor: #crTextColor!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #crTextColor:!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #dwEffects!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #dwEffects:!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #dwMask!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #dwMask:!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #dwSize:!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #effectsAny:!accessing!private! !
!CHARFORMAT categoriesFor: #faceName:!accessing!public! !
!CHARFORMAT categoriesFor: #font!accessing!public! !
!CHARFORMAT categoriesFor: #font:!accessing!public! !
!CHARFORMAT categoriesFor: #height:!accessing!public! !
!CHARFORMAT categoriesFor: #isBold!public!testing! !
!CHARFORMAT categoriesFor: #isBold:!accessing!public! !
!CHARFORMAT categoriesFor: #isItalic!accessing!public! !
!CHARFORMAT categoriesFor: #isItalic:!accessing!public! !
!CHARFORMAT categoriesFor: #isStruckThrough!public!testing! !
!CHARFORMAT categoriesFor: #isStruckThrough:!accessing!public! !
!CHARFORMAT categoriesFor: #isUnderlined!accessing!public! !
!CHARFORMAT categoriesFor: #isUnderlined:!accessing!public! !
!CHARFORMAT categoriesFor: #logFont!public! !
!CHARFORMAT categoriesFor: #maskAny:!accessing!private! !
!CHARFORMAT categoriesFor: #maskIn:!accessing!private! !
!CHARFORMAT categoriesFor: #maskOut:!private! !
!CHARFORMAT categoriesFor: #pointSize!accessing!public! !
!CHARFORMAT categoriesFor: #pointSize:!accessing!public! !
!CHARFORMAT categoriesFor: #populateChooseFont:!private! !
!CHARFORMAT categoriesFor: #populateFromChooseFont:!private! !
!CHARFORMAT categoriesFor: #setEffect:mask:set:!accessing!private! !
!CHARFORMAT categoriesFor: #size:!accessing!public! !
!CHARFORMAT categoriesFor: #szFaceName!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #szFaceName:!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #yHeight!**compiled accessors**!public! !
!CHARFORMAT categoriesFor: #yHeight:!**compiled accessors**!public! !

!CHARFORMAT class methodsFor!

defineFields
	"Define the layout of the CHARFORMAT structure
		CHARFORMAT compileDefinition
	"

	self defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #dwMask type: DWORDField new;
		defineField: #dwEffects type: DWORDField new;
		defineField: #yHeight type: SDWORDField new;
		defineField: #yOffset type: SDWORDField new beUncompiled;
		defineField: #crTextColor type: DWORDField new;
		defineField: #bCharSet type: BYTEField new;
		defineField: #bPitchAndFamily type: BYTEField new;
		defineField: #szFaceName type: (StringField length: 32)!

fromChooseFont: aCHOOSEFRONT 
	^(self new)
		populateFromChooseFont: aCHOOSEFRONT;
		yourself! !
!CHARFORMAT class categoriesFor: #defineFields!initializing!public! !
!CHARFORMAT class categoriesFor: #fromChooseFont:!public! !

