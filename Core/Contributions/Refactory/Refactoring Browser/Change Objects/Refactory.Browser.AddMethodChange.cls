"Filed out from Dolphin Smalltalk 7"!

RefactoryClassChange subclass: #AddMethodChange
	instanceVariableNames: 'source selector protocols'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AddMethodChange guid: (GUID fromString: '{67095785-de4e-4bb9-ae66-cb2d970c8a5f}')!
AddMethodChange isAbstract: true!
AddMethodChange comment: ''!
!AddMethodChange categoriesForClass!Refactory-Change Objects! !
!AddMethodChange methodsFor!

= anAddMethodChange 
	super = anAddMethodChange ifFalse: [^false].
	^self parseTree = anAddMethodChange parseTree!

asUndoOperation
	^(self changeClass includesSelector: self selector) 
		ifTrue: 
			[| oldProtocol |
			#rbFix. "Extract protocol lookup to #currentProtocols"
			oldProtocol := self currentProtocols.
			oldProtocol isNil ifTrue: [oldProtocol := #accessing].
			#rbFix.	"Use 'self class' instead of hard ref to AddMethodChange"
			^self class 
				compile: (self methodSourceFor: self selector)
				in: self changeClass
				classified: oldProtocol]
		ifFalse: [RemoveMethodChange remove: selector from: self changeClass]!

changeForClass: aSymbol selector: aSelector 
	^(isMeta not and: [self selector = aSelector and: [className = aSymbol]])
		ifTrue: [self]
		ifFalse: [nil]!

changeForMetaclass: aSymbol selector: aSelector 
	^(isMeta and: [self selector = aSelector and: [className = aSymbol]])
		ifTrue: [self]
		ifFalse: [nil]!

changeString
	^self displayClassName , '>>#' , self selector!

class: aClass protocol: aProtocol source: aString 
	self changeClass: aClass.
	self protocols: aProtocol.
	source := aString!

class: aClass source: aString 
	self changeClass: aClass.
	source := aString.
	#rbFix. "Extract lookup of current protocols to a method so can override"
	self protocols: self currentProtocols!

controller
	^nil!

currentProtocols
	#rbFix. "Private - Extracted from #class:source:"
	^BrowserEnvironment new whichProtocolIncludes: self selector in: self changeClass!

hash
	^self parseTree hash!

parseTree
	^RBParser parseMethod: source onError: [:str :pos | ^nil]!

primitiveExecute
	^self subclassResponsibility!

printOn: aStream 
	aStream
		nextPut: $!!;
		nextPutAll: self displayClassName;
		nextPutAll: ' methodsFor: ';
		print: self protocol displayString;
		nextPut: $!!;
		cr;
		cr;
		nextPutAll: source;
		nextPutAll: '!! !!'!

protocol
	^self protocols notEmpty ifTrue: [self protocols first]!

protocols
	^protocols!

protocols: aCollection
	protocols := aCollection isString ifTrue: [{aCollection}] ifFalse: [aCollection asArray].
	protocols isNil ifTrue: [protocols := #(#accessing)]!

selector
	selector isNil 
		ifTrue: 
			[selector := RBParser parseMethodPattern: source.
			selector isNil ifTrue: [selector := #unknown]].
	^selector! !
!AddMethodChange categoriesFor: #=!comparing!public! !
!AddMethodChange categoriesFor: #asUndoOperation!converting!public! !
!AddMethodChange categoriesFor: #changeForClass:selector:!accessing!public! !
!AddMethodChange categoriesFor: #changeForMetaclass:selector:!accessing!public! !
!AddMethodChange categoriesFor: #changeString!printing!public! !
!AddMethodChange categoriesFor: #class:protocol:source:!initialize/release!public! !
!AddMethodChange categoriesFor: #class:source:!initialize/release!public! !
!AddMethodChange categoriesFor: #controller!accessing!private! !
!AddMethodChange categoriesFor: #currentProtocols!helpers!private! !
!AddMethodChange categoriesFor: #hash!comparing!public! !
!AddMethodChange categoriesFor: #parseTree!helpers!private! !
!AddMethodChange categoriesFor: #primitiveExecute!operations!private! !
!AddMethodChange categoriesFor: #printOn:!printing!public! !
!AddMethodChange categoriesFor: #protocol!accessing!public! !
!AddMethodChange categoriesFor: #protocols!accessing!public! !
!AddMethodChange categoriesFor: #protocols:!initialize/release!public! !
!AddMethodChange categoriesFor: #selector!accessing!public! !

!AddMethodChange class methodsFor!

compile: aString in: aClass 
	^self new class: aClass source: aString!

compile: aString in: aBehavior classified: aProtocol 
	^self new 
		class: aBehavior
		protocol: aProtocol
		source: aString! !
!AddMethodChange class categoriesFor: #compile:in:!instance creation!public! !
!AddMethodChange class categoriesFor: #compile:in:classified:!instance creation!public! !

