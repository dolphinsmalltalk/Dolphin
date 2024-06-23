"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.CHARFORMAT2W'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommonDialogConstants} #{OS.RichEditConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_CHARFORMAT2W_Size' -> 16r74.
			'_OffsetOf_bAnimation' -> 16r71.
			'_OffsetOf_bCharSet' -> 16r18.
			'_OffsetOf_bPitchAndFamily' -> 16r19.
			'_OffsetOf_bRevAuthor' -> 16r72.
			'_OffsetOf_bUnderlineColor' -> 16r73.
			'_OffsetOf_bUnderlineType' -> 16r70.
			'_OffsetOf_crBackColor' -> 16r60.
			'_OffsetOf_crTextColor' -> 16r14.
			'_OffsetOf_dwCookie' -> 16r68.
			'_OffsetOf_dwEffects' -> 16r8.
			'_OffsetOf_dwMask' -> 16r4.
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

	^bytes uint8AtOffset: _OffsetOf_bAnimation!

bAnimation: anInteger
	"Set the receiver's 'bAnimation' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_bAnimation put: anInteger!

bCharSet
	"Answer the <Integer> value of the receiver's 'bCharSet' field."

	^bytes uint8AtOffset: _OffsetOf_bCharSet!

bCharSet: anInteger
	"Set the receiver's 'bCharSet' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_bCharSet put: anInteger!

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

	^bytes uint8AtOffset: _OffsetOf_bPitchAndFamily!

bPitchAndFamily: anInteger
	"Set the receiver's 'bPitchAndFamily' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_bPitchAndFamily put: anInteger!

bRevAuthor
	"Answer the <Integer> value of the receiver's 'bRevAuthor' field."

	^bytes uint8AtOffset: _OffsetOf_bRevAuthor!

bRevAuthor: anInteger
	"Set the receiver's 'bRevAuthor' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_bRevAuthor put: anInteger!

bUnderlineColor
	"Answer the <Integer> value of the receiver's 'bUnderlineColor' field."

	^bytes uint8AtOffset: _OffsetOf_bUnderlineColor!

bUnderlineColor: anInteger
	"Set the receiver's 'bUnderlineColor' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_bUnderlineColor put: anInteger!

bUnderlineType
	"Answer the <Integer> value of the receiver's 'bUnderlineType' field."

	^bytes uint8AtOffset: _OffsetOf_bUnderlineType!

bUnderlineType: anInteger
	"Set the receiver's 'bUnderlineType' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_bUnderlineType put: anInteger!

characterSet
	^(self maskAny: CFM_CHARSET) ifTrue: [self bCharSet]!

characterSet: anIntegerOrNil 
	"Set the desired character set (permitted values of lfCharSet field of LOGFONT on MSDN)."

	self maskIn: CFM_CHARSET.
	self bCharSet: anIntegerOrNil!

color
	"Answer the character colour."

	^Graphics.Color fromCOLORREF: self crTextColor!

color: aColor
	"Set the character colour."

	self maskIn: CFM_COLOR.
	self crTextColor: (aColor ?? Graphics.Color.WindowText) asCOLORREF!

crBackColor
	"Answer the <Integer> value of the receiver's 'crBackColor' field."

	^bytes uint32AtOffset: _OffsetOf_crBackColor!

crBackColor: anInteger
	"Set the receiver's 'crBackColor' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_crBackColor put: anInteger!

crTextColor
	"Answer the <Integer> value of the receiver's 'crTextColor' field."

	^bytes uint32AtOffset: _OffsetOf_crTextColor!

crTextColor: anInteger
	"Set the receiver's 'crTextColor' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_crTextColor put: anInteger!

dwEffects
	"Answer the <Integer> value of the receiver's 'dwEffects' field."

	^bytes uint32AtOffset: _OffsetOf_dwEffects!

dwEffects: anInteger
	"Set the receiver's 'dwEffects' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwEffects put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwMask put: anInteger!

