"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.IPerPropertyBrowsingTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.IPerPropertyBrowsingTest guid: (Core.GUID fromString: '{9a6563b5-627e-4f36-a574-c3e393e52ad0}')!

OS.COM.Tests.IPerPropertyBrowsingTest comment: ''!

!OS.COM.Tests.IPerPropertyBrowsingTest methodsFor!

testStringsAndValues
	"This test requires that the old MS common controls used for VB6 are registered. It is possible to get the VB common controls directly from Microsoft in 32-bit form as follows:

	- download Microsoft Visual Basic 6.0 Service Pack 6 Cumulative Update from https://www.microsoft.com/en-us/download/details.aspx?id=7030
	- Use msiexec /a to extract the contents of the MSI to a folder, where mscomctl.ocx will be found in the SYSTEM subfolder
	- Run c:\windows\sysWOW64\regsvr32.exe mscomctl.ocx from a 64-bit administrator command prompt"

	| lvCtrl ippb map |
	lvCtrl := [IDispatch createObject: 'MSComctlLib.ListViewCtrl'] on: HRESULTError do: [:ex | self skip: ex description].
	ippb := lvCtrl queryInterface: IPerPropertyBrowsing.
	map := ippb stringsToValues: 1.
	self assert: map equals: (Dictionary withAll: {'0 - lvwNone' -> 0. '1 - lvwAutoLeft' -> 1. '2 - lvwAutoTop' -> 2}).
	ippb free.
	lvCtrl free! !

!OS.COM.Tests.IPerPropertyBrowsingTest categoriesForMethods!
testStringsAndValues!public! !
!

