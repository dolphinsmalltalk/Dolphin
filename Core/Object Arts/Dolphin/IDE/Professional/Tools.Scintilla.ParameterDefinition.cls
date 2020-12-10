"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.Scintilla.ParameterDefinition'
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
	^typeRef ifNil: [typeRef := Tools.Scintilla.TypeReference named: typeName]!

typeName
	^typeName! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #displayOn:!displaying!public! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #emitOutParam:on:!generating!private! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #isUnused!generating!helpers!public! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #name!initializing!private! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #parameterName!helpers!private! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #setName:typeName:!initializing!private! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #type!initializing!private! !
!Tools.Scintilla.ParameterDefinition categoriesFor: #typeName!public! !

!Tools.Scintilla.ParameterDefinition class methodsFor!

icon
	^UI.Scintilla.ScintillaView icon!

newName: nameString typeName: typeString
	^self new
		setName: nameString typeName: typeString! !
!Tools.Scintilla.ParameterDefinition class categoriesFor: #icon!constants!development!public! !
!Tools.Scintilla.ParameterDefinition class categoriesFor: #newName:typeName:!instance creation!public! !

