"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Tools.Scintilla.TypeReference'
	instanceVariableNames: ''
	classVariableNames: 'TypeMap'
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
	^nil!

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
!Tools.Scintilla.TypeReference categoriesFor: #byRef!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #defaultValue!constants!public! !
!Tools.Scintilla.TypeReference categoriesFor: #directFunctionKeyword!constants!public! !
!Tools.Scintilla.TypeReference categoriesFor: #displayOn:!displaying!public! !
!Tools.Scintilla.TypeReference categoriesFor: #emitReturnConversionAround:on:!generating!public! !
!Tools.Scintilla.TypeReference categoriesFor: #isVoid!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #name!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #objectClass!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #printOn:!printing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #printParameter:on:!generating!public! !

!Tools.Scintilla.TypeReference class methodsFor!

declareEnum: aString
	TypeMap at: aString put: (EnumTypeReference name: aString)!

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
	TypeMap := LookupTable new
				at: 'void' put: VoidTypeReference new;
				at: 'string' put: (PointerTypeReference name: 'string' objectClass: String);
				at: 'int' put: IntTypeReference new;
				at: 'cells' put: (PointerTypeReference name: 'cells' objectClass: ByteArray);
				at: 'line' put: LineTypeReference new;
				at: 'position' put: PositionTypeReference new;
				at: 'bool' put: BoolTypeReference new;
				at: 'textrange' put: (PointerTypeReference name: 'textrange' objectClass: OS.TEXTRANGE);
				at: 'stringresult' put: (PointerTypeReference name: 'stringresult' objectClass: String);
				at: 'pointer' put: (PointerTypeReference name: 'pointer' objectClass: External.Address);
				at: 'colour' put: ColourTypeReference new;
				at: 'colouralpha' put: ColourAlphaTypeReference new;
				at: 'keymod' put: KeyModTypeReference new;
				at: 'findtext' put: (PointerTypeReference name: 'findtext' objectClass: OS.FINDTEXTEX);
				at: 'formatrange' put: (PointerTypeReference name: 'formatrange' objectClass: OS.FORMATRANGE);
				yourself! !
!Tools.Scintilla.TypeReference class categoriesFor: #declareEnum:!constants!public! !
!Tools.Scintilla.TypeReference class categoriesFor: #icon!constants!development!public! !
!Tools.Scintilla.TypeReference class categoriesFor: #initialize!constants!private! !
!Tools.Scintilla.TypeReference class categoriesFor: #named:!public! !
!Tools.Scintilla.TypeReference class categoriesFor: #resetTypeMap!public! !

