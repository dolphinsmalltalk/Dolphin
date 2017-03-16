"Filed out from Dolphin Smalltalk 7"!

StsEdition subclass: #StsResourceEdition
	instanceVariableNames: 'className name resource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsResourceEdition guid: (GUID fromString: '{32425707-1c73-11d4-b0b1-000000000000}')!
StsResourceEdition comment: ''!
!StsResourceEdition categoriesForClass!Unclassified! !
!StsResourceEdition methodsFor!

canSave
	^false!

className
	^className!

className: anObject 
	className := anObject!

copy
	^ResourceIdentifier class: (self owningClass isNil ifTrue: [Presenter] ifFalse: [self owningClass])
		name: self name!

displayOn: aStream 
	aStream
		nextPutAll: className asString;
		nextPut: $.;
		nextPutAll: name!

icon
	^ResourceIdentifier icon!

load
	self owningClass isNil ifTrue: [self error: 'Owning class does not exist'].
	(ResourceIdentifier class: (Smalltalk at: self className) name: name) assign: resource!

name
	^name!

name: anObject 
	name := anObject!

owningClass
	^Smalltalk at: className ifAbsent: []!

prompt
	"Prompt for and answer a new ResourceIdentifier using the receiver to give the default settings."

	^(ResourceIdentifierDialog createOn: self) showModal!

resolveProxies
	super resolveProxies.
	self resource odbResolve!

resource
	^resource odbResolve!

resource: anObject 
	resource := anObject!

resourceOrNil
	^self resource! !
!StsResourceEdition categoriesFor: #canSave!accessing!public! !
!StsResourceEdition categoriesFor: #className!accessing!public! !
!StsResourceEdition categoriesFor: #className:!accessing!public! !
!StsResourceEdition categoriesFor: #copy!accessing!public! !
!StsResourceEdition categoriesFor: #displayOn:!accessing!public! !
!StsResourceEdition categoriesFor: #icon!accessing!public! !
!StsResourceEdition categoriesFor: #load!public! !
!StsResourceEdition categoriesFor: #name!accessing!public! !
!StsResourceEdition categoriesFor: #name:!accessing!public! !
!StsResourceEdition categoriesFor: #owningClass!accessing!public! !
!StsResourceEdition categoriesFor: #prompt!accessing!public! !
!StsResourceEdition categoriesFor: #resolveProxies!OmniBase!public! !
!StsResourceEdition categoriesFor: #resource!accessing!public! !
!StsResourceEdition categoriesFor: #resource:!accessing!public! !
!StsResourceEdition categoriesFor: #resourceOrNil!accessing!public! !

!StsResourceEdition class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!StsResourceEdition class categoriesFor: #icon!constants!public! !

