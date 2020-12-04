"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.CHARFORMAT2W'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommonDialogConstants} #{OS.RichEditConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bAnimation' -> 16r71.
		'_OffsetOf_bCharSet' -> 16r18.
		'_OffsetOf_bPitchAndFamily' -> 16r19.
		'_OffsetOf_bRevAuthor' -> 16r72.
		'_OffsetOf_bUnderlineColor' -> 16r73.
		'_OffsetOf_bUnderlyineType' -> 16r70.
		'_OffsetOf_crBackColor' -> 16r60.
		'_OffsetOf_crTextColor' -> 16r14.
		'_OffsetOf_dwCookie' -> 16r68.
		'_OffsetOf_dwEffects' -> 16r8.
		'_OffsetOf_dwMask' -> 16r4.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_lcid' -> 16r64.
		'_OffsetOf_sSpacing' -> 16r5C.
		'_OffsetOf_sStyle' -> 16r6C.
		'_OffsetOf_szFaceName' -> 16r1A.
		'_OffsetOf_wKerning' -> 16r6E.
		'_OffsetOf_wWeight' -> 16r5A.
		'_OffsetOf_yHeight' -> 16rC.
		'_OffsetOf_yOffset' -> 16r10
	}!
OS.CHARFORMAT2W guid: (Core.GUID fromString: '{87b4c5cf-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.CHARFORMAT2W comment: 'CHARFORMAT2W is an <ExternalStructure> class to represent the Win32 structure of the same name.

The CHARFORMAT2W structure contains information about character formatting in a rich edit control.'!
!OS.CHARFORMAT2W categoriesForClass!External-Data-Structured-Win32! !
!OS.CHARFORMAT2W methodsFor!

bAnimation
	"Answer the <Integer> value of the receiver's 'bAnimation' field."

	^bytes byteAtOffset: _OffsetOf_bAnimation!

bAnimation: anInteger
	"Set the receiver's 'bAnimation' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bAnimation put: anInteger!

bCharSet
	"Answer the <Integer> value of the receiver's 'bCharSet' field."

	^bytes byteAtOffset: _OffsetOf_bCharSet!

bCharSet: anInteger
	"Set the receiver's 'bCharSet' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bCharSet put: anInteger!

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
	"Answer the <Integer> value of the receiver's 'bPitchAndFamily' field."

	^bytes byteAtOffset: _OffsetOf_bPitchAndFamily!

bPitchAndFamily: anInteger
	"Set the receiver's 'bPitchAndFamily' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bPitchAndFamily put: anInteger!

bRevAuthor
	"Answer the <Integer> value of the receiver's 'bRevAuthor' field."

	^bytes byteAtOffset: _OffsetOf_bRevAuthor!

bRevAuthor: anInteger
	"Set the receiver's 'bRevAuthor' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bRevAuthor put: anInteger!

bUnderlineColor
	"Answer the <Integer> value of the receiver's 'bUnderlineColor' field."

	^bytes byteAtOffset: _OffsetOf_bUnderlineColor!

bUnderlineColor: anInteger
	"Set the receiver's 'bUnderlineColor' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bUnderlineColor put: anInteger!

bUnderlyineType
	"Answer the <Integer> value of the receiver's 'bUnderlyineType' field."

	^bytes byteAtOffset: _OffsetOf_bUnderlyineType!

bUnderlyineType: anInteger
	"Set the receiver's 'bUnderlyineType' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bUnderlyineType put: anInteger!

characterSet
	^(self maskAny: CFM_CHARSET) ifTrue: [self bCharSet]!

characterSet: anIntegerOrNil 
	"Set the desired character set (permitted values of lfCharSet member of LOGFONT on MSDN)."

	self maskIn: CFM_CHARSET.
	self bCharSet: anIntegerOrNil!

color
	"Answer the character colour."

	^Graphics.Color fromCOLORREF: self crTextColor!

color: aColor
	"Set the character colour."

	self maskIn: CFM_COLOR.
	self crTextColor: (aColor ifNil: [Graphics.Color windowText]) asCOLORREF!

crBackColor
	"Answer the <Integer> value of the receiver's 'crBackColor' field."

	^bytes dwordAtOffset: _OffsetOf_crBackColor!

crBackColor: anInteger
	"Set the receiver's 'crBackColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_crBackColor put: anInteger!

crTextColor
	"Answer the <Integer> value of the receiver's 'crTextColor' field."

	^bytes dwordAtOffset: _OffsetOf_crTextColor!

crTextColor: anInteger
	"Set the receiver's 'crTextColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_crTextColor put: anInteger!

dwEffects
	"Answer the <Integer> value of the receiver's 'dwEffects' field."

	^bytes dwordAtOffset: _OffsetOf_dwEffects!

dwEffects: anInteger
	"Set the receiver's 'dwEffects' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwEffects put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwMask put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

effectsAny: anInteger
	"Private - Answer true if the effects member contains the bit flags represented by anInteger."

	^self dwEffects anyMask: anInteger!

faceName: aString
	"Set the character face name.
	Note that the szFaceName member is an embedded string, rather than a pointer,
	and there is, therefore, no need to save down a reference to aString."

	self maskIn: CFM_FACE.
	self szFaceName: aString asUtf16String!

font
	^Graphics.Font fromLogFont: self logFont!

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

lcid
	"Answer the <Integer> value of the receiver's 'lcid' field."

	^bytes dwordAtOffset: _OffsetOf_lcid!

lcid: anInteger
	"Set the receiver's 'lcid' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcid put: anInteger!

logFont
	"Answer a <LOGFONTW> configured with the font settings from the receiver. The display resolution is assumed in converting from the point size to font height."

	| answer |
	answer := LOGFONTW new.
	answer faceName: self szFaceName.
	answer lfHeight: (self pointSize * Graphics.Canvas desktopResolution y / 72) rounded negated.
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
	(flags allMask: CF_NOFACESEL) ifFalse: [self faceName: lf faceName].
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

sSpacing
	"Answer the <Integer> value of the receiver's 'sSpacing' field."

	^bytes swordAtOffset: _OffsetOf_sSpacing!

sSpacing: anInteger
	"Set the receiver's 'sSpacing' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_sSpacing put: anInteger!

sStyle
	"Answer the <Integer> value of the receiver's 'sStyle' field."

	^bytes swordAtOffset: _OffsetOf_sStyle!

sStyle: anInteger
	"Set the receiver's 'sStyle' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_sStyle put: anInteger!

szFaceName
	"Answer the <Utf16String> value of the receiver's 'szFaceName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szFaceName!

szFaceName: anUtf16String
	"Set the receiver's 'szFaceName' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(31 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szFaceName + 1)
		to: _OffsetOf_szFaceName + size
		startingAt: 1.
	bytes wordAtOffset: _OffsetOf_szFaceName + size put: 0!

wKerning
	"Answer the <Integer> value of the receiver's 'wKerning' field."

	^bytes wordAtOffset: _OffsetOf_wKerning!

wKerning: anInteger
	"Set the receiver's 'wKerning' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wKerning put: anInteger!

wWeight
	"Answer the <Integer> value of the receiver's 'wWeight' field."

	^bytes wordAtOffset: _OffsetOf_wWeight!

wWeight: anInteger
	"Set the receiver's 'wWeight' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wWeight put: anInteger!

yHeight
	"Answer the <Integer> value of the receiver's 'yHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_yHeight!

yHeight: anInteger
	"Set the receiver's 'yHeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yHeight put: anInteger! !
!OS.CHARFORMAT2W categoriesFor: #bAnimation!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bAnimation:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bCharSet!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bCharSet:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #beBold!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #beItalic!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #beNotBold!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #beNotItalic!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #beNotUnderlined!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #bePlain!modes!public! !
!OS.CHARFORMAT2W categoriesFor: #beUnderlined!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #bPitchAndFamily!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bPitchAndFamily:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bRevAuthor!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bRevAuthor:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bUnderlineColor!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bUnderlineColor:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bUnderlyineType!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #bUnderlyineType:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #characterSet!public! !
!OS.CHARFORMAT2W categoriesFor: #characterSet:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #color!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #color:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #crBackColor!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #crBackColor:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #crTextColor!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #crTextColor:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #dwEffects!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #dwEffects:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #dwMask!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #dwMask:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #dwSize:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #effectsAny:!accessing!private! !
!OS.CHARFORMAT2W categoriesFor: #faceName:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #font!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #font:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #height:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #isBold!public!testing! !
!OS.CHARFORMAT2W categoriesFor: #isBold:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #isItalic!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #isItalic:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #isStruckThrough!public!testing! !
!OS.CHARFORMAT2W categoriesFor: #isStruckThrough:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #isUnderlined!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #isUnderlined:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #lcid!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #lcid:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #logFont!public! !
!OS.CHARFORMAT2W categoriesFor: #maskAny:!accessing!private! !
!OS.CHARFORMAT2W categoriesFor: #maskIn:!accessing!private! !
!OS.CHARFORMAT2W categoriesFor: #maskOut:!private! !
!OS.CHARFORMAT2W categoriesFor: #pointSize!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #pointSize:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #populateChooseFont:!private! !
!OS.CHARFORMAT2W categoriesFor: #populateFromChooseFont:!private! !
!OS.CHARFORMAT2W categoriesFor: #setEffect:mask:set:!accessing!private! !
!OS.CHARFORMAT2W categoriesFor: #size:!accessing!public! !
!OS.CHARFORMAT2W categoriesFor: #sSpacing!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #sSpacing:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #sStyle!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #sStyle:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #szFaceName!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #szFaceName:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #wKerning!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #wKerning:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #wWeight!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #wWeight:!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #yHeight!**compiled accessors**!public! !
!OS.CHARFORMAT2W categoriesFor: #yHeight:!**compiled accessors**!public! !

!OS.CHARFORMAT2W class methodsFor!

defineFields
	"Define the layout of the CHARFORMAT2 structure
		self compileDefinition
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #dwMask type: DWORDField new;
		defineField: #dwEffects type: DWORDField new;
		defineField: #yHeight type: SDWORDField new;
		defineField: #yOffset type: SDWORDField new beUncompiled;
		defineField: #crTextColor type: DWORDField new;
		defineField: #bCharSet type: BYTEField new;
		defineField: #bPitchAndFamily type: BYTEField new;
		defineField: #szFaceName type: (StringField type: Utf16String length: 32);
		defineField: #wWeight type: WORDField new;
		defineField: #sSpacing type: SWORDField new;
		defineField: #crBackColor type: DWORDField new;
		defineField: #lcid type: DWORDField new;
		defineField: #dwCookie type: DWORDField filler;
		defineField: #sStyle type: SWORDField new;
		defineField: #wKerning type: WORDField new;
		defineField: #bUnderlyineType type: BYTEField new;
		defineField: #bAnimation type: BYTEField new;
		defineField: #bRevAuthor type: BYTEField new;
		defineField: #bUnderlineColor type: BYTEField new!

fromChooseFont: aCHOOSEFRONT 
	^(self new)
		populateFromChooseFont: aCHOOSEFRONT;
		yourself!

getFieldNames
	^#(#dwSize #dwMask #dwEffects #yHeight #yOffset #crTextColor #bCharSet #bPitchAndFamily #szFaceName #wWeight #sSpacing #crBackColor #lcid #sStyle #wKerning #bUnderlyineType #bAnimation #bRevAuthor #bUnderlineColor)! !
!OS.CHARFORMAT2W class categoriesFor: #defineFields!public!template definition! !
!OS.CHARFORMAT2W class categoriesFor: #fromChooseFont:!public! !
!OS.CHARFORMAT2W class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

