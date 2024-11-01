"Filed out from Dolphin Smalltalk"!

DBAbstractStatement subclass: #DBTypeInfoStatement
	instanceVariableNames: 'dataType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBTypeInfoStatement guid: (GUID fromString: '{f2031aa4-c44d-4c58-9231-649abb882cba}')!

DBTypeInfoStatement comment: ''!

!DBTypeInfoStatement categoriesForClass!ODBC Interface! !

!DBTypeInfoStatement methodsFor!

dataType
	^dataType!

dataType: anObject
	dataType := anObject!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^self
		dbCheckException: (ODBCLibrary default sqlGetTypeInfo: self allocatedHandle dataType: self dataType)
		function: 'SQLGetTypeInfo'! !

!DBTypeInfoStatement categoriesForMethods!
dataType!accessing!public! !
dataType:!accessing!public! !
executeStatement!operations!private! !
!

