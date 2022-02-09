"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange subclass: #'Tools.ReplaceImportChange'
	instanceVariableNames: 'oldImport newImport'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ReplaceImportChange guid: (Core.GUID fromString: '{0de17edc-6eb7-4c7f-a0f9-85cd5c482bb2}')!
Tools.ReplaceImportChange comment: ''!
!Tools.ReplaceImportChange categoriesForClass!Refactory-Change Objects! !
!Tools.ReplaceImportChange methodsFor!

= anObject
	self class = anObject class ifFalse: [^false].
	^classReference = anObject classReference
		and: [oldImport = anObject oldImport and: [newImport = anObject newImport]]!

afterText
	| class |
	class := self changeClass.
	class ifNil: [^super afterText].
	class := class basicShallowCopy.
	class imports: (class imports copyReplacing: oldImport withObject: newImport).
	^class definition
!

asUndoOperation
	^self class
		rename: newImport
		to: oldImport
		in: self changeClass!

beforeText
	^self changeClass ifNil: [super beforeText] ifNotNil: [:class | class definition]!

changeClass: aBehavior
	super changeClass: aBehavior.
	classReference := classReference instance!

changeString
	^'Import <2p> into <3d>, instead of <1p>' << { oldImport. newImport. classReference }!

hash
	^(classReference hash bitXor: self oldImport hash) bitXor: self newImport hash!

newImport
	^newImport!

newImport: aBindingReference
	newImport := aBindingReference asQualifiedReference asFullyQualifiedReference!

oldImport
	^oldImport!

oldImport: aBindingReference
	oldImport := aBindingReference asQualifiedReference asFullyQualifiedReference!

primitiveExecute
	self changeClass replaceImport: oldImport with: newImport!

printOn: aStream
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' replaceImport: ';
		print: oldImport;
		nextPutAll: ' with: ';
		print: newImport;
		nextPutAll: '!!'! !
!Tools.ReplaceImportChange categoriesForMethods!
=!comparing!public! !
afterText!printing!public! !
asUndoOperation!converting!public! !
beforeText!printing!public! !
changeClass:!accessing!public! !
changeString!printing!public! !
hash!comparing!public! !
newImport!accessing!public! !
newImport:!accessing!private! !
oldImport!accessing!public! !
oldImport:!accessing!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
!

!Tools.ReplaceImportChange class methodsFor!

replaceImport: oldBindingReference with: newBindingReference in: aClass
	^self new
		oldImport: oldBindingReference;
		newImport: newBindingReference;
		changeClass: aClass;
		yourself! !
!Tools.ReplaceImportChange class categoriesForMethods!
replaceImport:with:in:!instance creation!public! !
!

