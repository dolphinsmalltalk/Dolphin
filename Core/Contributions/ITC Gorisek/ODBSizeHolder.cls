"Filed out from Dolphin Smalltalk 7"!

ODBExternalBuffer subclass: #ODBSizeHolder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBSizeHolder guid: (GUID fromString: '{8162edf8-0fb8-11d4-b091-000000000000}')!
ODBSizeHolder comment: ''!
!ODBSizeHolder categoriesForClass!No category! !
!ODBSizeHolder methodsFor!

dictionarySize

    ^self uLongAtOffset: 0!

dictionarySize: anInteger

    self uLongAtOffset: 0 put: anInteger!

loadPreviousVersionFrom: oldHolders 
	oldHolders loadAt: self previousVersionPosition for: contents!

makeNewVersion: oldHolders
        "Store receiver to oldHolders and make new instance 
        of receiver class that points to receiver in oldHolders."

    | newVersion position |
    self versionNumber = 0
        ifTrue: [ position := 0 ]
        ifFalse: [ position := oldHolders store: contents ].
    newVersion := self class new.
    ^newVersion previousVersionPosition: position!

previousVersionPosition

    ^self uLongAtOffset: 8!

previousVersionPosition: anInteger

    self uLongAtOffset: 8 put: anInteger!

versionNumber
	^self uLongAtOffset: 4!

versionNumber: anInteger

    self uLongAtOffset: 4 put: anInteger! !
!ODBSizeHolder categoriesFor: #dictionarySize!accessing!public! !
!ODBSizeHolder categoriesFor: #dictionarySize:!accessing!public! !
!ODBSizeHolder categoriesFor: #loadPreviousVersionFrom:!public! !
!ODBSizeHolder categoriesFor: #makeNewVersion:!public! !
!ODBSizeHolder categoriesFor: #previousVersionPosition!accessing!private! !
!ODBSizeHolder categoriesFor: #previousVersionPosition:!accessing!private! !
!ODBSizeHolder categoriesFor: #versionNumber!accessing!public! !
!ODBSizeHolder categoriesFor: #versionNumber:!accessing!public! !

!ODBSizeHolder class methodsFor!

sizeInBytes
	^12! !
!ODBSizeHolder class categoriesFor: #sizeInBytes!private! !

