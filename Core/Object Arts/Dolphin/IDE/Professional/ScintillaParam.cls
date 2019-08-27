"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaParam
	instanceVariableNames: 'name typeName typeRef'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaParam guid: (GUID fromString: '{c2e4de9a-2733-4744-a2e1-c18af7a172d1}')!
ScintillaParam comment: ''!
!ScintillaParam categoriesForClass!Kernel-Objects! !
!ScintillaParam methodsFor!

displayOn: aStream
	aStream display: self type; space; nextPutAll: name!

emitOutParam: aCharacter on: aWriteStream
	aWriteStream
		space;
		nextPut: aCharacter;
		nextPutAll: (self type byRef ifTrue: ['pParam: '] ifFalse: ['Param: ']);
		display: (self isUnused ifTrue: [0] ifFalse: [self parameterName]);
		space;
		display: self type toScintilla!

isUnused
	| aString |
	aString := self name.
	^aString isNil or: [aString = 'unused']!

name
	^name!

parameterName
	| nameString |
	nameString := self name.
	^(String with: nameString first asLowercase) , (nameString copyFrom: 2) , self type objectClass name!

setName: nameString typeName: typeString
	name := nameString.
	typeName := typeString!

type
	^typeRef ifNil: [typeRef := ScintillaTypeRef named: typeName]!

typeName
	^typeName! !
!ScintillaParam categoriesFor: #displayOn:!displaying!public! !
!ScintillaParam categoriesFor: #emitOutParam:on:!generating!private! !
!ScintillaParam categoriesFor: #isUnused!generating!helpers!public! !
!ScintillaParam categoriesFor: #name!initializing!private! !
!ScintillaParam categoriesFor: #parameterName!helpers!private! !
!ScintillaParam categoriesFor: #setName:typeName:!initializing!private! !
!ScintillaParam categoriesFor: #type!initializing!private! !
!ScintillaParam categoriesFor: #typeName!public! !

!ScintillaParam class methodsFor!

icon
	^ScintillaView icon!

newName: nameString typeName: typeString
	^self new
		setName: nameString typeName: typeString! !
!ScintillaParam class categoriesFor: #icon!constants!development!public! !
!ScintillaParam class categoriesFor: #newName:typeName:!instance creation!public! !

