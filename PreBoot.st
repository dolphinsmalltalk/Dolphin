!Kernel.BindingContext methodsFor!

visitImport: aBindingReference from: aNamespace
	(aBindingReference isPrivate and: [(source includesNamespace: aNamespace) not]) ifTrue: [^nil].
	^aBindingReference valueOrNil
		ifNotNil: 
			[:namespace |
			"We delay initializing the visited set until the last possible moment, as mostly is is not required."
			((visited ifNil: [visited := Set with: source]) addNewElement: namespace) ifTrue: [namespace]]! !

!Kernel.ChunkSourceFiler class methodsFor!

fileOutExtensionForClass: aClass
	^'cls'! !


