"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.LagoonTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.LagoonTests guid: (Core.GUID fromString: '{1d062465-a28b-438e-882d-da296eb78bfa}')!
Tools.Tests.LagoonTests comment: ''!
!Tools.Tests.LagoonTests methodsFor!

testExternalStructureAfterTemplateRemoval
	"Test the behavior of ExternalStructure after the removal of the ability to instantiate templates during image stripping (specifically its ability to handle canUnderstand:)
	Regression test for #1095"

	| testSubjectClass savedMethodDicts classesToPreserve msgboxparams |
	"Pre-check test assumptions"
	self deny: (OS.MSGBOXPARAMSW includesSelector: #dwLanguageId).
	self deny: (OS.MSGBOXPARAMSW includesSelector: #dwLanguageId:).
	self deny: (OS.MSGBOXPARAMSW canUnderstand: #dwLanguageId).
	self assert: (OS.MSGBOXPARAMSW canUnderstand: #dwLanguageId:).
	self assert: OS.MSGBOXPARAMSW dynamicSelectors single equals: #dwLanguageId:.
	msgboxparams := OS.MSGBOXPARAMSW new.
	msgboxparams dwLanguageId: 123.
	self assert: (msgboxparams bytes uint32AtOffset: OS.MSGBOXPARAMSW._OffsetOf_dwLanguageId)
		equals: 123.

	"Cache current and instantiate copy methodDictionaries to enable partial run of image stripper without destroying the system"
	classesToPreserve := {
				External.Structure.
				External.Structure class.
				OS.MSGBOXPARAMSW.
				OS.MSGBOXPARAMSW class.
				Smalltalk.ImageStripper.
				Smalltalk.BasicImageStripper
			}.
	savedMethodDicts := classesToPreserve collect: [:each | each methodDictionary].
	
	[classesToPreserve do: 
			[:each |
			each
				methodDictionary: each methodDictionary copy;
				flushMethodCache].
	testSubjectClass := Smalltalk.ImageStripper newAnonymousSubclass.
	testSubjectClass compile: '_deleteFieldClasses'.
	testSubjectClass
		compile: 'initialize super initialize. deploymentContext := DeploymentContext new initialize'.
	testSubjectClass new _compileExternalStructuresNow: { OS.MSGBOXPARAMSW }.
	self assert: External.Structure template isNil.
	self shouldnt: [External.Structure canUnderstand: #anything] raise: MessageNotUnderstood.
	self assert: (External.Structure canUnderstand: #value).
	self deny: (External.Structure canUnderstand: #vAlUe).
	self assert: External.Structure template isNil.
	self assert: OS.MSGBOXPARAMSW template isNil.
	self deny: (OS.MSGBOXPARAMSW includesSelector: #dwLanguageId).
	self assert: (OS.MSGBOXPARAMSW includesSelector: #dwLanguageId:).
	self deny: (OS.MSGBOXPARAMSW canUnderstand: #dwLanguageId).
	self assert: (OS.MSGBOXPARAMSW canUnderstand: #dwLanguageId:).
	msgboxparams dwLanguageId: 456.
	self assert: (msgboxparams bytes uint32AtOffset: OS.MSGBOXPARAMSW._OffsetOf_dwLanguageId)
		equals: 456]
			ensure: 
				[classesToPreserve with: savedMethodDicts
					do: 
						[:class :dict |
						class
							methodDictionary: dict;
							flushMethodCache]].

	"Ensure things are back to normal and no damage is done"
	self assert: External.Structure template notNil.
	self assert: #{External.Field} isDefined.
	self assert: #{Smalltalk.ExternalField} isDefined.
	self assert: (Smalltalk.BasicImageStripper includesSelector: #_deleteFieldClasses)! !
!Tools.Tests.LagoonTests categoriesForMethods!
testExternalStructureAfterTemplateRemoval!public!unit tests! !
!

