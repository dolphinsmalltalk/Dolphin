"Filed out from Dolphin Smalltalk"!

Kernel.Namespace
	subclass: #Smalltalk
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{Kernel} #{Graphics} #{UI} #{OS} #{External} #{Tools private})
	classInstanceVariableNames: 'events allRoots allClasses classesByGuid oldNames'
	classConstants: {}!
Smalltalk guid: (Core.GUID fromString: '{4c8d0eb7-6d0e-4467-aea6-e6f1107faf7d}')!
Smalltalk isNonInstantiable: true!
Smalltalk comment: '`Smalltalk` represents the distinguished namespace of the same name. Historically Smalltalk was a global variable holding an instance of the `SystemDictionary` class, although the `SystemDictionary` class no longer exists in Dolphin from 8.x and Smalltalk is now a `Namespace` class.

The primary purpose of the Smalltalk namespace is to support loading of old packages that pre-date namespace support. It can also continue to be used as the namespace for application code if that is your preference. It imports all the namespaces that contain parts of the original Dolphin image, and aliases some specific classes, so the effect is that almost all the classes are globally bindable.  This means that older packages can be loaded and should continue to function, however loose methods added to classes that have been moved to other namespaces may fail to compile due to former global names no longer being in scope. Such compilation failures can be easily corrected by qualifying global names as necessary in the loose methods.

Smalltalk has special implementations of some of the `Dictionary` protocol such as `at:[put:]`, `includesKey:`, etc, that will accept qualified names. This is to assist with the migration of legacy code to namespaces and allows dynamic lookups such as `Smalltalk at: #MyClass` to continue to function after renaming into namespaces, e.g., `Smalltalk at: #''MyNamespace.MyClass`. The Rename Class refactoring will translate symbolic references to classes that were in Smalltalk into fully-qualified references when a class is renamed into a namespace. This is necessary because the old unqualified name will no longer be found directly in `Smalltalk`, although it is really only intended as a temporary solution while porting code into namespaces. The illusion of a single flat namespace is far from complete.'!
!Smalltalk categoriesForClass!Kernel-Objects! !
!Smalltalk class methodsFor!

allClasses
	"Answer a <sequencedReadableCollection> of all of the classes in the system, in breadth-first order.
	There is no particular ordering at a particular depth."

	allClasses isNil
		ifTrue: 
			[allClasses := Class allClasses
						beImmutableObject;
						yourself].
	^allClasses!

allClassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the <Class>es that are values of bindings in the receiver, including aliases, and recursively in any of the nested namespaces."

	self allClasses do: aMonadicValuable!

allRoots
	"Answer a <sequencedReadableCollection> of all global root classes - ie. those that are subclasses of nil."

	allRoots isNil ifTrue: [allRoots := Class allRoots].
	^allRoots!

basicAddBinding: aVariableBinding
	"Private - For historical reasons the names of variables in the system namespace are always Symbols. This isn't strictly necessary in most cases as in Dolphin Symbols and Strings for the same character sequence are equivalent, but they are not identical and so some code may be broken if we don't stick with Symbols."

	aVariableBinding setKey: aVariableBinding key asSymbol.
	^super basicAddBinding: aVariableBinding!

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
	"Private - Clear down the class caches."

	oldNames := allRoots := allClasses := classesByGuid := nil!

developmentSystem
	"Answer the current instance of <SmalltalkSystem> if installed, otherwise a <DeafObject>."

	^#{Tools.SmalltalkSystem} valueOrNil
		ifNil: [DeafObject current]
		ifNotNil: [:devSys | devSys current]!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

oldNames
	"Answer an <abstractDictionary> mapping new namespaced classes to old pre-namespace Smalltalk class names."

	^oldNames
		ifNil: 
			[oldNames := IdentityDictionary new.
			self bindingsDo: 
					[:each |
					| value |
					value := each value.
					(value class isMeta and: [value environment ~~ self and: [each isDeprecated not]])
						ifTrue: [oldNames at: value put: each key]].
			oldNames]!

removeClass: aClass
	aClass environment removeBindingFor: aClass unqualifiedName.
	aClass removeFromSuper.	"At this point it would be a good idea to make the class become: a special error reporting class"
	self classRemoved: aClass!

resetOldNames
	oldNames := nil!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

shortNameFor: aString
	"Private - Answer the short name for the receiver's variable named, aString. The short name is the shortest name that binds to variable starting from the Smalltalk namespace. All of the receiver's variables are of course bindable by unqualified name."

	^aString!

shortNameFor: aString in: aNamespace
	^(aNamespace isNil or: 
			[(self fullBindingFor: aString)
				ifNil: [self imports anySatisfy: [:each | each valueOrNil == aNamespace]]
				ifNotNil: [:binding | binding environment == aNamespace or: [binding environment == self]]])
		ifTrue: [aString]
		ifFalse: [aNamespace relativeShortName: aString]!

staticVariableRemoved: aVariableBinding
	self
		clearCachedClasses;
		trigger: #variableRemoved: with: aVariableBinding! !
!Smalltalk class categoriesForMethods!
allClasses!accessing!public! !
allClassesDo:!binding!public! !
allRoots!accessing!public! !
basicAddBinding:!class variables!private! !
classAdded:!event handling!private! !
classesByGuid!private! !
classRemoved:!private!removing! !
classUpdated:!event handling!private! !
clearCachedClasses!initializing!private! !
developmentSystem!accessing!public! !
getEvents!events!private! !
oldNames!accessing!public! !
removeClass:!operations!public! !
resetOldNames!initializing!private! !
setEvents:!events!private! !
shortNameFor:!enquiries!private! !
shortNameFor:in:!helpers!private! !
staticVariableRemoved:!class hierarchy-mutating!class variables!private! !
!

