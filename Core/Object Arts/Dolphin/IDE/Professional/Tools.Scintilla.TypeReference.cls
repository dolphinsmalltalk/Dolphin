"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.Scintilla.TypeReference'
	instanceVariableNames: 'name objectClass byRef toMessage fromMessage default'
	classVariableNames: 'TypeMap'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.TypeReference guid: (Core.GUID fromString: '{c10bac58-803f-49da-939e-1f2522b7856d}')!
Tools.Scintilla.TypeReference comment: ''!
!Tools.Scintilla.TypeReference categoriesForClass!Development! !
!Tools.Scintilla.TypeReference methodsFor!

byRef
	^byRef!

default
	^default!

default: anObject
	default := anObject!

displayOn: aStream
	aStream nextPutAll: name!

emitReturnConversionAround: aBlockClosure on: aPuttableStream
	fromMessage
		ifNotNil: 
			[fromMessage last == $:
				ifTrue: 
					[aPuttableStream
						print: self objectClass;
						space;
						nextPutAll: fromMessage;
						nextPutAll: ' (']
				ifFalse: [aPuttableStream nextPut: $(]].
	aBlockClosure value.
	fromMessage
		ifNotNil: 
			[aPuttableStream nextPut: $).
			fromMessage last == $:
				ifFalse: 
					[aPuttableStream
						space;
						nextPutAll: fromMessage]]!

fromMessage: anObject
	fromMessage := anObject!

isVoid
	^self name = 'void'!

name
	^name!

name: aString objectClass: aClass byRef: aBoolean 
	name := aString.
	objectClass := aClass.
	byRef := aBoolean!

objectClass
	^objectClass!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; display: self; nextPut: $).!

toMessage: anObject
	toMessage := anObject!

toScintilla
	^toMessage! !
!Tools.Scintilla.TypeReference categoriesFor: #byRef!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #default!accessing!private! !
!Tools.Scintilla.TypeReference categoriesFor: #default:!accessing!private! !
!Tools.Scintilla.TypeReference categoriesFor: #displayOn:!displaying!public! !
!Tools.Scintilla.TypeReference categoriesFor: #emitReturnConversionAround:on:!generating!private! !
!Tools.Scintilla.TypeReference categoriesFor: #fromMessage:!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #isVoid!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #name!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #name:objectClass:byRef:!instance creation!private! !
!Tools.Scintilla.TypeReference categoriesFor: #objectClass!accessing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #printOn:!printing!public! !
!Tools.Scintilla.TypeReference categoriesFor: #toMessage:!accessing!private! !
!Tools.Scintilla.TypeReference categoriesFor: #toScintilla!accessing!public! !

!Tools.Scintilla.TypeReference class methodsFor!

declareEnum: aString
	TypeMap at: aString
		put: ((self
				name: aString
				objectClass: Integer
				byRef: false)
				default: 0;
				yourself)!

icon
	^UI.Scintilla.ScintillaView icon!

initialize
	"
		self initialize
	"

	self resetTypeMap!

name: aString objectClass: aClass byRef: aBoolean 
	^self new 
		name: aString
		objectClass: aClass
		byRef: aBoolean!

named: aString 
	^aString ifNotNil: [TypeMap at: aString]!

resetTypeMap
	TypeMap := LookupTable new
				at: 'void'
					put: (self
							name: 'void'
							objectClass: nil
							byRef: false);
				at: 'string'
					put: (self
							name: 'string'
							objectClass: String
							byRef: true);
				at: 'int'
					put: ((self
							name: 'int'
							objectClass: Integer
							byRef: false)
							default: 0;
							yourself);
				at: 'cells'
					put: (self
							name: 'cells'
							objectClass: ByteArray
							byRef: true);
				at: 'line'
					put: ((self
							name: 'line'
							objectClass: Integer
							byRef: false)
							default: 0;
							toMessage: ' - 1';
							fromMessage: ' + 1';
							yourself);
				at: 'position'
					put: ((self
							name: 'position'
							objectClass: Integer
							byRef: false)
							default: 0;
							toMessage: ' - 1';
							fromMessage: ' + 1';
							yourself);
				at: 'bool'
					put: ((self
							name: 'bool'
							objectClass: Boolean
							byRef: false)
							default: false;
							toMessage: #asParameter;
							fromMessage: #asBoolean;
							yourself);
				at: 'textrange'
					put: ((self
							name: 'textrange'
							objectClass: OS.TEXTRANGE
							byRef: true)
							fromMessage: #fromAddress:;
							yourself);
				at: 'stringresult'
					put: (self
							name: 'stringresult'
							objectClass: String
							byRef: true);
				at: 'pointer'
					put: (self
							name: 'pointer'
							objectClass: External.Address
							byRef: true);
				at: 'colour'
					put: ((self
							name: 'colour'
							objectClass: Color
							byRef: false)
							toMessage: #rgbCode;
							fromMessage: #fromRgbCode:;
							yourself);
				at: 'keymod'
					put: (self
							name: 'keymod'
							objectClass: Integer
							byRef: false);
				at: 'findtext'
					put: (self
							name: 'findtext'
							objectClass: OS.FINDTEXTEX
							byRef: true);
				at: 'formatrange'
					put: ((self
							name: 'formatrange'
							objectClass: OS.FORMATRANGE
							byRef: true)
							fromMessage: #fromAddress:;
							yourself);
				yourself! !
!Tools.Scintilla.TypeReference class categoriesFor: #declareEnum:!constants!public! !
!Tools.Scintilla.TypeReference class categoriesFor: #icon!constants!development!public! !
!Tools.Scintilla.TypeReference class categoriesFor: #initialize!constants!private! !
!Tools.Scintilla.TypeReference class categoriesFor: #name:objectClass:byRef:!instance creation!private! !
!Tools.Scintilla.TypeReference class categoriesFor: #named:!public! !
!Tools.Scintilla.TypeReference class categoriesFor: #resetTypeMap!constants!private! !

