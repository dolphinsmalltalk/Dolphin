"Filed out from Dolphin Smalltalk"!

SmalltalkSystem subclass: #CommunityEditionSmalltalkSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CommunityEditionSmalltalkSystem guid: (GUID fromString: '{fe94a239-c422-4a02-a575-5e7923ce1d63}')!

CommunityEditionSmalltalkSystem comment: ''!

!CommunityEditionSmalltalkSystem categoriesForClass!MVP-Models! !

!CommunityEditionSmalltalkSystem methodsFor!

initializeSystemFolder
	super initializeSystemFolder.
	self
		addSystemFolderIcon: (SmalltalkSystemFolder
					icon: self samplesFolderIcon
					description: 'Sample Applications'
					helpId: 10560);
		addSystemFolderIcon: (SmalltalkSystemFolder
					icon: self userPreferencesIcon
					description: 'User Preferences'
					openBlock: [:folder :item | self inspectSystemOptions]
					helpId: 10580)! !

!CommunityEditionSmalltalkSystem categoriesForMethods!
initializeSystemFolder!initializing!private! !
!

!CommunityEditionSmalltalkSystem class methodsFor!

initialize
	"Private - Initialize the receiver on load (take over as the development system model)."

	self installCurrent!

installCurrent
	"Private - Take over as the development system model."

	self current become: (self basicNew initializeFrom: self current)!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self uninstallCurrent!

uninstallCurrent
	(Current notNil and: [Current class == self]) 
		ifTrue: 
			[(self superclass basicNew)
				initializeFrom: Current;
				become: Current]! !

!CommunityEditionSmalltalkSystem class categoriesForMethods!
initialize!initializing!private! !
installCurrent!initializing!private! !
uninitialize!class hierarchy-removing!private! !
uninstallCurrent!class hierarchy-removing!private! !
!

