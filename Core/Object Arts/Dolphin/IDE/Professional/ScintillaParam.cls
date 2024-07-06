"Filed out from Dolphin Smalltalk"!

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

!ScintillaParam categoriesForMethods!
displayOn:!displaying!public! !
emitOutParam:on:!generating!private! !
isUnused!generating!helpers!public! !
name!initializing!private! !
parameterName!helpers!private! !
setName:typeName:!initializing!private! !
type!initializing!private! !
typeName!public! !
!

!ScintillaParam class methodsFor!

icon
	^ScintillaView icon!

newName: nameString typeName: typeString
	^self new
		setName: nameString typeName: typeString! !

!ScintillaParam class categoriesForMethods!
icon!constants!development!public! !
newName:typeName:!instance creation!public! !
!

