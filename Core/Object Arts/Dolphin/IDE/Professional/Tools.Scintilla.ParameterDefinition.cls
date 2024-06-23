"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.Scintilla.ParameterDefinition'
	instanceVariableNames: 'name typeName typeRef'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Scintilla.ParameterDefinition guid: (Core.GUID fromString: '{c2e4de9a-2733-4744-a2e1-c18af7a172d1}')!

Tools.Scintilla.ParameterDefinition comment: ''!

!Tools.Scintilla.ParameterDefinition categoriesForClass!Kernel-Objects! !

!Tools.Scintilla.ParameterDefinition methodsFor!

displayOn: aStream
	aStream display: self type; space; nextPutAll: name!

emitOutParam: aCharacter on: aWriteStream
	aWriteStream
		space;
		nextPut: aCharacter;
		nextPutAll: (self type byRef ifTrue: ['pParam: '] ifFalse: ['Param: ']).
	self isUnused
		ifTrue: [aWriteStream nextPut: $0]
		ifFalse: 
			[| paramType aString |
			paramType := self type.
			aString := self parameterName.
			paramType printParameter: aString on: aWriteStream]!

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
	^typeRef ifNil: [typeRef := TypeReference named: typeName]!

typeName
	^typeName! !

!Tools.Scintilla.ParameterDefinition categoriesForMethods!
displayOn:!displaying!public! !
emitOutParam:on:!generating!private! !
isUnused!generating!helpers!public! !
name!initializing!private! !
parameterName!helpers!private! !
setName:typeName:!initializing!private! !
type!initializing!private! !
typeName!public! !
!

!Tools.Scintilla.ParameterDefinition class methodsFor!

icon
	^UI.Scintilla.ScintillaView icon!

newName: nameString typeName: typeString
	^self new
		setName: nameString typeName: typeString! !

!Tools.Scintilla.ParameterDefinition class categoriesForMethods!
icon!constants!development!public! !
newName:typeName:!instance creation!public! !
!