effectsAny: anInteger
	"Private - Answer true if the effects field contains the bit flags represented by anInteger."

	^self dwEffects anyMask: anInteger!

faceName: aString
	"Set the character face name.
	Note that the szFaceName field is an embedded string, rather than a pointer,
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

	^bytes uint32AtOffset: _OffsetOf_lcid!

lcid: anInteger
	"Set the receiver's 'lcid' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lcid put: anInteger!

logFont
	"Answer a <LOGFONTW> configured with the font settings from the receiver. The display resolution is assumed in converting from the point size to font height."

	| answer |
	answer := LOGFONTW newBuffer.
	answer faceName: self szFaceName.
	answer lfHeight: (self pointSize * Graphics.Canvas desktopResolution y / 72) rounded negated.
	answer lfWeight: (self isBold ifTrue: [FW_BOLD] ifFalse: [FW_NORMAL]).
	answer lfItalic: self isItalic asParameter.
	answer lfUnderline: self isUnderlined asParameter.
	answer lfStrikeOut: self isStruckThrough asParameter.
	self characterSet ifNotNil: [:script | answer lfCharSet: script].
	^answer!

maskAny: anInteger
	"Private - Answer true if the mask field contains the bit flags represented by anInteger."

	^self dwMask anyMask: anInteger!

maskIn: anInteger
	"Private - OR in to the contents mask field the bit flags represented by anInteger.
	Answer the receiver."

	self dwMask: (self dwMask bitOr: anInteger)!

maskOut: anInteger 
	self dwMask: (self dwMask maskClear: anInteger)!

pointSize
	"Answer the receiver's height field in points (N.B. the answer may be
	a Fraction if, for example, the size is 10.5 points)."

	^self yHeight / 20!

pointSize: aNumber
	"Set the receiver's height field to aNumber points (aNumber 
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

	^bytes int16AtOffset: _OffsetOf_sSpacing!

sSpacing: anInteger
	"Set the receiver's 'sSpacing' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_sSpacing put: anInteger!

sStyle
	"Answer the <Integer> value of the receiver's 'sStyle' field."

	^bytes int16AtOffset: _OffsetOf_sStyle!

sStyle: anInteger
	"Set the receiver's 'sStyle' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_sStyle put: anInteger!

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
	bytes uint16AtOffset: _OffsetOf_szFaceName + size put: 0!

wKerning
	"Answer the <Integer> value of the receiver's 'wKerning' field."

	^bytes uint16AtOffset: _OffsetOf_wKerning!

wKerning: anInteger
	"Set the receiver's 'wKerning' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wKerning put: anInteger!

wWeight
	"Answer the <Integer> value of the receiver's 'wWeight' field."

	^bytes uint16AtOffset: _OffsetOf_wWeight!

wWeight: anInteger
	"Set the receiver's 'wWeight' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wWeight put: anInteger!

yHeight
	"Answer the <Integer> value of the receiver's 'yHeight' field."

	^bytes int32AtOffset: _OffsetOf_yHeight!

yHeight: anInteger
	"Set the receiver's 'yHeight' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_yHeight put: anInteger! !

!OS.CHARFORMAT2W categoriesForMethods!
bAnimation!**compiled accessors**!public! !
bAnimation:!**compiled accessors**!public! !
bCharSet!**compiled accessors**!public! !
bCharSet:!**compiled accessors**!public! !
beBold!accessing!public! !
beItalic!accessing!public! !
beNotBold!accessing!public! !
beNotItalic!accessing!public! !
beNotUnderlined!accessing!public! !
bePlain!modes!public! !
beUnderlined!accessing!public! !
bPitchAndFamily!**compiled accessors**!public! !
bPitchAndFamily:!**compiled accessors**!public! !
bRevAuthor!**compiled accessors**!public! !
bRevAuthor:!**compiled accessors**!public! !
bUnderlineColor!**compiled accessors**!public! !
bUnderlineColor:!**compiled accessors**!public! !
bUnderlineType!**compiled accessors**!public! !
bUnderlineType:!**compiled accessors**!public! !
characterSet!public! !
characterSet:!accessing!public! !
color!accessing!public! !
color:!accessing!public! !
crBackColor!**compiled accessors**!public! !
crBackColor:!**compiled accessors**!public! !
crTextColor!**compiled accessors**!public! !
crTextColor:!**compiled accessors**!public! !
dwEffects!**compiled accessors**!public! !
dwEffects:!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwMask:!**compiled accessors**!public! !
effectsAny:!accessing!private! !
faceName:!accessing!public! !
font!accessing!public! !
font:!accessing!public! !
height:!accessing!public! !
isBold!public!testing! !
isBold:!accessing!public! !
isItalic!accessing!public! !
isItalic:!accessing!public! !
isStruckThrough!public!testing! !
isStruckThrough:!accessing!public! !
isUnderlined!accessing!public! !
isUnderlined:!accessing!public! !
lcid!**compiled accessors**!public! !
lcid:!**compiled accessors**!public! !
logFont!public! !
maskAny:!accessing!private! !
maskIn:!accessing!private! !
maskOut:!private! !
pointSize!accessing!public! !
pointSize:!accessing!public! !
populateChooseFont:!private! !
populateFromChooseFont:!private! !
setEffect:mask:set:!accessing!private! !
size:!accessing!public! !
sSpacing!**compiled accessors**!public! !
sSpacing:!**compiled accessors**!public! !
sStyle!**compiled accessors**!public! !
sStyle:!**compiled accessors**!public! !
szFaceName!**compiled accessors**!public! !
szFaceName:!**compiled accessors**!public! !
wKerning!**compiled accessors**!public! !
wKerning:!**compiled accessors**!public! !
wWeight!**compiled accessors**!public! !
wWeight:!**compiled accessors**!public! !
yHeight!**compiled accessors**!public! !
yHeight:!**compiled accessors**!public! !
!

!OS.CHARFORMAT2W class methodsFor!

byteSize
	^_CHARFORMAT2W_Size!

defineFields
	"Define the layout of the CHARFORMAT2 structure
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #dwMask type: UInt32Field new;
		defineField: #dwEffects type: UInt32Field new;
		defineField: #yHeight type: Int32Field new;
		defineField: #yOffset type: Int32Field new beUncompiled;
		defineField: #crTextColor type: UInt32Field new;
		defineField: #bCharSet type: UInt8Field new;
		defineField: #bPitchAndFamily type: UInt8Field new;
		defineField: #szFaceName type: (StringField type: Utf16String length: 32);
		defineField: #wWeight type: UInt16Field new;
		defineField: #sSpacing type: Int16Field new;
		defineField: #crBackColor type: UInt32Field new;
		defineField: #lcid type: UInt32Field new;
		defineField: #dwCookie type: UInt32Field filler;
		defineField: #sStyle type: Int16Field new;
		defineField: #wKerning type: UInt16Field new;
		defineField: #bUnderlineType type: UInt8Field new;
		defineField: #bAnimation type: UInt8Field new;
		defineField: #bRevAuthor type: UInt8Field new;
		defineField: #bUnderlineColor type: UInt8Field new!

fromChooseFont: aCHOOSEFONT 
	^(self new)
		populateFromChooseFont: aCHOOSEFONT;
		yourself!

getFieldNames
	^#(#dwSize #dwMask #dwEffects #yHeight #yOffset #crTextColor #bCharSet #bPitchAndFamily #szFaceName #wWeight #sSpacing #crBackColor #lcid #sStyle #wKerning #bUnderlineType #bAnimation #bRevAuthor #bUnderlineColor)! !

!OS.CHARFORMAT2W class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromChooseFont:!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

