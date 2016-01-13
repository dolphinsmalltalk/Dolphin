"Filed out from Dolphin Smalltalk 7"!

DolphinProfessional subclass: #Project
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Project guid: (GUID fromString: '{127BC143-2779-43EA-B88D-0E575A9EE8B4}')!
Project comment: 'This class helps us build the Project Development image'!
!Project categoriesForClass!Development! !
!Project methodsFor!

contents
	"Answer the list of package contents owned by the receiver"

	^super contents
		add: #('Project Development.pax' #plain #imageBased);
		yourself!

fullName
	"Answer the full product name associated with the receiver"

	^'Project Development'!

shortProductName
	"Answer the abbreviated product name"
	
	^'Project'! !
!Project categoriesFor: #contents!public! !
!Project categoriesFor: #fullName!public! !
!Project categoriesFor: #shortProductName!public! !

!Project class methodsFor!

productName
	"Answer the product name"
	
	^'for Project'!

shortProductName
	"Answer the abbreviated product name"
	
	^'Project'! !
!Project class categoriesFor: #productName!accessing!public! !
!Project class categoriesFor: #shortProductName!accessing!public! !

