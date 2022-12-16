"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Tools.Scintilla.TypeReference'
	instanceVariableNames: ''
	classVariableNames: 'Enums TypeMap'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.TypeReference guid: (Core.GUID fromString: '{b22f3a15-8ccd-4dc0-b245-110e116464f3}')!
Tools.Scintilla.TypeReference isNonInstantiable: true!
Tools.Scintilla.TypeReference comment: ''!
!Tools.Scintilla.TypeReference categoriesForClass!Development! !
!Tools.Scintilla.TypeReference methodsFor!

byRef
	^false!

defaultValue
	^self subclassResponsibility!

directFunctionKeyword
	^'directFunction: '!

displayOn: aStream
	aStream nextPutAll: self name!

emitReturnConversionAround: aBlockClosure on: aPuttableStream
	aBlockClosure value!

isVoid
	^false!

name
	^self subclassResponsibility!

objectClass
	^self subclassResponsibility!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; display: self; nextPut: $).!

printParameter: aString on: aWriteStream
	aWriteStream nextPutAll: aString! !
!Tools.Scintilla.TypeReference categoriesForMethods!
byRef!accessing!public! !
defaultValue!constants!public! !
directFunctionKeyword!constants!public! !
displayOn:!displaying!public! !
emitReturnConversionAround:on:!generating!public! !
isVoid!accessing!public! !
name!accessing!public! !
objectClass!accessing!public! !
printOn:!printing!public! !
printParameter:on:!generating!public! !
!

!Tools.Scintilla.TypeReference class methodsFor!

declareEnum: aString prefix: anObject
	| enum |
	enum := EnumTypeReference name: aString prefix: anObject.
	TypeMap at: aString put: enum.
	Enums add: enum!

enumForConst: aString
	"Unfortunately we can't rely on the prefixes all ending in an underscore, as some do not"

	^Enums detect: [:each | aString beginsWith: each prefix] ifNone: nil!

icon
	^UI.Scintilla.ScintillaView icon!

initialize
	"
		self initialize
	"

	self resetTypeMap!

named: aString 
	^aString ifNotNil: [TypeMap at: aString]!

resetTypeMap
	Enums := Set new.
	TypeMap := LookupTable new
				at: 'void' put: VoidTypeReference new;
				at: 'string' put: (PointerTypeReference name: 'string' objectClass: String);
				at: 'int' put: IntTypeReference new;
				at: 'cells' put: (PointerTypeReference name: 'cells' objectClass: ByteArray);
				at: 'line' put: LineTypeReference new;
				at: 'position' put: PositionTypeReference new;
				at: 'bool' put: BoolTypeReference new;
				at: 'textrangefull'
					put: (PointerTypeReference name: 'textrangefull' objectClass: UI.Scintilla.TextRangeFull);
				at: 'stringresult' put: (PointerTypeReference name: 'stringresult' objectClass: String);
				at: 'pointer' put: (PointerTypeReference name: 'pointer' objectClass: External.Address);
				at: 'colour' put: ColourTypeReference new;
				at: 'colouralpha' put: ColourAlphaTypeReference new;
				at: 'keymod' put: KeyModTypeReference new;
				at: 'findtextfull'
					put: (PointerTypeReference name: 'findtext' objectClass: UI.Scintilla.TextToFindFull);
				at: 'formatrangefull'
					put: (PointerTypeReference name: 'formatrange' objectClass: UI.Scintilla.RangeToFormatFull);
				yourself! !
!Tools.Scintilla.TypeReference class categoriesForMethods!
declareEnum:prefix:!constants!public! !
enumForConst:!constants!public! !
icon!constants!development!public! !
initialize!constants!private! !
named:!public! !
resetTypeMap!public! !
!

