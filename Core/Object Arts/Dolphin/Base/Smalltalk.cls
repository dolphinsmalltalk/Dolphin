"Filed out from Dolphin Smalltalk 7"!

Kernel.Namespace subclass: #Smalltalk
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{Kernel} #{Graphics} #{UI} #{OS} #{External})
	classInstanceVariableNames: 'events allRoots allClasses classesByGuid'
	classConstants: {}!
Smalltalk guid: (Core.GUID fromString: '{4c8d0eb7-6d0e-4467-aea6-e6f1107faf7d}')!
Smalltalk isNonInstantiable: true!
Smalltalk comment: '`Smalltalk` represents the distinguished namespace of the same name. Historically Smalltalk was a global variable holding an instance of the `SystemDictionary` class, although the `SystemDictionary` class no longer exists in Dolphin from 7.2 and Smalltalk is now a namespace class.

The primary purpose of the Smalltalk namespace is to support loading of old packages that pre-date namespace support. It can also be used to continue to work in a flat namespace if that is your preference. It imports all the namespaces that contain parts of the original Dolphin image, and aliases some specifc classes, so the effect is that almost all the classes are globally bindable.  This means that older packages can be loaded and should continue to function, however loose methods added to classes that have been moved to other namespaces may fail to compile due to former global names no longer being in scope. Such compilation failures can be easily corrected by qualifying global names as necessary in the loose methods.
'!
!Smalltalk categoriesForClass!Kernel-Objects! !
!Smalltalk class methodsFor!

allClasses
	"Answer a <sequencedReadableCollection> of all of the classes in the system, in breadth-first order.
	There is no particular ordering at a particular depth."

	allClasses isNil
		ifTrue: 
			[allClasses := Class allClasses
						isImmutable: true;
						yourself].
	^allClasses!

allClassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the <Class>es that are values of bindings in the receiver, including aliases, and recursively in any of the nested namespaces."

	self allClasses do: aMonadicValuable!

allRoots
	"Answer a <sequencedReadableCollection> of all global root classes - ie. those that are subclasses of nil."

	allRoots isNil ifTrue: [allRoots := Class allRoots].
	^allRoots!

classAdded: class
	"Private - The new <Class>, class, has been added to the receiver.
	Clear down the all class cache and inform observers."

	self clearCachedClasses.
	^self trigger: #classAdded: with: class.
!

classesByGuid
	^classesByGuid ifNil: [
		classesByGuid := LookupTable new: self allClasses size.
		allClasses do: [:each | classesByGuid at: each guid put: each].
		classesByGuid]!

classRemoved: aClass
	"Private - The <Class> argument has been removed from the system.
	Clear down the class caches and inform observers."

	self clearCachedClasses.
	self trigger: #classRemoved: with: aClass!

classUpdated: aClass
	"Private - The <Class>, aClass, has been updated. 
	Clear down the class caches and inform observers."

	self clearCachedClasses.
	^self trigger: #classUpdated: with: aClass!

clearCachedClasses
	"Private - Clear down the all class cache."

	allRoots := allClasses := classesByGuid := nil!

declareVariable: aString
	"For historical reasons the names of variables in the system namespace are always Symbols. This isn't strictly necessary in most cases as in Dolphin Symbols and Strings for the same character sequence are equivalent, but they are not identical and so some code may be broken if we don't stick with Symbols."

	^super declareVariable: aString asSymbol!

developmentSystem
	"Answer the current instance of <SmalltalkSystem> if installed, otherwise a <DeafObject>."

	^#{Tools.SmalltalkSystem} valueOrNil
		ifNil: [DeafObject current]
		ifNotNil: [:devSys | devSys current]!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

removeClass: aClass
	aClass environment removeLocalBindingFor: aClass unqualifiedName.
	aClass removeFromSuper.	"At this point it would be a good idea to make the class become: a special error reporting class"
	self classRemoved: aClass!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

shortNameFor: aString in: aNamespace
	^(aNamespace isNil or: 
			[aNamespace == self or: 
					[(self bindingFor: aString)
						ifNil: [self imports anySatisfy: [:each | each value == aNamespace]]
						ifNotNil: [:binding | binding environment == aNamespace]]])
		ifTrue: [aString]
		ifFalse: [aNamespace fullNameFor: aString]!

triggerVariableRenamed: aVariableBinding from: oldSymbol
	"Private - Inform observers that a  system global object has been renamed."

	self
		trigger: #variableRenamed:from:
		with: aVariableBinding
		with: oldSymbol asQualifiedReference! !
!Smalltalk class categoriesFor: #allClasses!accessing!public! !
!Smalltalk class categoriesFor: #allClassesDo:!binding!public! !
!Smalltalk class categoriesFor: #allRoots!accessing!public! !
!Smalltalk class categoriesFor: #classAdded:!event handling!private! !
!Smalltalk class categoriesFor: #classesByGuid!private! !
!Smalltalk class categoriesFor: #classRemoved:!private!removing! !
!Smalltalk class categoriesFor: #classUpdated:!event handling!private! !
!Smalltalk class categoriesFor: #clearCachedClasses!private! !
!Smalltalk class categoriesFor: #declareVariable:!public! !
!Smalltalk class categoriesFor: #developmentSystem!accessing!public! !
!Smalltalk class categoriesFor: #getEvents!events!private! !
!Smalltalk class categoriesFor: #removeClass:!class hierarchy-removing!public! !
!Smalltalk class categoriesFor: #setEvents:!events!private! !
!Smalltalk class categoriesFor: #shortNameFor:in:!helpers!private! !
!Smalltalk class categoriesFor: #triggerVariableRenamed:from:!events!private! !

