"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Filename
	instanceVariableNames: 'filename file'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Filename guid: (GUID fromString: '{83bbd9dd-34a1-45f9-b021-cb12199da3fb}')!
Filename comment: ''!
!Filename categoriesForClass!Unclassified! !
!Filename methodsFor!

close
	self fileObject close!

creationTime
	^Timestamp fromSYSTEMTIME: self fileObject creationTime asSYSTEMTIME!

exists
	^(self fileObject == false) not!

fileObject
	file isNil 
		ifTrue: 
			[
			[file := File new 
						open: filename
						mode: #read
						check: true
						share: #read] 
					on: Error
					do: [:ex | ex exitWith: nil].
			file isNil ifTrue: [file := false]].
	^file!

lastModificationTime
	^Timestamp fromSYSTEMTIME: self fileObject lastWriteTime asSYSTEMTIME!

setFilename: aString 
	filename := aString!

size
	^self fileObject size! !
!Filename categoriesFor: #close!public! !
!Filename categoriesFor: #creationTime!public! !
!Filename categoriesFor: #exists!public! !
!Filename categoriesFor: #fileObject!public! !
!Filename categoriesFor: #lastModificationTime!public! !
!Filename categoriesFor: #setFilename:!public! !
!Filename categoriesFor: #size!public! !

!Filename class methodsFor!

named: filename 
	^self new setFilename: filename! !
!Filename class categoriesFor: #named:!public! !

