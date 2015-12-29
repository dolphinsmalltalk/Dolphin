"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBUndefinedObject
	instanceVariableNames: 'basicHash variables indexedVariables bytes classInfo basicSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBUndefinedObject guid: (GUID fromString: '{8162EDE8-0FB8-11D4-B091-000000000000}')!
ODBUndefinedObject comment: 'This object is used as a value holder for persistent objects for which there is no class in the image.

Example:

An object of class A was stored in the database. Later this object is loaded but there is no class A defined in the image. In this case an instance of ODBUndefinedObject is created with attribute values of A.
'!
!ODBUndefinedObject categoriesForClass!No category! !
!ODBUndefinedObject methodsFor!

className
	^classInfo name!

instVarNames
	^classInfo instVarNames!

instVarValues
	^variables!

odbLoadVariables: deserializer classInfo: aClassInfo 
	"Private - Deserialize instance of a nonexisting class."

	| stream |
	stream := deserializer stream.
	classInfo := aClassInfo.
	classInfo isVariable 
		ifTrue: [basicSize := stream getPositiveInteger]
		ifFalse: [basicSize := 0].
	deserializer register: self.
	classInfo isBytes 
		ifTrue: [stream getBytesFor: (bytes := ByteArray new: basicSize) len: basicSize]
		ifFalse: 
			[variables := Array new: classInfo instSize.
			1 to: classInfo instSize do: [:i | variables at: i put: deserializer odbNextObject].
			basicSize > 0 ifTrue: [indexedVariables := Array new: basicSize].
			1 to: basicSize do: [:i | indexedVariables at: i put: deserializer odbNextObject]].
	^self odbDeserialized: deserializer! !
!ODBUndefinedObject categoriesFor: #className!public! !
!ODBUndefinedObject categoriesFor: #instVarNames!public! !
!ODBUndefinedObject categoriesFor: #instVarValues!public! !
!ODBUndefinedObject categoriesFor: #odbLoadVariables:classInfo:!private! !

