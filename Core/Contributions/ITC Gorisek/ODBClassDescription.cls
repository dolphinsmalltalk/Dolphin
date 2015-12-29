"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBClassDescription
	instanceVariableNames: 'name bytes variable instSize instVarNames instVarIndexes class varOrder classID'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClassDescription guid: (GUID fromString: '{8162EDD0-0FB8-11D4-B091-000000000000}')!
ODBClassDescription comment: ''!
!ODBClassDescription categoriesForClass!No category! !
!ODBClassDescription methodsFor!

allPersistentInstanceVariablesFor: aClass 
	^(aClass allInstVarNames 
		reject: [:each | aClass odbTransientInstanceVariables includes: each]) asArray!

classID
	^classID!

classID: anInteger 
	classID := anInteger!

classNameSymbol
	^name asSymbol!

createdFor: aClass 
	^name = aClass name asString and: 
			[variable = aClass isVariable and: 
					[bytes = aClass isBytes 
						and: [instVarNames = (self allPersistentInstanceVariablesFor: aClass)]]]!

createFor: aClass 
	class := aClass.
	name := aClass name asString.
	instVarNames := self allPersistentInstanceVariablesFor: aClass.
	instSize := instVarNames size.
	bytes := aClass isBytes.
	variable := aClass isVariable.
	self updateVariableOrder!

instSize
	^instSize!

instVarIndexes
	^instVarIndexes!

instVarNames
	^instVarNames!

isBytes
	^bytes!

isVariable
	^variable!

loadFromStream: aStream 
	name := aStream getString.
	bytes := aStream getBoolean.
	variable := aStream getBoolean.
	instSize := aStream getPositiveInteger.
	instVarNames := Array new: instSize.
	1 to: instSize do: [:i | instVarNames at: i put: aStream getString].
	self updateVariableOrder!

name
	^name!

realClass
	^class!

realInstSize
	^class instSize!

saveOnStream: aStream 
	aStream
		putString: name;
		putBoolean: bytes;
		putBoolean: variable;
		putPositiveInteger: instSize.
	instVarNames do: [:n | aStream putString: n]!

updateVariableOrder
	| realNames |
	class := Smalltalk at: name asSymbol ifAbsent: [].
	varOrder := Array new: instVarNames size.
	class isNil 
		ifTrue: [varOrder atAllPut: 1]
		ifFalse: 
			[realNames := class allInstVarNames.
			1 to: varOrder size
				do: 
					[:i | 
					(varOrder at: i put: (realNames indexOf: (instVarNames at: i))) = 0 
						ifTrue: [varOrder at: i put: realNames size + 1]].
			instVarIndexes := Array new: instVarNames size.
			1 to: instVarNames size
				do: [:i | instVarIndexes at: i put: (class allInstVarNames indexOf: (instVarNames at: i))]]!

variableOrder
	^varOrder! !
!ODBClassDescription categoriesFor: #allPersistentInstanceVariablesFor:!private! !
!ODBClassDescription categoriesFor: #classID!public! !
!ODBClassDescription categoriesFor: #classID:!public! !
!ODBClassDescription categoriesFor: #classNameSymbol!public! !
!ODBClassDescription categoriesFor: #createdFor:!public! !
!ODBClassDescription categoriesFor: #createFor:!public! !
!ODBClassDescription categoriesFor: #instSize!public! !
!ODBClassDescription categoriesFor: #instVarIndexes!public! !
!ODBClassDescription categoriesFor: #instVarNames!public! !
!ODBClassDescription categoriesFor: #isBytes!public! !
!ODBClassDescription categoriesFor: #isVariable!public! !
!ODBClassDescription categoriesFor: #loadFromStream:!public! !
!ODBClassDescription categoriesFor: #name!public! !
!ODBClassDescription categoriesFor: #realClass!public! !
!ODBClassDescription categoriesFor: #realInstSize!public! !
!ODBClassDescription categoriesFor: #saveOnStream:!public! !
!ODBClassDescription categoriesFor: #updateVariableOrder!private! !
!ODBClassDescription categoriesFor: #variableOrder!public! !

