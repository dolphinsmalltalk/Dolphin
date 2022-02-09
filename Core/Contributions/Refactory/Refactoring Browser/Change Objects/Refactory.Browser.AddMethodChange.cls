"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.AddMethodChange'
	instanceVariableNames: 'source selector protocols environment packageName compilationFlags method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddMethodChange guid: (Core.GUID fromString: '{67095785-de4e-4bb9-ae66-cb2d970c8a5f}')!
Refactory.Browser.AddMethodChange comment: ''!
!Refactory.Browser.AddMethodChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.AddMethodChange methodsFor!

= anAddMethodChange 
	super = anAddMethodChange ifFalse: [^false].
	^self parseTree = anAddMethodChange parseTree!

afterText
	^source!

asUndoOperation
	^(self changeClass includesSelector: self selector)
		ifTrue: 
			[| oldProtocol |
			#rbFix.	"Extract protocol lookup to #currentProtocols"
			oldProtocol := self currentProtocols.
			oldProtocol isNil ifTrue: [oldProtocol := #accessing].
			#rbFix.	"Use 'self class' instead of hard ref to AddMethodChange"
			^self class
				compile: (self methodSourceFor: self selector)
				in: self changeClass
				environment: environment
				categories: protocols
				package: self package]
		ifFalse: [RemoveMethodChange remove: selector from: self changeClass]!

beforeText
	^(self methodSourceFor: selector) !

categories
	^protocols collect: [:each | each asMethodCategory]!

changeForClass: aSymbol selector: aSelector 
	^(self selector == aSelector and: [classReference asString = aSymbol])
		ifTrue: [self]
		ifFalse: [nil]!

changeForMetaclass: aSymbol selector: aSelector 
	^(self isMeta and: [self selector = aSelector and: [classReference instance asString = aSymbol]])
		ifTrue: [self]
		ifFalse: [nil]!

changeString
	^'<1s> <2s>>><3s>'
		expandMacrosWith: ((self changeClass
				ifNil: [false]
				ifNotNil: [:class | class includesSelector: self selector]) ifTrue: ['Modify'] ifFalse: ['Add'])
		with: self displayClassName
		with: self selector!

class: aClass protocol: aProtocol source: aString 
	self changeClass: aClass.
	self protocols: aProtocol.
	source := aString!

class: aClass source: aString 
	self changeClass: aClass.
	source := aString.
	#rbFix. "Extract lookup of current protocols to a method so can override"
	self protocols: self currentProtocols!

compilationFlags
	^compilationFlags ifNil: [self changeClass defaultCompilationFlags]!

compilationFlags: anInteger 
	compilationFlags := anInteger!

currentProtocols
	^self changeClass
		ifNil: [#()]
		ifNotNil: [:class | BrowserEnvironment new whichProtocolsInclude: self selector in: class]!

environment
	"Answer the <Namespace> into which the method should be compiled (or nil for the owning class' namespace)."

	^environment value!

environment: aNamespace
	environment := aNamespace ifNotNil: [aNamespace asQualifiedReference realReference]!

hash
	^self parseTree hash!

method
	"Answer the method resulting from the change. This will be nil if the change has not been
	performed yet, or was unsuccessful."

	^method!

package
	^packageName ifNotNil: [Package manager packageNamed: packageName ifNone: nil]!

package: aPackage 
	packageName := aPackage isNil ifFalse: [aPackage name]!

packageName
	^packageName!

parseTree
	^Parser parseMethod: source onError: [:str :pos | ^nil]!

primitiveExecute
	method := self changeClass
				compile: source
				environment: self environment
				categories: self categories
				package: self package
				flags: self compilationFlags!

printOn: aStream
	| className |
	className := self displayClassName.
	aStream
		nextPut: $!!;
		nextPutAll: className;
		nextPutAll: ' methodsFor';
		nextPut: $!!;
		cr;
		cr;
		nextPutAll: source;
		nextPutAll: '!! !!'.
	protocols isEmpty ifTrue: [^self].
	aStream
		cr;
		nextPut: $!!;
		nextPutAll: className;
		space;
		nextPutAll: #categoriesFor:;
		space;
		print: selector.
	protocols asSortedCollection do: 
			[:each |
			aStream
				nextPut: $!!;
				nextPutAll: each].
	aStream nextPutAll: '!! !!'!

protocol
	Notification deprecated.
	^self protocols notEmpty ifTrue: [self protocols first]!

protocols
	^protocols!

protocols: aCollection
	protocols := aCollection isString ifTrue: [{aCollection}] ifFalse: [aCollection asArray].
	protocols isNil ifTrue: [protocols := #(#accessing)]!

selector
	^selector ifNil: [selector := (Parser parseMethodPattern: source) ?? #unknown]!

source
	^source! !
!Refactory.Browser.AddMethodChange categoriesForMethods!
=!comparing!public! !
afterText!printing!public! !
asUndoOperation!converting!public! !
beforeText!printing!public! !
categories!accessing!public! !
changeForClass:selector:!accessing!public! !
changeForMetaclass:selector:!accessing!public! !
changeString!printing!public! !
class:protocol:source:!initializing!private! !
class:source:!initializing!private! !
compilationFlags!accessing!public! !
compilationFlags:!accessing!public! !
currentProtocols!converting!public! !
environment!accessing!public! !
environment:!accessing!private! !
hash!comparing!public! !
method!accessing!public! !
package!accessing!public! !
package:!accessing!public! !
packageName!accessing!public! !
parseTree!helpers!private! !
primitiveExecute!operations!private! !
printOn:!printing!public! !
protocol!accessing!public! !
protocols!accessing!public! !
protocols:!initializing!private! !
selector!accessing!public! !
source!accessing!public! !
!

!Refactory.Browser.AddMethodChange class methodsFor!

compile: aString in: aClass
	| change |
	change := self new class: aClass source: aString.
	change changeClass
		ifNotNil: 
			[:class |
			| programObject |
			programObject := class compiledMethodAt: change selector ifAbsent: class.
			change
				package: programObject owningPackage;
				environment: programObject environment].
	^change!

compile: aString in: aClass categories: aSequenceableCollection
	"N.B. The new method will be assigned to its existing package (if a modification) or the
	class' package (if an addition)."

	| change |
	change := self compile: aString in: aClass.
	aSequenceableCollection notNil
		ifTrue: [change protocols: (aSequenceableCollection collect: [:each | each asString])].
	^change!

compile: aString in: aBehavior classified: aProtocol
	Notification deprecated.
	^self
		compile: aString
		in: aBehavior
		categories: {aProtocol}!

compile: aString in: aClass environment: aNamespace categories: aSequenceableCollection package: aPackage
	| change |
	change := self new class: aClass source: aString.
	aSequenceableCollection notNil
		ifTrue: [change protocols: (aSequenceableCollection collect: [:each | each asString])].
	change
		environment: aNamespace;
		package: aPackage.
	^change! !
!Refactory.Browser.AddMethodChange class categoriesForMethods!
compile:in:!instance creation!public! !
compile:in:categories:!instance creation!public! !
compile:in:classified:!instance creation!public! !
compile:in:environment:categories:package:!instance creation!public! !
!

