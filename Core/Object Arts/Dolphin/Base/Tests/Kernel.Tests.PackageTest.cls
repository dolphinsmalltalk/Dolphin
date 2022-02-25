"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.PackageTest'
	instanceVariableNames: 'loadedPackages checkTimestamps'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.PackageTest guid: (Core.GUID fromString: '{0bcde90d-a936-43ee-9e4a-2bdec39abf2a}')!
Kernel.Tests.PackageTest comment: ''!
!Kernel.Tests.PackageTest categoriesForClass!Unclassified! !
!Kernel.Tests.PackageTest methodsFor!

checkNoTestPackageContents
	| scribbleClass |
	self deny: #{Smalltalk.ScribbleTest} isDefined.
	scribbleClass := #{Smalltalk.Scribble} value.
	self assertIsNil: (scribbleClass compiledMethodAt: #looseA ifAbsent: nil).
	self assertIsNil: (scribbleClass compiledMethodAt: #looseC ifAbsent: nil).
	self assertIsNil: (scribbleClass class compiledMethodAt: #resource_Scribble_test ifAbsent: nil).
	self deny: (SharedPool allSubclasses anySatisfy: [:each | each name = #ScribbleTestSourceGlobal])!

checkTestPackageContents
	| scribbleTestPackage scribbleTestClass scribbleTest scribbleTestResourceMethod scribbleTestDefaultViewId scribbleTestViewId scribbleClass resourceIds |
	scribbleTestPackage := loadedPackages first.
	self assert: (scribbleTestPackage name beginsWith: 'ScribbleTest').
	self verifyPackageElementNamesAreAbsolute: scribbleTestPackage.
	scribbleTestClass := #{Smalltalk.ScribbleTest} value.
	self assert: (scribbleTestPackage classes identityIncludes: scribbleTestClass).
	scribbleTestResourceMethod := scribbleTestClass class
				compiledMethodAt: #resource_Default_scribble_test_view.
	self assert: scribbleTestResourceMethod owningPackage equals: scribbleTestPackage.
	scribbleClass := #{Smalltalk.Scribble} value.
	self assert: (scribbleClass compiledMethodAt: #looseA) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass compiledMethodAt: #looseC) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass class compiledMethodAt: #resource_Scribble_test) owningPackage
		equals: scribbleTestPackage.
	resourceIds := scribbleTestPackage allResourceIdentifiers.
	self assert: resourceIds size equals: 2.
	scribbleTestDefaultViewId := UI.ResourceIdentifier class: scribbleTestClass
				name: 'Default scribble test view'.
	self assert: (resourceIds includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage equals: scribbleTestPackage.
	scribbleTestViewId := UI.ResourceIdentifier class: scribbleClass name: 'Scribble test'.
	self assert: (resourceIds includes: scribbleTestViewId).
	self assert: scribbleTestViewId owningPackage equals: scribbleTestPackage.
	
	[scribbleTest := scribbleTestClass show.
	self assert: scribbleTest a equals: 'A']
			ensure: [scribbleTest view topView destroy]!

d5ForwardRefTestPacContents
	^'| package |
package := Package name: ''D5LoadTest''.
package paxVersion: 0;
	basicComment: ''''.


package resourceNames
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself.

package binaryGlobalNames: (Set new
	yourself).

package globalAliases: (Set new
	yourself).

package allResourceNames: (Set new
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself).

package setPrerequisites: (IdentitySet new
	add: ''Object Arts\Dolphin\Base\Dolphin'';
	add: ''Object Arts\Dolphin\MVP\Views\Common Controls\Dolphin Common Controls'';
	add: ''Object Arts\Dolphin\MVP\Views\Control Bars\Dolphin Control Bars'';
	add: ''Object Arts\Dolphin\MVP\Base\Dolphin MVP Base'';
	yourself).

package!!

"Class Definitions"!!


"Global Aliases"!!


"Loose Methods"!!

"End of package definition"!!

"Source Globals"!!

"Classes"!!

"Binary Globals"!!

"Resources"!!

(ResourceIdentifier class: Presenter name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALoGAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAADQAAAENvbnRhaW5lclZpZXdiAAAA
DwAAAAAAAAAAAAAAYgAAAAIAAACCAAAABAAAAAAAAEQBAAIAoAEAAAAAAAAAAAAAAAAAAAcAAAAA
AAAAAAAAAAAAAACgAQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2Vx
dWVuY2UAAAAAygAAAAAAAADQAAAAYgAAAAEAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABS
AAAAEAAAAGNyZWF0ZUF0OmV4dGVudDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAAMICAAAA
AAAAvQIAAPUBAACgAQAABgEPAFdJTkRPV1BMQUNFTUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAA
AP////////////////////8FAAAABQAAAGMBAAD/AAAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAA
AAAAAJoAAAAAAAAAUgAAABcAAABEb2xwaGluIENvbW1vbiBDb250cm9sc1IAAAAZAAAATXVsdGlw
bGVTZWxlY3Rpb25MaXN0Vmlld2IAAAAeAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAASRABRAEE
AABAAwAARgMJAAIAAABMaXN0TW9kZWwAAAAAygAAAAAAAADQAAAAIAIAAAAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAADAAAAFNlYXJjaFBvbGlj
eboAAAAAAAAAUgAAAAgAAABpZGVudGl0eQAAAAAAAAAABwAAAAAAAAAAAAAAAAAAAEADAAAAAAAA
ggAAAAgAAAAzA///AAAAAJoAAAAAAAAAwAEAAFIAAAARAAAAQmFzaWNMaXN0QWJzdHJhY3SaAAAA
AAAAAGADAABSAAAAEgAAAEljb25pY0xpc3RBYnN0cmFjdOoDAAAAAAAAmgAAAAAAAADAAQAAUgAA
ABAAAABJY29uSW1hZ2VNYW5hZ2VyugAAAAAAAABSAAAABwAAAGN1cnJlbnQAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAADKAAAAAAAAANAAAABiAAAAAQAAAEYMDgAFAAAATGlzdFZpZXdDb2x1bW4AAAAA
UgAAAAgAAABDb2x1bW4gMckAAAC6AAAAAAAAAFIAAAAEAAAAbGVmdGAEAACaAAAAAAAAABAEAABS
AAAAEAAAAFNvcnRlZENvbGxlY3Rpb24AAAAAAAAAAEADAAAAAAAAAQAAAAAAAAAAAAAAugAAAAAA
AABSAAAABgAAAHJlcG9ydGIAAAAAAAAAAAAAAGEAAAAAAAAAAAAAADICAAAAAAAAygAAAAAAAADQ
AAAAYgAAAAIAAAByAgAAAAAAAJACAABiAAAAAgAAAMICAAAAAAAAbwAAAEcAAADCAgAAAAAAAJEB
AACNAQAAQAMAAHICAAAAAAAAugAAAAAAAABSAAAABQAAAHRleHQ6YgAAAAEAAABSAAAACAAAAENv
bHVtbiAxQAMAAPICAAAAAAAAcgAAACwAAAAsAAAAAAAAAAEAAAD/////////////////////NwAA
ACMAAAD/AAAA6QAAAMoAAAAAAAAA0AAAACACAADCAgAAAAAAAMEAAADBAAAAAAAAABcAAACaAQAA
AAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJlbmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAA
AgAAAIIAAAAEAAAAAAAARAEAAgCwBgAAAAAAAAAAAAAAAAAABwAAAAAAAAAAAAAAAAAAALAGAAAG
AhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAMgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAHICAAAAAAAAkAIAAGIAAAACAAAAwgIAAAAAAABRAAAACwAAAMICAAAAAAAA4QEAAFEAAACw
BgAA8gIAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8oAAAABQAAABgB
AAAtAAAAYgAAAAAAAACgBgAAAAAAABUAAACgBgAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAA
ABAAAAAOAhEAU1RCU2luZ2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAA
GAAAAEltYWdlUmVsYXRpdmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABEA
AABDb250YWluZXJWaWV3Lmljbw4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFyeVByb3h5AAAA
AFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAA=''))!!

(ResourceIdentifier class: Shell name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALUEAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAACQAAAFNoZWxsVmlld2IAAAAbAAAA
AAAAAAAAAABiAAAAAgAAAAEAngEBAAIAoAEAAAAAAAAAAAAAAAAAAAcCAAAAAAAAAAAAAAAAAACg
AQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAA
AAAAAAAAAAAAAAEAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2VxdWVuY2UAAAAAygAAAAAAAADQAAAA
YgAAAAIAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABSAAAAEAAAAGNyZWF0ZUF0OmV4dGVu
dDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAALICAAAAAAAATQMAAOcCAACgAQAAYgIAAAAA
AAC6AAAAAAAAAFIAAAAIAAAAbWVudUJhcjpiAAAAAQAAAAAAAACgAQAABgEPAFdJTkRPV1BMQUNF
TUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAAAP////////////////////8FAAAABQAAAKsBAAB4
AQAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAAAAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJl
bmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgBwAwAAAAAAAAAA
AAAAAAAABwAAAAAAAAAAAAAAAAAAAHADAAAGAhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAA
AAAAwAEAAFIAAAAJAAAAUHJlc2VudGVyUgAAAAIAAABENgAAAAAiAgAAAAAAAMoAAAAAAAAA0AAA
AGIAAAABAAAAYgIAAAAAAACAAgAAYgAAAAIAAACyAgAAAAAAAHkAAACDAAAAsgIAAAAAAAB3AgAA
dwIAAHADAAAiAwAAAAAAAHIAAAAsAAAALAAAAAAAAAABAAAA/////////////////////zwAAABB
AAAAdwEAAHwBAABiAAAAAAAAALICAAAAAAAAwQAAAMEAAAAAAAAAFQAAAJoBAAAAAAAAgAMAAGIA
AAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgDQBAAAAAAAAAAAAAAAAAAABwAA
AAAAAAAAAAAAAAAAANAEAADSAwAAAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAIgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAGICAAAAAAAAgAIAAGIAAAACAAAAsgIAAAAAAAApAAAACwAAALICAAAAAAAA9QEAAFsAAADQ
BAAAIgMAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8UAAAABQAAAA4B
AAAyAAAAsAQAAMAEAAAAAAAAFQAAAMAEAAAAAAAAFQAAAEYFBAADAAAASWNvbgAAAAAAAAAAEAAA
AA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIAAAAHAAAARG9scGhpblIAAAAYAAAA
SW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAABwAAAGN1cnJlbnRSAAAADQAAAFNo
ZWxsVmlldy5pY28OAh8AU1RCRXh0ZXJuYWxSZXNvdXJjZUxpYnJhcnlQcm94eQAAAABSAAAAEAAA
AGRvbHBoaW5kcjAwNS5kbGwAAAAA''))!!

(ResourceIdentifier class: Toolbar name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAAFUFAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAFAAAAERvbHBoaW4gQ29udHJvbCBCYXJzUgAAAAcAAABUb29sYmFyYgAAABkA
AAAAAAAAAAAAAGIAAAACAAAAggAAAAQAAAAECwBEAQACAKABAAAAAAAABgELAFN5c3RlbUNvbG9y
AAAAAB8AAAAAAAAABwIAAAAAAAAGBAQARm9udAAAAAAAAAAAEAAAAAYBBwBMT0dGT05UAAAAAHIA
AAA8AAAA8////wAAAAAAAAAAAAAAAJABAAAAAAAAAwIBIkFyaWFsAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAABgIFAFBvaW50AAAAAMEAAADBAAAAAAAAAKABAAAAAAAAggAAAAgAAADdA///AAAA
AOoAAAAAAAAAAAEAAGIAAAAAAAAA6gAAAAAAAAAAAQAAYgAAAAYAAADLvgAABgcNAFRvb2xiYXJC
dXR0b24AAAAAy74AAAAAAACgAQAAAQAAAEYFEgAEAAAAQ29tbWFuZERlc2NyaXB0aW9uAAAAALoA
AAAAAAAAUgAAAAkAAABub0NvbW1hbmRSAAAACgAAAE5vIGNvbW1hbmQBAAAAAQAAAAAAAABGCAYA
AwAAAEJpdG1hcAAAAAAAAAAAEAAAAA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIA
AAAHAAAARG9scGhpblIAAAAYAAAASW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAA
BwAAAGN1cnJlbnRSAAAACQAAAFRvb2xzLmJtcA4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFy
eVByb3h5AAAAAFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAAAAAAABwAAAIICAAAAAAAAIQcA
ACEAAABHAAAAzb4AAPICAAAAAAAAzb4AAAAAAACgAQAAAQAAABIDAAAAAAAAMAMAAFADAAABAAAA
AQAAAAAAAABiAwAAAAAAAAAAAAAQAAAAkAMAAPADAAAQBAAAAAAAAAUAAAAAAAAARwAAAM++AADy
AgAAAAAAAM++AAAAAAAAoAEAAAEAAAASAwAAAAAAADADAABQAwAAAQAAAAEAAAAAAAAAYgMAAAAA
AAAAAAAAEAAAAJADAADwAwAAEAQAAAAAAAAFAAAAAAAAAEcAAABiAAAAAwAAAAADAABABAAAcAQA
AOoAAAAAAAAA8AAAAGIAAAACAAAAcAMAAAEAAAAAAAAAIAAAAAAAAACCAgAAAAAAACEAAAAhAAAA
ggIAAAAAAAAtAAAALQAAAAAAAAAGAwoARmxvd0xheW91dAAAAAABAAAAAQAAALoAAAAAAAAAUgAA
AAQAAABsZWZ0BgEPAE1lc3NhZ2VTZXF1ZW5jZQAAAADKAAAAAAAAANAAAABiAAAAAgAAAAYDCwBN
ZXNzYWdlU2VuZAAAAAC6AAAAAAAAAFIAAAAQAAAAY3JlYXRlQXQ6ZXh0ZW50OmIAAAACAAAAggIA
AAAAAAALAAAACwAAAIICAAAAAAAAvQIAADMAAACgAQAAcgUAAAAAAAC6AAAAAAAAAFIAAAAKAAAA
dXBkYXRlU2l6ZWIAAAAAAAAAoAEAAAYBDwBXSU5ET1dQTEFDRU1FTlQAAAAAcgAAACwAAAAsAAAA
AAAAAAAAAAD/////////////////////BQAAAAUAAABjAQAAHgAAAMoAAAAAAAAA0AAAAMACAACC
AgAAAAAAAMEAAADBAAAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAAABAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAAGAAAAEltYWdlUmVsYXRp
dmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABYAAABDb250cm9sQmFyQWJz
dHJhY3QuaWNvDgIfAFNUQkV4dGVybmFsUmVzb3VyY2VMaWJyYXJ5UHJveHkAAAAAUgAAABAAAABk
b2xwaGluZHIwMDUuZGxsAAAAAA==''))!!


'!

filenameFor: aString
	^FileLocator installRelative localFileSpecFor: 'Resources\Tests\' , aString!

loadAndTestPackage: filename
	self checkNoTestPackageContents.
	loadedPackages := Package manager install: (self filenameFor: filename).
	self checkTestPackageContents
!

loadTestAndUninstallPackage: aString
	self loadAndTestPackage: aString.
	self assert: loadedPackages first paxVersion equals: 1.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

setUp
	| var |
	var := Package classPool associationAt: 'CheckTimestamps'.
	checkTimestamps := var value.
	var value: true!

tearDown
	| scribbleClass |
	Package classPool at: 'CheckTimestamps' put: checkTimestamps.
	self uninstallTestPackages.
	"Manually remove the test components in case the uninstall failed or the test package didn't load correctly."
	#{Smalltalk.ScribbleTest} ifDefined: [:class | class removeFromSystem].
	scribbleClass := #{Smalltalk.Scribble} value.
	#(#looseA #looseC) do: [:each | scribbleClass removeSelector: each ifAbsent: nil].
	#(#resource_Scribble_test) do: [:each | scribbleClass class removeSelector: each ifAbsent: nil]!

testForwardRefLoadPac
	"#1720: Test loading and converting of old packages with forward reference view referereces"

	| pacName |
	pacName := self filenameFor: 'D5LoadTest.pac'.
	(FileStream write: pacName)
		nextPutAll: self d5ForwardRefTestPacContents;
		close.
	[loadedPackages := Package manager install: pacName] ensure: [File delete: pacName]!

testLegacyFormatErrorAliasToQualifiedName
	| package ref filer filerClass |
	package := Package new.
	package paxVersion: 1.
	ref := #{Smalltalk.TestCase}.
	self assert: ref value identicalTo: XProgramming.SUnit.TestCase.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag class isMeta]!

testLegacyFormatErrorMethodOfNamespacedClass
	| package filerClass filer method |
	package := Package new.
	package paxVersion: 1.
	method := self class >> self selector.
	package addLooseMethod: method.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = (MethodName method: method)]!

testLegacyFormatErrorQualifiedAliasName
	| package filerClass filer ref |
	package := Package new.
	package paxVersion: 1.
	ref := #{XProgramming.SUnit.ExampleTestResource}.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = ref]!

testLegacyFormatErrorQualifiedBinaryVariableName
	| package filerClass filer ref |
	package := Package new.
	package paxVersion: 1.
	ref := #{Kernel.SourceFiles}.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag == ref]!

testLegacyFormatErrorQualifiedClassName
	| package filerClass filer |
	package := Package new.
	package paxVersion: 1.
	package classNames add: self class fullyQualifiedReference.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = self class asQualifiedReference]!

testLegacyFormatErrorQualifiedSourceVariableName
	| package anonClass filerClass filer pool ref |
	package := Package new.
	package paxVersion: 1.
	"PoolConstantDictionary instances only support Smalltalk as their environment because it is only used for legacy packages, but we want to test a theoretical sourceObject that can live in any Namespace."
	anonClass := Smalltalk.PoolConstantsDictionary newAnonymousSubclass.
	anonClass compile: 'environment ^Kernel.Tests'.
	pool := anonClass named: #TestPool.
	self class environment at: #TestPool put: pool.
	
	[ref := #{Kernel.Tests.TestPool}.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag == ref]]
			ensure: [self class environment removeKey: #TestPool]!

testLegacyFormatErrorQualifiedSuperclassName
	"Test that if a class in Smalltalk is defined as a subclass of a class that is not bindable from Smalltalk, that it cannot be a member of a legacy format package (because the superclass will not be bindable without a qualified name)."

	| package filerClass filer testClass |
	package := Package new.
	package paxVersion: 1.
	testClass := self class
				subclass: #__Foo__
				instanceVariableNames: ''
				classVariableNames: ''
				imports: #()
				classInstanceVariableNames: ''
				classConstants: {}.
	
	[package classNames add: testClass fullyQualifiedReference.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag == self class]]
			ensure: [testClass removeFromSystem]!

testLegacyFormatErrorQualifiedUntracedVariable
	| package filerClass filer ref |
	package := Package new.
	package paxVersion: 1.
	ref := #{XProgramming.SUnit.ExampleTestResource}.
	package setUntracedVariables: (Set with: ref).
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = ref]!

testLoad21Pac
	"The 2.1 packages were a mix of text and binary. The package itself was binary filed, and the view resources also.
	The test 2.1 package contains a stb version 1 Views and so exercises the whole stb conversion stack. We don't have anything with version 0, but that predated the first commercial release."

	self loadTestAndUninstallPackage: 'ScribbleTestPackages\2.1\ScribbleTest21.pac'!

testLoad40Pac
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\4.0\ScribbleTest4.pac'!

testLoad40Pax
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\4.0\ScribbleTest4.pax'!

testLoad51Pac
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\5.1\ScribbleTest51.pac'!

testLoad51Pax
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\5.1\ScribbleTest51.pax'!

testLoad60Pac
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\6.0\ScribbleTest6.pac'!

testLoad60Pax
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\6.0\ScribbleTest6.pax'!

testLoad70Pax
	"Test loading of D7 package in version 1 pax format."

	| scribbleTestPackage aliasName binaryVariableName sourceVariableName testPool poolConst testPackagePath filer actual expected method |
	testPackagePath := 'ScribbleTestPackages\7.0\ScribbleTest7.pax'.
	self loadAndTestPackage: testPackagePath.
	scribbleTestPackage := loadedPackages first.
	self assert: scribbleTestPackage paxVersion equals: 1.
	aliasName := #{Smalltalk.AliasToScribbleTest}.
	self assert: scribbleTestPackage aliasVariableNames asArray equals: {aliasName}.
	self assert: aliasName value identicalTo: #{Smalltalk.ScribbleTest} value.
	self assert: (scribbleTestPackage manager packageOfVariableNamed: aliasName)
		identicalTo: scribbleTestPackage.
	binaryVariableName := #{Smalltalk.ScribbleTestBinaryGlobal}.
	self assert: scribbleTestPackage binaryVariableNames asArray equals: {binaryVariableName}.
	self assert: (scribbleTestPackage manager packageOfVariableNamed: binaryVariableName)
		identicalTo: scribbleTestPackage.
	self assert: binaryVariableName value equals: #('Scribble').
	self assert: scribbleTestPackage sourceVariableNames asArray equals: #().
	sourceVariableName := #{Smalltalk.ScribbleTestSourceGlobal}.
	"We should still find the class binding among the packaged variables"
	self assert: (scribbleTestPackage manager packageOfVariableNamed: sourceVariableName)
		identicalTo: scribbleTestPackage.
	self assert: (scribbleTestPackage classNames includes: sourceVariableName).
	testPool := sourceVariableName value.
	self assert: testPool isKindOf: SharedPool class.
	poolConst := testPool bindingFor: 'ConstantString'.
	self assert: poolConst isClassVariable.
	self assert: poolConst isImmutable.
	self assert: poolConst value equals: 'abc'.
	self
		assert: (MethodName className: #{Smalltalk.ScribbleTest} selector: #string) value literals first
		equals: poolConst.
	self assert: #{Smalltalk.ScribbleTest} value new string equals: 'abc'.
	method := Object >> #scribble.
	self assert: method environment identicalTo: Smalltalk.
	self assert: method owningPackage identicalTo: scribbleTestPackage.
	self assert: (method value: Object new withArguments: #()) identicalTo: #{Smalltalk.Scribble} value.

	"Now verify it round trips"
	filer := scribbleTestPackage sourceFilerClass on: String writeStream.
	filer fileOutPackage: scribbleTestPackage.
	actual := filer stream contents.
	expected := File readAllText: (File change: (self filenameFor: testPackagePath) extension: 'pac').
	"
	Smalltalk.DiffBrowser compare: actual with: expected
	"
	self assert: actual equals: expected.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

testLoad72Pax
	"Test loading of the interim 2.0 package format which uses BindingReferences, but not namespace qualified names."

	| scribbleTestPackage aliasName binaryVariableName sourceVariableName testPool |
	self loadAndTestPackage: 'ScribbleTestPackages\7.2\ScribbleTest72.pax'.
	scribbleTestPackage := loadedPackages first.
	"Package gets downgraded to version 1 format as we don't want to support the interim source format going forward"
	self assert: scribbleTestPackage paxVersion equals: 1.
	aliasName := #{Smalltalk.AliasToScribbleTest}.
	self assert: scribbleTestPackage aliasVariableNames asArray equals: {aliasName}.
	self assert: aliasName value identicalTo: #{Smalltalk.ScribbleTest} value.
	binaryVariableName := #{Smalltalk.ScribbleTestBinaryGlobal}.
	self assert: scribbleTestPackage binaryVariableNames asArray equals: {binaryVariableName}.
	self assert: binaryVariableName value equals: #('Scribble').
	sourceVariableName := #{Smalltalk.ScribbleTestSourceGlobal}.
	self assert: scribbleTestPackage sourceVariableNames asArray equals: #().
	self assert: (scribbleTestPackage classNames includes: sourceVariableName).
	testPool := sourceVariableName value.
	self assert: testPool isKindOf: SharedPool class.
	self verifyTestPackageResources: scribbleTestPackage.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

testLoadedPackagesAreWellFormed
	Package manager packages do: 
			[:each |
			self verifyPackageElementNamesAreAbsolute: each.
			self verifyPackageElementsExist: each]!

testLooseResourceIdentifiers
	| all loose notLoose |
	loose := Package manager looseResourceIdentifiers.
	self assert: (loose allSatisfy: [:each | each owningClass owningPackage ~= each owningPackage]).
	all := Smalltalk developmentSystem allResourceIdentifiers.
	self assert: (loose difference: all) isEmpty.
	notLoose := all difference: loose.
	self assert: (notLoose allSatisfy: [:each | each owningClass owningPackage = each owningPackage])!

testPropertyManager
	self verifyPropertyManagerOf: Package new!

testTimestampInitialized
	self assert: Package new timestamp asInteger equals: 0!

uninstallTestPackages
	loadedPackages notNil
		ifTrue: 
			[loadedPackages do: [:each | Package manager basicUninstall: each].
			loadedPackages := nil]!

verifyPackageElementNamesAreAbsolute: aPackage
	aPackage classNames do: [:each | self assert: each scope isNil].
	aPackage methodNames do: [:each | self assert: each className scope isNil].
	aPackage variableNames do: [:each | self assert: each scope isNil].
	aPackage untracedVariables do: [:each | self assert: each scope isNil]!

verifyPackageElementsExist: aPackage
	aPackage classNames do: [:each | | class |
		class := each valueOrNil.
		self assert: class notNil.
		self assert: class owningPackage identicalTo: aPackage].
	aPackage methodNames do: [:each | | method |
		method := each valueOrNil.
		self assert: method notNil.
		self assert: method owningPackage identicalTo: aPackage].
	aPackage variableNames do: [:each | self assert: each isDefined].
	aPackage sourceVariableNames do: [:each |
		| value |
		value := each value.
		self assert: value owningPackage identicalTo: aPackage].
	aPackage untracedVariables do: [:each | self assert: each isDefined]!

verifyTestPackageResources: scribbleTestPackage
	| resourceIds scribbleTestDefaultViewId scribbleTestViewId |
	resourceIds := scribbleTestPackage allResourceIdentifiers.
	self assert: resourceIds size equals: 2.
	scribbleTestDefaultViewId := UI.ResourceIdentifier class: #{Smalltalk.ScribbleTest} value
				name: 'Default scribble test view'.
	self assert: (resourceIds includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage equals: scribbleTestPackage.
	self assertNotNil: scribbleTestDefaultViewId resource.
	scribbleTestViewId := UI.ResourceIdentifier class: #{Smalltalk.Scribble} value name: 'Scribble test'.
	self assert: (resourceIds includes: scribbleTestViewId).
	self assert: scribbleTestViewId owningPackage equals: scribbleTestPackage.
	self assertNotNil: scribbleTestViewId resource! !
!Kernel.Tests.PackageTest categoriesForMethods!
checkNoTestPackageContents!helpers!private! !
checkTestPackageContents!helpers!private! !
d5ForwardRefTestPacContents!constants!private! !
filenameFor:!helpers!private! !
loadAndTestPackage:!helpers!private! !
loadTestAndUninstallPackage:!helpers!private! !
setUp!private!running! !
tearDown!private!running! !
testForwardRefLoadPac!public!unit tests! !
testLegacyFormatErrorAliasToQualifiedName!public!unit tests! !
testLegacyFormatErrorMethodOfNamespacedClass!public!unit tests! !
testLegacyFormatErrorQualifiedAliasName!public!unit tests! !
testLegacyFormatErrorQualifiedBinaryVariableName!public!unit tests! !
testLegacyFormatErrorQualifiedClassName!public!unit tests! !
testLegacyFormatErrorQualifiedSourceVariableName!public!unit tests! !
testLegacyFormatErrorQualifiedSuperclassName!public!unit tests! !
testLegacyFormatErrorQualifiedUntracedVariable!public!unit tests! !
testLoad21Pac!public!unit tests! !
testLoad40Pac!public!unit tests! !
testLoad40Pax!public!unit tests! !
testLoad51Pac!public!unit tests! !
testLoad51Pax!public!unit tests! !
testLoad60Pac!public!unit tests! !
testLoad60Pax!public!unit tests! !
testLoad70Pax!public!unit tests! !
testLoad72Pax!public!unit tests! !
testLoadedPackagesAreWellFormed!public!unit tests! !
testLooseResourceIdentifiers!public!unit tests! !
testPropertyManager!public! !
testTimestampInitialized!public!unit tests! !
uninstallTestPackages!private!running! !
verifyPackageElementNamesAreAbsolute:!helpers!private! !
verifyPackageElementsExist:!helpers!private! !
verifyTestPackageResources:!helpers!private! !
!

