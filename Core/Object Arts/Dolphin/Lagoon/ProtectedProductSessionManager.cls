"Filed out from Dolphin Smalltalk 7"!

RuntimeSessionManager subclass: #ProtectedProductSessionManager
	instanceVariableNames: 'encryptedClasses'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProtectedProductSessionManager guid: (GUID fromString: '{a90c2f6f-8f92-4493-995a-1ec18066d054}')!
ProtectedProductSessionManager isAbstract: true!
ProtectedProductSessionManager comment: ''!
!ProtectedProductSessionManager categoriesForClass!Unclassified! !
!ProtectedProductSessionManager methodsFor!

encryptedClasses
	"Answer classes owned by the receiver that will be encrypted in the deployed executable."

	^encryptedClasses!

encryptedClasses: aCollectionOfClasses
	"Private - Record which classes we should encrypt during deployment (this is called
	from #initialise with a list of classes derived from #encryptedPackageNames)."

	encryptedClasses := aCollectionOfClasses.!

encryptedPackageNames
	"Answer an <Array> of <readableStrings> which are the names of the packages whose classes
	will be encrypted in the deployed executable. This must be overidden by subclasses."

	self subclassResponsibility!

initialize
	| packages classes |
	super initialize.
	packages := self encryptedPackageNames collect: [:each | Package manager packageNamed: each ].
	classes := Set new.
	packages do: [:each | classes addAll: each classes ].
	classes := classes asArray select: [:each | self isSafeToEncrypt: each].
	self shouldEncryptMetaclasses ifTrue: [classes := classes , (classes collect: [:each | each class])].
	self encryptedClasses: classes.!

initializeFromSessionManager: oldSessionManager
	"Private - The receiver has taken take over as the current session
	manager from oldSessionManager. We use this as an opportunity to 
	encrypt the classes owned by the receiver."

	super initializeFromSessionManager: oldSessionManager.

	self lock.
!

isSafeToEncrypt: aClass
	"Private -- Answer whether it is safe to encrypt the given class.
	Classes that must not be encrypted are this session manager's
	class, our serial number class, and our product protection class.
	This list is not intended to be exhaustive but just to catch the
	cases that occur easily if some attempts to product protect
	the package containing the protected session manager."

	^ (aClass respondsTo: #isSafeToEncryptWithProductProtection)
		ifTrue: [aClass isSafeToEncryptWithProductProtection]
		ifFalse: ["presumably its OK" ^ true].!

lock
	"Lock the receiver with the serial number determined by our serial number class."

	"the serial number class holds policy decisions about how locking is done, so
	we ask it to arrange the process"
	self serialNumberClass lockClasses: self encryptedClasses.
!

main
	"Start up the application after first unlocking it."

	self unlock.
	self mainShellClass show.
!

productRegistrationKey
	"Answer the registry key where the user's serial number will be stored under HKCU"

	self subclassResponsibility!

promptForSerialNumber
	"Prompt for a serial number to unlock this product. This can be overidden by subclasses that
	want to provide a more luxurious dialog. Answers a valid serial number."

	| snTextValue sn |
	snTextValue := '' asValue.
	
	[(Prompter 
		on: snTextValue
		prompt: 'Please enter your serial number:'
		caption: 'This Product is Licensed') isNil 
		ifTrue: [self quit].
	sn := self serialNumberClass fromString: snTextValue value.
	sn isValid 
		ifFalse: 
			[| mb |
			mb := MessageBox new.
			mb beTaskModal.
			mb errorMsg: 'The serial number you typed was invalid.
Please try again'].
	sn isValid] 
			whileFalse.
	^sn!

serialNumberClass
	"Answer the class of <ProtectedProductSerialNumber> to use for the receiver"

	^self subclassResponsibility!

shouldEncryptMetaclasses
	"Answer whether we should encrypt the class-side methods of our protected classes."

	^ true.!

unlock
	"Unlock the receiver with a serial number pulled from the registry. If none is available
	then prompt the user for a new one."

	"Find the serial number"

	| sn snText |
	snText := RegKey userRoot at: self productRegistrationKey ifPresent: [:key | key value].
	(snText isNil or: [(sn := self serialNumberClass fromString: snText) isValid not]) 
		ifTrue: 
			[sn := self promptForSerialNumber.
			RegKey userRoot at: self productRegistrationKey put: sn displayString].

	"Unlock the product.
	The serial number class holds policy decisions about how locking is done, so
	we ask it to arrange the process"
	self serialNumberClass
		unlockClasses: self encryptedClasses
		using: sn.
! !
!ProtectedProductSessionManager categoriesFor: #encryptedClasses!accessing!public! !
!ProtectedProductSessionManager categoriesFor: #encryptedClasses:!accessing!private! !
!ProtectedProductSessionManager categoriesFor: #encryptedPackageNames!accessing!public! !
!ProtectedProductSessionManager categoriesFor: #initialize!initializing!private! !
!ProtectedProductSessionManager categoriesFor: #initializeFromSessionManager:!initializing!private! !
!ProtectedProductSessionManager categoriesFor: #isSafeToEncrypt:!helpers!private! !
!ProtectedProductSessionManager categoriesFor: #lock!operations!public! !
!ProtectedProductSessionManager categoriesFor: #main!operations!public! !
!ProtectedProductSessionManager categoriesFor: #productRegistrationKey!constants!public! !
!ProtectedProductSessionManager categoriesFor: #promptForSerialNumber!operations!public! !
!ProtectedProductSessionManager categoriesFor: #serialNumberClass!constants!public! !
!ProtectedProductSessionManager categoriesFor: #shouldEncryptMetaclasses!constants!public!testing! !
!ProtectedProductSessionManager categoriesFor: #unlock!operations!public! !

!ProtectedProductSessionManager class methodsFor!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application."

	^ false.! !
!ProtectedProductSessionManager class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !

