"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaTypeRef
	instanceVariableNames: 'name objectClass byRef toMessage fromMessage default'
	classVariableNames: 'TypeMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaTypeRef guid: (GUID fromString: '{C10BAC58-803F-49DA-939E-1F2522B7856D}')!
ScintillaTypeRef comment: ''!
!ScintillaTypeRef categoriesForClass!Development! !
!ScintillaTypeRef methodsFor!

byRef
	^byRef!

default
	^default!

default: anObject
	default := anObject!

fromMessage
	^fromMessage!

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

toMessage: anObject
	toMessage := anObject!

toScintilla
	^toMessage! !
!ScintillaTypeRef categoriesFor: #byRef!accessing!public! !
!ScintillaTypeRef categoriesFor: #default!accessing!private! !
!ScintillaTypeRef categoriesFor: #default:!accessing!private! !
!ScintillaTypeRef categoriesFor: #fromMessage!accessing!public! !
!ScintillaTypeRef categoriesFor: #fromMessage:!accessing!private! !
!ScintillaTypeRef categoriesFor: #isVoid!accessing!public! !
!ScintillaTypeRef categoriesFor: #name!accessing!public! !
!ScintillaTypeRef categoriesFor: #name:objectClass:byRef:!instance creation!private! !
!ScintillaTypeRef categoriesFor: #objectClass!accessing!public! !
!ScintillaTypeRef categoriesFor: #toMessage:!accessing!private! !
!ScintillaTypeRef categoriesFor: #toScintilla!accessing!public! !

!ScintillaTypeRef class methodsFor!

icon
	^ScintillaView icon!

initialize
	"
		self initialize
	"

	TypeMap := (LookupTable new)
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
				at: 'position'
					put: ((self 
							name: 'position'
							objectClass: Integer
							byRef: false)
							default: 0;
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
				at: 'colour'
					put: ((self 
							name: 'colour'
							objectClass: RGB
							byRef: false)
							toMessage: #asParameter;
							fromMessage: #fromInteger:;
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
				shrink;
				isImmutable: true;
				yourself!

name: aString objectClass: aClass byRef: aBoolean 
	^self new 
		name: aString
		objectClass: aClass
		byRef: aBoolean!

named: aString 
	^aString ifNotNil: [TypeMap at: aString]! !
!ScintillaTypeRef class categoriesFor: #icon!constants!development!public! !
!ScintillaTypeRef class categoriesFor: #initialize!constants!private! !
!ScintillaTypeRef class categoriesFor: #name:objectClass:byRef:!instance creation!private! !
!ScintillaTypeRef class categoriesFor: #named:!public! !

