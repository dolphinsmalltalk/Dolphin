"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaTypeRef
	instanceVariableNames: 'name objectClass byRef toMessage fromMessage default'
	classVariableNames: 'TypeMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaTypeRef guid: (GUID fromString: '{c10bac58-803f-49da-939e-1f2522b7856d}')!
ScintillaTypeRef comment: ''!
!ScintillaTypeRef categoriesForClass!Development! !
!ScintillaTypeRef methodsFor!

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
!ScintillaTypeRef categoriesFor: #byRef!accessing!public! !
!ScintillaTypeRef categoriesFor: #default!accessing!private! !
!ScintillaTypeRef categoriesFor: #default:!accessing!private! !
!ScintillaTypeRef categoriesFor: #displayOn:!displaying!public! !
!ScintillaTypeRef categoriesFor: #emitReturnConversionAround:on:!generating!private! !
!ScintillaTypeRef categoriesFor: #fromMessage:!accessing!public! !
!ScintillaTypeRef categoriesFor: #isVoid!accessing!public! !
!ScintillaTypeRef categoriesFor: #name!accessing!public! !
!ScintillaTypeRef categoriesFor: #name:objectClass:byRef:!instance creation!private! !
!ScintillaTypeRef categoriesFor: #objectClass!accessing!public! !
!ScintillaTypeRef categoriesFor: #printOn:!printing!public! !
!ScintillaTypeRef categoriesFor: #toMessage:!accessing!private! !
!ScintillaTypeRef categoriesFor: #toScintilla!accessing!public! !

!ScintillaTypeRef class methodsFor!

declareEnum: aString
	TypeMap at: aString
		put: ((self
				name: aString
				objectClass: Integer
				byRef: false)
				default: 0;
				yourself)!

icon
	^ScintillaView icon!

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
							objectClass: TEXTRANGE
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
							objectClass: ExternalAddress
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
							objectClass: FINDTEXTEX
							byRef: true);
				at: 'formatrange'
					put: ((self
							name: 'formatrange'
							objectClass: FORMATRANGE
							byRef: true)
							fromMessage: #fromAddress:;
							yourself);
				yourself! !
!ScintillaTypeRef class categoriesFor: #declareEnum:!constants!public! !
!ScintillaTypeRef class categoriesFor: #icon!constants!development!public! !
!ScintillaTypeRef class categoriesFor: #initialize!constants!private! !
!ScintillaTypeRef class categoriesFor: #name:objectClass:byRef:!instance creation!private! !
!ScintillaTypeRef class categoriesFor: #named:!public! !
!ScintillaTypeRef class categoriesFor: #resetTypeMap!constants!private! !

